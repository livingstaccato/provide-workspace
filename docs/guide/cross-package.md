# Cross-Package Development

This guide is intentionally brief; see the linked guides below.

## Quick Example

```bash
# Edit in one package
cd provide-foundation/
# ... make changes to logger ...

# Test in another package (immediate!)
cd ../pyvider/
uv run pytest tests/test_logging.py
```

## How It Works

Editable installs (`uv pip install -e`) make changes immediately available without reinstall.

## See Also

- [Development Workflow](workflow/)
- [Package Layers](../architecture/layers.md)
- [uv Documentation](https://docs.astral.sh/uv/)
