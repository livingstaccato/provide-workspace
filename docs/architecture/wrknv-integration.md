# wrknv Integration

How provide-workspace uses wrknv to manage the workspace.

## Overview

**wrknv** ("work envy") is the work environment management tool.
**provide-workspace** uses wrknv to coordinate all provide.io repositories.

Think of it as:
- **wrknv** = the tool (like Make or Task)
- **provide-workspace** = a specific configuration (like a Makefile)

## What is wrknv?

wrknv is a general-purpose work environment manager that:
- Manages sibling repositories
- Coordinates environment setup
- Provides task automation
- Handles workspace configuration

See [wrknv documentation](https://foundry.provide.io/wrknv/) for complete details.

## How provide-workspace Uses wrknv

### 1. Workspace Configuration

`wrknv.toml` defines the workspace structure:

```toml
[workspace]
name = "provide-workspace"
description = "provide.io ecosystem workspace manager"

# List all sibling repositories
[[siblings]]
name = "provide-foundation"
path = "../provide-foundation"
repo = "https://github.com/provide-io/provide-foundation.git"

[[siblings]]
name = "provide-testkit"
path = "../provide-testkit"
repo = "https://github.com/provide-io/provide-testkit.git"

[[siblings]]
name = "pyvider"
path = "../pyvider"
repo = "https://github.com/provide-io/pyvider.git"

# ... 13+ total siblings
```

### 2. Scripts Use wrknv Configuration

The bootstrap script reads `wrknv.toml`:

```bash
# bootstrap.sh (simplified)
# Reads wrknv.toml to find all siblings
for repo in $(parse_wrknv_siblings); do
  if [ ! -d "../$repo" ]; then
    git clone "https://github.com/provide-io/$repo.git" "../$repo"
  fi
done
```

### 3. Dependency Detection

wrknv can detect sibling repositories automatically:

```bash
# wrknv scans parent directory for provide.io packages
wrknv siblings list

# Output:
# provide-foundation  ../provide-foundation
# provide-testkit     ../provide-testkit
# pyvider            ../pyvider
# ...
```

## wrknv.toml Format

### Full Example

```toml
[workspace]
name = "provide-workspace"
description = "Workspace manager for the provide.io ecosystem"
version = "0.1.0"

# Python configuration
[workspace.python]
version = ">=3.11"
venv_path = ".venv"

# Development tools
[workspace.tools]
uv = ">=0.1.0"
ruff = ">=0.1.0"
mypy = ">=1.0"

# Sibling repositories (in dependency order)
[[siblings]]
name = "provide-foundation"
path = "../provide-foundation"
repo = "https://github.com/provide-io/provide-foundation.git"
layer = "foundation"

[[siblings]]
name = "provide-testkit"
path = "../provide-testkit"
repo = "https://github.com/provide-io/provide-testkit.git"
layer = "foundation"

[[siblings]]
name = "pyvider-cty"
path = "../pyvider-cty"
repo = "https://github.com/provide-io/pyvider-cty.git"
layer = "framework"

[[siblings]]
name = "pyvider"
path = "../pyvider"
repo = "https://github.com/provide-io/pyvider.git"
layer = "framework"
depends_on = ["provide-foundation", "pyvider-cty"]

[[siblings]]
name = "flavorpack"
path = "../flavorpack"
repo = "https://github.com/provide-io/flavorpack.git"
layer = "tools"
depends_on = ["provide-foundation"]

# ... more siblings
```

### Configuration Sections

**`[workspace]`**: Basic workspace metadata
- `name`: Workspace identifier
- `description`: Human-readable description
- `version`: Workspace configuration version

**`[workspace.python]`**: Python environment settings
- `version`: Required Python version
- `venv_path`: Where to create virtual environment

**`[workspace.tools]`**: Development tool requirements
- List of tools with minimum versions

**`[[siblings]]`**: Repository definitions (array of tables)
- `name`: Package name
- `path`: Relative path from workspace
- `repo`: Git repository URL
- `layer`: Architecture layer (foundation/framework/tools)
- `depends_on`: Other siblings this depends on

## Using wrknv Commands

While provide-workspace provides bash scripts, wrknv offers additional capabilities:

### List Siblings

```bash
wrknv siblings list
# Shows all configured sibling repositories
```

### Check Status

```bash
wrknv status
# Shows git status of all siblings
```

### Update All

```bash
wrknv update
# Pulls latest changes in all siblings
```

### Run Command Across Siblings

```bash
wrknv exec --all "git status"
# Runs command in each sibling repository
```

## Why Not Use wrknv Commands Directly?

provide-workspace provides bash scripts instead of using wrknv commands directly because:

1. **Simplicity**: Bash scripts are more transparent and easier to debug
2. **Portability**: Works without wrknv installed (can bootstrap it)
3. **Customization**: Easy to modify behavior for provide.io specifics
4. **Learning Curve**: Standard bash is familiar to all developers
5. **Bootstrap Problem**: Need to clone repositories before wrknv can manage them

**However**, wrknv is still valuable for:
- Configuration format (`wrknv.toml`)
- Sibling detection and management
- Advanced workspace automation
- Integration with other tools

## Creating Your Own wrknv Workspace

You can use provide-workspace as a template for your own multi-repo workspace:

### 1. Create Workspace Repository

```bash
mkdir my-workspace
cd my-workspace
git init
```

### 2. Create wrknv.toml

```toml
[workspace]
name = "my-workspace"
description = "My multi-repository workspace"

[[siblings]]
name = "package-one"
path = "../package-one"
repo = "https://github.com/me/package-one.git"

[[siblings]]
name = "package-two"
path = "../package-two"
repo = "https://github.com/me/package-two.git"
```

### 3. Create Bootstrap Script

```bash
#!/usr/bin/env bash
# bootstrap.sh

# Parse wrknv.toml and clone repositories
# (See provide-workspace/scripts/bootstrap.sh for full example)

echo "Cloning repositories from wrknv.toml..."
# ... clone logic ...
```

### 4. Create Setup Script

```bash
#!/usr/bin/env bash
# setup.sh

# Create venv and install packages
uv venv
source .venv/bin/activate

# Install packages in order
uv pip install -e ../package-one
uv pip install -e ../package-two
```

## wrknv vs provide-workspace

| Aspect | wrknv | provide-workspace |
|--------|-------|-----------------|
| **Type** | General tool | Specific workspace |
| **Purpose** | Work environment management | provide.io ecosystem coordination |
| **Configuration** | Creates wrknv.toml | Provides wrknv.toml |
| **Commands** | General workspace commands | Ecosystem-specific scripts |
| **Users** | Any multi-repo project | provide.io developers |

**Analogy**:
- wrknv : Make :: provide-workspace : Makefile
- wrknv : Task :: provide-workspace : Taskfile
- wrknv : Docker :: provide-workspace : docker-compose.yml

## Advanced wrknv Features

wrknv provides features that provide-workspace doesn't currently use:

### Task Automation

```toml
[workspace.tasks]
test = "pytest tests/"
lint = "ruff check ."
format = "ruff format ."
```

Run with: `wrknv run test`

### Environment Variables

```toml
[workspace.env]
LOG_LEVEL = "DEBUG"
PYTHONPATH = "src:."
```

### Pre/Post Hooks

```toml
[workspace.hooks]
pre_install = "scripts/pre_install.sh"
post_install = "scripts/post_install.sh"
```

## Next Steps

- **[Development Workflow](../guide/workflow/)** - Working with the workspace
- **[Configuration Reference](../reference/configuration/)** - wrknv.toml details
- **[wrknv Documentation](https://foundry.provide.io/wrknv/)** - Full wrknv capabilities
