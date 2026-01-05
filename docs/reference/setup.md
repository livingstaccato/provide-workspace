# setup.sh Reference

This reference is intentionally brief; see the linked guides below.

## Quick Usage

```bash
./scripts/setup.sh
```

Creates virtual environment and installs all packages in editable mode.

## Options

Run `./scripts/setup.sh --help` for options.

## What It Does

1. Creates `.venv/` virtual environment
2. Installs packages in dependency order (Foundation → Framework → Tools)
3. Uses editable installs (`uv add --editable`)
4. Installs development dependencies

## See Also

- [Installation Guide](../getting-started/installation.md)
- [Package Layers](../architecture/layers.md)
