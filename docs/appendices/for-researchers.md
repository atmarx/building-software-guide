# For Researchers

Research software has unique requirements: reproducibility for scientific integrity, compliance for sensitive data, and often limited time and resources. This appendix translates supply chain concepts for academic and research contexts.

---

## The Research Software Reality

Most research software:

- Starts as a "quick script" and grows unexpectedly
- Is written by domain experts, not software engineers
- Has limited maintenance resources after publication
- Must be reproducible for scientific integrity
- May handle sensitive data (human subjects, medical records)

These constraints don't make supply chain management less important—they make it more important to get right with minimal overhead.

## Reproducibility for Publications

When you publish research, your code should produce the same results. Always.

### Minimum Reproducibility

For any published code:

```bash
# Document versions
python --version > VERSION_INFO.txt
pip freeze > requirements-frozen.txt
git log -1 > GIT_INFO.txt
```

Include in your repository:

```markdown
# README.md

## Requirements
- Python 3.11.4
- See requirements-frozen.txt for exact package versions

## Reproducing Results
```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements-frozen.txt
python run_analysis.py --seed 42
```

Expected output: results/table1.csv should match published Table 1.
```

### Better Reproducibility

Add a container:

```dockerfile
# Dockerfile
FROM python:3.11.4-slim

WORKDIR /analysis

COPY requirements-frozen.txt .
RUN pip install --no-cache-dir -r requirements-frozen.txt

COPY . .

# Default: run the analysis
CMD ["python", "run_analysis.py", "--seed", "42"]
```

```bash
# Build and run
docker build -t my-analysis:v1.0 .
docker run my-analysis:v1.0
```

Now anyone can reproduce your exact environment.

### Best Reproducibility

For high-stakes research:

```yaml
# .github/workflows/reproducibility.yml
name: Verify Reproducibility

on: [push]

jobs:
  reproduce:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Build container
        run: docker build -t analysis .

      - name: Run analysis
        run: docker run analysis > output.txt

      - name: Verify results
        run: diff output.txt expected_output.txt
```

Automated verification that results don't drift.

## Sensitive Data Compliance

Research often involves data with compliance requirements.

### Common Frameworks

| Framework | Applies To | Key Requirements |
|-----------|------------|------------------|
| **HIPAA** | US health data | Access controls, encryption, audit logs |
| **FERPA** | US education records | Student consent, access restrictions |
| **GDPR** | EU personal data | Consent, data minimization, right to erasure |
| **IRB/Ethics** | Human subjects | Approval before data collection |

### Data Handling Principles

**Minimize collection:**
```python
# Bad: Collect everything, figure it out later
df = pd.read_sql("SELECT * FROM patients", conn)

# Good: Collect only what you need
df = pd.read_sql("""
    SELECT patient_id, age_group, diagnosis_code
    FROM patients
    WHERE consent_research = TRUE
""", conn)
```

**Separate identifiers:**
```
data/
├── identifiers/          # Restricted access
│   └── patient_keys.csv  # Links IDs to identities
└── analysis/             # For analysis
    └── deidentified.csv  # No direct identifiers
```

**Use the medallion architecture:**

```
Bronze (raw):      Original data with identifiers
Silver (cleaned):  Validated, de-identified
Gold (analysis):   Aggregated, ready for research
```

Each layer has different access controls. Analysis happens on Gold layer only.

### Dependency Considerations

For compliance-sensitive work:

**Audit your dependencies:**
```bash
# What are you actually running?
pip list
pip show package-name  # Check where it came from

# Any known vulnerabilities?
pip-audit
```

**Consider what dependencies access:**
```python
# This package might phone home
# Check before using with sensitive data
import some_analytics_package  # Does it send telemetry?
```

**Air-gapped environments:**
When data can't leave a secure environment, you may need:
- Private package mirrors
- Vendored dependencies
- Pre-approved package lists

## The "Quick Script" Problem

Scripts have a way of becoming critical infrastructure.

### Signs Your Script Is Growing Up

- Multiple people use it
- It runs in production
- Results depend on it
- You can't remember how it works

### Minimal Hardening

When a script starts to matter:

**Add requirements.txt:**
```bash
pip freeze > requirements.txt
```

**Add basic error handling:**
```python
def main():
    try:
        run_analysis()
    except Exception as e:
        logger.error(f"Analysis failed: {e}")
        sys.exit(1)
```

**Add a README:**
```markdown
# Analysis Script

## Usage
python analyze.py input.csv output.csv

## Requirements
pip install -r requirements.txt

## Notes
- Expects input CSV with columns: id, value, date
- Output includes statistical summary
```

**Version control:**
```bash
git init
git add .
git commit -m "Initial commit of analysis script"
```

### When to Invest More

Invest in proper engineering when:

- Multiple papers will depend on this code
- Other researchers will use it
- It processes sensitive data
- Results affect decisions (clinical, policy)

See [When Scripts Become Software](../concepts/scripts-become-software.md) for the full discussion.

## Managing Shared Resources

Research computing often means shared infrastructure.

### HPC Clusters

```bash
# Don't install globally
pip install --user package-name  # Goes to ~/.local

# Better: Use virtual environments
python -m venv ~/venvs/my-project
source ~/venvs/my-project/bin/activate
pip install -r requirements.txt
```

### JupyterHub

```python
# Each notebook should specify its environment
# requirements.txt or conda environment.yml

# In the notebook:
import sys
print(sys.executable)  # Verify which Python
print(sys.version)     # Verify version
```

### Module Systems

```bash
# On HPC with module system
module load python/3.11
module load cuda/12.1

# Document in README
# Required modules: python/3.11, cuda/12.1
```

## Archiving for Long-Term Reproducibility

Research should be reproducible years later.

### What to Archive

| Item | Where | Duration |
|------|-------|----------|
| Code | GitHub + Zenodo | Indefinite |
| Data | Institutional repository | Per policy |
| Environment | Container registry / Zenodo | Indefinite |
| Documentation | With code | Indefinite |

### Zenodo Integration

```yaml
# .zenodo.json
{
    "title": "Code for 'My Research Paper'",
    "upload_type": "software",
    "creators": [
        {"name": "Your Name", "orcid": "0000-0000-0000-0000"}
    ],
    "license": "MIT",
    "related_identifiers": [
        {
            "identifier": "10.1234/journal.1234",
            "relation": "isSupplementTo",
            "scheme": "doi"
        }
    ]
}
```

GitHub releases can automatically archive to Zenodo with DOIs.

### Container Archiving

```bash
# Save container image
docker save my-analysis:v1.0 | gzip > my-analysis-v1.0.tar.gz

# Include with archived code
# Can be loaded years later:
# docker load < my-analysis-v1.0.tar.gz
```

## Collaboration Practices

### Lab/Group Standards

Establish minimal standards:

```markdown
# Lab Code Standards

## Required for All Projects
- [ ] README with setup instructions
- [ ] requirements.txt or environment.yml
- [ ] Version control (git)
- [ ] Basic documentation of what code does

## Required for Publications
- [ ] Frozen dependencies (exact versions)
- [ ] Dockerfile or container
- [ ] Script to reproduce figures/tables
- [ ] Archive to Zenodo

## Required for Sensitive Data
- [ ] IRB/ethics approval documented
- [ ] Data access controls documented
- [ ] No sensitive data in repository
- [ ] Compliance review completed
```

### Code Review for Research

Even informal review helps:

```markdown
## Lab Code Review Checklist

- [ ] Code runs without errors
- [ ] README is accurate
- [ ] Dependencies are specified
- [ ] No hardcoded paths (or documented)
- [ ] No credentials in code
- [ ] Results are reproducible
```

## Grant and Publication Requirements

### Data Management Plans

Many funders require data management plans:

```markdown
## Software Management

Code developed under this project will be:
- Version controlled using git
- Archived to Zenodo upon publication
- Licensed under MIT license
- Documented with README and inline comments

Dependencies will be:
- Managed using pip/conda with lock files
- Scanned for vulnerabilities before deployment
- Documented in requirements files
```

### Journal Requirements

Some journals require:

- Code availability statements
- Data availability statements
- Environment specifications
- Container images

Prepare these from the start, not as an afterthought.

## The Graybeard's Take

Research software occupies an awkward middle ground. It's too important to ignore best practices—results must be reproducible, data must be protected. But it's often developed by people whose primary job isn't software development, with timelines that don't include "refactoring week."

The key is finding the minimum viable rigor for your situation. A script that runs once for a class project needs less than code underlying a clinical trial. But even the simplest analysis benefits from basic version control and documented dependencies.

I've seen too many papers retracted or questioned because the code couldn't be reproduced. I've seen careers damaged by data breaches from scripts that grew beyond their original scope. The investment in getting dependencies right, documenting your environment, and protecting sensitive data is small compared to these costs.

Start simple. requirements.txt, git, a README. Add more as your code becomes more important. But start.

---

## Quick Reference

### Minimum Reproducibility Kit

```
project/
├── README.md              # What this does, how to run
├── requirements.txt       # pip freeze output
├── run_analysis.py        # Main script
└── results/               # Expected outputs
```

### Sensitive Data Checklist

- [ ] IRB/ethics approval obtained
- [ ] Data minimization applied
- [ ] Identifiers separated from analysis data
- [ ] Access controls documented
- [ ] No sensitive data in version control
- [ ] Dependencies audited for data handling

### Publication Checklist

- [ ] Code archived (Zenodo, institutional repo)
- [ ] DOI obtained for code
- [ ] Exact dependency versions frozen
- [ ] Container available (Dockerfile or image)
- [ ] Reproduction instructions tested
- [ ] Data availability documented
