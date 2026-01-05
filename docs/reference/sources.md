# Sources

This page collects citations referenced throughout the guide. Entries are organized alphabetically and include links to primary sources where available.

---

## A

### Alex Birsan Dependency Confusion Research
<!-- slug: birsan-dependency-confusion -->
Birsan, Alex. "Dependency Confusion: How I Hacked Into Apple, Microsoft and Dozens of Other Companies." February 2021.
https://medium.com/@alex.birsan/dependency-confusion-4a5d60fec610

## C

### CISA Software Supply Chain Security Guidance
<!-- slug: cisa-supply-chain -->
Cybersecurity and Infrastructure Security Agency. "Defending Against Software Supply Chain Attacks." April 2021.
https://www.cisa.gov/sites/default/files/publications/defending_against_software_supply_chain_attacks_508_1.pdf

### colors.js Incident
<!-- slug: colors-js -->
Sharma, Ax. "Dev corrupts NPM libs 'colors' and 'faker' breaking thousands of apps." Bleeping Computer. January 2022.
https://www.bleepingcomputer.com/news/security/dev-corrupts-npm-libs-colors-and-faker-breaking-thousands-of-apps/

### CVE Program
<!-- slug: cve-program -->
MITRE Corporation. "Common Vulnerabilities and Exposures."
https://www.cve.org/

### CycloneDX Specification
<!-- slug: cyclonedx -->
OWASP Foundation. "CycloneDX Software Bill of Materials Standard."
https://cyclonedx.org/

## E

### event-stream Incident
<!-- slug: event-stream -->
Sharma, Ax. "Widely used open source software contained bitcoin-stealing backdoor." Ars Technica. November 2018.
https://arstechnica.com/information-technology/2018/11/hacker-backdoors-widely-used-open-source-software-to-steal-bitcoin/

### Executive Order 14028
<!-- slug: eo-14028 -->
The White House. "Executive Order on Improving the Nation's Cybersecurity." May 2021.
https://www.whitehouse.gov/briefing-room/presidential-actions/2021/05/12/executive-order-on-improving-the-nations-cybersecurity/

## G

### GitHub Advisory Database
<!-- slug: github-advisories -->
GitHub. "GitHub Advisory Database."
https://github.com/advisories

## L

### left-pad Incident
<!-- slug: left-pad -->
Williams, Chris. "How one developer just broke Node, Babel and thousands of projects in 11 lines of JavaScript." The Register. March 2016.
https://www.theregister.com/2016/03/23/npm_left_pad_chaos/

### log4shell Vulnerability
<!-- slug: log4shell -->
NIST. "CVE-2021-44228 Detail." National Vulnerability Database. December 2021.
https://nvd.nist.gov/vuln/detail/CVE-2021-44228

### log4shell CISA Advisory
<!-- slug: log4shell-cisa -->
CISA. "Apache Log4j Vulnerability Guidance." December 2021.
https://www.cisa.gov/news-events/news/apache-log4j-vulnerability-guidance

## N

### NIST Secure Software Development Framework
<!-- slug: nist-ssdf -->
NIST. "Secure Software Development Framework (SSDF) Version 1.1." February 2022.
https://csrc.nist.gov/publications/detail/sp/800-218/final

### National Vulnerability Database
<!-- slug: nvd -->
NIST. "National Vulnerability Database."
https://nvd.nist.gov/

## O

### OpenSSF Scorecard
<!-- slug: openssf-scorecard -->
Open Source Security Foundation. "Scorecard: Security Health Metrics for Open Source."
https://securityscorecards.dev/

### OWASP Dependency-Check
<!-- slug: owasp-dependency-check -->
OWASP Foundation. "OWASP Dependency-Check."
https://owasp.org/www-project-dependency-check/

## S

### Semantic Versioning Specification
<!-- slug: semver -->
Preston-Werner, Tom. "Semantic Versioning 2.0.0."
https://semver.org/

### Sigstore
<!-- slug: sigstore -->
Sigstore Project. "Sigstore: A new standard for signing, verifying and protecting software."
https://www.sigstore.dev/

### SLSA Framework
<!-- slug: slsa -->
SLSA Project. "Supply-chain Levels for Software Artifacts."
https://slsa.dev/

### SolarWinds Attack
<!-- slug: solarwinds -->
CISA. "Advanced Persistent Threat Compromise of Government Agencies, Critical Infrastructure, and Private Sector Organizations." December 2020.
https://www.cisa.gov/news-events/cybersecurity-advisories/aa20-352a

### SPDX Specification
<!-- slug: spdx -->
Linux Foundation. "Software Package Data Exchange (SPDX)."
https://spdx.dev/

## T

### Trivy Scanner
<!-- slug: trivy -->
Aqua Security. "Trivy: Find vulnerabilities, misconfigurations, secrets, SBOM in containers, Kubernetes, code repositories, clouds and more."
https://trivy.dev/

### Typosquatting Research
<!-- slug: typosquatting-research -->
Vu, Duc-Ly et al. "Typosquatting and Combosquatting Attacks on the Python Ecosystem." IEEE European Symposium on Security and Privacy. 2020.
https://ieeexplore.ieee.org/document/9230387

## U

### ua-parser-js Incident
<!-- slug: ua-parser-js -->
Sharma, Ax. "Popular NPM package UA-Parser-JS poisoned with cryptominer, password stealer." Bleeping Computer. October 2021.
https://www.bleepingcomputer.com/news/security/popular-npm-package-ua-parser-js-poisoned-with-cryptominer-password-stealer/

## X

### xz Utils Backdoor
<!-- slug: xz-utils -->
Freund, Andres. "Backdoor in upstream xz/liblzma leading to ssh server compromise." oss-security mailing list. March 2024.
https://www.openwall.com/lists/oss-security/2024/03/29/4

### xz Utils Backdoor Analysis
<!-- slug: xz-utils-analysis -->
Goodin, Dan. "What we know about the xz Utils backdoor that almost infected the world." Ars Technica. April 2024.
https://arstechnica.com/security/2024/04/what-we-know-about-the-xz-utils-backdoor-that-almost-infected-the-world/

---

## Adding Sources

When adding new sources to this page:

1. Place entries alphabetically by first letter
2. Use descriptive headers in Title Case
3. Include HTML comment with slug for linking: `<!-- slug: example-slug -->`
4. Provide author, title, publication/organization, and date where available
5. Include URL to primary source

To cite a source in other pages, use footnotes:

```markdown
The incident affected thousands of projects.[^left-pad]

[^left-pad]: See [left-pad Incident](../reference/sources.md#left-pad-incident)
```
