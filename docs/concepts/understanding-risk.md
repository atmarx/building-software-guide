# Understanding Risk

Every decision in software involves tradeoffs. Every tradeoff involves risk. This chapter introduces risk as a framework for thinking about those tradeoffs—not to eliminate risk, but to understand it.

!!! terminal "No Safety Net"
    Every decision I've made in 30+ years of software has involved risk. Every one. The people who think they've found the zero-risk path are just the people who haven't noticed the risks yet. The goal isn't safety—it's *informed* risk-taking.

---

## There Is No Zero-Risk Option

Let me say this plainly: **you cannot eliminate risk from your software supply chain**. You can reduce it, manage it, and make informed decisions about it. But you cannot make it zero.

If you use dependencies, you inherit their risks. If you don't use dependencies, you take on the risk of writing everything yourself—including security-critical code you're probably not qualified to write. Either way, you're accepting risk.

The question isn't "how do I avoid risk?" It's "which risks am I willing to accept, and why?"

## Risk as a Framework

Risk in software has two components:

**Likelihood:** How probable is it that something goes wrong?

**Impact:** If it goes wrong, how bad is it?

A risk that's highly likely but low impact (your build occasionally fails due to a flaky test) is different from a risk that's unlikely but catastrophic (an attacker gains access to your production database).

When you make a decision—add a dependency, skip a security review, delay an update—you're implicitly accepting some level of risk. Making that implicit calculation explicit helps you make better decisions.

## Categories of Supply Chain Risk

Based on the [lessons learned](../lessons-learned/index.md) from real incidents, here are the major categories of supply chain risk:

### Availability Risk

*What if this dependency disappears?*

The [left-pad incident](../lessons-learned/left-pad.md) demonstrated this vividly: a maintainer unpublished a package, and builds broke across the internet. But dependencies disappear in other ways too:

- Maintainer loses interest and stops updating
- Package registry has an outage
- Legal dispute forces removal
- Project is archived or deprecated

**Mitigation:** Lock files, vendoring, private registry mirrors, identifying critical dependencies and having fallback plans.

### Vulnerability Risk

*What if this dependency has a security flaw?*

Every dependency is code you didn't write and probably didn't review. That code may have vulnerabilities—[log4shell](../lessons-learned/log4shell.md) being the canonical example.

This isn't hypothetical. The average application has dozens to hundreds of known vulnerabilities in its dependency tree at any given time.[^snyk-state-of-oss] Most are low severity. Some are not.

**Mitigation:** Vulnerability scanning, SBOMs, update policies, minimizing dependencies, preferring well-maintained packages.

### Compromise Risk

*What if this dependency is deliberately malicious?*

The [event-stream](../lessons-learned/event-stream.md) and [xz utils](../lessons-learned/xz-utils.md) incidents showed that attackers can infiltrate legitimate projects. The [SolarWinds](../lessons-learned/solarwinds.md) attack showed they can compromise build systems.

Compromise can happen through:

- Maintainer account takeover
- Social engineering to gain commit access
- Build system infiltration
- Typosquatting (malicious packages with similar names)
- Dependency confusion (internal names matching public packages)

**Mitigation:** Dependency pinning, lock file review, provenance verification, SLSA compliance, limiting dependency count.

### Maintainer Risk

*What if the maintainer does something unexpected?*

[colors.js](../lessons-learned/colors-js.md) demonstrated that maintainers can go hostile—deliberately breaking their own packages. But maintainer risk includes less dramatic scenarios:

- Maintainer burns out and stops responding
- Maintainer makes breaking changes without warning
- Maintainer has different priorities than you do
- Maintainer's situation changes (new job, life circumstances)

**Mitigation:** Knowing who maintains your critical dependencies, having fallback options, contributing back to reduce bus factor.

### Compliance Risk

*What if this dependency has license implications?*

Using code means accepting its license terms. Some licenses (GPL, AGPL) have copyleft requirements that may not align with your project's needs. Some dependencies bundle other dependencies with different licenses.

For details on licensing, see the [Open Source Licensing Guide](https://libre.xram.net).

**Mitigation:** License scanning, SBOM analysis, legal review for critical applications.

### Operational Risk

*What if this dependency causes operational problems?*

Beyond security, dependencies can cause:

- Performance regressions
- Compatibility issues with other dependencies
- Unexpected resource consumption
- Breaking changes in "minor" updates

**Mitigation:** Testing, staged rollouts, monitoring, version pinning, reading changelogs before updating.

## Risk Assessment in Practice

When evaluating a dependency or making a supply chain decision, consider:

### 1. What's the blast radius?

If this goes wrong, what's affected?

- A build script that only runs on your laptop? Low blast radius.
- A library that handles authentication in production? High blast radius.
- A dependency embedded in software you ship to customers? Even higher.

### 2. What's the data exposure?

Does this code touch sensitive data?

- A utility that formats dates? Low exposure.
- A library that processes user input? Medium exposure.
- Code that handles credentials, PII, or research data? High exposure.

### 3. What's the maintenance burden?

How much ongoing effort does this require?

- A stable library with a clear upgrade path? Low burden.
- A rapidly evolving framework with breaking changes every release? High burden.
- A dependency on code that's no longer maintained? Increasing burden over time.

### 4. What's your escape plan?

If you need to stop using this dependency, how hard is it?

- A utility function you could rewrite in an hour? Easy escape.
- A framework that structures your entire application? Very hard escape.
- A cloud service with proprietary APIs and your data locked in? Nearly impossible escape.

## Accepting Risk Consciously

Not all risk needs to be mitigated. Sometimes the right answer is: "Yes, this is a risk, and we're accepting it."

The key is to accept risk *consciously* rather than *accidentally*. Document your reasoning:

- What risk are you accepting?
- Why is it acceptable in this context?
- What would change your assessment?
- When will you revisit this decision?

A dependency with a bus factor of 1 might be acceptable for a research prototype. It's probably not acceptable for production healthcare software.

## The Accumulation Problem

Individual risks compound. Each dependency you add:

- Increases your attack surface
- Adds maintenance burden
- Creates another potential point of failure
- Inherits its own dependencies' risks

A project with 5 dependencies has manageable complexity. A project with 500 has substantial risk even if each individual dependency is well-maintained.

This doesn't mean you should minimize dependencies at all costs—sometimes the right library saves weeks of work and prevents security mistakes. But it does mean the decision to add a dependency should be conscious, not reflexive.

## When Risk Assessment Goes Wrong

Common failure modes:

**Invisible risk:** You didn't know the risk existed. (You didn't know log4j was in your stack until log4shell dropped.)

**AI-amplified invisible risk:** AI-assisted coding creates a new category here. The AI added dependencies you never consciously chose, using patterns from training data you can't inspect. See [Vibe Coding](vibe-coding.md) for how AI makes invisible risk even more invisible.

**Unconsidered risk:** You knew the risk existed but didn't think about it. (You copied a Dockerfile from Stack Overflow without reading it. Or you accepted AI-generated code without reviewing what it imports.)

**Dismissed risk:** You considered the risk but decided it was someone else's problem. (The vendor handles security, right?)

**Stale assessment:** You evaluated the risk once and never revisited. (That dependency was fine in 2019...)

The goal of this guide is to help you move risks from "invisible" and "unconsidered" into the categories where you're making informed decisions.

!!! terminal "The Invisible"
    I've watched smart people make bad risk decisions my entire career. Not because they were careless, but because the risks were invisible to them.

    Nobody thinks "I'm accepting maintainer risk" when they pip install a package. They think "this solves my problem." The risk is there whether you think about it or not.

    What changes with experience isn't that you stop taking risks—you can't. What changes is that you start *seeing* the risks. You notice the single maintainer. You check the last commit date. You look at the dependency tree. You think "if this breaks, what's my plan?"

    That's what this guide is about. Not eliminating risk—that's impossible. Making it visible, so you can make informed decisions instead of lucky ones.

---

## Key Principles

1. **Risk cannot be eliminated, only managed.** Accept this, and focus on making informed decisions.

2. **Risk has two dimensions:** likelihood and impact. Both matter.

3. **Risks compound.** Each dependency adds to your total risk surface.

4. **Accept risk consciously.** Document decisions and revisit them.

5. **Invisible risk is the worst kind.** The goal is awareness, not avoidance.

---

[^snyk-state-of-oss]: Snyk. "State of Open Source Security." Annual reports 2020-2024. https://snyk.io/reports/open-source-security/
