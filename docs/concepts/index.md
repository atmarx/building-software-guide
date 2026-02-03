---
title: Concepts
---

<div class="hero hero-half" markdown>
  <img src="../assets/images/concepts.webp" alt="Art deco library with glowing orbs">
  <div class="hero-overlay">
    <h1>Concepts</h1>
  </div>
</div>

Before you can make informed decisions about dependencies and supply chain, you need to understand what you're actually dealing with. This section covers the foundational concepts that everything else builds on.

## What's Here

<div class="grid cards two-column" markdown>

-   :material-currency-usd-off:{ .lg .middle } **[The True Cost of Free](true-cost-of-free.md)**

    ---

    Dependencies aren't free. They cost evaluation time, maintenance effort, security surface area, and upgrade cycles.

-   :material-script-text:{ .lg .middle } **[When Scripts Become Software](scripts-become-software.md)**

    ---

    That "quick script" you wrote last month? It's now critical infrastructure. Code written to answer a question becomes code that must be maintained.

-   :material-robot:{ .lg .middle } **[Vibe Coding](vibe-coding.md)**

    ---

    When AI writes your code, you inherit dependencies you didn't choose, patterns you don't understand, and risks you can't see.

-   :material-saw-blade:{ .lg .middle } **[Power Tools](power-tools.md)**

    ---

    You're not vibe coding—you know what you're doing. But AI as a power tool carries its own risks. Expertise doesn't protect you when you're not the one holding the tool.

-   :material-scale-balance:{ .lg .middle } **[Understanding Risk](understanding-risk.md)**

    ---

    Every decision in software involves tradeoffs. Risk as a framework for thinking about what you're accepting.

-   :material-magnify-scan:{ .lg .middle } **[Evaluating Dependencies](evaluating-dependencies.md)**

    ---

    Before you install anything, know what you're getting into. A practical framework for assessing dependencies.

-   :material-lock-check:{ .lg .middle } **[Versioning and Lock Files](versioning-and-lockfiles.md)**

    ---

    Version numbers mean something (sometimes). Lock files ensure reproducibility (when you use them).

-   :material-docker:{ .lg .middle } **[The Build Environment](build-environment.md)**

    ---

    "Works on my machine" isn't good enough. Containerization, reproducibility, and the fundamentals of build environments.

</div>

## Key Takeaways

If you read nothing else in this section:

1. **Dependencies have weight** — Every package you add is code you now maintain, security surface you now defend, and complexity you now carry.

2. **Scripts become software** — That "temporary" notebook will outlive your expectations. Plan accordingly.

3. **AI amplifies, not replaces** — AI-assisted coding makes you faster at whatever you're doing—including making mistakes. Review AI output like a PR from an untrusted contributor.

4. **Expertise doesn't grant immunity** — Experienced developers are more vulnerable to approval errors, not less. Respect the power tool.

5. **Risk is unavoidable** — There's no zero-risk option. The goal is informed risk, not no risk.

6. **Evaluate before you install** — Five minutes of assessment can save weeks of pain later.

7. **Lock files are not optional** — If your builds aren't reproducible, you don't have builds.

8. **Understand your environment** — If you can't explain what's happening in your build, you don't control it.
