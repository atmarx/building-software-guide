# Lessons Learned

Abstract risks become real when you see what happens when things go wrong. This section collects case studies of supply chain failures—what happened, why it mattered, and what the industry learned.

## The Classics

Early incidents that shaped how we think about dependency management.

- **[left-pad](left-pad.md)** (2016) — One developer unpublished an 11-line package. Builds broke across the internet. The lesson: transitive dependencies are invisible risk.

- **[event-stream](event-stream.md)** (2018) — A maintainer handed off a popular package to a helpful stranger. The stranger added code targeting a specific Bitcoin wallet. The lesson: trust doesn't transfer automatically.

- **[colors.js](colors-js.md)** (2022) — A frustrated maintainer intentionally corrupted their own packages. Thousands of applications broke. The lesson: maintainers are people with grievances.

## The Vulnerabilities

Critical security incidents that demonstrated the stakes.

- **[log4shell](log4shell.md)** (2021) — A critical vulnerability in one of the most widely-used Java libraries. Trivial to exploit, devastating in impact. The lesson: you need to know what you're running.

- **[xz utils](xz-utils.md)** (2024) — A multi-year social engineering campaign to backdoor SSH authentication. The attacker became a trusted maintainer. The lesson: even careful projects can be compromised.

- **[SolarWinds](solarwinds.md)** (2020) — Attackers compromised a build system, inserting malware into legitimate software updates. 18,000 organizations affected. The lesson: build systems are high-value targets.

## Ongoing Threats

Attack patterns that continue to evolve.

- **[Typosquatting](typosquatting.md)** — Malicious packages with names similar to popular ones. `lodash` vs `1odash`. Detection has improved but remains imperfect.

- **[Dependency Confusion](dependency-confusion.md)** — Internal package names that match public registry names. Build systems pull from the wrong source. Organizations now need explicit policies.

## Common Threads

Reading these cases, patterns emerge:

**Trust is transitive.** When you trust a dependency, you're trusting everyone who can push code to it—maintainers, CI systems, package registries. You're also trusting their dependencies, and their dependencies' dependencies.

**Incentives matter.** Maintainer burnout leads to abandoned projects or hostile takeovers. Lack of corporate support for open source isn't just unfair—it's a security risk.

**Visibility saves you.** Organizations that could answer "are we affected by log4shell?" quickly had SBOMs and vulnerability scanning. Those that couldn't were scrambling for weeks.

**Attacks are sophisticated.** The xz backdoor took years of social engineering. SolarWinds compromised a build system. These aren't script kiddies—they're patient, funded, and clever.

**Defense is possible.** Lock files, SBOMs, vulnerability scanning, update policies, code review—none of these are perfect, but together they reduce risk substantially.

---

Each case study includes sources. Where possible, we link to primary sources (CVE records, original disclosure posts, official advisories) rather than news coverage.
