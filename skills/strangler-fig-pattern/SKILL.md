---
name: strangler-fig-pattern
description: Use when replacing legacy systems incrementally - safely replaces legacy systems by building new implementations alongside, gradually routing traffic, and eventually removing obsolete code
---

# Strangler Fig Pattern

## Overview

This refactoring approach safely replaces legacy systems incrementally by building new implementations alongside existing code, gradually routing traffic, and eventually removing obsolete code—mirroring how strangler fig trees grow around host trees.

**Core principle:** "Never big-bang rewrite. Replace incrementally with production traffic validating each step."

## When to Use

**Ideal for:**
- Large legacy systems too complex for complete rewrites
- Systems requiring continuous operation during migration
- High-risk migrations where downtime is unaffordable
- Situations requiring production validation before full cutover

**Avoid when:**
- Legacy system is small enough to simply rebuild
- Planned downtime is acceptable
- Legacy and new implementations cannot coexist architecturally
- System has no natural seams for splitting

## The Six-Step Process

### Step 1: Identify a Seam

Find natural architectural boundaries:
- Module boundaries
- API endpoints
- Feature toggles
- Database tables
- Service interfaces

```python
# Example: Payment processing seam
class PaymentProcessor:
    def process_payment(self, amount, method):
        if method == 'credit_card':
            return self._process_credit_card(amount)  # Seam here
        elif method == 'paypal':
            return self._process_paypal(amount)      # And here
```

### Step 2: Add Characterization Tests

**REQUIRED SUB-SKILL:** Use @flows:characterization-testing

Document existing behavior comprehensively:

```python
def test_legacy_payment_behavior():
    """Characterization tests for legacy payment"""
    processor = LegacyPaymentProcessor()

    # Document actual behavior
    assert processor.process_payment(100, 'credit_card') == 'SUCCESS'
    assert processor.process_payment(-10, 'credit_card') == 'SUCCESS'  # Bug!
    assert processor.process_payment(0, 'paypal') == 'ERROR'
```

### Step 3: Create Abstraction Layer

Build a facade that routes between implementations:

```python
class PaymentFacade:
    def __init__(self):
        self.legacy = LegacyPaymentProcessor()
        self.modern = ModernPaymentProcessor()
        self.feature_flags = FeatureFlags()

    def process_payment(self, amount, method):
        # Route based on feature flags
        if self.feature_flags.is_enabled('modern_payments', user_id):
            try:
                return self.modern.process_payment(amount, method)
            except Exception as e:
                # Fallback to legacy on error
                logger.error(f"Modern payment failed: {e}")
                return self.legacy.process_payment(amount, method)
        else:
            return self.legacy.process_payment(amount, method)
```

### Step 4: Implement New Version

Build replacement behind feature flags:

```python
class ModernPaymentProcessor:
    def process_payment(self, amount, method):
        # New implementation with fixes
        if amount <= 0:
            raise ValueError("Amount must be positive")

        if method == 'credit_card':
            return self._process_credit_card_v2(amount)
        elif method == 'paypal':
            return self._process_paypal_v2(amount)
        else:
            raise ValueError(f"Unknown payment method: {method}")
```

### Step 5: Gradually Route Traffic

Execute phased rollout:

```python
# Phase 1: Dark launch (0% traffic, monitoring only)
class DarkLaunchFacade(PaymentFacade):
    def process_payment(self, amount, method):
        # Process with legacy
        legacy_result = self.legacy.process_payment(amount, method)

        # Shadow process with modern (async, non-blocking)
        async_task.delay(
            self.modern.process_payment,
            amount,
            method,
            compare_with=legacy_result
        )

        return legacy_result

# Phase 2: Canary (1% traffic)
feature_flags.set_percentage('modern_payments', 1)

# Phase 3: Gradual ramp-up
# Week 1: 1%
# Week 2: 5%
# Week 3: 25%
# Week 4: 50%
# Week 5: 90%
# Week 6: 100%
```

### Step 6: Remove Legacy Code

After full migration and stability period:

```python
class PaymentProcessor:
    """Final state - legacy removed"""
    def __init__(self):
        self.processor = ModernPaymentProcessor()

    def process_payment(self, amount, method):
        return self.processor.process_payment(amount, method)

# Delete legacy files
# git rm legacy_payment_processor.py
# git rm tests/test_legacy_payment.py
```

## Feature Flag Strategies

### Boolean Flags
```python
if feature_flags.is_enabled('use_new_system'):
    return new_system.process()
else:
    return legacy_system.process()
```

### Percentage Rollout
```python
if feature_flags.percentage_enabled('new_system', user_id, 25):
    # 25% of users get new system
    return new_system.process()
```

### User-Based Rollout
```python
if user_id in feature_flags.get_users('new_system_beta'):
    return new_system.process()
```

### A/B Testing
```python
variant = feature_flags.get_variant('payment_system', user_id)
if variant == 'control':
    return legacy_system.process()
elif variant == 'treatment':
    return new_system.process()
```

## Monitoring Strategy

### Key Metrics to Track

```python
class MigrationMonitor:
    def track_migration(self, user_id, result, system):
        metrics.increment(f'payment.{system}.count')
        metrics.timing(f'payment.{system}.duration', result.duration)

        if result.error:
            metrics.increment(f'payment.{system}.errors')

        # Compare systems
        if system == 'modern':
            legacy_result = self.shadow_legacy_call(...)
            if legacy_result != result:
                metrics.increment('payment.divergence')
                logger.warning(f"System divergence: {legacy_result} vs {result}")
```

### Rollback Triggers

Define automatic rollback conditions:

```python
def should_rollback():
    error_rate = metrics.get('payment.modern.errors') / metrics.get('payment.modern.count')
    latency_p99 = metrics.get_percentile('payment.modern.duration', 99)

    if error_rate > 0.01:  # >1% errors
        return True
    if latency_p99 > 1000:  # >1s P99 latency
        return True

    return False

# Auto-rollback
if should_rollback():
    feature_flags.disable('modern_payments')
    alert_team("Auto-rolled back modern payments")
```

## Database Migration Strategy

### Dual Write Pattern
```python
def save_order(order_data):
    # Write to both databases during migration
    legacy_db.save(order_data)
    new_db.save(transform_for_new_schema(order_data))

def read_order(order_id):
    # Read from legacy, validate against new
    legacy_data = legacy_db.read(order_id)
    new_data = new_db.read(order_id)

    if not equivalent(legacy_data, new_data):
        log_divergence(order_id, legacy_data, new_data)

    return legacy_data  # Still trust legacy during migration
```

### Event Sourcing Bridge
```python
class EventBridge:
    def handle_legacy_change(self, entity):
        # Convert legacy changes to events
        event = self.create_event_from_legacy(entity)
        event_store.append(event)

        # Apply to new system
        new_system.apply_event(event)
```

## Complete Example: API Migration

```python
# Step 1: Identify seam (API endpoints)
# OLD: /api/v1/users
# NEW: /api/v2/users

# Step 2: Characterization tests
def test_v1_user_api():
    response = client.get('/api/v1/users/123')
    assert response.json() == {
        'id': 123,
        'name': 'John',
        'email': 'john@example'  # No .com - bug!
    }

# Step 3: Abstraction layer
class UserAPIRouter:
    def get_user(self, user_id, api_version=None):
        # Determine version
        if api_version == 'v2' or self.should_use_v2(user_id):
            return self.get_user_v2(user_id)
        else:
            return self.get_user_v1(user_id)

    def should_use_v2(self, user_id):
        # Gradual rollout logic
        return feature_flags.percentage_enabled('api_v2', user_id, 10)

# Step 4: New implementation
def get_user_v2(self, user_id):
    user = db.get_user(user_id)
    return {
        'id': user.id,
        'name': user.name,
        'email': user.email + '.com' if '@example' in user.email else user.email,
        'created_at': user.created_at.isoformat(),  # New field
        'version': 'v2'
    }

# Step 5: Gradual routing
@app.route('/api/users/<user_id>')
def user_endpoint(user_id):
    router = UserAPIRouter()

    # Check header for explicit version
    requested_version = request.headers.get('API-Version')

    # Route based on version or rollout
    return router.get_user(user_id, requested_version)

# Step 6: Remove legacy (after 100% rollout + 2 weeks)
# Delete get_user_v1 method
# Delete /api/v1/* routes
# Update documentation
```

## Risk Mitigation

### The Safety Period

**Wait 2-4 weeks at 100% before removing legacy code:**

```python
def can_remove_legacy():
    # Check conditions
    days_at_100 = (datetime.now() - feature_flags.get_100_percent_date('modern_payments')).days
    error_rate = metrics.get_recent('payment.modern.errors', days=7)
    rollback_count = metrics.get('payment.rollbacks', days=30)

    if days_at_100 < 14:
        return False, "Need 14 days at 100%"
    if error_rate > 0.001:
        return False, "Error rate too high"
    if rollback_count > 0:
        return False, "Had rollbacks recently"

    return True, "Safe to remove legacy"
```

### Parallel Run Validation

```python
class ParallelValidator:
    def validate_systems_match(self, input_data):
        legacy_result = legacy_system.process(input_data)
        modern_result = modern_system.process(input_data)

        if legacy_result != modern_result:
            self.log_divergence(input_data, legacy_result, modern_result)

            # Analyze divergence
            if self.is_legacy_bug(legacy_result, modern_result):
                # Modern is correct, legacy had bug
                return modern_result
            else:
                # Unexpected divergence - investigate!
                alert_team(f"Unexpected divergence: {input_data}")
                return legacy_result  # Safe default
```

## Success Criteria

Migration is complete when:
1. ✅ 100% traffic on new system for 2+ weeks
2. ✅ Error rates equal or better than legacy
3. ✅ Performance metrics acceptable
4. ✅ No rollbacks in past 30 days
5. ✅ Legacy code removed and archived
6. ✅ Documentation updated
7. ✅ Feature flags cleaned up

## Integration with Other Skills

**Required:**
- @flows:characterization-testing - Before creating abstraction layer
- @flows:verification-before-completion - Before declaring migration complete

**Recommended:**
- @flows:pattern-discovery - Find similar migrations in codebase
- @flows:knowledge-lineages - Understand why legacy exists
