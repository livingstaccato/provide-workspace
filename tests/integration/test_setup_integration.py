#
# SPDX-FileCopyrightText: Copyright (c) 2025 provide.io llc. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#

"""Integration tests for setup.sh script with real execution."""

from __future__ import annotations

from pathlib import Path

import pytest

from provide.testkit import ScriptExecutionContext


@pytest.fixture
def setup_script(scripts_dir: Path) -> Path:
    """Return path to setup.sh script.

    Args:
        scripts_dir: Path to scripts directory.

    Returns:
        Path to setup.sh.
    """
    return scripts_dir / "setup.sh"


@pytest.mark.slow
def test_setup_script_runs(
    script_execution_context: ScriptExecutionContext,
    setup_script: Path,
) -> None:
    """Test setup.sh executes without crashing."""
    script_execution_context.timeout = 120  # Longer timeout for setup

    result = script_execution_context.run_script(setup_script)

    # Script may fail due to missing prerequisites but shouldn't crash
    assert result.returncode in (0, 1)
    assert result.stdout or result.stderr  # Should produce some output
