---
title: Security
---

<div class="hero hero-half" markdown>
  <img src="../assets/images/security.webp" alt="Art deco vault door with radiating golden lines">
  <div class="hero-overlay">
    <h1>Security</h1>
  </div>
</div>

Your code doesn't exist in isolation. It depends on other code, written by people you've never met, maintained by volunteers who might disappear tomorrow. Any link in that chain can be compromised—and you inherit the security posture of every dependency, whether you know it or not.

This section covers supply chain security: the attacks that target it, the tools that defend it, and the practices that minimize risk.

## What's Here

<div class="grid cards two-column" markdown>

-   :material-link-variant:{ .lg .middle } **[The Software Supply Chain](supply-chain.md)**

    ---

    What "supply chain" means in software, why it's a target, and how attacks actually work.

-   :material-format-list-checks:{ .lg .middle } **[Software Bills of Materials](sbom.md)**

    ---

    An SBOM is an inventory of everything in your software. Answer "are we affected?" in minutes instead of days.

-   :material-bug-outline:{ .lg .middle } **[Vulnerability Management](vulnerability-management.md)**

    ---

    Vulnerabilities are inevitable. What matters is how you find them, assess them, and respond.

-   :material-key-variant:{ .lg .middle } **[Secrets Management](secrets-management.md)**

    ---

    API keys in notebooks. Credentials in git history. How to handle secrets properly—and clean up when you don't.

-   :material-shield-check:{ .lg .middle } **[Supply Chain Security Practices](security-practices.md)**

    ---

    Practical defenses: dependency updates, artifact signing, SLSA compliance, and repository security.

-   :material-database-lock:{ .lg .middle } **[Research Data Security](research-data.md)**

    ---

    When your code touches sensitive data, the stakes change. Data handling, environment separation, and audit trails.

</div>

## Why This Matters

In December 2021, a critical vulnerability in log4j—a logging library used by millions of Java applications—allowed attackers to execute arbitrary code by simply sending a crafted string to a server.[^log4shell] Organizations scrambled to answer a simple question: "Are we affected?"

Many couldn't answer. They didn't know what was in their software.

In March 2024, a sophisticated backdoor was discovered in xz utils, a compression library embedded in SSH servers across Linux distributions.[^xz-utils] The attacker had spent years building trust as a maintainer before inserting malicious code.

These aren't theoretical risks. They're recent history. And they're the kind of attacks that researchers—focused on their domains, using code as a means to an end—are least prepared for.

## Key Takeaways

If you read nothing else in this section:

1. **You inherit your dependencies' security posture** — A vulnerability in a transitive dependency is your vulnerability.

2. **Know what you're running** — Generate SBOMs. When a CVE drops, you need to know if you're affected.

3. **Automate vulnerability scanning** — Don't rely on hearing about vulnerabilities through the news.

4. **Secrets don't belong in code** — Not in variables, not in git history, not in container images. Handle them properly.

5. **Update dependencies deliberately** — Stale dependencies accumulate risk, but updates require testing.

6. **Protect your data** — Research data security isn't optional. Know what you're handling and protect it appropriately.

[^log4shell]: See [log4shell Vulnerability](../reference/sources.md#log4shell)
[^xz-utils]: See [xz Utils Backdoor](../reference/sources.md#xz-utils)
