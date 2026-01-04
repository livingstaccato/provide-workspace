# Quick Start

Fast-track setup for provide-workspace in three commands.

## Prerequisites

Ensure you have:

- Python 3.11+
- uv
- Git
- 5GB free disk space

See [full prerequisites](prerequisites/) if any are missing.

## Setup (3 Commands)

```bash
# 1. Clone the workspace
git clone https://github.com/provide-io/provide-workspace.git
cd provide-workspace

# 2. Bootstrap all repositories (~5-10 min)
./scripts/bootstrap.sh

# 3. Install dependencies (~3-5 min)
./scripts/setup.sh
```

## Activate & Validate

```bash
# Activate the environment
source .venv/bin/activate

# Verify everything works
./scripts/validate.sh
```

Expected output:

```
✓ Python 3.11.5
✓ Virtual environment is active
✓ All packages imported successfully
All checks passed! ✓
```

## Test It

```bash
# Test an import
python3 -c "import pyvider; print(f'pyvider {pyvider.__version__}')"

# Run a test
cd pyvider/
uv run pytest tests/ -k "test_version"
```

## What You Have Now

- **13+ repositories** cloned as siblings to `provide-workspace/`
- **Shared `.venv`** with all packages installed in editable mode
- **Cross-package development** enabled - changes in one package immediately available in others

## Workspace Layout

```
parent-directory/
├── provide-workspace/      # ← Workspace manager (you are here)
│   ├── .venv/            # ← Shared virtual environment
│   ├── scripts/          # ← bootstrap.sh, setup.sh, validate.sh
│   └── wrknv.toml        # ← Workspace configuration
│
├── provide-foundation/   # Foundation layer
├── provide-testkit/
│
├── pyvider/              # Framework layer
├── pyvider-cty/
├── pyvider-hcl/
├── pyvider-rpcplugin/
├── pyvider-components/
│
├── flavorpack/           # Tools layer
├── wrknv/
├── plating/
├── tofusoup/
├── supsrc/
│
└── provide-foundry/      # Documentation hub
```

## Next Steps

### Make Your First Change

```bash
# 1. Navigate to a package
cd pyvider/

# 2. Open in your editor
code .  # or vim, emacs, etc.

# 3. Edit a file in src/
# Changes are immediately available!

# 4. Test your changes
uv run pytest

# 5. Format code
ruff format .
```

### Explore the Documentation

```bash
cd provide-foundry/
we run docs.serve
# Visit http://localhost:11000
```

### Run Tests Across Packages

```bash
# Test a single package
cd pyvider/
uv run pytest

# Test with coverage
uv run pytest --cov=src --cov-report=html

# Test integration
cd pyvider/
uv run pytest tests/integration/
```

## Common Commands

```bash
# Activate environment (run from anywhere)
source /path/to/provide-workspace/.venv/bin/activate

# Update all repositories
cd provide-workspace/
for dir in ../*/; do (cd "$dir" && git pull); done

# Reinstall dependencies
./scripts/setup.sh

# Validate setup
./scripts/validate.sh
```

## Troubleshooting Quick Fixes

### Import Error

```bash
source .venv/bin/activate
./scripts/setup.sh
```

### Permission Denied

```bash
chmod +x scripts/*.sh
```

### Missing Repositories

```bash
./scripts/bootstrap.sh  # Safe to re-run
```

### Outdated Dependencies

```bash
./scripts/setup.sh  # Reinstalls all packages
```

## Need More Details?

- **[Installation Guide](installation/)** - Detailed step-by-step instructions
- **[Validation Guide](validation/)** - Understanding validation checks
- **[Development Workflow](../guide/workflow/)** - How to work with the workspace
- **[Troubleshooting](../troubleshooting/common/)** - Solutions to common issues

## One-Liner Setup

For the bold:

```bash
git clone https://github.com/provide-io/provide-workspace.git && \
cd provide-workspace && \
./scripts/bootstrap.sh && \
./scripts/setup.sh && \
source .venv/bin/activate && \
./scripts/validate.sh
```

(Not recommended for first-time setup - better to run commands individually to catch issues early.)
