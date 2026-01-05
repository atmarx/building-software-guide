# Preface

## About the Voice

I've been writing software since before "open source" had a name. I learned vi on a VT100 because that's what was available. I've watched build systems come and go—make, ant, maven, gradle, webpack, and whatever we're using next year. I remember when "dependency management" meant tarring up vendor libraries and hoping you remembered which versions you'd grabbed.

I've seen the same mistakes made across decades, just with different tools. The patterns don't change. Someone picks a framework without understanding it. Someone adds a dependency without reading it. Someone copies a configuration from Stack Overflow and runs it in production. The tools change, but the failures don't.

I'm not anti-modern. I use containers. I appreciate good tooling. But I insist you understand what's happening before you trust it. If you can't explain what a Dockerfile does, you don't understand your build. If you can't name ten of your transitive dependencies, you don't understand your supply chain.

This isn't about being paranoid. It's about being informed. Every dependency is a decision. Every decision has costs. The goal isn't to avoid dependencies—that's impractical and often counterproductive. The goal is to make conscious decisions about what you trust and why.

## Why This Guide Exists

I've had the same conversations a thousand times:

"I just ran pip install, why are there 200 packages now?"

"My notebook worked last month, why is it broken?"

"What do you mean the package I've been using for three years was abandoned?"

"Wait, my code has *how many* security vulnerabilities?"

These aren't failures of intelligence. They're failures of education. Nobody taught you to think about software supply chain because it wasn't part of your curriculum. You learned your domain, you learned enough programming to be productive, and you moved on.

But the code you write doesn't exist in isolation. It depends on other code. That code depends on other code. You inherit the quality, the security posture, and the maintenance burden of everything in that chain—whether you know it or not.

This guide is about making the invisible visible. Not to scare you, but to inform you.

## Relationship to Other Guides

This guide is foundational. It explains the *why* and *what* of software supply chain management. It doesn't tell you how to configure Kubernetes or submit jobs to Slurm—that's what the practical guides are for. But before you follow any of those guides, you should understand what you're building on.

If you're working with open source software—and if you're writing code, you are—you should also read the companion [Open Source Licensing Guide](licensing-guide). Understanding licenses is part of understanding your supply chain. When licensing questions arise in this guide, we'll cross-reference rather than duplicate.

## How to Read This Guide

If you're new to thinking about dependencies and supply chain, start at the beginning. The concepts build on each other.

If you're here because something broke or you're worried about security, jump to the [Security](security/index.md) section and work backwards to concepts as needed.

If you want to understand what can go wrong, the [Lessons Learned](lessons-learned/index.md) section has case studies that make abstract risks concrete.

Whatever path you take, don't try to absorb everything at once. This guide is a reference. Read what you need, bookmark the rest, and come back when questions arise.

The goal isn't to know everything. It's to know enough to ask the right questions.
