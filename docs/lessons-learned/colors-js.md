# colors.js (2022)

**The Lesson:** Maintainers are people with grievances. "Trusted" packages can become hostile.

!!! terminal "People, Not Code"
    Software is written by people. People get tired, frustrated, burned out. People sometimes act out. Your supply chain isn't just code—it's all the humans behind that code, with everything that implies.

---

## What Happened

On January 8, 2022, users of `colors` and `faker`—two widely-used npm packages—started seeing strange behavior. Instead of their expected output, applications were printing "LIBERTY LIBERTY LIBERTY" followed by gibberish, then hanging in an infinite loop.[^colors-bleeping]

This wasn't an attack by an outside party. It was deliberate sabotage by the packages' own maintainer, Marak Squires.

Squires had grown frustrated. His packages were downloaded hundreds of millions of times, used by Fortune 500 companies, embedded in critical infrastructure. He wasn't getting paid. In a GitHub issue the previous year, he'd written: "Respectfully, I am no longer going to support Fortune 500s (and other smaller sized companies) with my free work."[^marak-github]

The January update was his follow-through.

## The Attack

Unlike event-stream or xz, this wasn't a sophisticated targeted attack. It was a maintainer using his legitimate access to publish broken code.

The `colors` package (terminal color formatting, 20+ million weekly downloads) received version 1.4.1, which included an infinite loop. The `faker` package (fake data generation, 2+ million weekly downloads) received version 6.6.6, which deleted most of its functionality.

Anyone running `npm install` with loose version constraints—and that was most people—automatically pulled the corrupted versions. CI pipelines failed. Applications crashed. Developers scrambled to pin versions and wait for fixes.

## Why It Happened

Squires had been vocal about open source sustainability for years. His packages were everywhere, but his income was minimal. Companies were profiting from his work while he struggled.

In his view, he was providing free labor to corporations that could easily afford to pay. When they didn't, he decided to make a point.

Whether you sympathize with his grievance or not, the incident demonstrated a real vulnerability: **the person who maintains a package controls what it does**. That's obvious in hindsight. But most developers don't think about it until something goes wrong.

## Why It Mattered

This incident was different from others in an important way: **there was no outside attacker**. The threat came from inside the trust boundary.

**Maintainers can go hostile.** Open source licenses give maintainers significant latitude. They can publish broken code, inject protests, or simply abandon the project. The license doesn't require them to be good stewards.

**Automation amplifies damage.** Loose version constraints (`^1.0.0` instead of `1.0.0`) meant the malicious update flowed automatically into projects. Developers didn't choose to upgrade—their build systems did it for them.

**There's no effective recourse.** npm could (and did) revert the packages, but they couldn't prevent Squires from publishing. He had legitimate access. The packages were his to do with as he pleased—at least until npm's terms of service caught up.

## The Response

npm acted quickly, reverting the packages to pre-sabotage versions and suspending Squires' account.[^colors-npm-response]

But the incident left uncomfortable questions:

- How do you prevent a legitimate maintainer from sabotaging their own package?
- Should package managers have the right to override authors?
- What obligations do companies have to support the open source they depend on?

None of these questions have clean answers.

## What Changed

The colors.js incident accelerated several trends:

**Pin your dependencies.** The advice had always been there, but it gained urgency. If you're not controlling which versions flow into your builds, you're trusting every maintainer in your dependency tree to behave responsibly, forever.

**Discussions about funding intensified.** GitHub Sponsors, Open Collective, and Tidelift saw increased interest. Companies started (slowly) recognizing that free-riding on open source has costs.

**Package manager policies evolved.** npm clarified its terms of service around intentionally malicious behavior. The line between "my code, my choice" and "sabotaging dependents" became a subject of policy discussion.

**Some sympathy, some condemnation.** The open source community was divided. Some saw Squires as a burned-out maintainer making a legitimate protest. Others saw him as violating the implicit contract of open source. The debate continues.

!!! terminal "Norms Aren't Enforceable"
    I've felt what Squires felt. Not the acting-out part—but the frustration of watching your work used by companies that could write you a check without noticing the expense, and don't.

    Open source runs on norms. Maintainers publish good code because that's what maintainers do. Companies use it because it's there. The system works remarkably well most of the time, because most people follow the norms.

    But norms aren't enforceable. When someone decides to stop following them—whether out of malice, frustration, or protest—the system has few defenses. You can revert the package, ban the user, write new policies. But you can't make someone care about your build pipeline.

    The lesson isn't that Squires was right or wrong. It's that **your dependencies are maintained by people**, with all the unpredictability that implies. If your business depends on software that a single frustrated person can break, that's a risk you're carrying. Pin your versions. Know your critical dependencies. And maybe—just maybe—find a way to support the people who maintain them.

---

## Timeline

| Date | Event |
|------|-------|
| November 2020 | Squires posts about withdrawing free support for companies |
| January 8, 2022 | colors 1.4.1 and faker 6.6.6 published with sabotage |
| January 8, 2022 | Reports of broken builds begin |
| January 9, 2022 | npm reverts packages; Squires' account suspended |

---

[^colors-bleeping]: See [colors.js Incident](../reference/sources.md#colors-js)

[^marak-github]: Squires, Marak. "No more free work from Marak." GitHub issue, faker.js repository. November 2020.

[^colors-npm-response]: npm. Account suspension and package reversion. January 2022.
