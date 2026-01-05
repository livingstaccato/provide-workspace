# Scripts Reference

Detailed documentation for provide-workspace management scripts.

## Overview

provide-workspace provides three core scripts:

- **[bootstrap.sh](bootstrap.md)** - Clone all ecosystem repositories
- **[setup.sh](setup.md)** - Install dependencies and configure environment
- **[validate.sh](validate.md)** - Verify workspace setup

## Quick Reference

```bash
# Bootstrap (clone repos)
./scripts/bootstrap.sh

# Setup (install packages)
./scripts/setup.sh

# Validate (verify environment)
./scripts/validate.sh
```

## Configuration

See [Configuration Reference](configuration.md) for `wrknv.toml` format and options.

## Documentation Status

📝 Detailed script documentation is in progress. For now, see:
- Scripts have inline comments and `--help` options
- [Development Setup](../getting-started/installation.md) for usage examples
- Script source code in `scripts/` directory
