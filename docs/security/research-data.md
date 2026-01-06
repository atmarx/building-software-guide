# Research Data Security

When your code touches sensitive data—research subjects, medical records, proprietary information—the stakes change. A dependency vulnerability becomes a potential data breach. A misconfigured environment becomes a compliance violation. This chapter covers the practices that protect research data.

!!! terminal "Careers End Here"
    I've seen research projects shut down and careers damaged over data handling mistakes. Not malice—just someone who didn't understand what they were holding. Research data security isn't bureaucracy. It's respect for the people who trusted you with their information.

---

## Data Classification

Not all data needs the same protection. Classification helps you match security controls to sensitivity.

### Common Classification Levels

| Level | Examples | Controls |
|-------|----------|----------|
| **Public** | Published results, public datasets | Basic hygiene |
| **Internal** | Preliminary results, internal communications | Access controls |
| **Confidential** | Unpublished research, proprietary methods | Encryption, audit logging |
| **Restricted** | PII, PHI, human subjects data | Full compliance controls |

### Regulatory Considerations

Some data has legal requirements:

**HIPAA (PHI):** Health data requires specific safeguards, access controls, and audit trails.

**FERPA:** Student educational records have privacy requirements.

**GDPR:** EU personal data has consent, access, and deletion requirements.

**IRB protocols:** Human subjects research has institution-specific requirements.

**Export controls:** Some research data can't cross borders.

If you're unsure what applies to your data, ask. Your institution has compliance officers for a reason.

## Environment Separation

The principle: **production data belongs in production environments, not on your laptop**.

### The Problem

Researchers often:

- Download real data to local machines for "quick analysis"
- Copy production databases to development environments
- Share datasets via email or cloud storage
- Use real data in demos and presentations

Each of these creates risk:

- Local machines are less secure than managed infrastructure
- Development environments have weaker controls
- Shared copies multiply attack surface
- Demos expose data to unintended audiences

### The Solution: Environment Tiers

**Production Environment:**

- Contains real, sensitive data
- Full security controls
- Audit logging
- Access restricted to authorized personnel
- Used only for production workloads

**Staging/Test Environment:**

- Mirrors production configuration
- Uses synthetic or anonymized data
- Safe for testing changes
- Can be accessed by broader team

**Development Environment:**

- Individual or team workspaces
- Uses fake/synthetic data only
- May have relaxed security
- Where initial development happens

### Data Flow Rules

```
Real Data → Production only
              ↓
         Anonymization
              ↓
Test Data → Staging/Test
              ↓
         Synthetic Generation
              ↓
Fake Data → Development
```

Data flows down through anonymization and synthetic generation, never up.

## Test Data Strategies

### Synthetic Data Generation

Create fake data that has the same statistical properties as real data:

```python
# Using Faker for basic synthetic data
from faker import Faker
fake = Faker()

synthetic_patient = {
    "name": fake.name(),
    "dob": fake.date_of_birth(),
    "mrn": fake.uuid4(),
    "diagnosis": random.choice(diagnoses)
}
```

For more complex needs, libraries like `SDV` (Synthetic Data Vault) can learn distributions from real data and generate statistically similar synthetic data.

### Anonymization

Remove or obscure identifying information:

**De-identification:** Remove direct identifiers (names, SSNs, email addresses).

**Pseudonymization:** Replace identifiers with consistent fake ones.

**Aggregation:** Use summary statistics instead of individual records.

**k-anonymity:** Ensure each record matches at least k-1 others on quasi-identifiers.

**Differential privacy:** Add statistical noise to protect individual records.

For healthcare data, HIPAA defines specific de-identification standards (Safe Harbor and Expert Determination methods).

### Subsetting

Use a representative sample rather than full dataset:

```sql
-- Create a development subset
CREATE TABLE dev_patients AS
SELECT * FROM prod_patients
WHERE patient_id IN (
  SELECT patient_id FROM prod_patients
  ORDER BY RANDOM()
  LIMIT 1000
);
```

Combined with anonymization, this gives developers realistic data without full production access.

## The Medallion Architecture

For data-intensive research, the medallion (bronze/silver/gold) architecture provides structure:

### Bronze Layer (Raw)

- Ingested data in original format
- No transformations applied
- Full audit trail of what arrived
- May contain sensitive data in original form

**Security:** Restricted access, encrypted at rest, audit logged.

### Silver Layer (Cleaned)

- Validated and cleaned data
- Schema enforced
- Duplicates removed
- Anonymization applied if needed

**Security:** Access based on data sensitivity, audit logged.

### Gold Layer (Refined)

- Business/research-ready views
- Aggregated as needed
- Optimized for analysis
- De-identified where appropriate

**Security:** Broader access for analysis, may be less restricted.

### Why This Matters for Security

The medallion architecture creates natural checkpoints for security controls:

- Bronze → Silver: Apply anonymization transforms
- Silver → Gold: Apply aggregation, verify de-identification
- Each layer can have different access controls

This beats the alternative: raw data scattered across notebooks and shared drives.

## Logging and Audit Trails

When working with sensitive data, you need to know: **who accessed what, when, and why**.

### What to Log

- **Access events:** Who queried what data, when
- **Data exports:** What data left the system, where it went
- **Schema changes:** Who modified data structure
- **Permission changes:** Who granted or revoked access
- **Authentication events:** Login attempts, especially failures

### Logging Practices

**Log enough to reconstruct events:**

```json
{
  "timestamp": "2024-01-15T10:30:00Z",
  "user": "researcher@university.edu",
  "action": "query",
  "resource": "patient_records",
  "row_count": 150,
  "columns_accessed": ["diagnosis", "treatment", "outcome"],
  "ip_address": "192.168.1.50"
}
```

**Don't log the sensitive data itself:**

```json
// BAD
{"action": "query", "result": {"patient_name": "John Doe", "diagnosis": "..."}}

// GOOD
{"action": "query", "row_count": 1, "table": "patients"}
```

**Retain logs appropriately:** Long enough for audit purposes, compliant with regulations. Often 6 months to 7 years depending on requirements.

**Protect log integrity:** Logs that can be modified aren't trustworthy. Use append-only storage, separate permissions from production systems.

### Database Audit Logging

Most databases support audit logging:

**PostgreSQL:**
```sql
-- Enable logging
ALTER SYSTEM SET log_statement = 'all';
ALTER SYSTEM SET log_connections = on;
```

**MySQL:**
```sql
-- Enterprise feature, or use proxies like ProxySQL
SET GLOBAL general_log = 'ON';
```

For comprehensive audit logging, consider dedicated tools like `pgAudit` (PostgreSQL) or database activity monitoring solutions.

## Access Control

### Principle of Least Privilege

Users should have the minimum access needed for their role:

| Role | Bronze | Silver | Gold | Notes |
|------|--------|--------|------|-------|
| Data Engineer | Read/Write | Read/Write | Read | Maintains pipelines |
| Analyst | — | Read | Read | Analysis only |
| Researcher | — | — | Read | Uses refined data |
| Admin | Full | Full | Full | System administration |

### Implementation Approaches

**Database-level controls:**

```sql
-- Create role with limited access
CREATE ROLE analyst;
GRANT SELECT ON gold_schema.* TO analyst;

-- Assign users to roles
GRANT analyst TO researcher@university.edu;
```

**Application-level controls:** When database controls aren't granular enough, implement in your application layer.

**Column-level security:** Some databases support restricting access to specific columns—useful for keeping identifiers separate from analysis data.

**Row-level security:** Restrict access based on row contents (e.g., researchers only see their own study's data).

## Notebook Security

Jupyter notebooks need special attention because they:

- Save outputs (including data samples)
- Are easily shared
- Persist credentials entered in cells
- Can access production data if connected

### Notebook Hygiene

**Don't hardcode credentials:** Use environment variables or secrets managers.

**Clear outputs before sharing:**
```bash
jupyter nbconvert --clear-output --inplace notebook.ipynb
```

**Don't display real data samples:**
```python
# BAD: Shows real data in output
df.head()

# BETTER: Show shape and dtypes only
print(df.shape)
print(df.dtypes)
```

**Use nbstripout as a pre-commit hook:**
```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/kynan/nbstripout
    rev: 0.6.1
    hooks:
      - id: nbstripout
```

### JupyterHub Security

For shared JupyterHub environments:

- **Authentication:** Integrate with institutional SSO
- **Authorization:** Control who can access which resources
- **Resource limits:** Prevent runaway computations
- **Audit logging:** Track user activity
- **Network isolation:** Limit what notebooks can connect to

!!! terminal "Trust Has to Mean Something"
    I've seen research projects shut down over data handling violations. Not because of malicious intent—because someone emailed a spreadsheet, or left a notebook running with production credentials, or demoed with real patient data.

    The researchers weren't careless. They were focused on their science. Data security wasn't part of their training. It wasn't in their grant proposal. It wasn't what they were being evaluated on. But it's still their responsibility. And when something goes wrong, "I didn't know" isn't an acceptable answer.

    The practices in this chapter aren't about checking compliance boxes. They're about building habits that protect the people whose data you're using. Those research subjects trusted you with their information. That trust has to mean something.

    Use synthetic data for development. Keep production data in production. Know who's accessing what. And when you're not sure if something is appropriate, ask. The inconvenience of doing this right is nothing compared to the consequences of doing it wrong.

---

## Quick Reference

### Data Environment Checklist

- [ ] Data classified by sensitivity
- [ ] Environments separated (dev/staging/prod)
- [ ] Synthetic data available for development
- [ ] Anonymization applied before leaving production
- [ ] Access controls match data sensitivity
- [ ] Audit logging enabled
- [ ] Notebooks cleared before sharing

### Compliance Quick Guide

| Regulation | Applies To | Key Requirements |
|------------|------------|------------------|
| HIPAA | Health data (US) | Access controls, audit trails, encryption |
| FERPA | Student records (US) | Consent, access controls |
| GDPR | EU personal data | Consent, access rights, deletion |
| IRB | Human subjects | Institution-specific protocols |
