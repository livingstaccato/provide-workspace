# Development Setup Guide

Complete guide for setting up the provide.io development workspace.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Initial Setup](#initial-setup)
- [Workspace Structure](#workspace-structure)
- [Development Workflow](#development-workflow)
- [Testing](#testing)
- [Documentation](#documentation)
- [Troubleshooting](#troubleshooting)

## Prerequisites

### Required Tools

1. **Python 3.11+**
   ```bash
   python3 --version  # Should be 3.11 or higher
   ```

2. **uv** - Modern Python package installer
   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```

3. **Git**
   ```bash
   git --version
   ```

4. **GitHub CLI** (optional but recommended)
   ```bash
   brew install gh  # macOS
   # or follow: https://cli.github.com/
   ```

5. **Make** (for documentation builds)
   ```bash
   make --version
   ```

6. **Go 1.24+** (for some tooling components)
   ```bash
   go version
   ```

### System Requirements

- macOS, Linux, or WSL2 on Windows
- 8GB+ RAM recommended
- 5GB+ free disk space

## Initial Setup

### 1. Clone the Workspace Repository

```bash
git clone https://github.com/provide-io/provide-workspace.git
cd provide-workspace
```

### 2. Bootstrap the Workspace

This clones all provide.io repositories:

```bash
./scripts/bootstrap.sh
```

This will create a directory structure like:

```
provide-workspace/
├── provide-foundation/
├── provide-testkit/
├── pyvider/
├── pyvider-cty/
├── pyvider-hcl/
├── pyvider-rpcplugin/
├── pyvider-components/
├── flavorpack/
├── wrknv/
├── plating/
├── tofusoup/
├── supsrc/
└── provide-foundry/
```

### 3. Install Dependencies

```bash
./scripts/setup.sh
```

This creates a shared virtual environment (`.venv`) and installs all packages in editable mode.

### 4. Activate the Environment

```bash
source .venv/bin/activate
```

### 5. Validate Your Setup

```bash
./scripts/validate.sh
```

## Workspace Structure

### Package Layers

The provide.io ecosystem is organized in dependency layers:

```
Foundation Layer
├── provide-foundation  # Core telemetry, logging, error handling
└── provide-testkit    # Testing framework

Framework Layer (Pyvider)
├── pyvider-cty        # CTY type system (Terraform types)
├── pyvider-hcl        # HCL parsing
├── pyvider-rpcplugin  # gRPC plugin protocol
└── pyvider            # Core Terraform provider framework

Components Layer
└── pyvider-components # Standard components library

Tools Layer
├── flavorpack         # PSPF packaging system
├── wrknv              # Work environment management
├── plating            # Documentation generation
├── tofusoup           # Conformance testing
└── supsrc             # Git automation

Infrastructure
└── provide-foundry    # Documentation hub
```

### Virtual Environment

All packages share a single virtual environment at `provide-workspace/.venv`:

- Located at workspace root
- Packages installed in editable mode with `uv pip install -e`
- Changes to any package immediately visible to others
- Separate from individual project `workenv/` directories

## Development Workflow

### Making Changes

1. **Navigate to the package**
   ```bash
   cd pyvider/
   ```

2. **Make your changes**
   Edit source files in `src/`

3. **Changes are immediately available**
   Since packages are installed in editable mode, changes are live:
   ```bash
   python3 -c "import pyvider; print(pyvider.__version__)"
   ```

4. **Run tests**
   ```bash
   uv run pytest
   ```

5. **Format and lint**
   ```bash
   ruff format .
   ruff check .
   ```

### Working with Dependencies

#### Adding a Dependency

```bash
cd <package-name>/
uv add <dependency-name>
```

#### Adding a Dev Dependency

```bash
uv add --dev <dependency-name>
```

#### Updating Dependencies

```bash
uv lock --upgrade
```

### Cross-Package Development

When working on changes that span multiple packages:

1. Make changes in the dependency package first
2. Changes are immediately reflected in dependent packages
3. Test in dependent packages without reinstalling

Example:

```bash
# Make changes to pyvider-hcl
cd pyvider-hcl/
# Edit src/pyvider/hcl/parser.py

# Test immediately in pyvider
cd ../pyvider/
uv run pytest tests/test_hcl_integration.py
```

## Testing

### Running Tests for a Single Package

```bash
cd <package-name>/
uv run pytest
```

### Running Tests with Coverage

```bash
uv run pytest --cov=src --cov-report=html
```

### Running All Tests

```bash
./scripts/validate.sh --all-tests
```

### Test Structure

Each package follows this structure:

```
<package>/
├── src/
│   └── <package>/
│       └── __init__.py
└── tests/
    ├── unit/
    ├── integration/
    └── conftest.py
```

### Testing provide-workspace

The workspace repository itself includes tests for the bootstrap, setup, and validate scripts.

#### Running Workspace Tests

```bash
# Run all tests
pytest tests/

# Run only unit tests
pytest tests/unit/

# Run only integration tests
pytest tests/integration/

# Run with verbose output
pytest tests/ -v

# Run specific test file
pytest tests/unit/test_bootstrap_unit.py
```

#### Test Categories

- **Unit Tests** (`tests/unit/`) - Test script logic with mocked commands
- **Integration Tests** (`tests/integration/`) - Test scripts with real execution
- **Full Workflow Tests** - End-to-end bootstrap → setup → validate workflows

#### Running Tests with Coverage

For code coverage analysis (run separately from default tests):

```bash
# Full coverage report with branch coverage and missing lines
pytest tests/ --cov=scripts --cov-branch --cov-report=term-missing

# Generate HTML coverage report
pytest tests/ --cov=scripts --cov-branch --cov-report=html
# Open htmlcov/index.html in browser

# Generate XML coverage report (for CI/CD)
pytest tests/ --cov=scripts --cov-branch --cov-report=xml
```

**Note:** Coverage runs separately from default tests to keep fast feedback during development. CI/CD workflows will run coverage checks automatically.

#### Running Shellcheck

Lint bash scripts with shellcheck:

```bash
# Check all scripts
shellcheck scripts/*.sh

# Check specific script
shellcheck scripts/bootstrap.sh
```

Configuration is in `.shellcheckrc`.

#### GitHub Actions Workflows

Workflows are manually triggered (no automatic PR/push triggers yet):

1. **CI Workflow** (`.github/workflows/ci.yml`)
   - Runs shellcheck, ruff, mypy, and pytest
   - Tests on both Ubuntu and macOS

2. **Validate Workflow** (`.github/workflows/validate-workflow.yml`)
   - Full end-to-end workflow testing
   - Tests with and without optional tools (uv)

To trigger manually:
- Go to Actions tab in GitHub
- Select the workflow
- Click "Run workflow"

## Documentation

### Building Documentation

The unified documentation is built from `provide-foundry`:

```bash
cd provide-foundry/
we run docs.build
```

### Serving Documentation Locally

```bash
cd provide-foundry/
we run docs.serve
```

Then visit http://localhost:11000

### Building Individual Package Docs

```bash
cd <package-name>/
we run docs.serve
```

### Documentation Structure

Each package has:

- `docs/` - Markdown documentation
- `mkdocs.yml` - MkDocs configuration (inherits from base)
- API docs auto-generated from docstrings

## Troubleshooting

### Import Errors

**Problem**: `ModuleNotFoundError: No module named 'pyvider'`

**Solution**: Ensure the virtual environment is activated and packages are installed:
```bash
source .venv/bin/activate
./scripts/setup.sh
```

### Outdated Package Changes

**Problem**: Changes to a package aren't reflected in another package

**Solution**: Editable installs should work automatically. Verify installation:
```bash
pip list | grep pyvider
# Should show paths like: /Users/you/provide-workspace/pyvider
```

### Virtual Environment Conflicts

**Problem**: Packages using wrong virtual environment

**Solution**: Deactivate all environments and re-activate workspace:
```bash
deactivate
cd /path/to/provide-workspace
source .venv/bin/activate
```

### Missing Repositories

**Problem**: Some repositories not cloned

**Solution**: Re-run bootstrap (it's idempotent):
```bash
./scripts/bootstrap.sh
```

### Test Failures

**Problem**: Tests failing in fresh setup

**Solution**:
1. Ensure all dependencies are installed: `./scripts/setup.sh`
2. Check Python version: `python3 --version` (must be 3.11+)
3. Run validation: `./scripts/validate.sh`

### Documentation Build Errors

**Problem**: `we run docs.build` fails

**Solution**:
1. Ensure Make is installed
2. Install doc dependencies:
   ```bash
   cd provide-foundry/
   uv pip install -e ".[docs]"
   ```

### Permission Denied on Scripts

**Problem**: `./scripts/bootstrap.sh: Permission denied`

**Solution**: Make scripts executable:
```bash
chmod +x scripts/*.sh
```

## Git Workflow

### Important Notes

- Changes are **auto-committed** but NOT auto-pushed
- There is **no git rollback** capability - be careful
- Each package has its own git repository

### Making Commits

Changes are auto-committed when you save files. To push:

```bash
cd <package-name>/
git push
```

### Branch Management

```bash
# Create a feature branch
cd <package-name>/
git checkout -b feature/my-feature

# Make changes (auto-committed)

# Push to remote
git push -u origin feature/my-feature
```

## Advanced Topics

### Adding a New Package to the Ecosystem

1. Create the package repository
2. Add it to `scripts/bootstrap.sh` in the `REPOS` array
3. Add it to `scripts/setup.sh` in the `PACKAGES` array (in dependency order)
4. Update `.gitignore` to exclude it
5. Add it to provide-foundry's `mkdocs.yml`

### Custom uv Configuration

Create a `uv.toml` in the workspace root for custom settings:

```toml
[tool.uv]
cache-dir = "~/.cache/uv"
```

### Using Different Python Versions

```bash
uv venv --python 3.12
source .venv/bin/activate
./scripts/setup.sh
```

## Getting Help

- Check package-specific `CLAUDE.md` files
- Review package README files
- Open issues in the relevant repository
- Ask in team channels

## Next Steps

After setup, you can:

1. Explore the codebase: `cd pyvider && ls -la`
2. Run tests: `uv run pytest`
3. Build documentation: `cd provide-foundry && we run docs.serve`
4. Start developing!
