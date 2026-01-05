# Practices

Concepts explain the *why*. Security explains the *what to defend against*. This section explains the *how*—the practical habits and approaches that reduce risk without making your work impossible.

## What's Here

**[Choosing Frameworks](choosing-frameworks.md)** — Frameworks can accelerate development or trap you in someone else's opinions. This chapter helps you evaluate whether a framework is worth adopting, and how to escape when it isn't.

**[Configuration Management](configuration-management.md)** — Hardcoded values, environment variables, config files, secrets stores. This chapter covers the spectrum of configuration approaches and when to use each—from the simplest script to production deployment.

**[Development Practices](development-practices.md)** — Version control hygiene, CI/CD fundamentals, testing philosophy, and documentation as code. The baseline practices that make everything else easier.

**[Reproducibility](reproducibility.md)** — "It works for me" isn't good enough—especially in research. This chapter covers the layers of reproducibility and practical approaches to achieving them.

**[Publishing Your Code](publishing-your-code.md)** — When you release your work—whether to a journal, GitHub, or a package registry—you become a dependency for others. This chapter covers how to be a responsible publisher: security policies, versioning, documentation, and making your code consumable.

## The Researcher's Reality

Most software engineering advice assumes you're building products with teams. You're probably not. You're likely:

- Working alone or in small groups
- Writing code to answer questions, not to ship features
- Building as you go, without a clear specification
- Under pressure to produce results, not maintainable software

That's fine. Not every script needs enterprise architecture. But every script that touches real data, runs on shared infrastructure, or produces results you'll publish needs *some* discipline.

This section focuses on practices that provide the most value for the least overhead. Not everything here will apply to you—but the fundamentals do.

## Key Takeaways

If you read nothing else in this section:

1. **Frameworks are tradeoffs** — They solve problems but create dependencies. Know what you're trading.

2. **Configuration should be explicit** — Magic values buried in code become bugs. Externalize configuration intentionally.

3. **Version control is not optional** — Even for "throwaway" scripts. You will need that history.

4. **Tests enable change** — Without tests, updates are scary. Scary updates don't get done. Stale dependencies accumulate.

5. **Reproducibility is a core value** — In research especially. If your experiment can't be reproduced, did it happen?

6. **If you publish it, maintain it** — Releasing code creates responsibility. Be a good dependency for others.

7. **Start simple** — Add complexity only when pain demands it. Most research software never needs Kubernetes.
