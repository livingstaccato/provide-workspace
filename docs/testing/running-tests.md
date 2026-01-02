# Running Tests

This guide is intentionally brief; see the linked guides below.

## Quick Commands

```bash
# Single package
cd pyvider/
uv run pytest

# With coverage
uv run pytest --cov=src --cov-report=html

# Specific test
uv run pytest tests/test_specific.py

# Verbose
uv run pytest -v
```

## See Also

- [Testing Overview](index/)
