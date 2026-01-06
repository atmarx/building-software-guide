<div class="hero hero-half" markdown>
  <img src="../assets/images/lessons-learned.webp" alt="Art deco archaeological dig revealing buried machinery">
  <div class="hero-overlay">
    <h1>Lessons Learned</h1>
  </div>
</div>

Abstract risks become real when you see what happens when things go wrong. This section collects case studies of supply chain failures—what happened, why it mattered, and what the industry learned.

!!! terminal "I Was There"
    I've watched most of these unfold in real time. The panicked Slack messages. The "are we affected?" scramble. The 2 AM dependency audits. Reading about incidents in a textbook is one thing. Living through them teaches you differently. These aren't hypotheticals—they're why I check my dependencies.

## The Classics

Early incidents that shaped how we think about dependency management.

<div class="grid cards two-column" markdown>

-   :material-package-variant-remove:{ .lg .middle } **[left-pad](left-pad.md)** (2016)

    ---

    One developer unpublished an 11-line package. Builds broke across the internet. *Lesson: transitive dependencies are invisible risk.*

-   :material-account-switch:{ .lg .middle } **[event-stream](event-stream.md)** (2018)

    ---

    A maintainer handed off a popular package to a helpful stranger who added malicious code. *Lesson: trust doesn't transfer automatically.*

-   :material-emoticon-angry:{ .lg .middle } **[colors.js](colors-js.md)** (2022)

    ---

    A frustrated maintainer intentionally corrupted their own packages. *Lesson: maintainers are people with grievances.*

</div>

## The Vulnerabilities

Critical security incidents that demonstrated the stakes.

<div class="grid cards two-column" markdown>

-   :material-fire:{ .lg .middle } **[log4shell](log4shell.md)** (2021)

    ---

    A critical vulnerability in one of the most widely-used Java libraries. Trivial to exploit, devastating in impact. *Lesson: you need to know what you're running.*

-   :material-incognito:{ .lg .middle } **[xz utils](xz-utils.md)** (2024)

    ---

    A multi-year social engineering campaign to backdoor SSH authentication. *Lesson: even careful projects can be compromised.*

-   :material-cloud-alert:{ .lg .middle } **[SolarWinds](solarwinds.md)** (2020)

    ---

    Attackers compromised a build system, inserting malware into legitimate updates. 18,000 organizations affected. *Lesson: build systems are high-value targets.*

</div>

## Ongoing Threats

Attack patterns that continue to evolve.

<div class="grid cards two-column" markdown>

-   :material-keyboard:{ .lg .middle } **[Typosquatting](typosquatting.md)**

    ---

    Malicious packages with names similar to popular ones. `lodash` vs `1odash`. Detection has improved but remains imperfect.

-   :material-swap-horizontal:{ .lg .middle } **[Dependency Confusion](dependency-confusion.md)**

    ---

    Internal package names that match public registry names. Build systems pull from the wrong source.

</div>

## Common Threads

Reading these cases, patterns emerge:

**Trust is transitive.** When you trust a dependency, you're trusting everyone who can push code to it—maintainers, CI systems, package registries. You're also trusting their dependencies, and their dependencies' dependencies.

**Incentives matter.** Maintainer burnout leads to abandoned projects or hostile takeovers. Lack of corporate support for open source isn't just unfair—it's a security risk.

**Visibility saves you.** Organizations that could answer "are we affected by log4shell?" quickly had SBOMs and vulnerability scanning. Those that couldn't were scrambling for weeks.

**Attacks are sophisticated.** The xz backdoor took years of social engineering. SolarWinds compromised a build system. These aren't script kiddies—they're patient, funded, and clever.

**Defense is possible.** Lock files, SBOMs, vulnerability scanning, update policies, code review—none of these are perfect, but together they reduce risk substantially.

---

Each case study includes sources. Where possible, we link to primary sources (CVE records, original disclosure posts, official advisories) rather than news coverage.
