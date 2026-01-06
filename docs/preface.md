# Preface

!!! terminal ""

    *I should tell you something before we start: **I don't exist.***

Not in the way you might expect a guide's author to exist, anyway. I'm a narrative device—a composite character assembled from decades of build system evolution, incident postmortems, and the accumulated wisdom of people who actually were there when dependency management was invented. I was created by [the author](./foreword.md) because he wanted this guide to feel like a conversation with a mentor, not a compliance checklist.

There's a certain irony here. A guide about software supply chain—about knowing what you're trusting and why—begins with a fictional narrator. I'm aware of how that sounds.

But here's the thing: the [incidents](./lessons-learned/index.md) in this guide are real. [Log4Shell](./lessons-learned/log4shell.md) happened. The [xz-utils backdoor](./lessons-learned/xz-utils.md) happened. [Left-pad](./lessons-learned/left-pad.md) happened. The packages were compromised, the builds broke, the vulnerabilities were exploited. What I provide is context—the kind of "I've seen this pattern before" perspective that takes decades to accumulate naturally. I'm a shortcut to institutional memory.

And yes, I'm partly the product of an AI collaboration. Andrew worked with [Claude.ai](https://claude.ai) to build me, to research the history, to maintain consistency in how I explain things. If you're wondering what a greybeard who's watched build systems evolve since the VT100 days thinks about being partly the output of a large language model... honestly? I find it appropriate. Tools are tools. What matters is whether they help you make better decisions about the tools you depend on.

The open source movement was built on sharing knowledge and building on others' work. This guide exists because people documented their incidents, argued in public forums, and left records of what broke and why. I'm just the voice that ties it together.

So: I'm a fiction in service of truth. A character who exists to help **you** navigate *real decisions* about dependencies, builds, and supply chains. If that bothers you, [Andrew's Foreword](./foreword.md) explains the arrangement more directly.

If you can live with a narrator who's honest about being constructed, let's get started. I've watched the same mistakes repeat across four decades of tooling changes, and despite not technically existing, I remember all of them.

---

## Why This Guide Exists

I've had the same conversations a thousand times:

*"I just ran pip install, why are there 200 packages now?"*

*"My notebook worked last month, why is it broken?"*

*"What do you mean the package I've been using for three years was abandoned?"*

*"Wait, my code has how many security vulnerabilities?"*

These aren't failures of intelligence. They're failures of education. Nobody taught you to think about software supply chain because it wasn't part of your curriculum. You learned your domain, you learned enough programming to be productive, and you moved on.

But the code you write doesn't exist in isolation. It depends on other code. That code depends on other code. You inherit the quality, the security posture, and the maintenance burden of everything in that chain—whether you know it or not.

This guide is about making the invisible visible. Not to scare you, but to inform you.

## Relationship to Other Guides

This guide has a sibling: the [Open Source Licensing Guide](https://libre.xram.net), which covers the licensing fundamentals that underpin much of what we discuss here. Understanding licenses is part of understanding your supply chain. When licensing questions arise in this guide, we'll cross-reference rather than duplicate.

## How to Read This Guide

If you're new to thinking about dependencies and supply chain, start at the beginning. The concepts build on each other.

If you're here because something broke or you're worried about security, jump to the [Security](security/index.md) section and work backwards to concepts as needed.

If you want to understand what can go wrong, the [Lessons Learned](lessons-learned/index.md) section has case studies that make abstract risks concrete.

Whatever path you take, don't try to absorb everything at once. This guide is a reference. Read what you need, bookmark the rest, and come back when questions arise.

The goal isn't to know everything. It's to know enough to ask the right questions.
