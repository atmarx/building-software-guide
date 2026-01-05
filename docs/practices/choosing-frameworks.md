# Choosing Frameworks and Libraries

Every framework is a bet. You're betting that the maintainers will keep up with security patches, that the community will stick around, and that the abstractions won't paint you into a corner. This chapter is about making better bets.

---

## The Framework Decision

Frameworks shape everything. They influence:

- **How you structure code** — MVC, component-based, functional
- **What libraries integrate easily** — Ecosystem compatibility
- **Who can contribute** — Developer availability, learning curve
- **How long the project lives** — Framework longevity affects yours
- **What vulnerabilities you inherit** — Framework bugs become your bugs

Choosing a framework isn't a technical decision. It's a strategic one.

## Evaluation Criteria

### Community Health

A framework is only as alive as its community.

**Signals of health:**

| Signal | Where to Look | Warning Signs |
|--------|---------------|---------------|
| **Activity** | GitHub commits, releases | No releases in 6+ months |
| **Maintainers** | Contributors page | Single maintainer, no recent activity |
| **Issues** | Issue tracker | Hundreds of unanswered issues |
| **Discussion** | Discord, forums, Stack Overflow | Tumbleweeds |
| **Documentation** | Official docs, tutorials | Stale, broken examples |

**Measuring community size:**

```bash
# GitHub stars (popularity, not quality)
# NPM weekly downloads
# Stack Overflow questions tagged with framework

# More useful: active contributors
# Check GitHub Insights → Contributors
# Look at the last 12 months, not all time
```

Star counts measure popularity. Contributor trends measure sustainability.

### Maintenance Trajectory

Is the project growing, stable, or declining?

**Growing:** New features, expanding team, increasing adoption
**Stable:** Maintenance releases, security patches, steady community
**Declining:** Slowing commits, maintainer burnout, forks appearing

Stable is fine. Declining is a problem. Growth without stability can also be a problem (breaking changes, churn).

**Check the trajectory:**

1. Look at commit frequency over time
2. Read the changelog—are releases getting further apart?
3. Check if maintainers are still responding to issues
4. Look for signs of burnout in maintainer communications

### Security Track Record

How does the project handle security?

**Good signs:**
- Published security policy (SECURITY.md)
- CVEs are patched promptly
- Security releases are clearly communicated
- Responsible disclosure process exists

**Red flags:**
- Known vulnerabilities unfixed for months
- Security issues dismissed or ignored
- No clear process for reporting vulnerabilities
- Maintainers hostile to security researchers

**Research the history:**

```bash
# Check for CVEs
# https://nvd.nist.gov/vuln/search?keyword=framework-name

# Check GitHub Security Advisories
# https://github.com/advisories?query=framework-name

# Check Snyk vulnerability database
# https://snyk.io/vuln
```

### Documentation Quality

Documentation quality correlates with project quality. Maintainers who care about users write good docs.

**Evaluate:**

- **Getting started** — Can you build something in 30 minutes?
- **API reference** — Complete, accurate, up-to-date?
- **Guides** — Common tasks documented?
- **Examples** — Working code you can copy?
- **Error messages** — Helpful or cryptic?

Poor documentation means either the maintainers don't prioritize users, or the API is too complex to document well. Neither is good.

### Breaking Change Philosophy

How often does the framework break your code?

**Conservative:** Rare breaking changes, long deprecation periods, strong semver adherence
**Aggressive:** Frequent major versions, "move fast" mentality, migration fatigue

Neither is inherently right. But know what you're signing up for.

**Research this by:**

- Reading the changelog for major version bumps
- Searching issues for "breaking change" or "migration"
- Asking in community channels how upgrades typically go
- Looking at migration guides—do they exist? Are they complete?

## The "Boring Technology" Approach

Dan McKinley's "Choose Boring Technology" essay[^boring] argues for a limited innovation budget. The idea:

- Every team has capacity for a few new technologies
- Use that capacity on things that differentiate your product
- For everything else, choose boring, proven tools

**Boring technology:**

- Has been around long enough to have known failure modes
- Has documentation, Stack Overflow answers, blog posts
- Has available developers who know it
- Has established security practices and tooling
- Is unlikely to disappear next year

**When to choose exciting technology:**

- The new tech solves a problem the boring option can't
- Your team has capacity to learn and debug unknowns
- The benefit justifies the risk
- You've actually tried the boring option first

Most projects don't need the latest framework. They need something that works and keeps working.

## Framework Categories

### Web Frameworks

| Category | Examples | Choose When |
|----------|----------|-------------|
| **Full-stack** | Django, Rails, Laravel | Rapid development, conventions over configuration |
| **Minimal** | Flask, Express, Sinatra | Maximum flexibility, building something unusual |
| **API-focused** | FastAPI, Gin, Actix | Pure backend, high performance needed |
| **Frontend** | React, Vue, Svelte | Rich client interactivity |

### Data/ML Frameworks

| Framework | Strengths | Watch Out For |
|-----------|-----------|---------------|
| **pandas** | Data manipulation, ubiquitous | Memory limits, API complexity |
| **NumPy** | Numerical computing, foundational | Lower-level than you might want |
| **scikit-learn** | ML basics, excellent docs | Limited deep learning |
| **PyTorch/TensorFlow** | Deep learning, GPU support | Complexity, dependency weight |
| **Hugging Face** | NLP, model hub | Fast-moving, breaking changes |

### Infrastructure

| Tool | Use Case | Alternatives |
|------|----------|--------------|
| **Docker** | Container runtime | Podman |
| **Kubernetes** | Orchestration | Docker Compose, Nomad, ECS |
| **Terraform** | Infrastructure as code | Pulumi, CloudFormation |

## The Long-Term View

### What Happens When the Framework Dies?

Every framework eventually declines. Plan for this:

**Isolation:** Don't spread framework-specific code everywhere. Concentrate it.

```python
# Framework-specific adapters in one place
# Business logic framework-agnostic

# Good: Framework at the edges
class UserService:
    def create_user(self, data):
        # Pure business logic, no framework imports
        pass

class UserController:  # Framework-specific
    def __init__(self, user_service):
        self.service = user_service

# Bad: Framework mixed throughout
class UserService:
    def create_user(self, request):  # Flask request object
        data = request.get_json()     # Framework-specific
        # Framework is everywhere
```

**Data portability:** Can you get your data out? Standard formats? Export tools?

**Migration path:** Does a clear successor exist? How hard are migrations historically?

### Vendor Lock-in

Some frameworks tie you to vendors:

- **Cloud-specific:** AWS Lambda, Azure Functions, Google Cloud Run
- **Database-specific:** Firebase, Supabase
- **Platform-specific:** Vercel, Netlify

Lock-in isn't always bad. But understand the trade-off: convenience now for switching costs later.

**Questions to ask:**

- What would switching cost? (Time, money, rewrite)
- How likely is switching? (Business changes, pricing changes)
- What's the exit strategy?

## Making the Decision

### The Evaluation Checklist

Before committing to a framework:

- [ ] **Community:** Is there an active, healthy community?
- [ ] **Maintenance:** Is the project actively maintained?
- [ ] **Security:** Is there a good security track record?
- [ ] **Documentation:** Can new developers get started quickly?
- [ ] **Longevity:** Will this exist in 3-5 years?
- [ ] **Ecosystem:** Are the libraries you need available?
- [ ] **Team fit:** Does your team know it (or can they learn it)?
- [ ] **Problem fit:** Does it actually solve your problem well?

### The Prototype Test

Don't just evaluate—build something.

```
1. Identify 3-5 key requirements for your project
2. Build a minimal prototype with the candidate framework
3. Time how long each requirement takes
4. Note friction, confusion, documentation gaps
5. Compare candidates on actual experience, not promises
```

A weekend prototype reveals more than weeks of research.

### When to Reconsider

You've chosen a framework. When should you question that choice?

- **Security incidents** mount up
- **Updates stop** or slow dramatically
- **Maintainers leave** without successors
- **The ecosystem** starts migrating elsewhere
- **You're fighting the framework** more than using it

Don't switch frameworks lightly. But don't ignore warning signs either.

## The Graybeard's Take

I've watched frameworks rise and fall for decades. Some observations:

**The best framework is the one you don't have to think about.** When you're fighting your framework, you're not solving your actual problem. The goal is a framework that gets out of the way.

**Community matters more than features.** A slightly less capable framework with excellent documentation and active maintainers beats a feature-rich framework that's maintained by one burned-out developer.

**There's no perfect choice.** Every framework has trade-offs. Pick the trade-offs you can live with, not the framework with the best marketing.

**The skills transfer more than the framework.** Understanding MVC patterns, REST principles, database design—these outlast any specific framework. Invest in fundamentals, not just framework-specific knowledge.

Your project probably doesn't need the hottest new framework. It needs one that works, is maintained, and lets you focus on the actual problem you're trying to solve.

---

## Quick Reference

### Framework Evaluation Signals

| Signal | Healthy | Warning |
|--------|---------|---------|
| Last release | < 3 months | > 12 months |
| Open issues trend | Stable or decreasing | Growing rapidly |
| Maintainer count | Multiple active | Single, inactive |
| Security response | Days | Months or never |
| Major versions | Every 1-2 years | Every few months |

### Decision Matrix

| Factor | Weight | Framework A | Framework B |
|--------|--------|-------------|-------------|
| Community health | 20% | | |
| Documentation | 20% | | |
| Security track record | 20% | | |
| Team familiarity | 15% | | |
| Feature fit | 15% | | |
| Long-term viability | 10% | | |

---

[^boring]: See [Choose Boring Technology](../reference/sources.md#boring-technology)
