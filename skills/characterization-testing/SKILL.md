---
name: characterization-testing
description: Use before refactoring legacy code without tests - documents actual behavior as safety net, capturing current behavior including bugs to prevent regressions during refactoring
---

# Characterization Testing

## Overview

Characterization testing documents the actual behavior of legacy code as a safety net before refactoring, not as a specification of correctness.

**Core principle:** "Document what IS, not what SHOULD BE. Fix behavior later, after safety net exists."

**The Iron Law:** "NO REFACTORING WITHOUT CHARACTERIZATION TESTS FIRST"

## When to Use

Apply characterization testing when:
- Legacy code lacks automated tests
- Code's intended behavior is unclear
- Before refactoring critical or risky sections
- Documentation contradicts actual behavior
- You need protection without full understanding

**Don't use when:**
- Code already has comprehensive tests
- Building new features (use TDD instead)
- Code is trivially simple
- Complete rewrite is planned

## The Process (7 Steps)

### Step 1: Identify Target
- Start with a single function or method
- Choose something you need to refactor
- Don't try to test everything at once

### Step 2: Write Failing Test
```python
def test_calculate_discount():
    # Don't know expected output yet
    result = calculate_discount(100, 'GOLD')
    assert result == None  # Placeholder
```

### Step 3: Run and Capture
```bash
# Run test to see actual output
pytest test_legacy.py::test_calculate_discount
# FAILED: AssertionError: assert 85.0 == None
```

### Step 4: Lock In Behavior
```python
def test_calculate_discount():
    # Document actual behavior (even if wrong)
    result = calculate_discount(100, 'GOLD')
    assert result == 85.0  # What it ACTUALLY returns

    # Note: Should be 80.0 (20% discount) but has bug
    # DO NOT FIX YET - document first
```

### Step 5: Add Edge Cases
```python
def test_calculate_discount_edge_cases():
    # Test nulls
    assert calculate_discount(None, 'GOLD') == 0  # Actual behavior

    # Test empty
    assert calculate_discount(100, '') == 100  # No discount

    # Test negative
    assert calculate_discount(-50, 'GOLD') == -42.5  # Bug: applies to negative

    # Test boundaries
    assert calculate_discount(0, 'GOLD') == 0
    assert calculate_discount(999999, 'GOLD') == 849999.15
```

### Step 6: Document Known Issues
```python
def test_calculate_discount_known_bugs():
    """
    Known issues in calculate_discount:
    1. Returns 85 instead of 80 for GOLD (15% vs 20%)
    2. Applies discount to negative amounts
    3. No validation for customer_type
    """
    # These tests document bugs - keep them passing
    assert calculate_discount(100, 'GOLD') == 85.0  # Wrong but actual
    assert calculate_discount(-50, 'GOLD') == -42.5  # Nonsensical

    # Future correct behavior (skip for now)
    @pytest.skip("Document intended behavior")
    def test_calculate_discount_correct():
        assert calculate_discount(100, 'GOLD') == 80.0
        with pytest.raises(ValueError):
            calculate_discount(-50, 'GOLD')
```

### Step 7: Verify Coverage
```bash
# Check test coverage
pytest --cov=legacy_module test_legacy.py
# Ensure main paths covered (aim for 70%+ on legacy)
```

## Key Principles

### Document, Don't Fix

**Wrong approach:**
```python
def test_discount():
    # Fixing bug while writing characterization test
    result = calculate_discount(100, 'GOLD')
    assert result == 80.0  # "Correct" value
```

**Right approach:**
```python
def test_discount():
    # Document actual behavior
    result = calculate_discount(100, 'GOLD')
    assert result == 85.0  # Wrong but actual
    # TODO: Should be 80.0 - fix after refactoring
```

### Test the Whole Stack

Don't mock dependencies in characterization tests:

```python
# BAD: Mocking hides actual behavior
def test_with_mock():
    with mock.patch('database.fetch'):
        result = process_order(123)

# GOOD: Test actual integration
def test_actual_behavior():
    result = process_order(123)  # Real DB call
    assert result.status == 'PENDING'  # Actual result
```

### Capture Side Effects

```python
def test_side_effects():
    # Capture ALL behavior
    before_count = count_log_entries()

    result = process_payment(100)

    # Document main behavior
    assert result == 'SUCCESS'

    # Document side effects
    assert count_log_entries() == before_count + 2  # Logs twice
    assert email_queue_size() == 1  # Sends email
    assert cache.get('last_payment') == 100  # Updates cache
```

## Anti-Patterns to Avoid

### 1. Fixing During Characterization
**Never:** Change code to make "correct" test pass
**Always:** Document actual behavior, fix later

### 2. Excessive Mocking
**Never:** Mock to avoid complexity
**Always:** Test real behavior, including dependencies

### 3. Testing Implementation Details
**Never:** Test private methods directly
**Always:** Test through public interface

### 4. Ignoring Edge Cases
**Never:** Skip "unimportant" edge cases
**Always:** Document all discovered behaviors

## Integration with Other Skills

**Required by:**
- `systematic-debugging` - When debugging untested legacy code
- `strangler-fig-pattern` - Before replacing legacy systems

**Works with:**
- `code-archaeology` - Understand before characterizing
- `test-driven-development` - After characterization, use TDD for new code

## Complete Example

```python
# legacy_calculator.py (code we're characterizing)
def calculate_total(items, customer_type, tax_rate):
    """Legacy function with unclear behavior"""
    subtotal = sum(item['price'] for item in items)

    # Mysterious business logic
    if customer_type == 'VIP':
        discount = 0.15
    elif customer_type == 'GOLD':
        discount = 0.15  # Bug: should be 0.20
    else:
        discount = 0

    discounted = subtotal * (1 - discount)

    # More mysterious logic
    if tax_rate > 0:
        tax = discounted * tax_rate
    else:
        tax = discounted * 0.08  # Default tax?

    return round(discounted + tax, 2)

# test_legacy_calculator.py (characterization tests)
def test_calculate_total_normal_customer():
    """Document actual behavior for normal customer"""
    items = [{'price': 10}, {'price': 20}]

    # With tax rate
    assert calculate_total(items, 'NORMAL', 0.10) == 33.00

    # Without tax rate (uses mysterious default)
    assert calculate_total(items, 'NORMAL', 0) == 32.40

def test_calculate_total_vip_customer():
    """Document VIP discount behavior"""
    items = [{'price': 100}]

    # VIP gets 15% discount
    assert calculate_total(items, 'VIP', 0.10) == 93.50

def test_calculate_total_gold_customer_bug():
    """Document GOLD discount bug"""
    items = [{'price': 100}]

    # GOLD gets 15% (WRONG - should be 20%)
    assert calculate_total(items, 'GOLD', 0.10) == 93.50

    # Document that GOLD == VIP (the bug)
    vip_result = calculate_total(items, 'VIP', 0.10)
    gold_result = calculate_total(items, 'GOLD', 0.10)
    assert vip_result == gold_result  # Bug documented!

def test_calculate_total_edge_cases():
    """Document edge case behavior"""
    # Empty items
    assert calculate_total([], 'NORMAL', 0.10) == 0

    # Negative prices (shouldn't happen but does)
    items = [{'price': -10}]
    assert calculate_total(items, 'NORMAL', 0.10) == -11.00

    # Unknown customer type (treated as NORMAL)
    items = [{'price': 100}]
    assert calculate_total(items, 'UNKNOWN', 0.10) == 110.00

# Skip tests showing intended behavior
@pytest.mark.skip("Future behavior after fixing bugs")
def test_calculate_total_intended():
    items = [{'price': 100}]
    # GOLD should get 20% discount
    assert calculate_total(items, 'GOLD', 0.10) == 88.00

    # Negative prices should raise error
    with pytest.raises(ValueError):
        calculate_total([{'price': -10}], 'NORMAL', 0.10)
```

## Success Criteria

Characterization tests are complete when:
1. ✅ Main execution paths have tests
2. ✅ Edge cases are documented
3. ✅ Known bugs are captured (not fixed)
4. ✅ Tests pass without code changes
5. ✅ Coverage is sufficient for safe refactoring

You can now refactor with confidence, knowing these tests will catch any behavior changes.
