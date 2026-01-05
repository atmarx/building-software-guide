# Further Reading

Resources for deeper exploration beyond this guide.

---

## Books

### Software Engineering

**Software Engineering at Google** — Winters, Manshreck, Wright (O'Reilly, 2020)
Lessons from Google on building and maintaining software at scale. Chapters on dependency management, code review, and testing are particularly relevant.

**Building Secure and Reliable Systems** — Beyer et al. (O'Reilly, 2020)
The Google SRE team on designing systems that are both secure and reliable. Excellent coverage of supply chain security principles.

**The Phoenix Project** — Kim, Behr, Spafford (IT Revolution, 2013)
Novel format introduction to DevOps principles. Good for understanding why CI/CD and automation matter.

**The DevOps Handbook** — Kim et al. (IT Revolution, 2016)
Practical companion to The Phoenix Project. Covers the technical practices in detail.

### Security

**Threat Modeling** — Shostack (Wiley, 2014)
How to think systematically about security threats. Relevant for understanding supply chain attack vectors.

**Security Engineering** — Anderson (Wiley, 3rd ed. 2020)
Comprehensive treatment of security principles. Dense but authoritative.

---

## Standards and Frameworks

### Supply Chain Security

**SLSA (Supply-chain Levels for Software Artifacts)**
Framework for supply chain integrity with graduated assurance levels.
https://slsa.dev/

**NIST Secure Software Development Framework (SSDF)**
NIST SP 800-218. Government standard for secure development practices.
https://csrc.nist.gov/projects/ssdf

**OpenSSF Scorecard**
Automated security health metrics for open source projects.
https://securityscorecards.dev/

**in-toto**
Framework for securing software supply chain integrity.
https://in-toto.io/

### SBOMs

**SPDX Specification**
Linux Foundation standard for software bills of materials.
https://spdx.dev/specifications/

**CycloneDX Specification**
OWASP standard for SBOMs with security focus.
https://cyclonedx.org/specification/

**NTIA SBOM Resources**
US government guidance on SBOM minimum elements.
https://www.ntia.gov/page/software-bill-materials

### Vulnerability Management

**CVE Program**
The canonical vulnerability identification system.
https://www.cve.org/

**CVSS Specification**
How vulnerability severity scores are calculated.
https://www.first.org/cvss/

---

## Organizations

### Open Source Security

**Open Source Security Foundation (OpenSSF)**
Cross-industry collaboration on open source security. Hosts many relevant projects and working groups.
https://openssf.org/

**OWASP (Open Web Application Security Project)**
Application security resources, including dependency-check and CycloneDX.
https://owasp.org/

**Linux Foundation**
Hosts SPDX, OpenSSF, and many critical open source projects.
https://www.linuxfoundation.org/

### Government Resources

**CISA (Cybersecurity and Infrastructure Security Agency)**
US federal agency with software supply chain security guidance.
https://www.cisa.gov/

**NIST Computer Security Resource Center**
Standards and guidelines for security.
https://csrc.nist.gov/

---

## Online Resources

### Blogs and News

**Ars Technica Security**
Good coverage of major security incidents with technical depth.
https://arstechnica.com/security/

**Bleeping Computer**
Security news, often first to report supply chain incidents.
https://www.bleepingcomputer.com/

**Snyk Blog**
Research and analysis on dependency security.
https://snyk.io/blog/

### Research

**OpenSSF Research**
Academic and industry research on open source security.
https://openssf.org/research/

**ACM Digital Library**
Academic papers on software security (paywall, but many authors post preprints).
https://dl.acm.org/

---

## Related Guides

**Open Source Licensing Guide**
Companion guide covering software licensing fundamentals.
[Open Source Licensing Guide](licensing-guide)

---

## Staying Current

Supply chain security evolves rapidly. To stay informed:

1. **Follow OpenSSF** — Major initiatives and research
2. **Subscribe to security advisories** — GitHub, npm, PyPI for your ecosystems
3. **Monitor CISA alerts** — Major vulnerabilities affecting critical infrastructure
4. **Watch for post-mortems** — When incidents happen, read the analyses

The tools and specific vulnerabilities will change. The principles in this guide should remain relevant.
