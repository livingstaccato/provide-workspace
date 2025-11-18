# provide-workspace

This repository provides the development workspace setup for the provide.io ecosystem.

## Project Purpose

provide-workspace is the entry point for developers working with the provide.io ecosystem. It provides:

1. Scripts to bootstrap the entire workspace by cloning all necessary repositories
2. Setup and validation tools for the development environment
3. Documentation on workspace structure and development workflows
4. Centralized configuration for workspace-level tooling

## Key Files

- `scripts/bootstrap.sh` - Clones all provide-io repositories into the workspace
- `scripts/setup.sh` - Installs dependencies across all projects
- `scripts/validate.sh` - Verifies environment setup and runs health checks
- `docs/development-setup.md` - Detailed developer onboarding guide

## Guidelines for AI Assistants

### Repository Management
- Changes are auto-committed but NOT auto-pushed
- No git rollback capability - be careful with modifications
- Do not update files in virtual environments (venv/workenv) directly

### Workspace Structure
- This is a meta-repository for workspace setup, not a true monorepo
- Individual projects are cloned as sibling directories
- Each project maintains its own git repository and history

### Scripts
- Bootstrap script should be idempotent (safe to run multiple times)
- Setup script should detect and use uv for dependency management
- Validate script should check for common setup issues

### Documentation
- Keep README.md concise and focused on quick start
- Put detailed information in docs/development-setup.md
- Update documentation when adding new repositories to the ecosystem

## Standards

- Python 3.11+ only (no backward compatibility)
- Modern type hints: `str | None`, not `Optional[str]`
- Use `attrs` for data classes
- Google-style docstrings
- No inline defaults - use `constants.py` or `defaults.py`

## Testing

This repository primarily contains scripts and documentation. Testing should focus on:
- Script functionality and error handling
- Idempotency of setup operations
- Detection of missing prerequisites
