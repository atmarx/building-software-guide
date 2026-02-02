# Notepad++ (2025)

**The Lesson:** Your update infrastructure is part of your supply chain. A compromised update server can turn trusted software into a weapon—even if your code is pristine.

!!! terminal "The Update That Wasn't"
    I've been telling people for years: the code isn't the only attack surface. The build server. The hosting provider. The update mechanism. Every piece of infrastructure that sits between your code and your users is a potential point of compromise. Notepad++ learned this the hard way—six months of malicious updates, and the application code was never touched.

---

## What Happened

Between June and December 2025, attackers compromised the shared hosting infrastructure where Notepad++ was hosted. They didn't need to modify the source code or inject malicious commits. Instead, they targeted the update mechanism itself—specifically, the `getDownloadUrl.php` script that tells the application where to download updates from.

By manipulating this script, attackers could selectively redirect certain users to their own servers, serving malicious binaries instead of legitimate Notepad++ updates. The attack was "highly selective"—not a broad supply chain compromise, but targeted redirection of specific users. Security researchers attributed the operation to a likely Chinese state-sponsored group.[^npp-cyber]

## The Timeline

| Date | Event |
|------|-------|
| June 2025 | Attackers compromise shared hosting infrastructure |
| June – November 2025 | Selective redirection of targeted users to malicious servers |
| September 2, 2025 | Provider maintenance severs direct server access |
| September – December 2025 | Attackers maintain persistence via stolen credentials |
| November 10, 2025 | Active campaign appears to cease |
| December 2, 2025 | Hosting provider rotates credentials, blocking access |
| December 9, 2025 | Notepad++ v8.8.9 released with hardened verification |

## Why It Worked

The attack succeeded because of several compounding factors:

**Shared hosting is shared risk.** Notepad++ was hosted on a shared server. When attackers compromised that infrastructure, they gained access to everything on it—including the update mechanism. The application's own security posture was irrelevant; the infrastructure underneath was the weak point.

**Update mechanisms are trusted by design.** When your application checks for updates, it trusts what the server tells it. The WinGUp updater used by older Notepad++ versions lacked strict certificate and signature validation. It asked "is there an update?" and believed whatever answer it received.

**Selective targeting evades detection.** This wasn't a spray-and-pray attack. By targeting specific users rather than everyone, the attackers reduced the chance of detection. Mass compromise creates mass complaints; surgical strikes stay quiet longer.

**Credentials outlive access.** Even after the hosting provider performed maintenance that severed direct server access, the attackers maintained persistence through stolen credentials. Access revocation is only effective if you revoke *all* the access.

## The Fix

Notepad++ responded with layered defenses:

**Version 8.8.9** (December 2025):

- Mandatory digital signature verification for all downloaded installers
- Certificate matching requirements—downloads must be signed by the expected certificate
- Automatic abort if verification fails

**Version 8.9.2** (planned):

- XMLDSig standard enforcement for update manifests
- Cryptographic signing of the XML data returned by update servers
- Validates not just the binary, but the instructions for where to get it

The key insight: it's not enough to verify what you download. You need to verify the *instructions* telling you where to download from.

## The Broader Pattern

This attack fits a pattern we've seen before:

- **[SolarWinds](solarwinds.md)** (2020): Build infrastructure compromised, malicious updates pushed to 18,000 organizations
- **[Event-Stream](event-stream.md)** (2018): Package maintainer handed off control, new maintainer injected malicious code
- **[Codecov](https://about.codecov.io/security-update/)** (2021): CI/CD script modified to exfiltrate credentials

The code can be perfect. The tests can pass. The reviews can be thorough. None of that matters if the attacker controls the infrastructure that delivers your software to users.

## What We Can Learn

**Sign everything, verify everything.** Code signing isn't optional. And verification must be strict—not "check if a signature exists" but "check if this specific trusted signature matches." See [Security Practices](../security/security-practices.md) for implementation guidance.

**Update manifests need integrity too.** Signing your binaries doesn't help if attackers can modify the manifest that points to those binaries. Sign the manifest. Verify the manifest. Trust nothing unsigned. This is part of securing [your software supply chain](../security/supply-chain.md).

**Shared infrastructure is shared risk.** If you're on shared hosting, you inherit the security posture of that hosting. For critical software distribution, dedicated infrastructure may be worth the cost. Understanding your [build environment](../concepts/build-environment.md) means understanding what you're trusting.

**Monitor your own updates.** Would you notice if your update server started serving different files to certain users? If you're not monitoring the integrity of what your infrastructure serves, you're trusting that no one else has access. [Vulnerability management](../security/vulnerability-management.md) isn't just about dependencies—it's about your own infrastructure too.

**Credential rotation isn't optional.** The attackers maintained access for months after losing direct server access because credentials weren't rotated. Regular rotation limits the blast radius of any single compromise. See [Secrets Management](../security/secrets-management.md).

!!! terminal "The Invisible Infrastructure"
    I've used Notepad++ for decades—whenever I have to touch a Windows box, anyway. I try not to make a habit of it, but good sysadmins know it's not the OS that matters; it's what you've made it do. And every time, I just clicked "yes" when the update prompt appeared. Never thought twice. That's the thing about infrastructure: when it works, you don't see it. When it's compromised, you still don't see it.

    The attackers here were patient and precise. They didn't need to break the code; they just needed to control where the code came from. That's the lesson I keep coming back to: your software is only as trustworthy as the least secure piece of infrastructure between you and your users. For six months, that infrastructure was serving poison to selected targets, and nobody noticed.

    Sign your manifests. Verify your updates. And maybe, every once in a while, think about what happens when you click "yes."

---

## Key Takeaways

- [x] Update infrastructure is part of your supply chain attack surface
- [x] Code signing must be mandatory and strictly verified
- [x] Update manifests need cryptographic integrity, not just the binaries
- [x] Selective/targeted attacks are harder to detect than mass compromise
- [x] Shared hosting means shared risk

[^npp-cyber]: See [Notepad++ Update Infrastructure Compromise](../reference/sources.md#notepadplusplus)
