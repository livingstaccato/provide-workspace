# bootstrap.sh Reference

This reference is intentionally brief; see the linked guides below.

## Quick Usage

```bash
./scripts/bootstrap.sh
```

Clones all ecosystem repositories as siblings to provide-workspace.

## Options

Run `./scripts/bootstrap.sh --help` for options.

## What It Does

1. Reads `wrknv.toml` to find all sibling repositories
2. Checks if each repository exists
3. Clones missing repositories using `gh` or `git`
4. Skips existing directories (idempotent)

## See Also

- [Installation Guide](../getting-started/installation.md)
- [wrknv Integration](../architecture/wrknv-integration.md)
