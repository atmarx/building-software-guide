# Evaluating Dependencies

Before you install anything, you should know what you're getting into. This chapter provides a practical framework for assessing dependencies: who maintains them, how healthy the project is, and what happens if things go wrong.

---

## Before You Install Anything

The five minutes you spend evaluating a dependency can save weeks of pain. Here's how to spend those five minutes.

### The Five-Minute Assessment

**1. Who maintains this?**

Look at the project's GitHub (or equivalent):

- Is there a person, a company, or an organization?
- How many contributors are there?
- Is it just one person?

A single maintainer isn't automatically bad, but it's a risk factor. If that person disappears, so does the project.

**2. When was it last updated?**

Check the commit history and release dates:

- Last commit: days ago, months ago, years ago?
- Last release: is there a regular cadence?
- Are there recent responses to issues?

A package last updated three years ago might be stable—or abandoned. Context matters.

**3. How many open issues/PRs are languishing?**

Look at the issue tracker:

- Are issues being triaged and responded to?
- Are pull requests reviewed and merged?
- Is there a backlog growing without attention?

Hundreds of open issues with no responses is a red flag. So is a maintainer who closed everything as "won't fix."

**4. What does the dependency tree look like?**

Before installing, check what you're actually getting:

```bash
# npm
npm explain package-name

# pip (after creating a test environment)
pip install package-name
pip show package-name  # Shows direct dependencies
pipdeptree  # Shows full tree

# Check before committing
pip install --dry-run package-name
```

If installing one package brings in 200 others, that's worth knowing.

**5. What's the license?**

Check for license compatibility with your project. See the [Open Source Licensing Guide](licensing-guide) for details.

```bash
# Quick check
pip-licenses  # Python
license-checker  # npm
```

## Red Flags

Stop and reconsider if you see:

### Single Maintainer with No Succession Plan

One person maintaining a package is common. But ask:

- What happens if they get a new job?
- What if they lose interest?
- What if their account is compromised?

The [event-stream](../lessons-learned/event-stream.md) attack happened because a single maintainer handed off to the wrong person. The [xz utils](../lessons-learned/xz-utils.md) backdoor exploited maintainer burnout.

### Last Commit Over 1 Year Ago (for Active Domains)

Context matters:

- A math library might be "done" and need no updates
- A web framework that hasn't been updated in a year is probably abandoned
- Anything security-related should have recent activity

Ask: Is this project finished, or neglected?

### Hundreds of Open Issues, Few Responses

Issues are normal. What matters is how they're handled:

- Are they triaged?
- Is there any response, even "we can't fix this now"?
- Are security issues treated urgently?

No engagement with the community suggests no one is home.

### No Clear Versioning Strategy

Good projects follow semver or something similar:

- MAJOR.MINOR.PATCH
- Clear changelog
- Breaking changes documented

If version numbers seem random or changes aren't documented, updates are risky.

### "Works on My Machine" Documentation

Setup instructions should actually work for someone who isn't the author:

- Are there clear installation steps?
- Are dependencies documented?
- Are there examples?

If the README just says "install and run," that's a warning sign.

### Minified or Obfuscated Source

For open source packages, the source should be readable:

- Is the repo just minified/compiled files?
- Can you inspect what the code does?
- Are there unexplained binary blobs?

The [xz utils](../lessons-learned/xz-utils.md) backdoor was hidden in test fixture files that looked like binary data. Unusual files deserve scrutiny.

## Green Flags

These suggest a healthier project:

### Multiple Active Maintainers

More maintainers means:

- Lower bus factor
- More review of changes
- Less single-point-of-failure risk

Check the contributor graph. Is there activity from multiple people, or just one?

### Clear Governance (Foundation-Backed)

Projects backed by foundations (Apache, Linux Foundation, Python Software Foundation) have:

- Succession planning
- Legal structure
- Long-term stability focus

This doesn't guarantee quality, but it reduces abandonment risk.

### Semantic Versioning with Changelog

Good signs:

- Clear version numbers that mean something
- Changelog documenting what changed
- Breaking changes clearly marked

This makes updates predictable and plannable.

### Active Issue Triage

Even if issues aren't all resolved, triage suggests engagement:

- Labels applied
- Duplicates marked
- Questions answered
- Security issues prioritized

### Security Policy (SECURITY.md)

A SECURITY.md file indicates:

- They've thought about security
- There's a way to report vulnerabilities
- They'll handle reports seriously

```markdown
# Security Policy

## Reporting a Vulnerability

Please report security vulnerabilities to security@example.com.
Do not open public issues for security problems.
```

### Reproducible Build Process

Can you build the package from source and get the same result as the published artifact? This matters for:

- Verifying the published code matches the repo
- Building patched versions if needed
- Trust verification

## The Bus Factor

**Bus factor:** The minimum number of people who would need to be hit by a bus before the project can no longer be maintained.

A bus factor of 1 means one person's absence kills the project. This is common—and risky.

### How to Check

Look at the contributor graph:

```bash
# Git shortlog shows commit distribution
git shortlog -sn --all
```

If one person has 95% of commits, that's a bus factor of approximately 1.

### When Bus Factor of 1 Is Acceptable

Sometimes it's fine:

- Small, stable, well-understood code
- Limited functionality (unlikely to need changes)
- You could fork and maintain if needed
- The risk is proportional to how critical the dependency is

A utility function with bus factor 1 is different from a database driver with bus factor 1.

## Maintenance Burden Assessment

Different types of code need different maintenance:

### Active Maintenance Required

High-risk categories that need ongoing attention:

| Category | Why | Examples |
|----------|-----|----------|
| Security-sensitive | Vulnerabilities need rapid response | Auth libraries, crypto |
| External APIs | APIs change, clients must follow | AWS SDK, Stripe |
| Native dependencies | Platform changes require updates | Image processing, DB drivers |
| Rapidly evolving ecosystems | Standards shift quickly | ML frameworks, frontend |

For these, stale packages are dangerous. Check activity carefully.

### Stable and Lower Risk

Some code changes less:

| Category | Why | Examples |
|----------|-----|----------|
| Pure algorithms | Math doesn't change | Statistics, sorting |
| Data structures | Fundamentals are stable | Trees, queues |
| Stable format parsers | Formats are fixed | JSON, CSV |
| Math libraries | Equations don't update | NumPy core functions |

A math library with no commits in two years might be fine. It's probably just done.

## The "What If" Exercise

Before committing to a dependency, imagine failure modes:

### What if it disappears tomorrow?

- [left-pad](../lessons-learned/left-pad.md) was unpublished and broke thousands of builds
- How hard would replacement be?
- Do alternatives exist?

### What if the maintainer goes hostile?

- [colors.js](../lessons-learned/colors-js.md) was deliberately broken by its maintainer
- Are you pinning versions?
- Would you notice malicious updates?

### What if a critical vulnerability is found?

- [log4shell](../lessons-learned/log4shell.md) affected millions of systems
- How quickly could you update?
- Do you even know you're using it? (transitive dependencies)

### How tightly coupled is your code?

- If you use a utility function, replacement is easy
- If you use a framework that structures your application, replacement is a rewrite

The deeper the integration, the higher the cost of problems.

## Making the Decision

After evaluation, you'll have a sense of the risk. Now weigh it against the benefit.

### Decision Matrix

| Benefit | Risk Assessment | Decision |
|---------|-----------------|----------|
| High (saves significant work) | Low (healthy project) | Use it |
| High | Medium (some concerns) | Use cautiously, monitor |
| High | High (red flags) | Find alternative or write yourself |
| Low (saves little work) | Low | Consider writing yourself anyway |
| Low | Medium or High | Don't use it |

### Document Your Decision

For critical dependencies, document why you chose them:

```markdown
## Dependency: some-package

**Purpose:** Handles date parsing for multiple formats
**Alternatives considered:** dateutil, arrow, pendulum
**Why this one:** Active maintenance, good performance, MIT license
**Risk assessment:** Medium (2 maintainers, monthly releases)
**Exit plan:** Could migrate to dateutil with moderate effort
**Last reviewed:** 2024-01-15
```

This helps future-you (or your successor) understand the choice.

## The Graybeard's Take

I've been burned by every category of dependency problem. The unmaintained package that broke with a Python update. The single-maintainer project that disappeared. The heavily-adopted framework that made a breaking change.

After enough burns, you develop instincts. A certain skepticism. Not paranoia—I still use dependencies constantly. But I check. I spend the five minutes.

The developers who avoid the worst outcomes aren't necessarily smarter. They're just more careful. They look at the contributor graph. They read the issues. They think about what happens when, not if, something goes wrong.

Five minutes of evaluation. That's all it takes. And it's five minutes you'll never regret.

---

## Evaluation Checklist

### Quick Check (2 minutes)

- [ ] Who maintains this?
- [ ] When was the last update?
- [ ] How many dependencies does it bring?
- [ ] What's the license?

### Deeper Check (5 minutes)

- [ ] What's the bus factor?
- [ ] Are issues being responded to?
- [ ] Is there a SECURITY.md?
- [ ] Can I understand the release process?
- [ ] What happens if this disappears?

### For Critical Dependencies (15+ minutes)

- [ ] Read the documentation thoroughly
- [ ] Review recent commits and releases
- [ ] Check for known vulnerabilities
- [ ] Test in isolated environment
- [ ] Document the decision and exit plan
