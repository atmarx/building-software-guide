# The Weight of Your Dependencies

**A Pragmatist's Guide to Software Supply Chain**

---

You ran `pip install`. Maybe `npm install`. Maybe you copied a Dockerfile from Stack Overflow. It worked. You moved on.

But that one command pulled in dozens—maybe hundreds—of packages you've never examined. Written by people you've never met. Maintained by volunteers who might disappear tomorrow. Any one of them could contain the vulnerability that compromises your research data, or the license clause that complicates your publication.

This guide is about that moment between "I need to solve this problem" and "install random-package." It's about understanding what you're building on, so you can make informed decisions about risk.

## Who This Guide Is For

You write code as part of your work—scripts, analysis pipelines, applications—but software engineering isn't your primary discipline. You've never thought much about where your dependencies come from or what happens if they disappear. You `pip install` things that seem to work and move on.

Some of you will stay in JupyterHub, running Python notebooks. That's fine. This guide will help you understand the risks you're accepting and how to minimize them.

Some of you will go deeper—containers, orchestration, production deployments. This guide will give you the foundation. The specifics live in other guides that build on these concepts.

## What This Guide Covers

**[Concepts](concepts/index.md)** — The true cost of dependencies, how to evaluate them, versioning strategies, and build environments. Foundational knowledge for everything that follows.

**[Security](security/index.md)** — Supply chain attacks, software bills of materials (SBOMs), vulnerability management, and research data security. This is where most blind spots live.

**[Practices](practices/index.md)** — Choosing frameworks, development hygiene, and reproducibility. Practical approaches that reduce risk without slowing you down.

**[Lessons Learned](lessons-learned/index.md)** — Case studies of supply chain failures. What happened, why it mattered, and what changed.

**[Reference](reference/index.md)** — Checklists, tools, glossary, and sources.

**[Appendices](appendices/index.md)** — Ecosystem-specific guidance for Node.js, Python, Go, Rust, and considerations for researchers.

## What This Guide Assumes

You have basic programming experience. You've used a package manager. You understand that code has dependencies.

You don't need to be a security expert. You don't need to know what a container is (yet). You don't need to have opinions about build systems.

If you're working with licensed code—and you are—you should understand the basics of open source licensing. This guide's companion, the [Open Source Licensing Guide](licensing-guide), covers that territory. When licensing questions arise here, we'll cross-reference rather than re-explain.

## A Note on Risk

Every decision in software involves tradeoffs. Adding a dependency saves development time but adds maintenance burden and security surface area. Pinning versions adds stability but means you miss security patches. Containerizing your environment adds reproducibility but adds complexity.

This guide won't tell you what to do. It will help you understand the risks you're accepting so you can make informed decisions. The right choice depends on your context—what you're building, who uses it, what data it touches, and how long it needs to last.

There is no zero-risk option. There's only informed risk.

---

<div class="grid cards" markdown>

-   :material-lightbulb-outline:{ .lg .middle } **Start with Concepts**

    ---

    Understand what dependencies actually cost before you evaluate specific risks.

    [:octicons-arrow-right-24: The True Cost of Free](concepts/true-cost-of-free.md)

-   :material-shield-alert-outline:{ .lg .middle } **Jump to Security**

    ---

    If you're here because something went wrong, start with the security fundamentals.

    [:octicons-arrow-right-24: The Software Supply Chain](security/supply-chain.md)

-   :material-book-open-variant:{ .lg .middle } **Learn from Failures**

    ---

    Case studies make abstract risks concrete.

    [:octicons-arrow-right-24: Lessons Learned](lessons-learned/index.md)

</div>
