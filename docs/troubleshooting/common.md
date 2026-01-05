# Common Issues

Common problems and solutions.

## Import Errors

**Problem**: `ModuleNotFoundError: No module named 'pyvider'`

**Solution**:
```bash
source .venv/bin/activate
./scripts/setup.sh
```

## Missing Repositories

**Problem**: Some repositories not cloned

**Solution**:
```bash
./scripts/bootstrap.sh  # Safe to re-run
```

## Virtual Environment Issues

**Problem**: Wrong environment active

**Solution**:
```bash
deactivate
cd /path/to/provide-workspace
source .venv/bin/activate
```

## Documentation Status

For setup verification, see [Validation Guide](../getting-started/validation.md).
