# Git Workflow

This guide is intentionally brief; see the linked guides below.

## Key Points

- Each package has its own git repository
- Changes are **auto-committed** but NOT auto-pushed
- Standard git workflows (branches, PRs) work normally

## Basic Workflow

```bash
cd pyvider/
# ... make changes (auto-committed) ...
git push

# Create PR on GitHub
gh pr create
```

## See Also

- [Development Workflow](git-workflow.md)
- [CLAUDE.md](../../CLAUDE.md) for auto-commit details
