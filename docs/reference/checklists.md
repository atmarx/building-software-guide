# Checklists

Actionable checklists for common supply chain tasks. Print these, bookmark them, integrate them into your workflow.

!!! terminal "Because We Forget"
    Checklists exist because I've forgotten every single item on them at least once. Smart people make dumb mistakes under pressure. Checklists are how you stop making the same mistakes repeatedly. I don't trust my memory anymore—I trust the checklist.

---

## New Dependency Checklist

Before adding a new dependency to your project:

- [ ] **Searched for alternatives** — Is there a simpler solution? Could you write this yourself in reasonable time?
- [ ] **Checked maintenance status** — When was the last commit? Are issues being addressed? What's the bus factor?
- [ ] **Reviewed dependency tree** — What transitive dependencies come with this? How deep is the tree?
- [ ] **Verified license compatibility** — Is the license compatible with your project? (See [Licensing Guide](https://libre.xram.net))
- [ ] **Assessed security posture** — Does the project have a security policy? Any recent CVEs? How were they handled?
- [ ] **Checked download counts / adoption** — Is this widely used, or an obscure package?
- [ ] **Documented rationale** — Why this package? What alternatives were considered?

### Red Flags

Stop and reconsider if you see:

- :material-close-circle:{ .red-flag } Single maintainer with no succession plan
- :material-close-circle:{ .red-flag } Last commit over 1 year ago (for active problem domains)
- :material-close-circle:{ .red-flag } Hundreds of open issues with no responses
- :material-close-circle:{ .red-flag } No clear versioning strategy
- :material-close-circle:{ .red-flag } Minified or obfuscated source in repository
- :material-close-circle:{ .red-flag } Excessive permissions requested

---

## Dependency Update Checklist

Before updating dependencies:

- [ ] **Read the changelog** — What changed? Any breaking changes?
- [ ] **Check for breaking changes** — Review migration guides if major version
- [ ] **Run test suite** — All tests pass after update?
- [ ] **Review lock file diff** — What else changed? Any unexpected new dependencies?
- [ ] **Check for new transitive dependencies** — Did the update pull in anything new?
- [ ] **Verify no new security advisories** — Is the new version clean?
- [ ] **Test in staging environment** — Before production, verify behavior

### Update Cadence Guidelines

| Update Type | Suggested Cadence |
|-------------|-------------------|
| Security patches | Immediately |
| Patch versions | Weekly or bi-weekly |
| Minor versions | Monthly review |
| Major versions | Planned and scheduled |

---

## Container Security Checklist

For Docker/container images:

- [ ] **Minimal base image** — Using alpine, distroless, or scratch where possible?
- [ ] **Pinned base image version** — Including digest, not just tag?
- [ ] **Non-root user** — Container runs as non-root?
- [ ] **No secrets in image** — No API keys, passwords, credentials baked in?
- [ ] **No secrets in build history** — Checked all layers, not just final state?
- [ ] **Multi-stage build** — Build dependencies separated from runtime?
- [ ] **Minimal installed packages** — Only what's needed for runtime?
- [ ] **Scanned for vulnerabilities** — Trivy, Grype, or equivalent run?
- [ ] **.dockerignore configured** — Sensitive files excluded from build context?

### Base Image Selection

| Use Case | Recommended Base |
|----------|------------------|
| Production (compiled) | `distroless` or `scratch` |
| Production (interpreted) | `*-slim` variants |
| Development | Full images acceptable |
| Security-critical | `distroless` with minimal packages |

---

## Release Checklist

Before releasing software:

- [ ] **SBOM generated** — Complete inventory of components?
- [ ] **Artifacts signed** — Using Sigstore/cosign or GPG?
- [ ] **Provenance recorded** — Build metadata captured?
- [ ] **Security scan passed** — No critical or high vulnerabilities?
- [ ] **License scan passed** — No license conflicts?
- [ ] **Tests pass** — Full test suite green?
- [ ] **Changelog updated** — Changes documented?
- [ ] **Version bumped appropriately** — Following semver?

---

## Vulnerability Response Checklist

When a CVE is announced:

- [ ] **Determine exposure** — Are we running affected versions? Check SBOM.
- [ ] **Assess exploitability** — Is the vulnerable code path reachable in our context?
- [ ] **Evaluate severity** — CVSS score + our context = actual risk
- [ ] **Identify remediation** — Patch available? Workaround possible?
- [ ] **Test fix** — Verify patch doesn't break functionality
- [ ] **Deploy fix** — Push to all affected environments
- [ ] **Verify deployment** — Confirm vulnerable versions no longer running
- [ ] **Document decision** — Record assessment and actions for audit trail

### When You Can't Update Immediately

If patching isn't immediately possible:

- [ ] **Document risk acceptance** — Who approved? What's the timeline?
- [ ] **Implement mitigating controls** — WAF rules, input validation, network segmentation
- [ ] **Increase monitoring** — Watch for exploitation attempts
- [ ] **Set review date** — When will this be reassessed?

---

## Research Data Security Checklist

When working with sensitive research data:

- [ ] **Data classification determined** — What level of sensitivity?
- [ ] **Appropriate environment used** — Does compute environment match data sensitivity?
- [ ] **Access controls configured** — Principle of least privilege?
- [ ] **Data at rest encrypted** — Storage encryption enabled?
- [ ] **Data in transit encrypted** — TLS/HTTPS everywhere?
- [ ] **Test data separated** — Using synthetic/anonymized data for development?
- [ ] **Audit logging enabled** — Who accessed what, when?
- [ ] **Retention policy defined** — When is data deleted?
- [ ] **IRB/compliance requirements met** — For human subjects data

---

## CI/CD Security Checklist

For your build and deployment pipelines:

- [ ] **Build from lock file** — Not resolving versions at build time?
- [ ] **Secrets management** — Using secret store, not environment variables in code?
- [ ] **Minimal permissions** — CI service accounts have least privilege?
- [ ] **Dependency scanning** — Running on every build?
- [ ] **SBOM generation** — Automated as part of build?
- [ ] **Artifact signing** — Automated as part of release?
- [ ] **Branch protection** — Main branch requires review?
- [ ] **Audit logging** — Pipeline actions are logged?
