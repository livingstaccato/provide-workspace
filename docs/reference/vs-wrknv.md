# provide-workspace vs wrknv

Understanding the relationship between the workspace and the tool.

## Quick Answer

- **wrknv** = the tool (like Make, Task, or npm)
- **provide-workspace** = workspace configuration (like Makefile, Taskfile, or package.json)

## The Relationship

**wrknv** is a general-purpose work environment management tool.
**provide-workspace** uses wrknv's configuration format to manage the provide.io ecosystem.

## Analogy

| Tool | Configuration |
|------|---------------|
| Make | Makefile |
| Task | Taskfile.yml |
| npm | package.json |
| Docker | docker-compose.yml |
| **wrknv** | **wrknv.toml** |
| | **provide-workspace** |

## You Can Use wrknv For:

- Your own multi-repository workspaces
- Different project structures
- Custom workspace automation
- Any Python (or other) multi-repo project

## provide-workspace Is:

- A specific wrknv configuration
- Tailored for provide.io ecosystem
- Reference implementation of wrknv usage
- Template for creating your own workspace

## Learn More

- **[wrknv Documentation](https://foundry.provide.io/wrknv/)** - Full wrknv capabilities
- **[wrknv Integration](../architecture/wrknv-integration/)** - How provide-workspace uses wrknv
