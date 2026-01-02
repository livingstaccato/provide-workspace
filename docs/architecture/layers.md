# Package Layers

Understanding package organization from a workspace development perspective.

## Overview

The provide.io ecosystem is organized in three layers based on **dependencies**. This layering determines:
- Installation order (bottom-up)
- Change propagation (top-down)
- Development workflows
- Testing strategies

For detailed information about what each package **does**, see the [Foundry Architecture](https://foundry.provide.io/foundry/architecture/).

## Three-Layer Architecture

```
┌────────────────────────────────────┐
│        🛠️ Tools Layer              │
│                                     │
│  flavorpack, wrknv, plating,       │
│  tofusoup, supsrc                  │
│                                     │
│  Can depend on Framework+Foundation │
└────────────────┬───────────────────┘
                 │ depends on
┌────────────────▼───────────────────┐
│      🏗️ Framework Layer             │
│                                     │
│  pyvider, pyvider-cty, pyvider-hcl,│
│  pyvider-rpcplugin, components     │
│                                     │
│  Depends on Foundation              │
└────────────────┬───────────────────┘
                 │ depends on
┌────────────────▼───────────────────┐
│      🏛️ Foundation Layer            │
│                                     │
│  provide-foundation, testkit        │
│                                     │
│  Minimal external dependencies      │
└─────────────────────────────────────┘
```

## Layer Characteristics

### 🏛️ Foundation Layer

**Packages**: provide-foundation, provide-testkit

**Dependencies**: Minimal external dependencies (attrs, structlog, click, pytest)

**Installation Order**: First (no internal dependencies)

**Change Impact**: HIGH - changes affect all other packages

**Development Pattern**:
```bash
# Edit foundation
cd provide-foundation/
# ... make changes ...

# Test immediately in other packages (no reinstall!)
cd ../pyvider/
uv run pytest  # Uses your changes immediately
```

### 🏗️ Framework Layer

**Packages**: pyvider-cty, pyvider-hcl, pyvider-rpcplugin, pyvider, pyvider-components

**Dependencies**: Foundation layer + domain-specific (gRPC, protobuf, msgpack)

**Installation Order**: Second (after Foundation)

**Change Impact**: MEDIUM - affects tools and applications built on framework

**Internal Dependencies**:
- pyvider-cty: Standalone (Foundation only)
- pyvider-hcl: Depends on pyvider-cty
- pyvider-rpcplugin: Depends on Foundation
- pyvider: Depends on Foundation + pyvider-cty
- pyvider-components: Depends on all above

**Development Pattern**:
```bash
# Edit CTY types
cd pyvider-cty/
# ... make changes ...

# Test in dependent framework packages
cd ../pyvider/
uv run pytest tests/test_cty_integration.py

# Test in tools layer
cd ../plating/
uv run pytest tests/test_schema_extraction.py
```

### 🛠️ Tools Layer

**Packages**: flavorpack, wrknv, plating, tofusoup, supsrc

**Dependencies**: Can use both Foundation and Framework layers

**Installation Order**: Last (may depend on both other layers)

**Change Impact**: LOW - tools are typically end-user facing

**Development Pattern**:
```bash
# Tools can use everything below them
cd flavorpack/
# Can import from provide.foundation
# Can import from pyvider if needed

# But tools don't depend on each other
# wrknv doesn't import flavorpack
# plating doesn't import tofusoup
```

## Dependency Rules

### Allowed Dependencies

```
Tools ──→ Framework ──→ Foundation
  │          │             │
  └──────────┴─────────────┘
     (Can skip layers)
```

**Valid**:
- Tools → Foundation (skip Framework)
- Tools → Framework → Foundation
- Framework → Foundation

**Invalid**:
- Foundation → Framework (upward dependency)
- Foundation → Tools (upward dependency)
- Framework → Tools (sideways dependency)
- Tools ↔ Tools (peer dependencies)

### Why These Rules?

**Prevents Circular Dependencies**: Clear hierarchy prevents import cycles

**Enables Independent Releases**: Lower layers can release without coordinating with upper layers

**Simplifies Testing**: Test lower layers first, upper layers can assume lower layers work

**Facilitates Partial Installation**: Users can install Foundation alone, or Foundation+Framework, without Tools

## Installation Order in setup.sh

The workspace setup script installs packages in dependency order:

```bash
# 1. Foundation Layer (no dependencies)
uv pip install -e ../provide-foundation
uv pip install -e ../provide-testkit

# 2. Framework Layer (depends on Foundation)
uv pip install -e ../pyvider-cty
uv pip install -e ../pyvider-hcl      # depends on pyvider-cty
uv pip install -e ../pyvider-rpcplugin
uv pip install -e ../pyvider           # depends on pyvider-cty
uv pip install -e ../pyvider-components # depends on all above

# 3. Tools Layer (depends on Foundation, optionally Framework)
uv pip install -e ../flavorpack
uv pip install -e ../wrknv
uv pip install -e ../plating
uv pip install -e ../tofusoup
uv pip install -e ../supsrc
```

**Why this order matters**: Later packages import earlier packages. Installing out of order causes import errors.

## Change Propagation

### Foundation Change

```
Foundation Change
    ↓
All packages potentially affected
    ↓
Must test:
  - All Framework packages
  - All Tools packages
  - All Applications
```

**Example**: Change to `provide.foundation.logger` affects every package that uses logging.

### Framework Change

```
Framework Change
    ↓
Tools and Applications potentially affected
    ↓
Must test:
  - Dependent Framework packages
  - All Tools using Framework
  - Applications
```

**Example**: Change to `pyvider-cty` type system affects `pyvider`, `plating`, and any providers.

### Tools Change

```
Tools Change
    ↓
Only that tool affected
    ↓
Must test:
  - The changed tool
  - Applications using it
```

**Example**: Change to `flavorpack` packaging only affects packaged applications.

## Cross-Layer Development

### Scenario: Add New Feature to Foundation

```bash
# 1. Add feature to Foundation
cd provide-foundation/
# Edit src/provide/foundation/new_feature.py
uv run pytest tests/test_new_feature.py

# 2. Use in Framework (immediately available!)
cd ../pyvider/
# Import and use new feature
from provide.foundation.new_feature import Feature
# NO reinstall needed - editable install FTW!

# 3. Test integration
uv run pytest tests/test_foundation_integration.py

# 4. Commit in both repos
cd ../provide-foundation && git commit -am "Add new feature"
cd ../pyvider && git commit -am "Use new foundation feature"
```

### Scenario: Breaking Change in Foundation

```bash
# 1. Update Foundation API
cd provide-foundation/
# Make breaking change
uv run pytest  # Ensure foundation tests pass

# 2. Update dependent packages
# Framework layer
cd ../pyvider && # ... fix imports ... && uv run pytest
cd ../pyvider-hcl && # ... fix imports ... && uv run pytest

# Tools layer
cd ../flavorpack && # ... fix imports ... && uv run pytest
cd ../wrknv && # ... fix imports ... && uv run pytest

# 3. Coordinate releases
# Foundation 0.2.0 (breaking)
# Framework packages 0.2.0 (require foundation >=0.2.0)
# Tools packages 0.2.0 (require foundation >=0.2.0)
```

## Testing Strategy

### Unit Tests (Per-Package)

Test each package in isolation:

```bash
cd provide-foundation/
uv run pytest tests/unit/
```

### Integration Tests (Cross-Package)

Test interactions between layers:

```bash
# In pyvider, test integration with foundation
cd pyvider/
uv run pytest tests/integration/test_foundation.py

# In plating, test integration with framework
cd plating/
uv run pytest tests/integration/test_pyvider.py
```

### Workspace Tests

Test the workspace setup itself:

```bash
cd provide-workspace/
pytest tests/  # Tests bootstrap, setup, validate scripts
```

## Version Compatibility

Each layer specifies minimum versions of dependencies:

```toml
# pyvider/pyproject.toml
[project]
dependencies = [
    "provide-foundation>=0.1.0",
    "pyvider-cty>=0.1.0",
]
```

**Compatibility Strategy**:
- **Major versions must match**: Foundation 1.x → Framework 1.x
- **Minor versions can lag**: Foundation 1.2.0 works with Framework 1.1.0
- **Patch versions independent**: Foundation 1.1.5 works with Framework 1.1.2

## Next Steps

- **[Meta-Repository Pattern](meta-repository/)** - Why separate repos?
- **[Workspace vs Workenv](workspace-vs-workenv/)** - Different environment types
- **[Development Workflow](../guide/workflow/)** - Practical development patterns
