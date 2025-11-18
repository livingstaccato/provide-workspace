# Configuration Reference

📝 Detailed documentation coming soon.

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

- [wrknv Integration](../architecture/wrknv-integration/)
- [wrknv Documentation](https://foundry.provide.io/wrknv/)
