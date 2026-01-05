# Development Practices

Good development practices are force multipliers. They catch bugs before production, make code easier to maintain, and reduce the friction of working with others. This chapter covers the practices that pay dividends.

---

## Code Review

Code review catches bugs, improves code quality, and spreads knowledge across the team. Done well, it's one of the highest-value practices. Done poorly, it's a bottleneck that breeds resentment.

### What Code Review Is For

**Finding defects:** Bugs, security issues, edge cases the author missed.

**Knowledge sharing:** Reviewers learn the codebase. Authors get different perspectives.

**Maintaining standards:** Consistent style, architecture patterns, best practices.

**Catching supply chain issues:** New dependencies, version changes, suspicious patterns.

### What Code Review Is Not For

**Bikeshedding:** Arguing about tabs vs. spaces, minor style preferences that don't matter.

**Gatekeeping:** Blocking merges for ego or political reasons.

**Rewriting:** If the code needs to be completely different, that's a conversation, not a review comment.

### Effective Review Practices

**Review promptly.** Long review times block authors and encourage large PRs. Aim for same-day reviews.

**Review in context.** Understand what the change is trying to accomplish before critiquing how.

**Be specific.** "This could be better" is useless. "This could be clearer if we extracted a function for the validation logic" is actionable.

**Distinguish severity.** Prefix comments to indicate importance:

```
[blocking] This SQL is vulnerable to injection. Must fix.
[suggestion] Consider using a constant here for clarity.
[question] Why did we choose this approach over X?
[nit] Typo in comment.
```

**Review for security.** Check for:

- Input validation
- SQL injection, XSS, command injection
- Secrets in code
- New dependencies (check them!)
- Authentication/authorization logic

### Reviewing Dependency Changes

When lock files or dependency manifests change:

```markdown
## Dependency Change Review Checklist

- [ ] What dependencies were added? Are they necessary?
- [ ] What dependencies were updated? Are these intentional?
- [ ] Check new dependencies:
  - [ ] Maintainer reputation
  - [ ] Download counts
  - [ ] Recent activity
  - [ ] Known vulnerabilities
- [ ] Check version changes:
  - [ ] Any major version bumps?
  - [ ] Read changelogs for breaking changes
  - [ ] Security fixes included?
```

### Automated Checks

Automate what can be automated:

- **Linting:** Style enforcement shouldn't require human review
- **Type checking:** Catch type errors in CI
- **Tests:** PRs should pass tests before review
- **Security scanning:** Automated vulnerability checks
- **Coverage:** Track coverage changes

Humans should review logic, architecture, and security. Machines should review style.

## Testing

Tests give confidence that code works and keeps working.

### The Testing Pyramid

```
         /\
        /  \  End-to-End (few)
       /----\
      /      \ Integration (some)
     /--------\
    /          \ Unit (many)
   --------------
```

**Unit tests:** Fast, isolated, many of them. Test individual functions and classes.

**Integration tests:** Test components working together. Database queries, API calls, service interactions.

**End-to-end tests:** Full system tests. Slow, brittle, but catch integration issues nothing else can.

More unit tests than integration tests. More integration tests than E2E tests.

### What to Test

**Test behavior, not implementation:**

```python
# Bad: Testing implementation details
def test_user_creation():
    user = User("alice")
    assert user._name == "alice"  # Implementation detail

# Good: Testing behavior
def test_user_creation():
    user = User("alice")
    assert user.get_name() == "alice"  # Public behavior
```

**Test edge cases:**

```python
def test_division():
    assert divide(10, 2) == 5       # Normal case
    assert divide(0, 5) == 0        # Zero numerator
    with pytest.raises(ValueError):
        divide(10, 0)                # Zero denominator
```

**Test error paths:**

```python
def test_api_handles_network_failure():
    with mock.patch('requests.get') as mock_get:
        mock_get.side_effect = ConnectionError()
        result = fetch_data()
        assert result.error == "Network unavailable"
```

### Test Data

**Don't use production data in tests.** Production data contains real user information, real secrets, real problems.

**Generate test data:**

```python
# Using factories
from factory import Factory, Faker

class UserFactory(Factory):
    class Meta:
        model = User

    name = Faker('name')
    email = Faker('email')

# In tests
user = UserFactory()
```

**Fixtures for common scenarios:**

```python
@pytest.fixture
def sample_dataset():
    return pd.DataFrame({
        'id': [1, 2, 3],
        'value': [10, 20, 30]
    })

def test_calculation(sample_dataset):
    result = calculate_sum(sample_dataset)
    assert result == 60
```

### Testing Dependencies

Be wary of tests that depend on external services:

```python
# Bad: Test depends on external API
def test_weather_api():
    result = get_weather("New York")
    assert result['temp'] is not None  # Flaky!

# Good: Mock external dependencies
def test_weather_api():
    with mock.patch('weather.api.fetch') as mock_fetch:
        mock_fetch.return_value = {'temp': 72}
        result = get_weather("New York")
        assert result['temp'] == 72
```

External services fail, rate limit, and change. Mock them for unit tests. Test real integrations separately, accepting they'll be flaky.

## Version Control Practices

### Commit Hygiene

**Atomic commits:** Each commit should be one logical change.

```bash
# Bad: One commit with unrelated changes
git commit -m "Fix login bug, add user dashboard, update deps"

# Good: Separate commits
git commit -m "Fix login validation bug"
git commit -m "Add user dashboard page"
git commit -m "Update axios to 1.4.0"
```

**Meaningful messages:** The message should explain *why*, not just *what*.

```bash
# Bad
git commit -m "Fix bug"
git commit -m "Update code"

# Good
git commit -m "Fix race condition in session handler

The previous implementation could lose session data if
two requests arrived within the same millisecond.
Fixes #1234"
```

### Branching Strategy

Keep it simple. Most teams need either:

**GitHub Flow:** Main branch + feature branches. Merge via PR.

```
main ─────●─────●─────●─────●─────
           \         /
feature-x   ●───●───●
```

**Trunk-based development:** Small, frequent merges to main. Feature flags for incomplete work.

```
main ─●─●─●─●─●─●─●─●─●─
```

Don't overcomplicate branching. Complex branching strategies usually indicate process problems, not technical needs.

### Pre-commit Hooks

Catch issues before they're committed:

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files

  - repo: https://github.com/psf/black
    rev: 23.7.0
    hooks:
      - id: black

  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.0
    hooks:
      - id: gitleaks  # Catch secrets
```

```bash
# Install hooks
pip install pre-commit
pre-commit install
```

Hooks run automatically on commit. Fail fast, locally.

## Continuous Integration

CI runs automated checks on every change.

### Basic CI Pipeline

```yaml
# .github/workflows/ci.yml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: pip install -r requirements.txt

      - name: Run linting
        run: ruff check .

      - name: Run tests
        run: pytest --cov=src

      - name: Security scan
        run: pip-audit
```

### CI Principles

**Fast feedback:** CI should complete in minutes, not hours. Slow CI gets ignored.

**Deterministic:** Same code should produce same results. Flaky tests erode trust.

**Required:** PRs should require passing CI. No exceptions.

**Visible:** Everyone should see CI status. Failed builds are everyone's problem.

### Security in CI

```yaml
# Security-focused additions
- name: Dependency audit
  run: pip-audit --requirement requirements.txt

- name: SAST scanning
  uses: github/codeql-action/analyze@v2

- name: Secret scanning
  uses: gitleaks/gitleaks-action@v2

- name: Container scanning
  uses: aquasecurity/trivy-action@master
  with:
    scan-type: 'fs'
    severity: 'HIGH,CRITICAL'
```

## Documentation

Documentation is code for humans.

### What to Document

**How to get started:** README with setup instructions, prerequisites, basic usage.

**Architecture decisions:** Why did we choose this approach? What alternatives were considered?

**API contracts:** Function signatures, expected inputs/outputs, error conditions.

**Runbooks:** How to deploy, how to debug common issues, how to handle incidents.

### What Not to Document

**Obvious code:** Good code is self-documenting for *what* it does. Document *why*.

```python
# Bad: Comment restates the code
# Increment counter by 1
counter += 1

# Good: Comment explains why
# Skip the header row
counter += 1
```

**Stale information:** Outdated docs are worse than no docs. They mislead.

### Documentation as Code

Keep documentation near the code it describes:

```
src/
  auth/
    login.py
    README.md  # Auth module docs
docs/
  architecture.md  # High-level architecture
  deployment.md    # Deployment procedures
```

Review documentation changes like code changes. Docs rot without maintenance.

## Dependency Updates

Keep dependencies current. Stale dependencies accumulate vulnerabilities and make future updates harder.

### Update Cadence

| Type | Frequency | Approach |
|------|-----------|----------|
| Security patches | Immediately | Drop everything |
| Patch versions | Weekly | Auto-merge if tests pass |
| Minor versions | Monthly | Review changelog, test |
| Major versions | Quarterly | Plan, schedule, migrate |

### Automated Updates

Use Dependabot or Renovate:

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "pip"
    directory: "/"
    schedule:
      interval: "weekly"
    groups:
      development:
        dependency-type: "development"
      production:
        dependency-type: "production"
```

Automated PRs + good test coverage = updates that can often auto-merge.

## The Graybeard's Take

Practices are habits. The teams that test well, test habitually. The teams that review well, review habitually. The teams that struggle treat these as burdens to be avoided.

I've watched teams try to bolt on quality at the end—adding tests before a release, reviewing code right before deployment. It doesn't work. Quality practices work because they're integrated into the daily workflow, not bolted on after.

The specific practices matter less than consistency. A team that always reviews code, even imperfectly, develops better code than a team that sometimes reviews perfectly. A team that always runs tests, even incomplete ones, catches more bugs than a team with a comprehensive test suite that's often skipped.

Start simple. Add practices one at a time. Make them habits before adding more. The goal isn't to follow a checklist—it's to build a culture where quality is automatic.

---

## Quick Reference

### Code Review Checklist

- [ ] Code does what it claims to do
- [ ] No obvious bugs or edge cases missed
- [ ] Security considerations addressed
- [ ] Dependencies are necessary and vetted
- [ ] Tests cover new functionality
- [ ] Documentation updated if needed
- [ ] No secrets in code

### CI Pipeline Components

| Component | Purpose | Tools |
|-----------|---------|-------|
| Linting | Code style | ruff, eslint, prettier |
| Type checking | Type safety | mypy, TypeScript |
| Unit tests | Logic verification | pytest, jest |
| Security scan | Vulnerability detection | pip-audit, npm audit |
| SAST | Code security | CodeQL, semgrep |
| Secret detection | Credential leaks | gitleaks, trufflehog |

### Testing Priorities

1. **Critical paths:** Login, payments, data handling
2. **Complex logic:** Anything with many branches
3. **Past bugs:** Regression tests for fixed issues
4. **Edge cases:** Boundaries, nulls, empty inputs
5. **Error handling:** Failures should fail gracefully
