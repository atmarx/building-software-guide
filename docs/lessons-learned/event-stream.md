# event-stream (2018)

**The Lesson:** Trust doesn't transfer automatically. Maintainer handoffs are security events.

!!! terminal "They Asked Politely"
    The attacker didn't hack anything. They didn't exploit a vulnerability. They sent a polite email offering to help, and they waited. Patience is a weapon.

---

## What Happened

In November 2018, a user noticed something strange in `event-stream`, a popular npm package with two million weekly downloads.[^event-stream-issue] The package had a new dependency called `flatmap-stream` that contained obfuscated code targeting a very specific application: the Copay Bitcoin wallet.

The attack was precise. The malicious code only activated when running in the Copay application. It would harvest wallet credentials and send them to an attacker-controlled server. Anyone else importing `event-stream` saw nothing unusual—the malicious code paths simply never executed.[^event-stream-snyk]

The package's original author, Dominic Tarr, had handed off maintenance months earlier to a helpful stranger. That stranger had been waiting.

## The Attack

`event-stream` was a utility for working with Node.js streams. Tarr had created it years earlier, and like many open source maintainers, he'd moved on. The package worked. It didn't need active development. But npm packages need *someone* with publish rights.

In September 2018, a user named "right9ctrl" approached Tarr, offering to help maintain the package. Tarr, like many burned-out maintainers, was happy to hand it off. He gave right9ctrl publish access.[^tarr-statement]

Right9ctrl's first action was adding a new dependency: `flatmap-stream`, a package they also controlled. This dependency contained the malicious payload, AES-encrypted and targeted specifically at Copay.

The attack remained hidden for two months. When discovered, the malicious code had already been downloaded millions of times—though only Copay users were actually affected.

## Why It Mattered

This incident revealed a new attack pattern: **social engineering maintainers, not code**.

The code review processes that organizations rely on assume that packages come from trusted sources. But what happens when the trusted source changes? npm showed the package author as "event-stream maintainers"—the same as always. Nothing indicated that a new person was pushing code.

**Maintainer burnout is exploitable.** Tarr wasn't negligent. He was doing what open source maintainers do constantly: trying to find someone to take over projects they no longer have time for. The attacker exploited that pattern.

**Targeted attacks hide in broad distribution.** The malicious code was downloaded by everyone using `event-stream`, but it only executed in one specific context. This meant the vast majority of affected builds showed no symptoms. Traditional testing wouldn't catch it—your tests don't run the Copay code paths.

**Transitive dependencies multiply risk.** Most of the two million weekly downloads were indirect. Developers who'd never heard of `event-stream` were pulling it in through other packages. They had no reason to notice a new dependency being added to a package they didn't know they used.

## The Response

Once discovered, npm removed the malicious versions. Copay issued patches. The `flatmap-stream` package was unpublished.

But the harder question remained: how do you prevent this?

The uncomfortable answer is that you can't, entirely. Open source maintainer transitions happen constantly. There's no registry of "legitimate" maintainers. No verification that the person taking over a project has good intentions. The system runs on trust.

What you *can* do is:

- **Pin dependencies** so malicious updates don't automatically flow into your builds
- **Review lock file changes** to notice when new transitive dependencies appear
- **Use SBOMs and scanning** to know what you're running
- **Monitor for anomalous behavior** in your applications

## What Changed

The event-stream incident sparked several changes:

**npm added security features.** Two-factor authentication became more prominent. npm began requiring 2FA for packages with high download counts.

**Dependency scanning tools improved.** Tools began flagging maintainer changes and new dependencies as potential signals, not just known vulnerabilities.

**The conversation about sustainability grew louder.** Tarr's candid admission—"I don't get anything from maintaining this module"[^tarr-statement]—put a human face on the maintainer burnout problem. Organizations started asking harder questions about who maintains the software they depend on.

!!! terminal "Given the Keys"
    I can't blame Tarr. I've done exactly what he did, more times than I can count. Someone offers to help with a project you no longer have time for. You're grateful. You give them access. What's the alternative—keep ignoring pull requests until the project dies?

    The system assumes maintainers will vet their successors carefully. But maintainers are volunteers, often burned out, often maintaining dozens of packages. They're not security teams. They're people trying to be helpful. The attacker understood this perfectly. They didn't hack anything. They asked politely. And they waited.

    The lesson isn't "don't trust anyone." The lesson is: **maintainer transitions are security events**. They should be noticed, logged, and considered in your risk assessment. When the person controlling a package changes, your trust model should update.

    But right now, most organizations have no idea who maintains their dependencies, let alone when that changes. We're trusting by default, and attackers know it.

---

## Timeline

| Date | Event |
|------|-------|
| September 2018 | right9ctrl gains publish access to event-stream |
| September 2018 | flatmap-stream dependency added |
| October 2018 | Versions 3.3.6 and 4.x published with malicious code |
| November 20, 2018 | Malicious code discovered; GitHub issue opened |
| November 2018 | npm removes malicious versions |

---

[^event-stream-issue]: Various contributors. "I don't know what to say." GitHub issue #116, event-stream repository. November 2018. https://github.com/dominictarr/event-stream/issues/116

[^event-stream-snyk]: See [event-stream Incident](../reference/sources.md#event-stream)

[^tarr-statement]: Tarr, Dominic. Comment on GitHub issue #116. November 2018. "I don't get anything mass open source mass ... mass mass mass mass mass mass mass maintaining this mass mass mass mass mass mass module."
