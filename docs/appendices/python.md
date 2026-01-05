# Python

Python's packaging ecosystem is notoriously fragmented. This appendix cuts through the confusion with practical guidance on managing Python dependencies.

---

## The Python Packaging Landscape

Python has more tools for the same job than any other language. This is historical baggage, not a feature.

### The Tool Zoo

| Tool | Purpose | Status |
|------|---------|--------|
| **pip** | Package installer | Standard, always available |
| **venv** | Virtual environments | Standard library (Python 3.3+) |
| **virtualenv** | Virtual environments | Older, more features |
| **pip-tools** | Lock file generation | Solid, widely used |
| **Poetry** | All-in-one project management | Popular, opinionated |
| **PDM** | PEP-compliant project management | Modern, growing |
| **uv** | Fast pip/pip-tools replacement | Very fast, new |
| **Pipenv** | All-in-one tool | Controversial, slower development |
| **conda** | Package + environment manager | Popular in data science |

**Recommendation:** Start with pip + venv + pip-tools. Graduate to Poetry or uv if you need more.

## Virtual Environments

Never install packages globally. Use virtual environments.

### Creating Environments

```bash
# Standard library venv
python -m venv venv

# Activate
source venv/bin/activate  # Linux/macOS
venv\Scripts\activate     # Windows

# Deactivate
deactivate
```

### Why Virtual Environments Matter

```bash
# Without venv: global pollution
pip install pandas==1.5.0  # Affects all projects
pip install pandas==2.0.0  # Breaks projects needing 1.5

# With venv: isolation
cd project-a && source venv/bin/activate
pip install pandas==1.5.0  # Only for project-a

cd project-b && source venv/bin/activate
pip install pandas==2.0.0  # Only for project-b
```

### .gitignore for Virtual Environments

```gitignore
# Virtual environments
venv/
.venv/
env/
.env/

# Don't commit installed packages
```

## Dependency Specification

### requirements.txt (Basic)

```txt
# requirements.txt
requests>=2.28.0
pandas>=2.0.0,<3.0.0
numpy~=1.24.0
```

**Problems with basic requirements.txt:**

- No transitive dependency locking
- Different installs on different days
- Version ranges resolve differently

### pip-tools (Better)

Separate what you want from what you get:

```txt
# requirements.in (what you want)
requests
pandas>=2.0
```

```bash
# Generate locked requirements.txt
pip-compile requirements.in

# Result: requirements.txt with exact versions
# requests==2.31.0
# pandas==2.1.0
# numpy==1.24.3  # transitive dependency
# ...
```

```bash
# Install from locked file
pip install -r requirements.txt

# Update all
pip-compile --upgrade requirements.in

# Update specific package
pip-compile --upgrade-package requests requirements.in
```

### Poetry

Modern project management with dependency resolution:

```toml
# pyproject.toml
[tool.poetry]
name = "my-project"
version = "0.1.0"
description = "My project"
authors = ["You <you@example.com>"]

[tool.poetry.dependencies]
python = "^3.11"
requests = "^2.28"
pandas = ">=2.0,<3.0"

[tool.poetry.group.dev.dependencies]
pytest = "^7.0"
black = "^23.0"
```

```bash
# Install
poetry install

# Add package
poetry add requests

# Add dev dependency
poetry add --group dev pytest

# Update lock file
poetry lock

# Export to requirements.txt (for deployment)
poetry export -f requirements.txt -o requirements.txt
```

Poetry creates `poetry.lock` automatically.

### uv

Extremely fast pip and pip-tools replacement:

```bash
# Install uv
pip install uv

# Create virtual environment
uv venv

# Install from requirements
uv pip install -r requirements.txt

# Compile lock file (like pip-compile)
uv pip compile requirements.in -o requirements.txt

# Sync environment to lock file
uv pip sync requirements.txt
```

uv is 10-100x faster than pip for most operations.

### pyproject.toml (Modern Standard)

The modern standard for Python project metadata:

```toml
[project]
name = "my-project"
version = "1.0.0"
description = "What it does"
authors = [{name = "You", email = "you@example.com"}]
license = {text = "MIT"}
readme = "README.md"
requires-python = ">=3.9"
dependencies = [
    "requests>=2.28.0",
    "pandas>=2.0.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0.0",
    "black>=23.0.0",
]

[build-system]
requires = ["setuptools>=61.0"]
build-backend = "setuptools.build_meta"
```

## Python Version Management

### pyenv

Manage multiple Python versions:

```bash
# Install pyenv (macOS)
brew install pyenv

# Install Python version
pyenv install 3.11.4

# Set global default
pyenv global 3.11.4

# Set project-specific version
cd my-project
pyenv local 3.11.4  # Creates .python-version
```

### mise (formerly rtx)

Multi-language version manager:

```toml
# .mise.toml
[tools]
python = "3.11.4"
node = "18.17.0"
```

```bash
mise install
mise activate
```

## Security

### pip-audit

```bash
pip install pip-audit

# Scan installed packages
pip-audit

# Scan requirements file
pip-audit -r requirements.txt

# JSON output
pip-audit --format json
```

### Safety (Alternative)

```bash
pip install safety

# Scan
safety check -r requirements.txt
```

### Scanning in CI

```yaml
# GitHub Actions
- name: Security scan
  run: |
    pip install pip-audit
    pip-audit -r requirements.txt
```

## Common Issues

### "pip install" vs "python -m pip"

```bash
# This might use the wrong pip
pip install package

# This always uses pip for the current Python
python -m pip install package
```

When in doubt, use `python -m pip`.

### Dependency Conflicts

```
ERROR: Cannot install package-a and package-b because
these package versions have conflicting dependencies.
```

**Diagnosis:**
```bash
pip install pipdeptree
pipdeptree --warn fail
```

**Solutions:**

1. Update packages to compatible versions
2. Use dependency resolution tools (Poetry, pip-tools)
3. Sometimes: accept you can't have both

### "No module named X"

```python
import pandas  # ModuleNotFoundError
```

**Checklist:**

1. Is the virtual environment activated?
2. Is the package installed in the right environment?
3. Are you running the right Python?

```bash
which python  # Check which Python
pip list      # Check installed packages
```

### Platform-Specific Dependencies

Some packages have platform-specific builds:

```txt
# requirements.txt with environment markers
pywin32>=300; sys_platform == 'win32'
uvloop>=0.17.0; sys_platform != 'win32'
```

## Conda

Popular in data science for managing both Python and native dependencies.

### When to Use Conda

- Complex native dependencies (CUDA, MKL, etc.)
- Reproducible scientific computing
- When pip packages don't have wheels for your platform

### Basic Usage

```bash
# Create environment
conda create -n myenv python=3.11

# Activate
conda activate myenv

# Install packages
conda install pandas numpy

# Export environment
conda env export > environment.yml

# Recreate environment
conda env create -f environment.yml
```

### Conda + pip

```bash
# Install conda packages first, pip packages after
conda install numpy pandas
pip install some-pip-only-package

# In environment.yml
dependencies:
  - numpy
  - pandas
  - pip:
    - some-pip-only-package
```

**Warning:** Mixing conda and pip can cause issues. Install as much as possible from conda first.

## Best Practices Checklist

- [ ] Always use virtual environments
- [ ] Pin Python version (.python-version)
- [ ] Use lock files (pip-tools, Poetry, or uv)
- [ ] Run pip-audit in CI
- [ ] Separate dev/test dependencies
- [ ] Use pyproject.toml for new projects
- [ ] Commit lock files to version control

## Quick Reference

### Tool Selection Guide

| Scenario | Recommendation |
|----------|----------------|
| Simple project | pip + venv + pip-tools |
| Library development | Poetry or PDM |
| Need speed | uv |
| Data science + native deps | conda |
| Enterprise/legacy | Whatever's established |

### Essential Commands

```bash
# Virtual environment
python -m venv venv && source venv/bin/activate

# pip-tools workflow
pip-compile requirements.in     # Generate lock file
pip install -r requirements.txt # Install locked deps

# Poetry workflow
poetry install                  # Install from lock file
poetry add package              # Add dependency
poetry lock                     # Update lock file

# Security
pip-audit -r requirements.txt
```

### File Purposes

| File | Purpose | Commit? |
|------|---------|---------|
| requirements.in | What you want | Yes |
| requirements.txt | What you got (locked) | Yes |
| pyproject.toml | Project metadata | Yes |
| poetry.lock | Poetry lock file | Yes |
| venv/ | Virtual environment | No |
| .python-version | Python version | Yes |
