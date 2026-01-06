# Glossary

Terms used throughout this guide. Most of these also appear as tooltips when you hover over them in the text.

!!! terminal "Say What You Mean"
    I've sat through too many meetings where people used the same words to mean different things. "We need to update the dependencies"—which ones? "There's a vulnerability"—in what? Jargon can illuminate or obscure. This is what these terms mean when I use them.

---

## A

### Artifact
A file produced by a build process—a compiled binary, a packaged library, a container image. Artifacts are what you deploy or distribute.

## B

### Bronze/Silver/Gold (Medallion Architecture)
A data lake pattern where data progresses through quality tiers: bronze (raw ingestion), silver (cleaned and validated), gold (refined and ready for analysis). Used to separate concerns and protect data quality.

### Bus Factor
The minimum number of people who would need to be unavailable (hit by a bus, quit, etc.) before a project can no longer be maintained. A bus factor of 1 is a significant risk.

## C

### CI/CD (Continuous Integration/Continuous Deployment)
Automated pipelines that build, test, and deploy code on every change. CI ensures code integrates correctly; CD automates deployment.

### CVE (Common Vulnerabilities and Exposures)
A standardized identifier for security vulnerabilities. Format: CVE-YEAR-NUMBER (e.g., CVE-2021-44228 for log4shell).

### CVSS (Common Vulnerability Scoring System)
A standardized way to rate vulnerability severity on a 0-10 scale. Critical (9.0-10.0), High (7.0-8.9), Medium (4.0-6.9), Low (0.1-3.9).

## D

### Data Lake
A storage repository holding large amounts of raw data in native format until needed for analysis. Contrasted with data warehouses, which store structured, processed data.

### Dependency Confusion
An attack where internal package names match public registry names, causing build systems to fetch malicious public packages instead of legitimate internal ones.

### Direct Dependency
A package you explicitly install or declare. Contrasted with transitive dependencies.

## I

### IaC (Infrastructure as Code)
Managing infrastructure through version-controlled configuration files rather than manual processes. Tools include Terraform, Pulumi, and Ansible.

## L

### Lock File
A file recording the exact resolved versions of all dependencies (direct and transitive) at a point in time. Enables reproducible installations. Examples: package-lock.json, poetry.lock, Cargo.lock.

## M

### Medallion Architecture
See Bronze/Silver/Gold.

## N

### NVD (National Vulnerability Database)
NIST's database of vulnerabilities, enriched with CVSS scores and affected version information. Built on CVE data.

## P

### PHI (Protected Health Information)
Health data covered by HIPAA regulations. Requires specific handling, storage, and access controls.

### PII (Personally Identifiable Information)
Data that can identify an individual—names, addresses, social security numbers, etc. Subject to various privacy regulations.

## R

### RCE (Remote Code Execution)
A vulnerability class where attackers can execute arbitrary code on a target system remotely. Among the most severe vulnerability types.

## S

### SBOM (Software Bill of Materials)
A complete inventory of components in software—dependencies, versions, licenses. Like a nutrition label for code.

### SCA (Software Composition Analysis)
Tools that analyze codebases to identify components, their versions, and known vulnerabilities. Examples: Snyk, Grype, Trivy.

### Semver (Semantic Versioning)
A versioning scheme using MAJOR.MINOR.PATCH format. MAJOR = breaking changes, MINOR = new features (backwards compatible), PATCH = bug fixes.

### SLSA (Supply-chain Levels for Software Artifacts)
A framework for supply chain integrity with graduated levels (1-4) of assurance. Pronounced "salsa."

## T

### Transitive Dependency
A dependency of your dependency. Packages you didn't install directly but inherit through your direct dependencies. Often invisible but carry the same risks.

### Typosquatting
Registering package names similar to popular packages (e.g., `1odash` vs `lodash`) to trick users into installing malicious code.

## V

### Vendoring
Copying dependency source code directly into your project rather than fetching from a registry. Provides complete control but requires manual maintenance.

---

## Adding Terms

This glossary covers terms specific to this guide. For licensing terminology, see the [Open Source Licensing Guide](https://libre.xram.net) glossary.
