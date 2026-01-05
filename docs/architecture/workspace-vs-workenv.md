# Workspace vs Workenv

Understanding the difference between "workspace" and "workenv" environments in the provide.io ecosystem.

## Quick Answer

**Workspace** (`.venv`): Shared virtual environment for all packages in provide-workspace
**Workenv** (`workenv/`): Individual package virtual environment for isolated development

They serve different purposes and can coexist.

## The Workspace Environment

### Location
```
provide-workspace/.venv/
```

### Purpose
Unified development across all ecosystem packages.

### Created By
```bash
./scripts/setup.sh
```

### Contains
- All 19 ecosystem packages in editable mode
- Shared dependencies
- Development tools (pytest, ruff, mypy, etc.)

### When to Use
- Cross-package development
- Testing changes across multiple packages
- Full ecosystem work
- Documentation building

### Example
```bash
# Activate workspace
cd provide-workspace/
source .venv/bin/activate

# Work across packages
cd ../pyvider/
python -c "import provide.foundation"  # Works!
python -c "import pyvider"              # Works!
python -c "import flavor"               # Works!

# All packages available
uv pip list | grep -E '(provide|pyvider|flavor)'
```

## The Workenv Environment

### Location
```
<package>/workenv/
```

### Purpose
Isolated development for a single package.

### Created By
Individual packages using `wrknv` or manual `uv venv`:

```bash
cd pyvider/
uv venv workenv/
source workenv/bin/activate
uv pip install -e ".[dev]"
```

### Contains
- Only that package and its direct dependencies
- Package-specific development tools
- Isolated from other packages

### When to Use
- Single-package development
- Package isolation
- Testing minimal dependencies
- CI/CD environments
- Package-specific tooling

### Example
```bash
# Activate package workenv
cd pyvider/
source workenv/bin/activate

# Only pyvider and its dependencies
python -c "import pyvider"              # Works!
python -c "import provide.foundation"  # Works (dependency)
python -c "import flavor"               # Fails! (not a dependency)

# Minimal package list
uv pip list | grep -E '(provide|pyvider|flavor)'
# Only shows: pyvider, provide-foundation, pyvider-cty
```

## Side-by-Side Comparison

| Aspect | Workspace (`.venv`) | Workenv (`workenv/`) |
|--------|---------------------|----------------------|
| **Location** | `provide-workspace/.venv/` | `<package>/workenv/` |
| **Scope** | All ecosystem packages | Single package |
| **Packages** | 19 packages | 1 package + dependencies |
| **Setup** | `./scripts/setup.sh` | `uv venv workenv/` |
| **Use Case** | Cross-package dev | Isolated package dev |
| **Dependencies** | Everything | Only what package needs |
| **Size** | Large (~500MB+) | Small (~50-100MB) |
| **Update Frequency** | Weekly/monthly | Per package release |

## When to Use Which

### Use Workspace (`.venv`) When:

✅ Making changes across multiple packages
✅ Testing integration between packages
✅ Building documentation hub
✅ New to the ecosystem (easiest setup)
✅ Working on provider that uses multiple pyvider packages

### Use Workenv (`workenv/`) When:

✅ Focused work on single package
✅ Testing minimal dependencies
✅ Package-specific CI/CD
✅ Want fast environment creation
✅ Need package isolation

### Use Both When:

✅ Developing a package that's also an ecosystem dependency
✅ Need to test "as dependency" vs "as workspace member"
✅ Verifying package works standalone

## Practical Scenarios

### Scenario 1: Add Feature to Foundation

**Best choice**: Workspace

Why? You'll need to test it in other packages (pyvider, flavorpack, etc.)

```bash
cd provide-workspace/
source .venv/bin/activate
cd ../provide-foundation/
# ... make changes ...
cd ../pyvider/
uv run pytest  # Tests your foundation changes
```

### Scenario 2: Fix Bug in pyvider-cty

**Best choice**: Workenv (or Workspace)

Why? pyvider-cty has minimal dependencies, can work standalone

```bash
cd pyvider-cty/
uv venv workenv/
source workenv/bin/activate
uv pip install -e ".[dev]"
# ... make changes and test ...
pytest
```

### Scenario 3: Build New Provider

**Best choice**: Workspace initially, Workenv eventually

Why? Need pyvider ecosystem while developing, but provider should work standalone

```bash
# Development: use workspace
cd provide-workspace/
source .venv/bin/activate
cd my-provider/
# ... develop using pyvider, pyvider-cty, etc ...

# Verification: use workenv
cd my-provider/
uv venv workenv/
source workenv/bin/activate
uv pip install -e "."
# Verify works with just declared dependencies
```

## Switching Between Environments

### Deactivate Current Environment

```bash
deactivate
```

### Activate Workspace

```bash
cd /path/to/provide-workspace/
source .venv/bin/activate
```

### Activate Workenv

```bash
cd /path/to/package/
source workenv/bin/activate
```

### Check Which is Active

```bash
echo $VIRTUAL_ENV
# Workspace: /path/to/provide-workspace/.venv
# Workenv: /path/to/package/workenv
```

## Common Pitfalls

### Pitfall 1: Wrong Environment Active

**Problem**: Import works in workspace but fails in workenv

**Cause**: Package not declared as dependency

**Solution**: Add dependency to `pyproject.toml`:
```toml
[project]
dependencies = [
    "missing-package>=0.1.0",
]
```

### Pitfall 2: Workenv Installed Wrong Package Version

**Problem**: Workenv has older version of dependency

**Cause**: Didn't update after dependency version bump

**Solution**: Recreate workenv:
```bash
rm -rf workenv/
uv venv workenv/
source workenv/bin/activate
uv pip install -e ".[dev]"
```

### Pitfall 3: Changes Not Reflected

**Problem**: Code changes not seen in tests

**Cause**: Using workenv without editable install

**Solution**: Install in editable mode:
```bash
# Instead of: uv add .
uv pip install -e "."  # Note the -e flag
```

## Configuration Files

### Workspace

`provide-workspace/wrknv.toml` defines workspace structure:
```toml
[workspace]
name = "provide-workspace"

[[siblings]]
name = "pyvider"
path = "../pyvider"
```

### Workenv

Each package's `pyproject.toml` defines dependencies:
```toml
[project]
name = "pyvider"
dependencies = [
    "provide-foundation>=0.1.0",
]
```

## Best Practices

1. **Default to Workspace** for ecosystem development
2. **Test in Workenv** before releasing packages
3. **Keep Workenvs in .gitignore** (they're regenerable)
4. **Document which environment** in README and CLAUDE.md
5. **CI/CD uses Workenv** (tests minimal dependencies)
6. **Activate one at a time** (don't nest virtual environments)

## Next Steps

- **[Development Workflow](../guide/workflow/)** - Practical development patterns
- **[wrknv Integration](wrknv-integration.md)** - How wrknv manages environments
- **[Cross-Package Development](../guide/cross-package.md)** - Working across packages
