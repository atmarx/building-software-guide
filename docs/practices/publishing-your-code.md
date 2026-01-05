# Publishing Your Code

You've written code. Now others might use it. This chapter covers what happens when your code goes from "works for me" to "works for everyone"—the responsibilities, the patterns, and the pitfalls.

---

## Why Publish?

Code gets published for different reasons:

**Collaboration:** You want others to contribute.

**Reproducibility:** Published results need published code.

**Community:** You've solved a problem others have.

**Requirements:** Some grants, journals, and institutions mandate open code.

Each motivation has different implications. Code you publish for reproducibility needs different treatment than a library you expect others to depend on.

## Before You Publish

### License Selection

No license means others legally can't use your code. Choose one.

| Use Case | License | Notes |
|----------|---------|-------|
| Maximum sharing | MIT, Apache 2.0 | Do whatever you want |
| Keep derivatives open | GPL, AGPL | Copyleft, viral |
| Academic attribution | BSD | Similar to MIT |
| Documentation | CC BY | Not for code |

For a deep dive, see the [Open Source Licensing Guide](https://libre.xram.net).

**Add a LICENSE file:**
```bash
# At repository root
curl -o LICENSE https://opensource.org/licenses/MIT
# Or create via GitHub's license picker
```

### Sensitive Data Audit

Before publishing, audit for:

**Secrets:**
```bash
# Scan git history
gitleaks detect --source . --verbose

# Scan current files
trufflehog filesystem .
```

**Personal data:**
- Email addresses in comments
- Usernames in configuration
- File paths that reveal system structure

**Internal information:**
- Internal URLs, endpoints
- Company-specific configurations
- References to internal tools or systems

### Dependency Audit

Check that your dependencies are compatible with your license and don't introduce issues:

```bash
# Python: Check licenses
pip-licenses

# Node: Check licenses
npx license-checker

# Check for vulnerabilities
pip-audit
npm audit
```

## Repository Structure

A well-structured repository signals quality and helps users understand your code.

### Essential Files

```
project/
├── README.md           # What this is, how to use it
├── LICENSE             # Legal terms
├── CHANGELOG.md        # Version history
├── CONTRIBUTING.md     # How to contribute
├── SECURITY.md         # How to report vulnerabilities
├── .gitignore          # What not to track
├── pyproject.toml      # (or package.json, Cargo.toml, etc.)
└── src/                # Source code
    └── ...
```

### README.md

The first thing users see. Make it count.

```markdown
# Project Name

One-sentence description of what this does.

## Installation

```bash
pip install your-package
```

## Quick Start

```python
from your_package import main_function

result = main_function(input_data)
```

## Documentation

[Full documentation](https://your-docs-site.com)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md)

## License

MIT License - see [LICENSE](LICENSE)
```

### CHANGELOG.md

Track what changed between versions:

```markdown
# Changelog

## [1.2.0] - 2024-03-15

### Added
- New `process_batch` function for bulk processing

### Changed
- `process` function now accepts optional `timeout` parameter

### Fixed
- Memory leak when processing large files (#123)

### Security
- Updated `requests` to 2.31.0 (CVE-2023-XXXXX)

## [1.1.0] - 2024-02-01
...
```

Follow [Keep a Changelog](https://keepachangelog.com) conventions.

### CONTRIBUTING.md

Tell people how to contribute:

```markdown
# Contributing

## Development Setup

```bash
git clone https://github.com/you/project.git
cd project
pip install -e ".[dev]"
```

## Running Tests

```bash
pytest tests/
```

## Pull Request Process

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and linting
5. Submit a PR with a clear description

## Code Style

We use `ruff` for linting and `black` for formatting.

```bash
ruff check .
black .
```
```

### SECURITY.md

Tell security researchers how to report vulnerabilities:

```markdown
# Security Policy

## Reporting a Vulnerability

Please report security vulnerabilities to security@example.com.

**Do not open public issues for security problems.**

We aim to:
- Respond within 48 hours
- Provide a fix within 7 days for critical issues
- Credit researchers who report responsibly

## Supported Versions

| Version | Supported |
|---------|-----------|
| 1.x     | ✅        |
| 0.x     | ❌        |
```

## Version Numbering

Use semantic versioning. Mean it.

### Semantic Versioning

`MAJOR.MINOR.PATCH`

- **MAJOR:** Breaking changes
- **MINOR:** New features, backwards compatible
- **PATCH:** Bug fixes, backwards compatible

### Pre-release Versions

For versions before 1.0.0, anything goes:

```
0.1.0  # Initial development
0.2.0  # Might break everything
0.9.0  # Approaching stability
1.0.0  # Public API is stable
```

Before 1.0.0, make no promises. After 1.0.0, keep them.

### Tagging Releases

```bash
# Update version in pyproject.toml/package.json
# Update CHANGELOG.md

git add pyproject.toml CHANGELOG.md
git commit -m "Release v1.2.0"
git tag v1.2.0
git push origin main --tags
```

## Publishing to Package Registries

### PyPI (Python)

**Setup:**
```toml
# pyproject.toml
[project]
name = "your-package"
version = "1.0.0"
description = "What your package does"
authors = [{name = "Your Name", email = "you@example.com"}]
license = {text = "MIT"}
readme = "README.md"
requires-python = ">=3.9"
dependencies = [
    "requests>=2.28.0",
]

[build-system]
requires = ["setuptools>=61.0"]
build-backend = "setuptools.build_meta"
```

**Build and publish:**
```bash
# Build
python -m build

# Upload to PyPI
twine upload dist/*

# Or upload to TestPyPI first
twine upload --repository testpypi dist/*
```

**CI/CD publishing (GitHub Actions):**
```yaml
name: Publish to PyPI

on:
  release:
    types: [published]

jobs:
  publish:
    runs-on: ubuntu-latest
    permissions:
      id-token: write  # For trusted publishing
    steps:
      - uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'

      - name: Install build tools
        run: pip install build

      - name: Build
        run: python -m build

      - name: Publish to PyPI
        uses: pypa/gh-action-pypi-publish@release/v1
```

### npm (Node.js)

**Setup:**
```json
{
  "name": "your-package",
  "version": "1.0.0",
  "description": "What your package does",
  "main": "index.js",
  "license": "MIT",
  "repository": {
    "type": "git",
    "url": "https://github.com/you/your-package.git"
  },
  "keywords": ["relevant", "keywords"]
}
```

**Publish:**
```bash
# Login
npm login

# Publish
npm publish

# With provenance (recommended)
npm publish --provenance
```

## Maintaining Published Code

Publishing is the beginning, not the end.

### Responding to Issues

**Triage promptly:** Even if you can't fix immediately, acknowledge.

**Use labels:**
- `bug` - Something is broken
- `enhancement` - Feature request
- `question` - User needs help
- `security` - Security-related
- `good first issue` - For new contributors

**Set expectations:** If you can't maintain actively, say so.

```markdown
## Maintenance Status

This project is **maintained** but with limited time.
- Security issues: Fixed promptly
- Bugs: Fixed when possible
- Features: PRs welcome, may take time to review
```

### Security Updates

When vulnerabilities are found in your code:

1. **Assess severity** using CVSS
2. **Develop fix** privately
3. **Coordinate disclosure** with reporter
4. **Release patch** with security advisory
5. **Announce** through appropriate channels

When vulnerabilities are found in your dependencies:

1. **Update dependency**
2. **Release new version**
3. **Notify users** through changelog

### Deprecation

When removing features:

```python
import warnings

def old_function():
    """Deprecated: Use new_function instead."""
    warnings.warn(
        "old_function is deprecated, use new_function instead",
        DeprecationWarning,
        stacklevel=2
    )
    return new_function()
```

Deprecation timeline:
1. Deprecation warning in version X
2. Documented in changelog
3. Remove in version X+1 or later

Give users time to migrate.

## When to Unpublish

Sometimes code should come down:

**Security:** Vulnerability that can't be fixed, active exploitation.

**Legal:** Copyright issues, license violations discovered.

**Mistakes:** Secrets committed, wrong code published.

### npm

```bash
# Unpublish within 72 hours
npm unpublish your-package@1.0.0

# After 72 hours, contact npm support
```

### PyPI

```bash
# "Yank" a release (hides but doesn't delete)
# Done through PyPI web interface or API
```

Note: Unpublishing is disruptive. Users' builds will break. Consider publishing a fixed version instead when possible.

## The Graybeard's Take

Publishing code is making a promise. Even if you say "no warranty," users will depend on you. Their builds will break when you break things. Their security posture depends on your security practices.

This doesn't mean don't publish. It means publish intentionally. If you're sharing code for reproducibility, make that clear—"this code accompanies Paper X, it's not a general-purpose library." If you're publishing a library, commit to the maintenance it requires.

The worst outcome is publishing something that gains users, then abandoning it. Those users are stuck with unmaintained code, frozen dependencies, accumulating vulnerabilities. Either maintain it or be explicit that you won't.

Publishing can be tremendously valuable—for you, for the community, for the advancement of knowledge. Just go in with eyes open about what you're signing up for.

---

## Quick Reference

### Publishing Checklist

- [ ] LICENSE file present
- [ ] README with installation and usage
- [ ] CHANGELOG documenting versions
- [ ] SECURITY.md for vulnerability reporting
- [ ] No secrets in code or history
- [ ] No personal data
- [ ] Dependencies audited
- [ ] Tests passing
- [ ] Documentation current

### Version Decision Tree

```
Is it a breaking change? → MAJOR
Is it a new feature? → MINOR
Is it a bug fix? → PATCH
Is it pre-1.0? → Do what you want
```

### Maintenance Levels

| Level | Commitment |
|-------|------------|
| Active | Regular updates, responsive to issues |
| Maintained | Security fixes, critical bugs |
| Minimal | Security fixes only |
| Archived | No updates, use at your own risk |

Be honest about your level.
