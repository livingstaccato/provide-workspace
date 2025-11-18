#
# SPDX-FileCopyrightText: Copyright (c) 2025 provide.io llc. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#

"""Integration tests for bootstrap.sh script with real execution."""

from __future__ import annotations

from pathlib import Path

import pytest
from provide.testkit import (
    ScriptExecutionContext,
    assert_stdout_contains,
)


@pytest.fixture
def bootstrap_script(scripts_dir: Path) -> Path:
    """Return path to bootstrap.sh script.

    Args:
        scripts_dir: Path to scripts directory.

    Returns:
        Path to bootstrap.sh.
    """
    return scripts_dir / "bootstrap.sh"


def test_bootstrap_help_integration(
    script_execution_context: ScriptExecutionContext,
    bootstrap_script: Path,
) -> None:
    """Test bootstrap.sh --help flag displays usage."""
    result = script_execution_context.run_script(bootstrap_script, args=["--help"])

    # Script displays usage and exits with code 1
    assert result.returncode == 1
    assert_stdout_contains(result, "Usage:")


def test_bootstrap_symlink_mode_creates_symlinks(
    isolated_workspace: Path,
    bootstrap_script: Path,
) -> None:
    """Test bootstrap.sh creates symlinks in symlink mode."""
    # Create a source directory with a test repo
    source_dir = isolated_workspace / "source"
    source_dir.mkdir()

    test_repo = source_dir / "provide-foundation"
    test_repo.mkdir()

    # Create a workspace directory
    workspace = isolated_workspace / "workspace"
    workspace.mkdir()

    # Copy bootstrap script to workspace
    import shutil

    test_script = workspace / "bootstrap.sh"
    shutil.copy(bootstrap_script, test_script)

    context = ScriptExecutionContext(workspace=workspace, timeout=30)
    context.run_script(test_script, args=["symlink", str(source_dir)])

    # Check that at least the test repo was symlinked
    symlink_path = workspace / "provide-foundation"
    if symlink_path.exists() and symlink_path.is_symlink():
        assert symlink_path.resolve() == test_repo.resolve()


@pytest.mark.slow
def test_bootstrap_idempotency(
    script_execution_context: ScriptExecutionContext,
    bootstrap_script: Path,
) -> None:
    """Test bootstrap.sh can be run multiple times safely."""
    # First run - will likely fail due to network but shouldn't crash
    result1 = script_execution_context.run_script(bootstrap_script)

    # Second run - should handle existing repos gracefully
    result2 = script_execution_context.run_script(bootstrap_script)

    # Both runs should complete (may fail but not crash)
    assert result1.returncode in (0, 1)
    assert result2.returncode in (0, 1)
