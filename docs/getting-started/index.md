# Getting Started with provide-workspace

Welcome to provide-workspace, the workspace manager for the provide.io ecosystem!

## What You'll Learn

This section guides you through setting up a complete provide.io development environment:

1. **[Prerequisites](prerequisites/)** - Required tools and system requirements
2. **[Installation](installation/)** - Step-by-step setup process
3. **[Quick Start](quick-start/)** - Fast-track setup (3 commands)
4. **[Validation](validation/)** - Verify your environment is working

## Overview

provide-workspace sets up a **unified development workspace** for all 13+ provide.io packages:

```bash
# Three commands to complete setup
./scripts/bootstrap.sh   # Clone all repositories
./scripts/setup.sh       # Install dependencies
./scripts/validate.sh    # Verify environment
```

After running these commands, you'll have:

- All ecosystem repositories cloned as siblings
- A shared virtual environment (`.venv`) with all packages
- Editable installs enabling cross-package development
- Validated Python imports and environment configuration

## What Gets Installed?

### Foundation Layer
- **provide-foundation** - Core infrastructure utilities
- **provide-testkit** - Testing framework

### Framework Layer
- **pyvider** ecosystem (5 packages) - Terraform provider framework

### Tools Layer
- **flavorpack**, **wrknv**, **plating**, **tofusoup**, **supsrc**

Plus Terraform providers, CI tooling, and documentation hub.

## Time Required

- **Quick Start**: ~5-10 minutes (depending on network speed for cloning)
- **Full Setup with Validation**: ~15 minutes
- **First-time Python/Git setup**: Add 10-30 minutes for prerequisites

## Next Steps

New to the ecosystem? Start with [Prerequisites](prerequisites/) to ensure you have required tools.

Already have the tools? Jump to [Quick Start](quick-start/) for immediate setup.

Want detailed explanations? Follow the [Installation](installation/) guide step-by-step.
