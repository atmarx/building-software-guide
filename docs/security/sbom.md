# Software Bills of Materials

An SBOM is an inventory of everything in your software—every component, every version, every dependency. It's the answer to "what are we running?" and it needs to be answerable in minutes, not days.

---

## What Is an SBOM?

A Software Bill of Materials (SBOM) is a formal, machine-readable inventory of components that make up a piece of software. Think of it like a nutrition label for code:

- What ingredients (components) are in this?
- Where did they come from?
- What version is each one?
- What license applies to each?

When [log4shell](../lessons-learned/log4shell.md) dropped in December 2021, organizations with SBOMs could answer "are we affected?" within hours. They grepped their inventory, found every instance of log4j, and knew exactly what to patch.

Organizations without SBOMs spent weeks hunting through codebases, asking developers, scanning servers. Some never fully answered the question.

## Why SBOMs Matter

### Vulnerability Response

A new CVE is announced. The question "are we affected?" should be:

1. Search your SBOM for the affected component
2. Check if you have vulnerable versions
3. Identify where they're deployed

Without an SBOM, this becomes:

1. Ask every team what they're running
2. Grep through source code repositories
3. Scan deployed systems
4. Hope you found everything
5. Repeat weekly as you discover more

### License Compliance

Every component has a license. Some licenses (GPL, AGPL) have implications for how you can use and distribute your software. An SBOM makes license auditing straightforward:

- What licenses are in our stack?
- Do any conflict with our distribution model?
- Are we meeting attribution requirements?

For licensing details, see the [Open Source Licensing Guide](licensing-guide).

### Supply Chain Visibility

An SBOM shows you:

- How deep your dependency tree goes
- Which components appear multiple times (at different versions)
- Who maintains your critical dependencies
- What changed between builds

### Regulatory Requirements

SBOMs are increasingly required:

- **U.S. Executive Order 14028** (2021) mandates SBOMs for software sold to the federal government[^eo-14028]
- **FDA guidance** recommends SBOMs for medical device software
- **EU Cyber Resilience Act** will require SBOMs for products sold in the EU
- **NIST guidelines** reference SBOMs as a security best practice

Even if you're not selling to government, your enterprise customers may require SBOMs as part of vendor security assessments.

## SBOM Formats

Two formats dominate:

### SPDX (Software Package Data Exchange)

- Developed by the Linux Foundation
- ISO/IEC 5962:2021 international standard
- Strong support for license information
- Formats: JSON, XML, RDF, tag-value

SPDX was designed for license compliance and later expanded to security use cases. If license tracking is your primary concern, SPDX has the most mature support.

```json
{
  "spdxVersion": "SPDX-2.3",
  "name": "my-application",
  "packages": [
    {
      "name": "lodash",
      "versionInfo": "4.17.21",
      "licenseConcluded": "MIT",
      "downloadLocation": "https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz"
    }
  ]
}
```

### CycloneDX

- Developed by OWASP
- Designed for security use cases
- Supports vulnerabilities, services, and compositions
- Formats: JSON, XML

CycloneDX was built with security in mind. It has first-class support for vulnerability information, making it easier to correlate SBOMs with vulnerability data.

```json
{
  "bomFormat": "CycloneDX",
  "specVersion": "1.5",
  "components": [
    {
      "type": "library",
      "name": "lodash",
      "version": "4.17.21",
      "purl": "pkg:npm/lodash@4.17.21"
    }
  ]
}
```

### Which to Use?

| Use Case | Recommendation |
|----------|----------------|
| License compliance focus | SPDX |
| Security/vulnerability focus | CycloneDX |
| Government contracts | Either (both accepted) |
| General purpose | Either—pick one and be consistent |

Both formats are widely supported by tools. The important thing is generating SBOMs at all, not which format you choose.

## Generating SBOMs

### Build-Time Generation

The most accurate SBOMs are generated during the build process, when the exact components being included are known.

**npm (built-in):**
```bash
npm sbom --format cyclonedx
npm sbom --format spdx
```

**Python (with tools):**
```bash
# Using cyclonedx-python
pip install cyclonedx-bom
cyclonedx-py -r requirements.txt -o sbom.json

# Using pip-licenses for license-focused output
pip install pip-licenses
pip-licenses --format=json --output-file=licenses.json
```

**Multi-ecosystem (Syft):**
```bash
# Analyze a directory
syft dir:./my-project -o cyclonedx-json

# Analyze a container image
syft my-image:latest -o spdx-json
```

### Container Image Analysis

For containerized applications, generate SBOMs from the final image:

```bash
# Using Syft
syft myregistry/myimage:v1.0 -o cyclonedx-json > sbom.json

# Using Trivy
trivy image --format cyclonedx myregistry/myimage:v1.0 > sbom.json
```

This captures everything in the image: OS packages, language packages, and your application code.

### CI/CD Integration

SBOMs should be generated automatically on every build:

```yaml
# GitHub Actions example
- name: Generate SBOM
  uses: anchore/sbom-action@v0
  with:
    format: cyclonedx-json
    output-file: sbom.json

- name: Upload SBOM
  uses: actions/upload-artifact@v4
  with:
    name: sbom
    path: sbom.json
```

Store SBOMs with your build artifacts. They should be retrievable for any deployed version.

## Using SBOMs

### Vulnerability Scanning

Feed your SBOM to vulnerability scanners:

```bash
# Using Grype
grype sbom:./sbom.json

# Using Trivy
trivy sbom ./sbom.json
```

This tells you which components in your inventory have known vulnerabilities.

### Dependency Tracking

Query your SBOM to understand your dependencies:

- How many direct vs. transitive dependencies?
- Which components appear at multiple versions?
- What's the oldest component version?
- Which maintainers own the most components?

### Change Detection

Compare SBOMs between versions:

- What components were added?
- What versions changed?
- What was removed?

This is especially useful in code review—lock file diffs show version changes, but SBOM diffs can show the full impact.

### License Auditing

Extract license information:

```bash
# Using SPDX tools or custom scripts
jq '.packages[] | {name, version, license: .licenseConcluded}' sbom.spdx.json
```

Flag components with licenses that conflict with your requirements.

## SBOM Hygiene

### Keep Them Current

SBOMs are snapshots. They're accurate for a specific build at a specific time. Stale SBOMs are worse than useless—they give false confidence.

- Generate on every build
- Store with build artifacts
- Update when dependencies change

### Make Them Complete

An SBOM should include everything:

- Direct dependencies
- Transitive dependencies
- OS packages (for containers)
- Vendored code
- Build tools (if they affect output)

Partial SBOMs miss things. The component you didn't inventory is the one with the vulnerability.

### Make Them Accessible

When a CVE drops, you need SBOMs fast:

- Store in searchable format
- Index by component name and version
- Link to deployed environments

"Where is log4j 2.14.1 running?" should be answerable with a query, not an investigation.

## The Graybeard's Take

I've been through enough fire drills to know: the organizations that handle incidents well are the ones that did the boring work beforehand.

When log4shell hit, I watched two types of responses. The first type had asset inventories, SBOMs, and vulnerability scanning. They spent the weekend patching. The second type spent the weekend figuring out what they were running. Some of them are probably still figuring it out.

SBOMs aren't exciting. Generating them isn't glamorous. Nobody gets promoted for having a complete software inventory. But when the next log4shell drops—and it will—the teams with SBOMs will sleep while the teams without them scramble.

The best time to generate your first SBOM was before you needed it. The second best time is now.

---

## Quick Reference

### SBOM Generation Tools

| Tool | Ecosystems | Output Formats |
|------|------------|----------------|
| **Syft** | All major | SPDX, CycloneDX |
| **Trivy** | All major | SPDX, CycloneDX |
| **npm sbom** | Node.js | SPDX, CycloneDX |
| **cyclonedx-python** | Python | CycloneDX |
| **CycloneDX Maven Plugin** | Java | CycloneDX |

### Minimum SBOM Content

- Component name
- Component version
- Package URL (purl) or download location
- License (if known)
- Direct vs. transitive indicator

---

[^eo-14028]: See [Executive Order 14028](../reference/sources.md#eo-14028)
