# Tools

Reference guide to tools for dependency management, security scanning, and supply chain hygiene. This isn't exhaustive—it covers commonly used, well-maintained options.

---

## Dependency Analysis

Tools for understanding what's in your dependency tree.

### By Ecosystem

| Ecosystem | Built-in | Third-party |
|-----------|----------|-------------|
| npm | `npm ls`, `npm explain` | — |
| Python | `pip show`, `pip list` | `pipdeptree`, `pip-tools` |
| Go | `go mod graph`, `go mod why` | — |
| Rust | `cargo tree` | — |
| Ruby | `bundle list`, `bundle viz` | — |

### Cross-Ecosystem

**Syft** — Generates SBOMs and dependency inventories for containers, filesystems, and archives. Supports many ecosystems.
https://github.com/anchore/syft

**dep-scan** — Dependency analysis and audit tool. Supports multiple ecosystems.
https://github.com/owasp-dep-scan/dep-scan

---

## SBOM Generation

Tools for creating Software Bills of Materials.

| Tool | Formats | Notes |
|------|---------|-------|
| **Syft** | SPDX, CycloneDX | Multi-ecosystem, container-aware |
| **Trivy** | SPDX, CycloneDX | Also does vulnerability scanning |
| **CycloneDX CLI** | CycloneDX | Official CycloneDX tooling |
| **SPDX tools** | SPDX | Official SPDX tooling |
| **npm sbom** | SPDX, CycloneDX | Built into npm 9+ |

### SBOM Formats

**SPDX** (Software Package Data Exchange) — Linux Foundation standard, ISO/IEC 5962:2021. Strong license information support.
https://spdx.dev/

**CycloneDX** — OWASP standard. Security-focused, supports vulnerabilities and services.
https://cyclonedx.org/

---

## Vulnerability Scanning

Tools for finding known vulnerabilities in dependencies.

### Open Source

| Tool | Type | Notes |
|------|------|-------|
| **Grype** | CLI scanner | Fast, container-aware, pairs with Syft |
| **Trivy** | CLI scanner | Multi-purpose: vulns, secrets, misconfig |
| **OSV-Scanner** | CLI scanner | Uses OSV database, Google-maintained |
| **npm audit** | Built-in | npm ecosystem only |
| **pip-audit** | CLI tool | Python ecosystem only |
| **cargo audit** | CLI tool | Rust ecosystem only |

**Grype** — https://github.com/anchore/grype
**Trivy** — https://trivy.dev/
**OSV-Scanner** — https://github.com/google/osv-scanner

### Commercial (Free Tiers Available)

| Tool | Notes |
|------|-------|
| **Snyk** | SCA, container, IaC scanning. Free tier generous. |
| **Dependabot** | GitHub-integrated, automatic PRs |
| **Renovate** | Like Dependabot, more configurable |
| **FOSSA** | License + vulnerability scanning |
| **Mend (WhiteSource)** | Enterprise SCA |

---

## Container Security

Tools for securing container images.

| Tool | Purpose |
|------|---------|
| **Trivy** | Vulnerability scanning for images |
| **Grype** | Vulnerability scanning for images |
| **Docker Scout** | Docker's built-in scanning |
| **Hadolint** | Dockerfile linting |
| **Dockle** | Container image linting |
| **cosign** | Container signing (Sigstore) |

**Hadolint** — https://github.com/hadolint/hadolint
**Dockle** — https://github.com/goodwithtech/dockle
**cosign** — https://github.com/sigstore/cosign

---

## Artifact Signing

Tools for signing and verifying software artifacts.

| Tool | Type | Notes |
|------|------|-------|
| **Sigstore/cosign** | Keyless signing | Modern, supports containers and blobs |
| **GPG** | Traditional | Widely supported, key management overhead |
| **Notation** | OCI signing | CNCF project, container-focused |

**Sigstore** — https://www.sigstore.dev/

---

## Lock File Management

Tools for managing dependency lock files.

### Python

| Tool | Lock File | Notes |
|------|-----------|-------|
| **pip-tools** | requirements.txt | `pip-compile` generates locked requirements |
| **Poetry** | poetry.lock | Full dependency management |
| **uv** | uv.lock | Fast, modern, Rust-based |
| **PDM** | pdm.lock | PEP 582 support |

**uv** — https://github.com/astral-sh/uv
**Poetry** — https://python-poetry.org/
**pip-tools** — https://github.com/jazzband/pip-tools

### Node.js

| Tool | Lock File | Notes |
|------|-----------|-------|
| **npm** | package-lock.json | Default |
| **yarn** | yarn.lock | Alternative package manager |
| **pnpm** | pnpm-lock.yaml | Efficient disk usage |

---

## Reproducibility

Tools for reproducible builds and environments.

| Tool | Purpose |
|------|---------|
| **mise** (formerly rtx) | Tool version management |
| **asdf** | Tool version management |
| **Nix** | Reproducible builds and environments |
| **Docker** | Environment containerization |
| **devcontainers** | VS Code development containers |

**mise** — https://mise.jdx.dev/
**asdf** — https://asdf-vm.com/
**Nix** — https://nixos.org/

---

## Vulnerability Databases

Where vulnerability information comes from.

| Database | Scope | URL |
|----------|-------|-----|
| **CVE** | All | https://www.cve.org/ |
| **NVD** | All (enriched) | https://nvd.nist.gov/ |
| **GitHub Advisory** | All | https://github.com/advisories |
| **OSV** | All | https://osv.dev/ |
| **npm Advisories** | npm | https://www.npmjs.com/advisories |
| **PyPI Advisory** | Python | https://github.com/pypa/advisory-database |
| **RustSec** | Rust | https://rustsec.org/ |
| **Go Vuln DB** | Go | https://vuln.go.dev/ |

---

## Security Frameworks and Standards

Reference materials for security practices.

| Resource | Purpose |
|----------|---------|
| **SLSA** | Supply chain integrity framework |
| **OpenSSF Scorecard** | Project security health metrics |
| **NIST SSDF** | Secure development framework |
| **OWASP** | Application security resources |

**SLSA** — https://slsa.dev/
**OpenSSF Scorecard** — https://securityscorecards.dev/
**NIST SSDF** — https://csrc.nist.gov/projects/ssdf
