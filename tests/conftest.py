#
# SPDX-FileCopyrightText: Copyright (c) 2025 provide.io llc. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#

"""Shared pytest fixtures for provide-workspace tests."""

from __future__ import annotations

from pathlib import Path

import pytest

# Ensure provide.testkit is imported early for setproctitle blocker
import provide.testkit  # noqa: F401

# Import script testing utilities
from provide.testkit import (
    ScriptExecutionContext,
    bash_script_runner,
    isolated_workspace,
    script_execution_context,  # noqa: F401 - Fixture used by tests
)

# Make utilities available to all tests
__all__ = [
    "ScriptExecutionContext",
    "bash_script_runner",
    "isolated_workspace",
    "script_execution_context",
    "scripts_dir",
]


def pytest_configure(config: pytest.Config) -> None:
    """Register custom pytest markers.

    Args:
        config: Pytest configuration object.
    """
    config.addinivalue_line("markers", "slow: marks tests as slow (deselect with '-m \"not slow\"')")
    config.addinivalue_line("markers", "integration: marks tests as integration tests")


@pytest.fixture
def scripts_dir() -> Path:
    """Return the path to the scripts directory.

    Returns:
        Path to provide-workspace/scripts directory.
    """
    return Path(__file__).parent.parent / "scripts"
