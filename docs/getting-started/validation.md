# Validation Guide

Understanding the validation process and troubleshooting validation failures.

## Running Validation

The validation script verifies your provide-workspace setup:

```bash
./scripts/validate.sh
```

Run this after [installation](installation.md) and whenever you suspect environment issues.

## What Gets Validated

### 1. Python Version Check

```
Python Version Check:
✓ Python 3.11.5
```

**What it checks:**
- Python executable version
- Minimum version 3.11

**If it fails:**
```bash
# Check your Python version
python3 --version

# If < 3.11, install newer Python
# See: getting-started/prerequisites.md#python-311
```

### 2. Virtual Environment Check

```
Virtual Environment Check:
✓ Virtual environment is active
```

**What it checks:**
- `VIRTUAL_ENV` environment variable is set
- Virtual environment path points to `.venv/`

**If it fails:**
```bash
# Activate the environment
source .venv/bin/activate

# Verify activation
echo $VIRTUAL_ENV
# Should show: /path/to/provide-workspace/.venv
```

### 3. Package Import Checks

```
Package Import Checks:
✓ provide.foundation
✓ provide.testkit
✓ pyvider.cty
✓ pyvider.hcl
✓ pyvider.rpcplugin
✓ pyvider
✓ pyvider.components
✓ flavor
✓ wrknv
✓ plating
✓ tofusoup
✓ supsrc
```

**What it checks:**
- Each package can be imported
- Basic module loading works
- No circular import issues

**If it fails:**

```bash
# Re-run setup to install packages
./scripts/setup.sh

# Verify specific package (should point to workspace path)
uv run python -c "import pyvider, pathlib; print(pathlib.Path(pyvider.__file__).resolve())"
```

### 4. Environment Configuration Check

```
Environment Configuration Check:
✓ Workspace configured correctly
```

**What it checks:**
- `wrknv.toml` configuration is valid
- Expected sibling directories exist
- No critical environment variables missing

**If it fails:**

```bash
# Check wrknv.toml syntax
cat wrknv.toml

# Verify sibling repositories exist
ls ../
```

## Validation Modes

### Default Validation (Fast)

```bash
./scripts/validate.sh
```

Runs core checks only (~10 seconds).

### Comprehensive Validation

```bash
./scripts/validate.sh --all-tests
```

Runs all tests across all packages (~5-15 minutes depending on packages).

**When to use:** Before committing major changes or before releases.

### Quiet Mode

```bash
./scripts/validate.sh --quiet
```

Minimal output - only shows failures.

**When to use:** In automation scripts or CI/CD.

### Verbose Mode

```bash
./scripts/validate.sh --verbose
```

Detailed output showing all checks and subprocess commands.

**When to use:** Troubleshooting validation failures.

## Understanding Exit Codes

```bash
./scripts/validate.sh
echo $?
```

**Exit codes:**

- `0` - All checks passed
- `1` - Python version check failed
- `2` - Virtual environment not active
- `3` - Package import failed
- `4` - Configuration error
- `5` - Other validation error

## Common Validation Failures

### Python Version Too Old

```
✗ Python 3.9.0
Error: Python 3.11 or higher required
```

**Solution:**

```bash
# Install Python 3.11+
# See: getting-started/prerequisites.md#python-311

# Recreate virtual environment with new Python
rm -rf .venv/
python3.11 -m venv .venv
source .venv/bin/activate
./scripts/setup.sh
```

### Virtual Environment Not Active

```
✗ Virtual environment is not active
```

**Solution:**

```bash
source .venv/bin/activate
```

Add to your `.bashrc` or `.zshrc` for convenience:

```bash
alias activate-provide='source /path/to/provide-workspace/.venv/bin/activate'
```

### Import Failures

```
✗ provide.foundation - ModuleNotFoundError
```

**Solutions:**

```bash
# 1. Ensure environment is active
source .venv/bin/activate

# 2. Reinstall packages
./scripts/setup.sh

# 3. Check if repository exists
ls ../provide-foundation/

# 4. If missing, re-bootstrap
./scripts/bootstrap.sh

# 5. Verify installation
uv run python -c "import provide.foundation, pathlib; print(pathlib.Path(provide.foundation.__file__).resolve())"
```

### Circular Import

```
✗ pyvider - ImportError: circular import
```

**Solution:**

This indicates a code issue, not a setup issue. Check recent changes in the failing package.

```bash
# Test import directly with more detail
python3 -c "import pyvider" 2>&1
```

### Missing Repositories

```
✗ Configuration error: Expected sibling directory not found: ../pyvider
```

**Solution:**

```bash
# Re-run bootstrap (idempotent)
./scripts/bootstrap.sh

# Or clone the specific missing repository
cd ..
git clone https://github.com/provide-io/pyvider.git
cd provide-workspace/
./scripts/setup.sh
```

## Manual Validation Steps

If the validation script fails and you need to diagnose manually:

### Check Python Version

```bash
python3 --version
# Should be 3.11.0 or higher
```

### Check Virtual Environment

```bash
which python3
# Should point to: /path/to/provide-workspace/.venv/bin/python3

uv run python -c "import importlib.metadata as m; names=sorted(d.metadata['Name'] for d in m.distributions()); print('\\n'.join(names[:20]))"
# Should show provide-* and pyvider-* packages
```

### Check Package Imports

```bash
python3 << 'EOF'
import sys
packages = [
    'provide.foundation',
    'provide.testkit',
    'pyvider.cty',
    'pyvider.hcl',
    'pyvider.rpcplugin',
    'pyvider',
    'flavor',
    'wrknv',
]

for pkg in packages:
    try:
        __import__(pkg)
        print(f'✓ {pkg}')
    except Exception as e:
        print(f'✗ {pkg}: {e}')
EOF
```

### Check Editable Installs

```bash
uv run python -c "import provide.foundation, pyvider, pathlib; print(pathlib.Path(provide.foundation.__file__).resolve()); print(pathlib.Path(pyvider.__file__).resolve())"
# Should show paths to local repositories
```

### Check Repository Structure

```bash
ls ../ | grep -E '(provide|pyvider|flavor|wrknv|plating|tofusoup|supsrc)'
# Should list all ecosystem repositories
```

## Validation in CI/CD

For automated environments:

```bash
#!/bin/bash
set -e

# Setup
./scripts/bootstrap.sh
./scripts/setup.sh

# Activate in script (can't use source in CI)
export PATH="$(pwd)/.venv/bin:$PATH"
export VIRTUAL_ENV="$(pwd)/.venv"

# Validate
./scripts/validate.sh --quiet

# If validation passes, exit code is 0
```

See [CI/CD Integration](../testing/ci-cd.md) for complete CI/CD workflows.

## Re-validation

You should re-run validation:

- After installation/setup
- After updating Python version
- After adding/removing packages
- After major git pulls across multiple repos
- When experiencing import errors
- Before committing major changes
- Before releases

## Next Steps

Once validation passes:

- **[Development Workflow](../guide/git-workflow.md)** - Start making changes
- **[Testing Guide](../testing/running-tests.md)** - Run tests across packages
- **[Architecture](../architecture/index.md)** - Understand the workspace structure
