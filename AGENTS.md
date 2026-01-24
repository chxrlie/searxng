# AGENTS.md - Guidance for Agentic Code Editors

Essential information for AI coding agents working in the SearXNG repository.

## Quick Start Commands

| Task | Command |
|------|---------|
| Install dev environment | `make install` |
| Run single test | `./manage pyenv.cmd python -m nose2 tests.unit.module:Class.test_method` |
| Run test file | `./manage pyenv.cmd python -m nose2 -s tests/unit/test_filename.py` |
| Format Python | `make format.python` |
| Lint Python | `make test.pylint` |
| Type check (modified) | `make test.pyright_modified` |
| Build frontend | `make themes.simple` |
| Lint frontend | `./manage themes.lint` |
| Run dev server | `make run` |

## Build & Test Commands

### Python Backend
- `make install` - Developer install with pyenv and dependencies
- `make test` - Run full test suite (unit, lint, type check, format)
- `make test.unit` - Run all unit tests
- `make test.pylint` - Pylint linter (config: `.pylintrc`)
- `make test.black` - Check Black formatting
- `make test.pyright` - Type check with basedpyright (config: `pyrightconfig.json`)
- `make test.pyright_modified` - Type check only modified files (faster)
- `make format.python` - Auto-format Python code with Black

### TypeScript/JavaScript Frontend
- `make themes.simple` - Build simple theme (TypeScript + Vite)
- `./manage themes.lint` - Lint JS/CSS/TS files
- `./manage themes.fix` - Auto-fix linting issues
- `./manage vite.simple.dev` - Start Vite dev server
- Frontend tools: Biome (lint/format), Stylelint (CSS), TypeScript, Vite (build)

### Single Test Execution
**Important**: Use single tests for faster iteration during development.

```bash
# Single test file
./manage pyenv.cmd python -m nose2 -s tests/unit/test_filename.py

# Single test method
./manage pyenv.cmd python -m nose2 tests.unit.test_module:TestClass.test_method

# With coverage
./manage pyenv.cmd python -m nose2 --with-coverage -s tests/unit/test_filename.py
```

## Python Code Style Guidelines

### File Structure
Every Python file must start with SPDX header and module docstring:
```python
# SPDX-License-Identifier: AGPL-3.0-or-later
"""Module docstring describing purpose."""

from __future__ import annotations

import sys
from typing import Any

from flask import Flask

from searx import settings
```

### Imports Organization (PEP 8)
1. Standard library imports
2. Third-party library imports
3. Local application imports
4. Separate each group with blank line
5. Always include `from __future__ import annotations` for modern type hints

### Formatting Rules
- **Indentation**: 4 spaces (never tabs)
- **Line length**: 120 characters max (Black enforced)
- **Encoding**: UTF-8
- **Line endings**: LF (Unix)
- **Blank lines**: 2 between top-level definitions

### Type Hints (Required)
Annotate all function parameters and return types:
```python
from __future__ import annotations

def process_query(query: str, limit: int = 10) -> dict[str, Any]:
    """Process a search query."""
    return {"results": []}
```

### Naming Conventions
- Variables/functions: `snake_case`
- Classes: `PascalCase`
- Constants: `UPPER_SNAKE_CASE`
- Private members: `_private_method`

### Error Handling
Use custom exceptions from `searx/exceptions.py`:
```python
from searx.exceptions import SearxParameterException

def validate_input(value: str) -> None:
    if not value:
        raise SearxParameterException('query', 'Value cannot be empty')
```

Available exceptions: `SearxException`, `SearxParameterException`, `SearxSettingsException`, `SearxEngineException`

### Docstrings
- Module docstrings: **Required** (after SPDX header)
- Class docstrings: **Required**
- Function docstrings: Optional (use triple quotes `"""` when needed)

## TypeScript/JavaScript Frontend Guidelines

### Configuration
- **Linter/Formatter**: Biome (`biome.json`)
- **CSS Linter**: Stylelint (`.stylelintrc.json`)
- **Type Checker**: TypeScript (`tsconfig.json`)
- **Build Tool**: Vite (`vite.config.ts`)

### Formatting
- Indentation: 2 spaces
- Line length: 120 characters
- Line endings: LF
- Strict TypeScript: enabled
- Import extensions: required (`.ts`, `.js`)

### TypeScript Settings
- `strict: true` - All strict checks enabled
- `noUnusedLocals: true` - No unused variables
- `noUnusedParameters: true` - No unused parameters
- `noImplicitReturns: true` - All code paths must return
- Import extensions required in all imports

## Testing Guidelines

### Framework & Structure
- **Framework**: nose2 with coverage plugin
- **Base class**: `tests.SearxTestCase` (or `unittest.TestCase`)
- **Location**: `tests/unit/` directory
- **Naming**: `test_*.py` files, `test_*` methods

### Test Naming Pattern
Use descriptive names: `test_<functionality>_<condition>_<expected_result>`

```python
# SPDX-License-Identifier: AGPL-3.0-or-later

from tests import SearxTestCase

class TestSearchEngine(SearxTestCase):
    def test_query_parsing_with_empty_string_raises_exception(self):
        """Test empty query raises proper exception."""
        # Test implementation
```

### Parameterized Tests
```python
from parameterized import parameterized

@parameterized.expand([
    ("valid", True),
    ("", False),
    (None, False),
])
def test_validation(self, input_value, expected):
    self.assertEqual(validate(input_value), expected)
```

## Development Workflow

1. **Before coding**: Explore existing code structure
2. **While coding**: Follow style guidelines, add type hints, handle errors with custom exceptions
3. **Before committing**:
   - Run relevant tests (single test for speed)
   - Format: `make format.python` or `./manage themes.fix`
   - Lint: `make test.pylint` and/or `./manage themes.lint`
   - Type check: `make test.pyright_modified`
4. **Commit**: Write clear commit messages

## Common Pitfalls

- ❌ Missing SPDX license header (`# SPDX-License-Identifier: AGPL-3.0-or-later`)
- ❌ Missing type hints on function signatures
- ❌ Not using custom exception classes from `searx.exceptions`
- ❌ Using tabs instead of spaces
- ❌ Exceeding 120-character line limit
- ❌ Not running formatter before commit
- ❌ Running full test suite when single test would suffice
- ❌ Missing import extensions in TypeScript files

## Important Notes

- **Python version**: 3.10+ required
- **Working directory**: All commands assume repository root
- **Pylint disabled checks**: `duplicate-code`, `missing-function-docstring`, `consider-using-f-string`
- **Black line length**: 120 characters (configured in pyproject.toml)
- **Frontend location**: `client/simple/` for TypeScript/Vite code
