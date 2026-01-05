#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "=== provide-workspace Validation ==="
echo

# Get the workspace root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

ERRORS=0
WARNINGS=0

# Function to report error
error() {
    echo -e "${RED}✗ $1${NC}"
    ((ERRORS++))
}

# Function to report warning
warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
    ((WARNINGS++))
}

# Function to report success
success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Check Python version
echo "Checking Python..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version | awk '{print $2}')
    PYTHON_MAJOR=$(echo "$PYTHON_VERSION" | cut -d. -f1)
    PYTHON_MINOR=$(echo "$PYTHON_VERSION" | cut -d. -f2)

    if [ "$PYTHON_MAJOR" -lt 3 ] || ([ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -lt 11 ]); then
        error "Python 3.11+ required (found $PYTHON_VERSION)"
    else
        success "Python $PYTHON_VERSION"
    fi
else
    error "python3 not found"
fi

# Check uv
echo "Checking uv..."
if command -v uv &> /dev/null; then
    UV_VERSION=$(uv --version | awk '{print $2}')
    success "uv $UV_VERSION"
else
    warning "uv not installed (recommended)"
fi

# Check git
echo "Checking git..."
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version | awk '{print $3}')
    success "git $GIT_VERSION"
else
    error "git not found"
fi

# Check gh (optional)
echo "Checking gh..."
if command -v gh &> /dev/null; then
    GH_VERSION=$(gh --version | head -1 | awk '{print $3}')
    success "gh $GH_VERSION"
else
    warning "gh (GitHub CLI) not installed (optional)"
fi

# Check make
echo "Checking make..."
if command -v make &> /dev/null; then
    success "make available"
else
    warning "make not found (needed for documentation builds)"
fi

echo

# Check virtual environment
echo "Checking virtual environment..."
cd "$WORKSPACE_ROOT"

if [ -d ".venv" ]; then
    success ".venv exists"

    # Check if it's activated
    if [[ "$VIRTUAL_ENV" == *"provide-workspace/.venv"* ]]; then
        success "Virtual environment is activated"
    else
        warning "Virtual environment not activated (run: source .venv/bin/activate)"
    fi
else
    error ".venv not found (run: ./scripts/setup.sh)"
fi

echo

# Check repositories
echo "Checking repositories..."
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

NON_PYTHON_REPOS=(
    "ci-tooling"
)

MISSING_REPOS=0
for repo in "${REPOS[@]}"; do
    if [ -d "$repo" ]; then
        success "$repo"
    else
        warning "$repo not found"
        ((MISSING_REPOS++))
    fi
done

if [ $MISSING_REPOS -gt 0 ]; then
    echo
    warning "$MISSING_REPOS repositories missing (run: ./scripts/bootstrap.sh)"
fi

echo

# Check installed packages (if venv is activated)
if [[ "$VIRTUAL_ENV" == *"provide-workspace/.venv"* ]]; then
    echo "Checking installed packages..."

    for repo in "${REPOS[@]}"; do
        if [ -d "$repo" ]; then
            for non_python in "${NON_PYTHON_REPOS[@]}"; do
                if [ "$repo" = "$non_python" ]; then
                    success "$repo present (non-Python repo)"
                    continue 2
                fi
            done
            # Try to import the package
            PACKAGE_NAME=$(echo "$repo" | sed 's/-/_/g')
            if python3 -c "import $PACKAGE_NAME" 2>/dev/null || \
               python3 -c "import ${PACKAGE_NAME/provide_/provide.}" 2>/dev/null; then
                success "$repo installed"
            else
                warning "$repo not installed or not importable"
            fi
        fi
    done
    echo
fi

# Run tests if requested
if [ "${1:-}" == "--all-tests" ]; then
    echo "Running tests across all packages..."
    echo

    for repo in "${REPOS[@]}"; do
        if [ -d "$repo" ] && [ -d "$repo/tests" ]; then
            echo -e "${BLUE}Testing $repo...${NC}"
            cd "$WORKSPACE_ROOT/$repo"

            if pytest -q 2>/dev/null; then
                success "$repo tests passed"
            else
                error "$repo tests failed"
            fi
            echo
        fi
    done

    cd "$WORKSPACE_ROOT"
fi

# Summary
echo "=== Summary ==="
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}All checks passed!${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}$WARNINGS warning(s) found${NC}"
    exit 0
else
    echo -e "${RED}$ERRORS error(s) and $WARNINGS warning(s) found${NC}"
    exit 1
fi
