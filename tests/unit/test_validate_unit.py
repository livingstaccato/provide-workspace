#
# SPDX-FileCopyrightText: Copyright (c) 2025 provide.io llc. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#

"""Unit tests for validate.sh script with mocked subprocess calls."""

from __future__ import annotations

from pathlib import Path

import pytest

from provide.testkit import (
    ScriptExecutionContext,
)


@pytest.fixture
def validate_script(scripts_dir: Path) -> Path:
    """Return path to validate.sh script.

    Args:
        scripts_dir: Path to scripts directory.

    Returns:
        Path to validate.sh.
    """
    return scripts_dir / "validate.sh"


def test_validate_help_flag(
    script_execution_context: ScriptExecutionContext,
    validate_script: Path,
) -> None:
    """Test validate.sh runs validation checks."""
    result = script_execution_context.run_script(validate_script, args=["--help"])

    # Script ignores --help and runs validation checks anyway
    # Should mention checking prerequisites
    output = result.stdout + result.stderr
    assert "checking" in output.lower() or "python" in output.lower()


def test_validate_checks_python_version(
    script_execution_context: ScriptExecutionContext,
    validate_script: Path,
) -> None:
    """Test validate.sh checks Python version."""
    result = script_execution_context.run_script(validate_script)

    # Will fail due to missing prerequisites but should check Python
    assert "python" in result.stdout.lower() or "python" in result.stderr.lower()
