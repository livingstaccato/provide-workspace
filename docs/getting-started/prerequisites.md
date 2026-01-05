# Prerequisites

Ensure you have the required tools before setting up provide-workspace.

## Required Tools

### 1. Python 3.11+

Python 3.11 or later is required for all ecosystem packages.

```bash
python3 --version  # Should be 3.11 or higher
```

**Installation:**

=== "macOS"
    ```bash
    brew install python@3.11
    ```

=== "Ubuntu/Debian"
    ```bash
    sudo apt update
    sudo apt install python3.11 python3.11-venv python3.11-dev
    ```

=== "Windows (WSL2)"
    ```bash
    sudo apt update
    sudo apt install python3.11 python3.11-venv python3.11-dev
    ```

### 2. uv (Modern Python Package Installer)

`uv` is a fast Python package installer and resolver written in Rust.

```bash
# Check if installed
uv --version
```

**Installation:**

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

After installation, restart your shell or source your profile:

```bash
source ~/.bashrc  # or ~/.zshrc
```

Learn more: [uv documentation](https://github.com/astral-sh/uv)

### 3. Git

Version control for all ecosystem repositories.

```bash
git --version
```

**Installation:**

=== "macOS"
    ```bash
    brew install git
    ```

=== "Ubuntu/Debian"
    ```bash
    sudo apt install git
    ```

=== "Windows (WSL2)"
    ```bash
    sudo apt install git
    ```

**Configuration:**

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 4. GitHub CLI (Optional but Recommended)

For working with GitHub repositories, issues, and PRs.

```bash
gh --version
```

**Installation:**

=== "macOS"
    ```bash
    brew install gh
    ```

=== "Ubuntu/Debian"
    ```bash
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install gh
    ```

=== "Windows (WSL2)"
    Same as Ubuntu/Debian

**Authentication:**

```bash
gh auth login
```

Follow prompts to authenticate with GitHub.

### 5. Make (For Documentation Builds)

Build automation tool used for documentation.

```bash
make --version
```

**Installation:**

=== "macOS"
    ```bash
    # Usually pre-installed with Xcode Command Line Tools
    xcode-select --install
    ```

=== "Ubuntu/Debian"
    ```bash
    sudo apt install build-essential
    ```

=== "Windows (WSL2)"
    ```bash
    sudo apt install build-essential
    ```

### 6. Go 1.24+ (For Some Tooling Components)

Required for certain provider components and tooling.

```bash
go version
```

**Installation:**

=== "macOS"
    ```bash
    brew install go
    ```

=== "Ubuntu/Debian"
    ```bash
    # Download from https://go.dev/dl/
    wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
    source ~/.bashrc
    ```

=== "Windows (WSL2)"
    Same as Ubuntu/Debian

## System Requirements

### Operating System

- **macOS** - 10.15 (Catalina) or later
- **Linux** - Ubuntu 20.04+, Debian 11+, or equivalent
- **Windows** - WSL2 with Ubuntu 20.04+ (**Windows native is not supported**)

### Hardware

- **RAM**: 8GB minimum, 16GB recommended
- **Disk Space**: 5GB+ free space for repositories and virtual environments
- **CPU**: Any modern multi-core processor (x86_64 or ARM64)

## Verification Checklist

Before proceeding to installation, verify all tools are installed:

```bash
# Quick verification script
echo "Python: $(python3 --version)"
echo "uv: $(uv --version)"
echo "Git: $(git --version)"
echo "GitHub CLI: $(gh --version 2>/dev/null || echo 'not installed (optional)')"
echo "Make: $(make --version | head -n1)"
echo "Go: $(go version)"
```

All required tools should display version numbers. If any are missing, install them using the instructions above.

## Next Steps

Once all prerequisites are installed, proceed to [Installation](installation.md) for the setup process.

## Troubleshooting

### Python 3.11 Not Available

If your system package manager doesn't have Python 3.11+, consider using [pyenv](https://github.com/pyenv/pyenv):

```bash
# Install pyenv
curl https://pyenv.run | bash

# Install Python 3.11
pyenv install 3.11.0
pyenv global 3.11.0
```

### uv Installation Issues

If the uv installation script fails, try the alternative method:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Or download pre-built binaries from [uv releases](https://github.com/astral-sh/uv/releases).

### Permission Errors

If you encounter permission errors during installation, **do not use sudo** with uv. Instead, use user installations:

```bash
uv venv  # Creates virtual environment
source .venv/bin/activate
```
