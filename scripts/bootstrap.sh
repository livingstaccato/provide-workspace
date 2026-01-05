#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# GitHub organization
ORG="provide-io"

# List of repositories to clone
REPOS=(
    "bfiles"
    "ci-tooling"
    "provide-foundation"
    "provide-testkit"
    "pyvider"
    "pyvider-cty"
    "pyvider-hcl"
    "pyvider-rpcplugin"
    "pyvider-components"
    "flavorpack"
    "messometer"
    "wrknv"
    "plating"
    "tofusoup"
    "supsrc"
    "provide-foundry"
    "terraform-provider-pyvider"
    "terraform-provider-tofusoup"
)

# Parse command line arguments
MODE="${1:-clone}"  # Default to clone mode
SOURCE_DIR="${2:-}"

usage() {
    echo "Usage: $0 [MODE] [SOURCE_DIR]"
    echo
    echo "Modes:"
    echo "  clone           Clone all repositories (default)"
    echo "  symlink <DIR>   Create symlinks to existing repositories in DIR"
    echo "  mixed <DIR>     Interactive: choose clone or symlink for each repo"
    echo
    echo "Examples:"
    echo "  $0 clone                           # Clone all repos"
    echo "  $0 symlink /path/to/repos          # Symlink all repos"
    echo "  $0 mixed /path/to/repos            # Choose per repo"
    exit 1
}

if [ "$MODE" = "--help" ] || [ "$MODE" = "-h" ]; then
    usage
fi

echo "=== provide-workspace Bootstrap ==="
echo "Mode: $MODE"
echo

# Get the workspace root (parent of this script)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "Workspace root: $WORKSPACE_ROOT"
echo

# Check prerequisites
echo "Checking prerequisites..."
if ! command -v git &> /dev/null; then
    echo -e "${RED}Error: git is not installed${NC}"
    exit 1
fi

if ! command -v gh &> /dev/null; then
    echo -e "${YELLOW}Warning: gh (GitHub CLI) is not installed${NC}"
    echo "You may need to authenticate manually for private repositories"
    USE_GH=false
else
    USE_GH=true
fi

echo -e "${GREEN}Prerequisites OK${NC}"
echo

# Validate source directory for symlink/mixed modes
if [ "$MODE" = "symlink" ] || [ "$MODE" = "mixed" ]; then
    if [ -z "$SOURCE_DIR" ]; then
        echo -e "${RED}Error: SOURCE_DIR required for $MODE mode${NC}"
        usage
    fi
    if [ ! -d "$SOURCE_DIR" ]; then
        echo -e "${RED}Error: Source directory does not exist: $SOURCE_DIR${NC}"
        exit 1
    fi
    SOURCE_DIR="$(cd "$SOURCE_DIR" && pwd)"  # Get absolute path
    echo "Source directory: $SOURCE_DIR"
    echo
fi

# Function to clone a repository
clone_repo() {
    local repo=$1
    echo "Cloning $repo..."
    if $USE_GH; then
        gh repo clone "$ORG/$repo" || {
            echo -e "${RED}Failed to clone $repo${NC}"
            return 1
        }
    else
        git clone "https://github.com/$ORG/$repo.git" || {
            echo -e "${RED}Failed to clone $repo${NC}"
            return 1
        }
    fi
    echo -e "${GREEN}$repo cloned successfully${NC}"
    return 0
}

# Function to create a symlink
symlink_repo() {
    local repo=$1
    local source_path="$SOURCE_DIR/$repo"

    if [ ! -d "$source_path" ]; then
        echo -e "${RED}$repo not found in source directory${NC}"
        return 1
    fi

    echo "Creating symlink to $repo..."
    ln -s "$source_path" "$repo" || {
        echo -e "${RED}Failed to create symlink for $repo${NC}"
        return 1
    }
    echo -e "${GREEN}$repo symlinked successfully${NC}"
    return 0
}

# Process repositories
cd "$WORKSPACE_ROOT"

for repo in "${REPOS[@]}"; do
    # Check if repo already exists
    if [ -e "$repo" ]; then
        if [ -L "$repo" ]; then
            echo -e "${BLUE}$repo already exists as symlink, skipping...${NC}"
        else
            echo -e "${YELLOW}$repo already exists, skipping...${NC}"
        fi
        continue
    fi

    # Handle based on mode
    case "$MODE" in
        clone)
            clone_repo "$repo"
            ;;
        symlink)
            symlink_repo "$repo"
            ;;
        mixed)
            echo -e "${BLUE}Repository: $repo${NC}"
            read -p "  [c]lone, [s]ymlink, or [skip]? " -n 1 -r choice
            echo
            case "$choice" in
                c|C)
                    clone_repo "$repo"
                    ;;
                s|S)
                    symlink_repo "$repo"
                    ;;
                *)
                    echo -e "${YELLOW}Skipping $repo${NC}"
                    ;;
            esac
            ;;
        *)
            echo -e "${RED}Invalid mode: $MODE${NC}"
            usage
            ;;
    esac
done

echo
echo -e "${GREEN}Bootstrap complete!${NC}"
echo
echo "Next steps:"
echo "  1. Run ./scripts/setup.sh to install dependencies"
echo "  2. Run ./scripts/validate.sh to verify your setup"
