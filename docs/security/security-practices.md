# Supply Chain Security Practices

Knowing the threats isn't enough. This chapter covers the practical habits that reduce risk over time—dependency updates, artifact signing, and the security practices that become second nature.

---

## Dependency Update Strategies

Updates are a double-edged sword: stale dependencies accumulate vulnerabilities, but updates can break things. You need a strategy.

### Update Cadence

| Update Type | Frequency | Approach |
|-------------|-----------|----------|
| **Security patches** | Immediately | Prioritize over everything |
| **Patch versions** | Weekly/bi-weekly | Usually safe, test and merge |
| **Minor versions** | Monthly | Review changelog, test thoroughly |
| **Major versions** | Planned | Schedule time, expect breaking changes |

### Automated Update PRs

**Dependabot** (GitHub) or **Renovate** (self-hostable) automate the tedious parts:

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    groups:
      development-dependencies:
        dependency-type: "development"
      production-dependencies:
        dependency-type: "production"
```

**Renovate** offers more control:

```json
{
  "extends": ["config:base"],
  "schedule": ["before 6am on monday"],
  "automerge": true,
  "automergeType": "branch",
  "packageRules": [
    {
      "matchUpdateTypes": ["patch"],
      "automerge": true
    },
    {
      "matchUpdateTypes": ["major"],
      "automerge": false
    }
  ]
}
```

### The Update Philosophy

Updates aren't free—they cost testing time. But stale dependencies are debt—compounding.

Find a sustainable rhythm:

- **Security updates:** Always. No exceptions.
- **Everything else:** Regular cadence that your team can sustain
- **Major updates:** Planned, not reactive

Never disable automated security updates to reduce noise. The noise is telling you something.

## Lock Files

Lock files record exact resolved versions of all dependencies. They're not optional.

### What Lock Files Do

- **Capture exact versions** — `lodash@4.17.21`, not `lodash@^4.17.0`
- **Include transitive dependencies** — Everything, not just direct
- **Record integrity hashes** — Verify downloads haven't been tampered with
- **Enable reproducible builds** — Same input → same output

### Lock Files by Ecosystem

| Ecosystem | Lock File | Command to Generate |
|-----------|-----------|---------------------|
| npm | `package-lock.json` | `npm install` |
| Yarn | `yarn.lock` | `yarn` |
| pnpm | `pnpm-lock.yaml` | `pnpm install` |
| pip | `requirements.txt` (weak) | `pip freeze` |
| pip-tools | `requirements.txt` | `pip-compile` |
| Poetry | `poetry.lock` | `poetry lock` |
| uv | `uv.lock` | `uv lock` |
| Bundler | `Gemfile.lock` | `bundle install` |
| Cargo | `Cargo.lock` | `cargo build` |
| Go | `go.sum` | `go mod tidy` |

### Lock File Rules

**1. Lock files go in version control.**

```bash
# YES
git add package-lock.json
git commit -m "Update dependencies"

# NO
echo "package-lock.json" >> .gitignore  # Don't do this
```

**2. CI installs from lock file.**

```bash
# npm: use ci, not install
npm ci  # Installs exactly what's in lock file

# pip: don't resolve, use frozen requirements
pip install -r requirements.txt --no-deps
```

**3. Update lock files intentionally.**

Don't let CI regenerate lock files. Updates should be explicit:

```bash
npm update lodash
git add package-lock.json
git commit -m "Update lodash to 4.17.21"
```

**4. Review lock file changes in PRs.**

When a PR includes lock file changes, review them:

- What versions changed?
- Were new dependencies added?
- Did any dependencies disappear?

## Artifact Signing

Code signing verifies authenticity: this artifact came from who it claims to come from, and hasn't been modified.

### Why Sign?

- **Authenticity** — Verify the claimed source
- **Integrity** — Detect tampering
- **Non-repudiation** — Prove who published what
- **Chain of custody** — Traceable provenance

### Signing Mechanisms

**Traditional (GPG):**

```bash
# Sign a file
gpg --armor --detach-sign artifact.tar.gz

# Verify
gpg --verify artifact.tar.gz.asc artifact.tar.gz
```

GPG works but has usability issues—key management is painful.

**Modern (Sigstore/cosign):**

```bash
# Sign a container image (keyless)
cosign sign myregistry/myimage:v1.0

# Verify
cosign verify myregistry/myimage:v1.0
```

Sigstore uses OpenID Connect for identity—no key management required. Sign with your GitHub/Google/Microsoft identity.

### npm Provenance

npm supports provenance attestations for packages published from CI:

```yaml
# GitHub Actions
- name: Publish with provenance
  run: npm publish --provenance --access public
  env:
    NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}
```

Consumers can verify packages were built from claimed source code.

### Verification in CI

```yaml
# Verify signatures before deployment
- name: Verify image signature
  run: |
    cosign verify \
      --certificate-identity=ci@myorg.com \
      --certificate-oidc-issuer=https://token.actions.githubusercontent.com \
      myregistry/myimage:${{ github.sha }}
```

## SLSA Framework

SLSA (Supply-chain Levels for Software Artifacts, pronounced "salsa") is a framework for supply chain integrity.[^slsa]

### SLSA Levels

| Level | Requirements | What It Means |
|-------|--------------|---------------|
| **1** | Documented build process | You can explain how artifacts are built |
| **2** | Hosted build, signed provenance | Builds run on service infrastructure, provenance is tamper-evident |
| **3** | Hardened build, non-falsifiable provenance | Build service is hardened, provenance can't be faked |
| **4** | Two-party review, hermetic builds | All changes reviewed, builds are fully reproducible |

### Practical SLSA

Most projects should target **Level 2-3**:

- Use a CI service (GitHub Actions, GitLab CI)
- Generate provenance attestations
- Sign artifacts

Level 4 is for high-security contexts—it requires hermetic builds (no network access during build) and two-party review for all changes.

**GitHub Actions SLSA Generator:**

```yaml
- uses: slsa-framework/slsa-github-generator/.github/workflows/generator_generic_slsa3.yml@v1.0.0
  with:
    artifact-name: my-artifact
```

This generates SLSA Level 3 provenance for your artifacts.

## Repository Security

### For Package Maintainers

If you maintain packages others depend on:

**Enable 2FA.** Required on npm and PyPI for popular packages. Do it anyway.

**Use fine-grained tokens.** Don't use personal tokens for CI. Create scoped tokens with minimal permissions.

**Require review for releases.** Tag protection, branch protection, and release approval workflows.

**Sign your releases.** Use Sigstore, GPG, or your registry's provenance features.

**Publish a SECURITY.md.** Tell people how to report vulnerabilities.

```markdown
# Security Policy

## Reporting a Vulnerability

Please report security vulnerabilities to security@example.com.
Do not open public issues for security problems.

We aim to respond within 48 hours and patch within 7 days.
```

### For Package Consumers

**Use lock files.** Already covered—don't skip this.

**Verify checksums.** Lock files include hashes. CI should verify them.

```bash
npm ci  # Verifies integrity hashes automatically
```

**Consider private registries.** For organizations, mirror approved packages:

- Artifactory
- Nexus
- Verdaccio (npm)
- devpi (Python)

Private registries give you:

- Caching (faster builds)
- Availability (builds don't break if upstream is down)
- Control (approve packages before use)

**Monitor for anomalies.** Watch for:

- New maintainers on critical dependencies
- Unusual release patterns
- Suspicious new dependencies

## Defense Checklist

### Minimum Viable Security

- [ ] Lock files in version control
- [ ] CI installs from lock file
- [ ] Automated vulnerability scanning
- [ ] 2FA on package registry accounts
- [ ] Secrets not in source code

### Better Security

- [ ] Automated dependency update PRs
- [ ] SBOM generation on every build
- [ ] Lock file changes reviewed in PRs
- [ ] Private registry mirror
- [ ] Signed artifacts

### Advanced Security

- [ ] SLSA Level 2+ compliance
- [ ] Hermetic builds
- [ ] Provenance verification in deployment
- [ ] Anomaly detection on dependencies
- [ ] Regular security audits

## The Graybeard's Take

Security practices are habits, not projects. You don't "do security" once—you build it into how you work.

The teams I've seen handle incidents well have these habits deeply embedded. Lock files are always committed. Vulnerability scans run on every PR. Updates happen on a predictable cadence. When something goes wrong, they're responding from a position of knowledge, not scrambling to figure out what they're even running.

The teams that struggle treat security as an obstacle. They disable scanning because it's noisy. They skip lock files because they're confusing. They defer updates because they might break things.

Both teams eventually face the same incidents. One is prepared. One isn't.

Build the habits now, before you need them.

---

[^slsa]: See [SLSA Framework](../reference/sources.md#slsa)
