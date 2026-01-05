# Installation Guide

Complete step-by-step guide for setting up the provide-workspace workspace.

## Prerequisites

Before starting, ensure you have all [required tools](prerequisites.md) installed.

## Installation Steps

### Step 1: Clone the Workspace Repository

Clone the provide-workspace repository to your local machine:

```bash
git clone https://github.com/provide-io/provide-workspace.git
cd provide-workspace
```

This creates the workspace root directory.

### Step 2: Bootstrap the Workspace

The bootstrap script clones all 19 provide.io ecosystem repositories:

```bash
./scripts/bootstrap.sh
```

**What it does:**

- Clones all ecosystem repositories as sibling directories
- Uses `gh` (GitHub CLI) if available, falls back to `git clone`
- Creates this directory structure:

```
parent-directory/
├── provide-workspace/        # ← You are here
├── provide-foundation/      # Cloned by bootstrap
├── provide-testkit/         # Cloned by bootstrap
├── pyvider/                 # Cloned by bootstrap
├── pyvider-cty/             # Cloned by bootstrap
├── pyvider-hcl/             # Cloned by bootstrap
├── pyvider-rpcplugin/       # Cloned by bootstrap
├── pyvider-components/      # Cloned by bootstrap
├── flavorpack/              # Cloned by bootstrap
├── wrknv/                   # Cloned by bootstrap
├── plating/                 # Cloned by bootstrap
├── tofusoup/                # Cloned by bootstrap
├── supsrc/                  # Cloned by bootstrap
├── provide-foundry/         # Cloned by bootstrap
└── ... (additional repos)
```

**Duration:** 5-10 minutes depending on network speed

**Alternative: Use Symbolic Links**

If you already have repositories cloned elsewhere, you can use symbolic links:

```bash
# Bootstrap will skip cloning for existing directories
ln -s /path/to/existing/pyvider ../pyvider
./scripts/bootstrap.sh
```

The script is idempotent - safe to run multiple times.

### Step 3: Install Dependencies

The setup script installs all packages in editable mode:

```bash
./scripts/setup.sh
```

**What it does:**

- Detects if `uv` is available
- Creates a shared virtual environment at `.venv/`
- Installs all packages in dependency order with editable installs
- Configures the environment for cross-package development

**Duration:** 3-5 minutes

**Output:**

```
Setting up provide.io development workspace...
Detected uv - using modern Python package manager
Creating virtual environment at .venv/
Installing packages in dependency order...

Foundation Layer:
✓ provide-foundation
✓ provide-testkit

Framework Layer:
✓ pyvider-cty
✓ pyvider-hcl
✓ pyvider-rpcplugin
✓ pyvider
✓ pyvider-components

Tools Layer:
✓ flavorpack
✓ wrknv
✓ plating
✓ tofusoup
✓ supsrc

Setup complete! Activate the environment:
    source .venv/bin/activate
```

### Step 4: Activate the Environment

Activate the shared virtual environment:

```bash
source .venv/bin/activate
```

You should see `(.venv)` in your shell prompt:

```bash
(.venv) user@host:~/provide-workspace$
```

**Add to Your Shell Profile** (optional but recommended):

```bash
# Add to ~/.bashrc or ~/.zshrc
alias activate-provide='source /path/to/provide-workspace/.venv/bin/activate'
```

Then use `activate-provide` from anywhere to activate the environment.

### Step 5: Validate Your Setup

Run the validation script to verify everything is working:

```bash
./scripts/validate.sh
```

**What it checks:**

- Python version (≥3.11)
- Virtual environment activation
- Package imports for all ecosystem packages
- Environment variable configuration

**Expected Output:**

```
Validating provide.io development workspace...

Python Version Check:
✓ Python 3.11.5

Virtual Environment Check:
✓ Virtual environment is active

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
... (all packages)

All checks passed! ✓

Your provide.io development workspace is ready.
```

If any checks fail, see [Validation](validation.md) for troubleshooting.

## Verification

After installation, verify the setup:

```bash
# Check that packages are installed in editable mode
uv pip list | grep provide
# Should show paths like: /Users/you/provide-workspace/provide-foundation

# Test an import
python3 -c "import pyvider; print(pyvider.__version__)"

# Run a simple test
cd pyvider/
uv run pytest tests/ -k "test_version"
```

## Next Steps

Your provide-workspace workspace is now ready!

### Learn the Basics

- **[Development Workflow](../guide/workflow/)** - Making changes and testing
- **[Cross-Package Development](../guide/cross-package.md)** - Working across packages
- **[Architecture](../architecture/index.md)** - Understanding the workspace structure

### Start Developing

Pick a package and dive in:

```bash
# Example: Work on pyvider
cd pyvider/
code .  # Open in VS Code

# Make changes, run tests
uv run pytest
```

### Build Documentation

View the complete ecosystem documentation:

```bash
cd provide-foundry/
we run docs.serve
# Visit http://localhost:11000
```

## Reinstalling

If you need to start over:

### Clean Reinstall

```bash
# Remove virtual environment
rm -rf .venv/

# Reinstall
./scripts/setup.sh
```

### Full Reset

```bash
# Remove all cloned repositories (CAUTION)
cd ..
rm -rf provide-*/  pyvider*/  flavor*/  wrknv  plating  tofusoup  supsrc

# Start fresh
cd provide-workspace/
./scripts/bootstrap.sh
./scripts/setup.sh
```

## Updating

To update all repositories to latest:

```bash
# Update provide-workspace itself
git pull

# Update all ecosystem packages
for dir in ../*/; do
  (cd "$dir" && git pull)
done

# Reinstall dependencies if needed
./scripts/setup.sh
```

## Troubleshooting

See [Common Issues](../troubleshooting/common.md) for solutions to common problems:

- [Import Errors](../troubleshooting/environment.md#import-errors)
- [Virtual Environment Issues](../troubleshooting/environment.md#virtual-environment-conflicts)
- [Permission Problems](../troubleshooting/script-errors.md#permission-denied)

## Alternative Installation Methods

### Using Existing Repositories

If you already have some repositories cloned:

```bash
# Create symlinks for existing repos
ln -s /path/to/existing/repo ../repo-name

# Bootstrap will skip existing directories
./scripts/bootstrap.sh

# Setup as normal
./scripts/setup.sh
```

### Minimal Installation

To install only specific packages (advanced):

```bash
# Bootstrap only certain repos
REPOS="provide-foundation pyvider" ./scripts/bootstrap.sh

# Install only those packages
./scripts/setup.sh
```

**Note:** Dependencies must be satisfied, so this requires understanding package relationships.

## Getting Help

If you encounter issues:

1. Check [Troubleshooting](../troubleshooting/common.md)
2. Review package-specific `CLAUDE.md` and `README.md` files
3. Open an issue in [provide-workspace](https://github.com/provide-io/provide-workspace/issues)
4. Ask in GitHub Discussions
