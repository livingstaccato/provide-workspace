# provide-workspace

!!! warning "Pre-release"
    This documentation covers a pre-release. APIs and features may change during the pre-release series.


**Workspace manager for the provide.io ecosystem**

## Overview

`provide-workspace` is the **official workspace management solution** for developing with the provide.io ecosystem. It orchestrates all 19 repositories across four architectural layers (Foundation, Framework, Tools, Providers), providing a unified development environment with a single command.

Unlike traditional monorepos, provide-workspace uses a **meta-repository pattern** - each package maintains its own repository while the workspace provides coordination, shared tooling, and integrated development workflows.

## Why provide-workspace?

**Single-Command Setup**
:   Clone all 19 repositories, install dependencies, and configure your development environment with three commands.

**Unified Development**
:   Work across multiple packages with editable installs, shared virtual environment, and integrated testing.

**Flexible Organization**
:   Choose between cloning repositories or symlinking existing ones. Mix and match based on your workflow.

**Built on wrknv**
:   Demonstrates best practices for workspace management using `wrknv`, the work environment automation tool.

**Maintained & Documented**
:   Official workspace configuration for the provide.io ecosystem with comprehensive documentation.

## Quick Start

```bash
# Clone the workspace manager
git clone https://github.com/provide-io/provide-workspace.git
cd provide-workspace

# Bootstrap all ecosystem repositories
./scripts/bootstrap.sh

# Install dependencies and configure environment
./scripts/setup.sh

# Validate your setup
./scripts/validate.sh
```

That's it! You now have a complete provide.io development environment with all packages installed in editable mode.

## What Gets Set Up?

provide-workspace manages the complete ecosystem:

### Foundation Layer
- **provide-foundation**: Core telemetry, logging, and infrastructure utilities
- **provide-testkit**: Unified testing framework with fixtures and utilities

### Framework Layer
- **pyvider**: Core Terraform provider framework in Python
- **pyvider-cty**: CTY type system bindings for Terraform data types
- **pyvider-hcl**: HCL parsing and manipulation
- **pyvider-rpcplugin**: gRPC plugin protocol implementation
- **pyvider-components**: Standard reusable provider components

### Tools Layer
- **flavorpack**: PSPF/2025 packaging system for secure executable bundles
- **wrknv**: Work environment management and toolchain automation
- **plating**: Documentation and code generation templates
- **tofusoup**: Cross-language conformance testing framework
- **supsrc**: Automated Git workflow and commit management

Plus Terraform providers, CI tooling, and documentation hub.

## Workspace Structure

```
provide-workspace/
├── scripts/
│   ├── bootstrap.sh    # Clone/symlink repositories
│   ├── setup.sh        # Install dependencies
│   └── validate.sh     # Verify environment
├── wrknv.toml          # Workspace configuration
├── .venv/              # Shared virtual environment
└── ../                 # Sibling directories
    ├── provide-foundation/
    ├── provide-testkit/
    ├── pyvider/
    ├── pyvider-cty/
    ├── pyvider-hcl/
    ├── pyvider-rpcplugin/
    ├── flavorpack/
    ├── wrknv/
    ├── plating/
    ├── tofusoup/
    └── ... (19 repositories)
```

## How It Works

provide-workspace uses a **meta-repository pattern**:

1. **bootstrap.sh** clones or symlinks all ecosystem repositories as siblings
2. **setup.sh** creates a shared `.venv` and installs all packages in editable mode
3. **validate.sh** verifies Python version, imports, and environment configuration
4. **wrknv.toml** defines workspace structure and package relationships

This means changes in any package are immediately available across the workspace - no reinstall needed.

## Key Features

### Cross-Package Development
Make changes in `provide-foundation`, and test them immediately in `pyvider` without rebuilding or reinstalling.

### Consistent Tooling
All packages share the same Python environment, code formatters, linters, and testing framework.

### Git Workflow Integration
Work with individual repositories for commits/PRs while maintaining workspace coordination.

### Validation & Quality
Built-in checks for environment setup, import validation, and dependency resolution.

### CI/CD Integration
GitHub Actions workflows test the bootstrap process to ensure new contributors can set up quickly.

## Documentation Sections

<div class="grid cards" markdown>

-   :material-rocket-launch: **[Getting Started](getting-started/index/)**

    ---

    Prerequisites, installation steps, and validation workflows

-   :material-sitemap: **[Architecture](architecture/index/)**

    ---

    Meta-repository pattern, package layers, and workspace concepts

-   :material-script-text: **[Scripts Reference](reference/index/)**

    ---

    Detailed documentation for bootstrap.sh, setup.sh, and validate.sh

-   :material-book-open: **[User Guide](guide/workflow/)**

    ---

    Development workflows, cross-package development, and git strategies

-   :material-test-tube: **[Testing](testing/index/)**

    ---

    Running tests, test structure, and CI/CD integration

-   :material-help-circle: **[Troubleshooting](troubleshooting/common/)**

    ---

    Common issues, script errors, and environment problems

</div>

## wrknv vs provide-workspace

**wrknv** is the *tool* - a general-purpose work environment manager
**provide-workspace** *uses* wrknv to manage the provide.io ecosystem

Think of wrknv as Make or Task, and provide-workspace as a specific Makefile configured for the provide.io ecosystem. You can use wrknv to create your own workspaces, and provide-workspace shows you how.

See [provide-workspace vs wrknv](reference/vs-wrknv/) for detailed comparison.

## Next Steps

New to provide.io? Start here:

1. **[Prerequisites](getting-started/prerequisites/)** - Ensure you have required tools
2. **[Installation](getting-started/installation/)** - Step-by-step setup guide
3. **[Development Workflow](guide/workflow/)** - Learn common development patterns
4. **[Architecture](architecture/index/)** - Understand the meta-repository pattern

## Support

- **Issues**: [GitHub Issues](https://github.com/provide-io/provide-workspace/issues)
- **Discussions**: [GitHub Discussions](https://github.com/provide-io/provide-workspace/discussions)
- **Documentation**: [Foundry Documentation](https://foundry.provide.io)
