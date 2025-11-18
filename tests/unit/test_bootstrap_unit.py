#
# SPDX-FileCopyrightText: Copyright (c) 2025 provide.io llc. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#

"""Unit tests for bootstrap.sh script with mocked subprocess calls."""

from __future__ import annotations

from pathlib import Path

import pytest
from provide.testkit import (
    ScriptExecutionContext,
    assert_script_failure,
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


def test_bootstrap_help_flag(
    script_execution_context: ScriptExecutionContext, bootstrap_script: Path
) -> None:
    """Test bootstrap.sh with --help flag displays usage."""
    result = script_execution_context.run_script(bootstrap_script, args=["--help"])

    # Script exits with code 1 when showing help, but outputs usage text
    assert result.returncode == 1
    assert_stdout_contains(result, "Usage:")
    assert_stdout_contains(result, "clone")
    assert_stdout_contains(result, "symlink")
    assert_stdout_contains(result, "mixed")


def test_bootstrap_symlink_requires_source_dir(
    script_execution_context: ScriptExecutionContext,
    bootstrap_script: Path,
) -> None:
    """Test bootstrap.sh symlink mode requires source directory."""
    result = script_execution_context.run_script(bootstrap_script, args=["symlink"])

    assert_script_failure(result)
    assert "SOURCE_DIR required" in result.stdout or "Usage:" in result.stdout


def test_bootstrap_mixed_requires_source_dir(
    script_execution_context: ScriptExecutionContext,
    bootstrap_script: Path,
) -> None:
    """Test bootstrap.sh mixed mode requires source directory."""
    result = script_execution_context.run_script(bootstrap_script, args=["mixed"])

    assert_script_failure(result)
    assert "SOURCE_DIR required" in result.stdout or "Usage:" in result.stdout
