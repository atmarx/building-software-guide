# SolarWinds (2020)

**The Lesson:** Build systems are high-value targets. Signed artifacts can still be malicious if the build is compromised.

!!! terminal "The Update You Trusted"
    They didn't break in through your firewall. They came in through the update you installed—signed, verified, from your trusted vendor. The signature was real. The malware was too. That's what makes supply chain attacks terrifying.

---

## What Happened

In December 2020, cybersecurity firm FireEye disclosed that they had been breached by a sophisticated attacker who had stolen their red team tools. The investigation revealed something larger: the attackers had compromised SolarWinds, an IT management software company whose Orion platform was used by 33,000 organizations worldwide.[^solarwinds-cisa]

The attackers hadn't broken into SolarWinds' customers directly. They had compromised SolarWinds' build system, inserting malicious code into the Orion software updates. When customers installed what appeared to be legitimate, signed updates from their trusted vendor, they were installing a backdoor.[^solarwinds-fireeye]

The attack had been active for at least nine months before discovery. Approximately 18,000 organizations had installed the compromised updates. The victims included:

- U.S. Treasury Department
- U.S. Department of Commerce
- U.S. Department of Homeland Security
- Multiple Fortune 500 companies
- Cybersecurity firms

## The Attack

The attackers—later attributed to Russia's SVR intelligence service by U.S. government agencies[^solarwinds-attribution]—demonstrated remarkable patience and sophistication:

**Build system compromise:** Rather than modifying source code (which would be visible in version control), the attackers modified the build process itself. Malicious code was inserted during compilation, producing backdoored binaries from clean source code.

**Legitimate signatures:** Because the malicious code was inserted during the official build, the resulting binaries were signed with SolarWinds' legitimate code-signing certificates. To customers, they appeared authentic—because, from a signing perspective, they were.

**Targeted activation:** The backdoor (dubbed SUNBURST) didn't activate immediately or universally. It waited weeks before beaconing, checked for security tools that might detect it, and only activated on targets the attackers found interesting. Most of the 18,000 compromised organizations never saw active exploitation.

**Supply chain leverage:** By compromising one vendor, the attackers gained potential access to thousands of targets. The efficiency was remarkable: one intrusion, one modified build, 18,000 backdoors.

## Why It Mattered

SolarWinds demonstrated that supply chain attacks work at nation-state scale against nation-state targets.

**Code signing isn't enough.** Organizations trusted the SolarWinds updates because they were signed. But signing only verifies that code came from a claimed source—it says nothing about whether that source has been compromised.

**Vendor trust is transitive.** When you install software from a vendor, you're trusting their entire software development lifecycle: their source control, their build systems, their employee access controls, their network security. A weakness anywhere in that chain can become your weakness.

**Detection is hard.** The backdoor was designed to evade detection. It used common network protocols, mimicked legitimate SolarWinds traffic, and only activated selectively. Traditional security tools had trouble distinguishing it from normal Orion behavior.

**Dwell time was long.** The attack began in October 2019. It wasn't discovered until December 2020. For over a year, attackers had potential access to thousands of networks—and nobody knew.

## The Response

The U.S. government treated SolarWinds as a major national security incident:

- CISA issued Emergency Directive 21-01, requiring federal agencies to disconnect affected SolarWinds products
- Multiple investigations were launched
- The incident was cited as a key motivation for Executive Order 14028 on improving the nation's cybersecurity[^eo-14028]

SolarWinds itself faced significant consequences:

- Stock price dropped substantially
- Multiple lawsuits filed
- The company undertook extensive remediation of their build process

## What Changed

SolarWinds accelerated supply chain security from a niche concern to a mainstream priority:

**SLSA framework development.** Google and others accelerated work on SLSA (Supply-chain Levels for Software Artifacts), a framework for verifying software supply chain integrity beyond just code signing.[^slsa]

**Build system hardening.** Organizations began treating build infrastructure as high-value targets requiring the same protection as production systems. Air-gapped builds, immutable build environments, and reproducible builds gained attention.

**SBOM requirements.** Executive Order 14028 mandated SBOM requirements for software sold to the federal government, creating regulatory pressure for supply chain transparency.[^eo-14028]

**Zero trust architecture.** The assumption that signed software from trusted vendors is safe was directly challenged. Organizations began implementing zero trust principles that don't assume any source is inherently trustworthy.

!!! terminal "It Got Real"
    I remember when supply chain attacks were theoretical. Conference talks would describe them, and audiences would nod thoughtfully, then go back to worrying about SQL injection and phishing.

    SolarWinds made supply chain attacks real in a way nothing else had. Not because they're new—they're not—but because the scale and sophistication were undeniable. Nation-state actors, critical infrastructure, a year of undetected access.

    The uncomfortable truth is that most organizations can't defend against a SolarWinds-level attack. They don't have the resources to verify every update from every vendor. They trust their vendors because the alternative is trusting nobody, which means building everything themselves.

    What you *can* do is: know your software supply chain, segment and monitor even trusted software, demand transparency from vendors, and plan for compromise. Assume that something in your supply chain is already compromised. What would you do?

    The attackers are patient. They're funded. They're good at this. The least we can do is make it harder.

---

## Timeline

| Date | Event |
|------|-------|
| October 2019 | Attackers gain access to SolarWinds build system |
| February 2020 | First backdoored Orion updates distributed |
| March 2020 | Backdoored updates continue through at least June |
| December 8, 2020 | FireEye discloses breach of their own systems |
| December 13, 2020 | SolarWinds compromise publicly disclosed |
| December 13, 2020 | CISA issues Emergency Directive 21-01 |
| December 2020 | Investigation reveals scope of compromise |
| May 2021 | Executive Order 14028 signed |

---

[^solarwinds-cisa]: See [SolarWinds Attack](../reference/sources.md#solarwinds)

[^solarwinds-fireeye]: FireEye. "Highly Evasive Attacker Leverages SolarWinds Supply Chain to Compromise Multiple Global Victims With SUNBURST Backdoor." December 2020.

[^solarwinds-attribution]: U.S. Government. Joint statement attributing SolarWinds attack to Russian SVR. April 2021.

[^eo-14028]: See [Executive Order 14028](../reference/sources.md#eo-14028)

[^slsa]: See [SLSA Framework](../reference/sources.md#slsa)
