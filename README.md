# provide-workspace

Development workspace setup for the provide.io ecosystem.

## Key Features
- One-command bootstrap to clone and configure the full ecosystem.
- Scripts for setup, validation, and common workspace workflows.
- Centralized docs for workspace conventions and tooling.

## Quick Start

```bash
# Clone this repository
git clone https://github.com/provide-io/provide-workspace.git
cd provide-workspace

# Bootstrap the entire workspace (clones all repositories)
./scripts/bootstrap.sh

# Set up development environment
./scripts/setup.sh

# Validate your setup
./scripts/validate.sh
```

## Documentation

For comprehensive documentation on the entire ecosystem, visit:

- **Local**: Run `cd provide-foundry && we docs serve` and visit http://localhost:8000
- **Online**: [provide.io documentation](https://docs.provide.io) (when available)

## Development
- See [CLAUDE.md](CLAUDE.md) for local development notes.
- Run `./scripts/validate.sh` to confirm your environment.

## Contributing

See [CLAUDE.md](CLAUDE.md) for workspace development guidance, and check each package for its own `CONTRIBUTING.md` when available.

## License

See individual package repositories for license information.

## What is provide-workspace?

This repository provides the development environment setup for working with the provide.io ecosystem, which includes 13+ interconnected Python packages for infrastructure-as-code tooling, particularly around Terraform provider development.

## Prerequisites

- **Python 3.11+** (required across all packages)
- **uv** - Modern Python package installer ([install instructions](https://github.com/astral-sh/uv))
- **Git** - Version control
- **Go 1.21+** - For some tooling components

## Workspace Structure

After running `bootstrap.sh`, your workspace will contain:

```
provide-workspace/                 # This repository
├── provide-foundation/          # Core telemetry, logging, error handling
├── provide-testkit/            # Unified testing framework
├── pyvider/                    # Core Terraform provider framework
├── pyvider-cty/                # CTY type system (Terraform types)
├── pyvider-hcl/                # HCL parsing
├── pyvider-rpcplugin/          # gRPC plugin protocol
├── pyvider-components/         # Standard components library
├── flavorpack/                 # PSPF packaging system
├── wrknv/                      # Work environment management
├── plating/                    # Documentation generation
├── tofusoup/                   # Conformance testing
├── supsrc/                     # Git automation
├── provide-foundry/            # Documentation hub
└── terraform-provider-pyvider/ # Official Pyvider provider
```

## Development Workflow

### Working with Multiple Packages

All packages are installed in editable mode, so changes to any package are immediately reflected in others:

```bash
# Activate the workspace environment
source .venv/bin/activate

# Make changes in any package
cd pyvider/
# Edit code...

# Changes are immediately available to dependent packages
cd ../pyvider-components/
python -c "import pyvider; print(pyvider.__version__)"
```

### Running Tests

```bash
# Run tests for a specific package
cd pyvider/
uv run pytest

# Run tests for all packages
cd provide-workspace/
./scripts/validate.sh --all-tests
```

### Building Documentation

```bash
# Build unified documentation
cd provide-foundry/
we docs build

# Serve documentation locally
we docs serve
```

## Common Tasks

### Adding a New Dependency

```bash
cd <package-name>/
uv add <dependency-name>
```

### Code Formatting and Linting

```bash
# Format code
ruff format .

# Check for issues
ruff check .
```

### Type Checking

```bash
mypy src/
```

## Project Standards

- **Python 3.11+ only** - No backward compatibility
- **Modern type hints** - Use `str | None`, not `Optional[str]`
- **attrs for data classes** - Preferred over dataclasses
- **Google-style docstrings**
- **No inline defaults** - Use `constants.py` or `defaults.py`

## Git Workflow

- Changes are auto-committed (via supsrc)
- Changes are **NOT** auto-pushed
- No git rollback capability - be careful with changes

## Getting Help

- Check the [detailed setup guide](docs/development-setup.md)
- Review package-specific CLAUDE.md files for AI-assisted development notes
- Open an issue in the relevant repository
