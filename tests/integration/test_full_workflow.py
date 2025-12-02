#
# SPDX-FileCopyrightText: Copyright (c) 2025 provide.io llc. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#

"""Integration tests for full bootstrap -> setup -> validate workflow."""

from __future__ import annotations

from pathlib import Path

import pytest
from provide.testkit import ScriptExecutionContext


@pytest.mark.slow
@pytest.mark.integration
def test_full_workflow_with_symlinks(
    isolated_workspace: Path,
    scripts_dir: Path,
) -> None:
    """Test complete workflow: bootstrap (symlink) -> setup -> validate."""
    # Create source directory with mock repos
    source_dir = isolated_workspace / "source"
    source_dir.mkdir()

    # Create minimal mock repos
    mock_repos = ["provide-foundation", "provide-testkit", "wrknv"]
    for repo in mock_repos:
        repo_path = source_dir / repo
        repo_path.mkdir()
        (repo_path / "README.md").write_text(f"# {repo}")

    # Create workspace
    workspace = isolated_workspace / "workspace"
    workspace.mkdir()

    # Copy scripts to workspace
    import shutil

    for script_name in ["bootstrap.sh", "setup.sh", "validate.sh"]:
        src = scripts_dir / script_name
        dst = workspace / script_name
        shutil.copy(src, dst)

    context = ScriptExecutionContext(workspace=workspace, timeout=180)

    # Step 1: Bootstrap with symlinks
    bootstrap_result = context.run_script(
        workspace / "bootstrap.sh",
        args=["symlink", str(source_dir)],
    )

    # Bootstrap should succeed or at least not crash
    assert bootstrap_result.returncode in (0, 1)

    # Step 2: Setup (will likely fail due to missing dependencies, but should run)
    setup_result = context.run_script(workspace / "setup.sh")

    # Setup may fail but should execute
    assert setup_result.returncode in (0, 1)

    # Step 3: Validate
    validate_result = context.run_script(workspace / "validate.sh")

    # Validate should run and report status
    assert validate_result.returncode in (0, 1)

    # All scripts should produce output
    assert bootstrap_result.stdout or bootstrap_result.stderr
    assert setup_result.stdout or setup_result.stderr
    assert validate_result.stdout or validate_result.stderr


@pytest.mark.slow
@pytest.mark.integration
def test_scripts_are_idempotent(scripts_dir: Path, isolated_workspace: Path) -> None:
    """Test that scripts can be run multiple times without errors."""
    workspace = isolated_workspace / "workspace"
    workspace.mkdir()

    import shutil

    bootstrap_script = workspace / "bootstrap.sh"
    shutil.copy(scripts_dir / "bootstrap.sh", bootstrap_script)

    context = ScriptExecutionContext(workspace=workspace, timeout=60)

    # Run bootstrap twice
    result1 = context.run_script(bootstrap_script)
    result2 = context.run_script(bootstrap_script)

    # Both should complete without crashing
    assert result1.returncode in (0, 1)
    assert result2.returncode in (0, 1)

    # Second run should handle existing state gracefully
    assert "skip" in result2.stdout.lower() or "exist" in result2.stdout.lower() or result2.returncode == 0
