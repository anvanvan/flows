# Installing Flows for Codex

Quick setup to enable flows skills in Codex.

## Installation

1. **Clone flows repository**:
   ```bash
   mkdir -p ~/.codex/flows
   cd ~/.codex/flows
   git clone https://github.com/anvanvan/flows.git .
   ```

2. **Create personal skills directory**:
   ```bash
   mkdir -p ~/.codex/skills
   ```

3. **Update ~/.codex/AGENTS.md** to include this flows section:
   ```markdown
   ## Flows System

   <EXTREMELY_IMPORTANT>
   You have flows. Flows teach you new skills and capabilities. RIGHT NOW run: `~/.codex/flows/.codex/flows-codex bootstrap` and follow the instructions it returns.
   </EXTREMELY_IMPORTANT>
   ```

## Verification

Test the installation:
```bash
~/.codex/flows/.codex/flows-codex bootstrap
```

You should see skill listings and bootstrap instructions. The system is now ready for use.