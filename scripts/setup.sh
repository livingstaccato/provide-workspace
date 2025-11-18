#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "=== provide-workspace Setup ==="
echo

# Get the workspace root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "Workspace root: $WORKSPACE_ROOT"
echo

# Check prerequisites
echo "Checking prerequisites..."

if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Error: python3 is not installed${NC}"
    exit 1
fi

PYTHON_VERSION=$(python3 --version | awk '{print $2}')
PYTHON_MAJOR=$(echo "$PYTHON_VERSION" | cut -d. -f1)
PYTHON_MINOR=$(echo "$PYTHON_VERSION" | cut -d. -f2)

if [ "$PYTHON_MAJOR" -lt 3 ] || ([ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -lt 11 ]); then
    echo -e "${RED}Error: Python 3.11+ is required (found $PYTHON_VERSION)${NC}"
    exit 1
fi

echo -e "${GREEN}Python $PYTHON_VERSION OK${NC}"

if ! command -v uv &> /dev/null; then
    echo -e "${YELLOW}Warning: uv is not installed${NC}"
    echo "Install uv with: curl -LsSf https://astral.sh/uv/install.sh | sh"
    echo "Falling back to pip..."
    USE_UV=false
else
    echo -e "${GREEN}uv OK${NC}"
    USE_UV=true
fi

echo

# Create workspace virtual environment
cd "$WORKSPACE_ROOT"

if [ -d ".venv" ]; then
    echo -e "${YELLOW}.venv already exists, skipping creation${NC}"
else
    echo "Creating workspace virtual environment..."
    if $USE_UV; then
        uv venv
    else
        python3 -m venv .venv
    fi
    echo -e "${GREEN}Virtual environment created${NC}"
fi

echo

# Activate virtual environment
source .venv/bin/activate

# Install wrknv first (needed for workspace commands)
echo "Installing wrknv..."
if [ -d "wrknv" ]; then
    cd "$WORKSPACE_ROOT/wrknv"
    if $USE_UV; then
        uv pip install -e . || {
            echo -e "${RED}Failed to install wrknv${NC}"
            exit 1
        }
    else
        pip install -e . || {
            echo -e "${RED}Failed to install wrknv${NC}"
            exit 1
        }
    fi
    echo -e "${GREEN}wrknv installed${NC}"
else
    echo -e "${RED}Error: wrknv not found. Run ./scripts/bootstrap.sh first.${NC}"
    exit 1
fi

cd "$WORKSPACE_ROOT"
echo

# Initialize workspace if not already done
if [ ! -f ".wrknv/workspace.toml" ]; then
    echo "Initializing wrknv workspace..."
    wrknv workspace init --auto-discover || {
        echo -e "${RED}Failed to initialize workspace${NC}"
        exit 1
    }
    echo -e "${GREEN}Workspace initialized${NC}"
    echo
else
    echo -e "${BLUE}Workspace already initialized${NC}"
    echo
fi

# Setup workspace using wrknv
echo "Setting up workspace repositories..."
wrknv workspace setup --generate-only || {
    echo -e "${RED}Failed to setup workspace${NC}"
    exit 1
}

echo
echo -e "${GREEN}Setup complete!${NC}"
echo
echo "Activate your environment with:"
echo "  source .venv/bin/activate"
echo
echo "Each repository now has env.sh and env.ps1 scripts."
echo "To setup a specific repository's workenv:"
echo "  cd <repo> && source env.sh"
echo
echo "Run validation with:"
echo "  ./scripts/validate.sh"
