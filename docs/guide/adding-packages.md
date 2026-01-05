# Adding Packages

This guide is intentionally brief; see the linked guides below.

## Quick Steps

1. Create package repository
2. Add to `wrknv.toml`:
   ```toml
   [[siblings]]
   name = "new-package"
   path = "../new-package"
   repo = "https://github.com/provide-io/new-package.git"
   ```
3. Add to `bootstrap.sh` and `setup.sh`
4. Re-run setup:
   ```bash
   ./scripts/bootstrap.sh
   ./scripts/setup.sh
   ```

## See Also

- [Configuration Reference](../reference/configuration.md)
