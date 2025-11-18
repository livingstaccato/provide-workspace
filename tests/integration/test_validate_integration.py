#
# SPDX-FileCopyrightText: Copyright (c) 2025 provide.io llc. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#

"""Integration tests for validate.sh script with real execution."""

from __future__ import annotations

from pathlib import Path

import pytest
from provide.testkit import ScriptExecutionContext


@pytest.fixture
def validate_script(scripts_dir: Path) -> Path:
    """Return path to validate.sh script.

    Args:
        scripts_dir: Path to scripts directory.

    Returns:
        Path to validate.sh.
    """
    return scripts_dir / "validate.sh"


@pytest.mark.slow
def test_validate_script_runs(
    script_execution_context: ScriptExecutionContext,
    validate_script: Path,
) -> None:
    """Test validate.sh executes and checks prerequisites."""
    result = script_execution_context.run_script(validate_script)

    # Script should exit with 0 or 1 (errors/warnings)
    assert result.returncode in (0, 1)

    # Should check for Python, git, etc
    output = result.stdout + result.stderr
    assert any(
        keyword in output.lower() for keyword in ["python", "git", "prerequisite", "checking"]
    )


def test_validate_all_tests_flag(
    script_execution_context: ScriptExecutionContext,
    validate_script: Path,
) -> None:
    """Test validate.sh with --all-tests flag."""
    script_execution_context.timeout = 180  # Longer timeout for tests

    result = script_execution_context.run_script(validate_script, args=["--all-tests"])

    # Should run and complete (may pass or fail, but shouldn't crash)
    # Script will fail due to missing repos but should handle gracefully
    assert result.returncode in (0, 1)
