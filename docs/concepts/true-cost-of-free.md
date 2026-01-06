---
title: The True Cost of Free
---

<div class="hero hero-half" markdown>
  <img src="../../assets/images/cost-of-free.webp" alt="Art deco gift box casting long shadow of fine print">
  <div class="hero-overlay">
    <h1>The True Cost of Free</h1>
  </div>
</div>

That library you just installed? It's not free. It costs evaluation time, maintenance effort, security surface area, and upgrade cycles. Understanding these costs helps you make better decisions about what to depend on.

!!! terminal "There's No Such Thing"
    I've watched developers treat `pip install` like it's free. Two seconds, zero thought, problem solved. Then I've watched those same developers spend three days debugging a version conflict, two weeks migrating off an abandoned package, or one very bad weekend cleaning up after a compromised dependency. The install was free. Everything after wasn't.

---

## Nothing Is Free

When you run `pip install some-package`, the immediate cost is close to zero. A few seconds of download time, some disk space, and you have new functionality. It feels like getting something for nothing.

But you're not getting something for nothing. You're deferring costs:

- **Evaluation cost** — Did you check who maintains this? When was it last updated? What's the license?
- **Integration cost** — Will it work with your other dependencies? Does it have the API you actually need?
- **Maintenance cost** — Who updates it when vulnerabilities are found? Who fixes it when it breaks?
- **Upgrade cost** — What happens when Python 4 comes out and this package isn't compatible?
- **Security cost** — You just added attack surface. Is that worth it?

These costs are real. They just don't come due immediately.

## The Convenience Trap

Modern package managers make adding dependencies frictionless. That's a feature—and a trap.

```bash
# This takes 2 seconds
pip install awesome-library

# This takes 2 years to discover
# - awesome-library was abandoned in 2022
# - It depends on a deprecated API
# - The maintainer's account was compromised last month
# - Your research pipeline now has a critical vulnerability
```

The friction that used to exist—finding source code, compiling it, resolving conflicts manually—was annoying, but it forced you to think. Is this worth the effort? Do I really need this?

Now the question isn't whether to add a dependency. It's whether you can justify *not* adding one. "There's a package for that" becomes the default answer to every problem.

AI-assisted coding removes even this minimal friction. You might not even see the import statement being added. You prompt for a solution; code appears; dependencies accumulate. The [Vibe Coding](vibe-coding.md) chapter explores this new reality where you don't even consciously choose to `pip install`—the AI does it for you, and you may not notice until something breaks.

## Technical Debt as Compound Interest

Every dependency you add is a small loan against your future time. Like financial debt, technical debt accumulates interest.

### The Debt Accumulates

| Year | What Happens |
|------|--------------|
| Year 0 | Install package. It works perfectly. Ship feature. |
| Year 1 | Minor version update. Probably fine. Skip it. |
| Year 2 | Major version released. Would require changes. Defer. |
| Year 3 | Security vulnerability announced. Old version affected. |
| Year 3 | Upgrade requires touching code you haven't looked at in years. |
| Year 3 | The upgrade breaks three other dependencies. |
| Year 3 | You're now doing a major refactor instead of your actual work. |

This is the compound interest of technical debt. The longer you defer maintenance, the more expensive it becomes.

### Debt That Can't Be Repaid

Some technical debt becomes permanent:

**Abandoned packages:** The maintainer moved on. No one is fixing bugs or security issues. You can fork it, but now you're the maintainer.

**Deprecated APIs:** The package depends on something that no longer exists. Python 2.7 packages that use `print` statements. PHP 7 code that WordPress plugins still ship. The platform moved on; your dependency didn't.

**Security time bombs:** Packages with known vulnerabilities that will never be patched. You're carrying risk that only grows over time.

## The Dependency Graph You Can't See

When you install one package, you often get dozens more:

```bash
$ pip install pandas
# ...
Successfully installed numpy-1.24.0 pandas-2.0.0 python-dateutil-2.8.2
pytz-2023.3 six-1.16.0 tzdata-2023.3
```

Pandas is useful. But you didn't just add pandas—you added numpy, python-dateutil, pytz, six, and tzdata. Each of those has maintainers, release cycles, and potential vulnerabilities.

### Visualizing the Tree

For a typical data science project:

```
your-analysis-script
├── pandas (you chose this)
│   ├── numpy (transitive)
│   ├── python-dateutil (transitive)
│   │   └── six (transitive)
│   └── pytz (transitive)
├── scikit-learn (you chose this)
│   ├── numpy (already there)
│   ├── scipy (transitive)
│   │   └── numpy (already there)
│   ├── joblib (transitive)
│   └── threadpoolctl (transitive)
├── matplotlib (you chose this)
│   ├── numpy (already there)
│   ├── pillow (transitive)
│   ├── pyparsing (transitive)
│   ├── cycler (transitive)
│   ├── fonttools (transitive)
│   ├── kiwisolver (transitive)
│   ├── packaging (transitive)
│   └── contourpy (transitive)
└── jupyter (you chose this)
    └── ... (dozens more)
```

You chose four packages. You got forty. Each one is code running with your privileges, maintained by someone you've never met.

With AI-assisted development, you might not even have consciously chosen those four. The AI suggested them; you accepted. You inherited the entire tree without ever making explicit decisions about the roots. See [Vibe Coding](vibe-coding.md) for how AI makes this invisible accumulation even more insidious.

### Why This Matters

**Security:** A vulnerability in any transitive dependency is your vulnerability. When [log4shell](../lessons-learned/log4shell.md) hit, most affected organizations had never directly installed log4j—it came in through something else.

**Licensing:** Each package has a license. Some licenses have requirements that flow through to your project. (See the [Open Source Licensing Guide](https://libre.xram.net) for details.)

**Stability:** More dependencies means more things that can break, update unexpectedly, or conflict with each other.

## When the 30-Line Solution Wins

Not every problem needs a library. Sometimes the right answer is to write the code yourself.

### The left-pad Lesson

The [left-pad incident](../lessons-learned/left-pad.md) happened because someone unpublished an 11-line package:

```javascript
function leftPad(str, len, ch) {
  str = String(str);
  var i = -1;
  if (!ch && ch !== 0) ch = ' ';
  len = len - str.length;
  while (++i < len) {
    str = ch + str;
  }
  return str;
}
```

Thousands of builds broke because of 11 lines of code that anyone could have written.

### When to Write It Yourself

Consider writing the code yourself when:

- **The problem is simple.** Padding a string. Checking if a number is even. Formatting a date in one specific way.
- **The solution is small.** A few dozen lines. Something you can understand at a glance.
- **The library is heavy.** You need one function but the package brings in megabytes of code.
- **You need stability.** Your code won't change unless you change it. A dependency might.

### When to Use a Library

Use a library when:

- **The problem is complex.** Cryptography. PDF parsing. Machine learning. Don't reinvent these.
- **Security matters.** Security-critical code should be written by experts and audited by many eyes.
- **You need ongoing maintenance.** Libraries that track changing standards (date/time handling, character encoding) benefit from active maintenance.
- **The cost of bugs is high.** Well-tested libraries have fewer bugs than code you wrote last Tuesday.

### The Decision Framework

| Factor | Write It | Use a Library |
|--------|----------|---------------|
| Complexity | Simple, well-understood | Complex, subtle |
| Size | Small (< 100 lines) | Large |
| Security sensitivity | Low | High |
| Maintenance burden | One-time | Ongoing |
| Bus factor | Only you need it | Others depend on it |

## "But I Don't Want to Maintain That Code"

A common objection: "If I write it myself, I have to maintain it. If I use a library, someone else maintains it."

This is partially true and partially an illusion.

### What "Someone Else Maintains It" Actually Means

- Someone else fixes bugs... maybe. If they're still active.
- Someone else adds features... that you may not want.
- Someone else decides the API... and might change it.
- Someone else's schedule determines your updates.
- Someone else's priorities may not match yours.

### What You're Actually Choosing Between

| Write It Yourself | Use a Library |
|-------------------|---------------|
| You maintain the code | You maintain the integration |
| Bugs are your fault | Bugs are your problem |
| Updates when you choose | Updates when they choose |
| You control the API | You adapt to their API |
| Small, focused scope | Larger, general scope |

You're not avoiding maintenance by using a library. You're trading one type of maintenance for another.

## Counting the Cost

Before adding a dependency, ask:

1. **Do I need this?** Can I solve this another way?
2. **What does it bring in?** How many transitive dependencies?
3. **Who maintains it?** Is this a person, a company, a foundation?
4. **How active is it?** When was the last commit? Last release?
5. **What's the license?** Any implications for my project?
6. **What's my exit plan?** If this disappears, how hard is replacement?

If you can't answer these questions, you're not making an informed decision. You're hoping for the best.

!!! terminal "Same Story, Different Decade"
    I've watched the same cycle for decades. New platform emerges. Developers discover they can easily share code. Package manager makes it frictionless. Everyone shares everything. Dependency counts explode. Eventually something breaks—an abandoned package, a security incident, a licensing dispute—and everyone acts surprised.

    The tools change. The pattern doesn't.

    Dependencies aren't bad. I use them constantly. But I've learned to treat them as decisions, not freebies. Every package I add is code I'm responsible for, whether I wrote it or not. Every package is complexity I'm carrying, vulnerabilities I'm exposed to, maintenance I'm deferring.

    The question isn't whether to use dependencies. It's whether to use them *thoughtlessly*. The developers who avoid the worst outcomes are the ones who pause, for just a moment, before typing `install`.

---

## Key Questions

Before adding a dependency:

- [ ] Do I actually need this?
- [ ] What's the dependency tree look like?
- [ ] Who maintains it? How actively?
- [ ] What's the license?
- [ ] What happens if it disappears?
- [ ] Is there a simpler solution?
