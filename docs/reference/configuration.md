# Configuration Reference

This reference is intentionally brief; see the linked guides below.

## wrknv.toml Format

```toml
[workspace]
name = "provide-workspace"
description = "Workspace manager for provide.io ecosystem"

[[siblings]]
name = "provide-foundation"
path = "../provide-foundation"
repo = "https://github.com/provide-io/provide-foundation.git"

[[siblings]]
name = "pyvider"
path = "../pyvider"
repo = "https://github.com/provide-io/pyvider.git"

# ... more siblings
```

## See Also

- [wrknv Integration](../architecture/wrknv-integration.md)
- [wrknv Documentation](https://foundry.provide.io/wrknv/)
