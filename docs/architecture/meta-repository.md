# Meta-Repository Pattern

Deep dive into the meta-repository pattern and how provide-workspace implements it.

## What is a Meta-Repository?

A **meta-repository** is a coordination repository that manages multiple independent repositories as a unified workspace, without merging them into a single repository (monorepo).

Think of it as:
- **Not a monorepo**: Code stays in separate repositories
- **Not individual repos**: Coordinated setup and development
- **A workspace manager**: Orchestrates multiple repos for unified development

## How provide-workspace Implements It

### 1. Sibling Directory Structure

All repositories are cloned as siblings:

```
parent-directory/
├── provide-workspace/      # Meta-repository (coordinator)
├── provide-foundation/   # Independent repository
├── pyvider/              # Independent repository
└── ... (19 repos)
```

**Why siblings?**
- Clean separation between workspace and packages
- Standard relative paths (`../provide-foundation`)
- Easy to work with individual repos when needed
- No nested `.git` directories conflicts

### 2. Unified Virtual Environment

One `.venv` in the workspace root:

```bash
provide-workspace/.venv/
├── bin/python3          # Python interpreter
├── lib/...              # Installed packages
└── pyvreate-workspace
```

**All packages installed with `-e` (editable mode)**:
```bash
uv add --editable ../provide-foundation
uv add --editable ../pyvider
# ... etc
```

This makes changes immediately available without reinstall.

### 3. Configuration-Driven Setup

`wrknv.toml` defines the workspace:

```toml
[[siblings]]
name = "provide-foundation"
path = "../provide-foundation"
repo = "https://github.com/provide-io/provide-foundation.git"

[[siblings]]
name = "pyvider"
path = "../pyvider"
repo = "https://github.com/provide-io/pyvider.git"
```

The bootstrap script reads this configuration and clones/verifies all repositories.

### 4. Automated Coordination

Three scripts coordinate the workspace:

- **bootstrap.sh**: Clones all repositories based on configuration
- **setup.sh**: Installs all packages in correct dependency order
- **validate.sh**: Verifies environment is correctly configured

## Benefits Over Alternatives

### vs. Monorepo

| Aspect | Meta-Repository | Monorepo |
|--------|-----------------|----------|
| **Git History** | Clean, per-package | Mixed, all packages |
| **Repository Size** | Small, focused | Large, grows forever |
| **Clone Time** | Fast per repo | Slow, one huge clone |
| **Tooling** | Standard Git | Custom (Bazel, Nx, etc.) |
| **CI/CD** | Per-package, focused | Global or complex splitting |
| **Releases** | Independent | Coordinated or complex |
| **Learning Curve** | Git knowledge | New tooling required |

**When monorepo wins**: Atomic cross-package changes, guaranteed consistency

**When meta-repository wins**: Independent release cycles, standard tooling, clear ownership

### vs. Manual Individual Clones

| Aspect | Meta-Repository | Individual Clones |
|--------|-----------------|-------------------|
| **Setup** | 3 commands | 19 clone + setup commands |
| **Consistency** | Enforced | Manual |
| **Cross-Package Dev** | Seamless editable installs | Manual `uv add --editable` everywhere |
| **Documentation** | Integrated | Fragmented across repos |
| **Onboarding** | Quick, automated | Slow, error-prone |

**When individual wins**: Working on single package only

**When meta-repository wins**: Cross-package development, new contributors, consistency

## Trade-offs

### Advantages

1. **Independent Repositories**
   - Each package has its own git history
   - Clear ownership and boundaries
   - Standard GitHub workflows (PRs, issues, releases)

2. **Flexible Development**
   - Work with all packages or subset
   - Clone what you need
   - Symlink existing clones

3. **Standard Tooling**
   - Works with standard Git
   - Compatible with all Python tools
   - No custom build systems required

4. **Per-Package CI/CD**
   - Each package can optimize its own pipeline
   - Faster CI (only test what changed)
   - Clear failure attribution

### Disadvantages

1. **Coordination Overhead**
   - Cross-package changes need multiple PRs
   - Must coordinate breaking changes
   - Version compatibility management

2. **Initial Clone Time**
   - 19 `git clone` operations
   - Though automated, takes longer than one clone
   - Network-dependent

3. **Dependency Management**
   - Must explicitly manage inter-package versions
   - Can have version conflicts
   - Requires careful release coordination

4. **Discovery**
   - Changes scattered across repositories
   - Need to check multiple repos for issues
   - Can miss related changes

## Implementation Pattern

The meta-repository pattern requires:

1. **Workspace Configuration** (`wrknv.toml`)
   - List all sibling repositories
   - Define paths and URLs
   - Specify any workspace-level settings

2. **Bootstrap Script** (`bootstrap.sh`)
   - Clone missing repositories
   - Skip existing directories
   - Support symbolic links

3. **Setup Script** (`setup.sh`)
   - Create shared virtual environment
   - Install packages in dependency order
   - Use editable installs

4. **Validation Script** (`validate.sh`)
   - Verify Python version
   - Check virtual environment
   - Test package imports

## When to Use Meta-Repository

**Good fit when:**
- Multiple related packages with independent release cycles
- Want standard Git/GitHub workflows
- Team familiar with Python packaging
- Packages can be used independently
- Clear package boundaries

**Not a good fit when:**
- Single monolithic application
- Require atomic cross-package changes
- Complex build dependencies between packages
- Team prefers monorepo workflows
- Need guaranteed version consistency

## Real-World Example

provide-workspace manages:
- 19 repositories
- 4 architectural layers
- Independent release cycles
- Cross-language tooling (Python + Terraform)
- Shared development environment

This would be difficult in a monorepo (too many unrelated changes) or individual repos (too much manual coordination).

## Next Steps

- **[Package Layers](layers.md)** - How packages depend on each other
- **[wrknv Integration](wrknv-integration.md)** - How wrknv enables the workspace
- **[Workspace vs Workenv](workspace-vs-workenv.md)** - Different environment types
