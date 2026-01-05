# Concepts

Before you can make informed decisions about dependencies and supply chain, you need to understand what you're actually dealing with. This section covers the foundational concepts that everything else builds on.

## What's Here

**[The True Cost of Free](true-cost-of-free.md)** — Dependencies aren't free. They cost evaluation time, maintenance effort, security surface area, and upgrade cycles. Understanding these costs helps you make better decisions about what to depend on.

**[When Scripts Become Software](scripts-become-software.md)** — That "quick script" you wrote last month? It's now critical infrastructure. This chapter addresses the research reality: code written to answer a question becomes code that must be maintained, reproduced, and trusted.

**[Understanding Risk](understanding-risk.md)** — Every decision in software involves tradeoffs. This chapter introduces risk as a framework for thinking about those tradeoffs—what risks you're accepting, how to assess them, and how to make informed decisions.

**[Evaluating Dependencies](evaluating-dependencies.md)** — Before you install anything, you should know what you're getting into. This chapter provides a practical framework for assessing dependencies: who maintains them, how healthy the project is, and what happens if things go wrong.

**[Versioning and Lock Files](versioning-and-lockfiles.md)** — Version numbers mean something (sometimes). Lock files ensure reproducibility (when you use them). This chapter explains how versioning works, why lock files matter, and how to avoid the common pitfalls.

**[The Build Environment](build-environment.md)** — "Works on my machine" isn't good enough. This chapter covers containerization, reproducibility, and the fundamentals of build environments—not the specific tools, but the principles that make them work.

## Key Takeaways

If you read nothing else in this section:

1. **Dependencies have weight** — Every package you add is code you now maintain, security surface you now defend, and complexity you now carry.

2. **Scripts become software** — That "temporary" notebook will outlive your expectations. Plan accordingly.

3. **Risk is unavoidable** — There's no zero-risk option. The goal is informed risk, not no risk.

4. **Evaluate before you install** — Five minutes of assessment can save weeks of pain later.

5. **Lock files are not optional** — If your builds aren't reproducible, you don't have builds.

6. **Understand your environment** — If you can't explain what's happening in your build, you don't control it.
