# Secrets Management

API keys in notebooks. Database passwords in config files. AWS credentials in git history. This chapter is about not doing those things—and cleaning up when you do.

!!! terminal "They're Already Looking"
    The number of credentials I've found in git histories would make you cry. Bots scan every public commit within seconds. Private repos get leaked. "I'll fix it later" becomes "I've been mining crypto on your AWS account for three weeks." Assume any secret that touches a repo is compromised.

---

## What Counts as a Secret?

A secret is any piece of information that grants access or capability:

- **API keys** — Access to external services
- **Passwords** — Database, service account, admin credentials
- **Private keys** — SSH keys, TLS certificates, signing keys
- **Tokens** — OAuth tokens, JWTs, session tokens
- **Connection strings** — Database URLs with embedded credentials
- **Encryption keys** — Keys for encrypting/decrypting data

If someone finding this value would be bad, it's a secret.

## Where Secrets Go Wrong

### Hardcoded in Source Code

The classic mistake:

```python
# Please don't do this
API_KEY = "sk-live-abc123def456"
client = SomeAPI(api_key=API_KEY)
```

This seems convenient. It's also:

- **Visible to anyone with repo access** — Every collaborator, every fork
- **Preserved in git history** — Even if you delete it later
- **Deployed everywhere** — Dev, test, prod all use the same key
- **Shared unintentionally** — Copy-paste the file, share the secret

### Committed to Git

Even if you use environment variables, accidents happen:

```bash
# Oops, committed .env
$ git add .
$ git commit -m "Added configuration"

# .env contains:
DATABASE_URL=postgres://admin:supersecret@prod-db:5432/app
```

Once committed, the secret is in git history. Deleting the file doesn't remove it from history. Anyone who clones the repo—or already has a copy—can find it.

### In Container Images

Docker layers preserve everything:

```dockerfile
# This secret is now in a layer
ENV API_KEY=sk-live-abc123
RUN curl -H "Authorization: $API_KEY" https://api.example.com/setup
# Even if you unset it later, it's in the layer history
```

Anyone who pulls your image can extract environment variables and layer contents.

### In Logs and Error Messages

```python
def connect_to_api(api_key):
    logger.info(f"Connecting with key: {api_key}")  # Don't log secrets
    try:
        response = client.connect(api_key)
    except Exception as e:
        raise Exception(f"Failed with key {api_key}: {e}")  # Don't include in errors
```

Logs get stored, shipped to log aggregators, viewed by support teams. Secrets in logs spread uncontrollably.

### In Notebooks

Jupyter notebooks are particularly prone to secret leakage:

```python
# Cell 1: Setup
import os
os.environ['API_KEY'] = 'sk-live-abc123'  # Saved in notebook

# Cell 47: Forgot about cell 1, share notebook with collaborator
```

Notebooks save cell outputs. If you print a secret or it appears in an error traceback, it's in the notebook file.

## How to Handle Secrets Properly

### Environment Variables (Basic)

The minimum viable approach:

```python
import os

api_key = os.environ.get('API_KEY')
if not api_key:
    raise ValueError("API_KEY environment variable required")
```

Set in your shell:

```bash
export API_KEY=sk-live-abc123
python my_script.py
```

**Pros:** Secrets not in code
**Cons:** Easy to leak via `env`, process listings, or logging

### .env Files (Better)

Use a `.env` file that's never committed:

```bash
# .env (add to .gitignore!)
API_KEY=sk-live-abc123
DATABASE_URL=postgres://user:pass@localhost:5432/db
```

Load with `python-dotenv` or similar:

```python
from dotenv import load_dotenv
import os

load_dotenv()
api_key = os.environ.get('API_KEY')
```

**Critical:** Add `.env` to `.gitignore` *before* creating it:

```bash
echo ".env" >> .gitignore
git add .gitignore
git commit -m "Ignore .env files"
# Now create .env
```

### Secrets Managers (Best)

For production and team environments, use a dedicated secrets manager:

**Cloud providers:**
- AWS Secrets Manager
- Google Secret Manager
- Azure Key Vault

**Self-hosted:**
- HashiCorp Vault
- Doppler
- 1Password (with CLI)

Example with AWS:

```python
import boto3
import json

def get_secret(secret_name):
    client = boto3.client('secretsmanager')
    response = client.get_secret_value(SecretId=secret_name)
    return json.loads(response['SecretString'])

secrets = get_secret('my-app/production')
api_key = secrets['api_key']
```

**Pros:**
- Centralized management
- Audit logging
- Rotation support
- Access controls

**Cons:**
- More infrastructure
- Learning curve
- Cost (for cloud services)

### In CI/CD

CI/CD systems have built-in secrets management:

**GitHub Actions:**
```yaml
steps:
  - name: Deploy
    env:
      API_KEY: ${{ secrets.API_KEY }}
    run: ./deploy.sh
```

**GitLab CI:**
```yaml
deploy:
  script:
    - ./deploy.sh
  variables:
    API_KEY: $CI_API_KEY  # Set in GitLab CI/CD settings
```

Never print secrets in CI logs. Mask them:

```yaml
- name: Use secret
  run: |
    echo "::add-mask::${{ secrets.API_KEY }}"
    ./script.sh
```

## When Secrets Leak

### Detection

How to find leaked secrets:

**Git history scanning:**
```bash
# Using trufflehog
trufflehog git file://./my-repo

# Using gitleaks
gitleaks detect --source ./my-repo
```

**Pre-commit hooks:**
```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.0
    hooks:
      - id: gitleaks
```

This catches secrets before they're committed.

### Remediation

If you've committed a secret:

**1. Revoke immediately.** Assume it's compromised. Generate new credentials.

**2. Remove from git history** (if not yet pushed):
```bash
# Remove file from history
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch path/to/secret-file" \
  --prune-empty --tag-name-filter cat -- --all
```

**3. If already pushed:** The secret is compromised. Focus on revocation, not removal. Removing from history doesn't remove from clones.

**4. Rotate credentials.** Don't reuse the compromised secret. Generate new ones.

**5. Audit access.** Check if the secret was used maliciously during the exposure window.

### The Hard Truth

If a secret was pushed to a public repository—even briefly—assume it's compromised. Bots scan GitHub continuously for leaked credentials. By the time you notice, someone may have already harvested it.

## Container Secrets

### Don't Use ENV for Secrets

Environment variables in Dockerfiles are visible in image history:

```dockerfile
# BAD: Secret visible in layer
ENV API_KEY=secret123

# ALSO BAD: Secret in build arg, still in history
ARG API_KEY
RUN curl -H "Auth: $API_KEY" https://api.example.com
```

### Use Runtime Injection

Pass secrets at runtime, not build time:

```dockerfile
# Dockerfile - no secrets here
FROM python:3.11-slim
COPY app.py .
CMD ["python", "app.py"]
```

```bash
# Runtime - secrets injected
docker run -e API_KEY=$API_KEY myimage
```

### Use Docker Secrets (Swarm) or Kubernetes Secrets

For orchestrated environments:

```yaml
# Kubernetes Secret
apiVersion: v1
kind: Secret
metadata:
  name: api-credentials
type: Opaque
data:
  api-key: c2stbGl2ZS1hYmMxMjM=  # base64 encoded
```

```yaml
# Pod using secret
containers:
  - name: app
    env:
      - name: API_KEY
        valueFrom:
          secretKeyRef:
            name: api-credentials
            key: api-key
```

Note: Kubernetes Secrets are base64 encoded, not encrypted by default. Enable encryption at rest for sensitive clusters.

## Notebook-Specific Guidance

Jupyter notebooks need extra care:

### Use Environment Variables

```python
import os
api_key = os.environ['API_KEY']  # Set before starting Jupyter
```

### Clear Outputs Before Sharing

```bash
jupyter nbconvert --clear-output --inplace notebook.ipynb
```

### Use ipython Magics Carefully

```python
# This saves to shell history and notebook
!export API_KEY=secret  # Don't do this

# Use Python instead
import os
os.environ['API_KEY'] = input('API Key: ')  # Prompts, doesn't save
```

### Consider jupyter-secrets Extensions

Tools like `jupyter-credentialstore` can manage secrets separately from notebooks.

!!! terminal "Just This Once"
    I've seen production databases get dropped because someone committed credentials and a bot found them faster than the developer could delete the commit. I've seen AWS bills in the tens of thousands from cryptominers using leaked keys.

    The pattern is always the same: convenience over security, just this once, just for testing. And then "just for testing" becomes "how we've always done it" until the breach.

    Secrets management isn't hard once you have the habit. Use environment variables at minimum. Use a secrets manager if you can. Add pre-commit hooks to catch mistakes. Assume any secret that touches git is compromised.

    The five minutes you spend setting up proper secrets handling saves the five days you'd spend rotating every credential after a leak.

---

## Quick Reference

### Do's and Don'ts

| Do | Don't |
|----|-------|
| Use environment variables | Hardcode secrets in source |
| Add `.env` to `.gitignore` | Commit `.env` files |
| Use secrets managers | Pass secrets as build args |
| Rotate leaked credentials | Try to hide commits |
| Use pre-commit hooks | Assume you'll catch it manually |
| Clear notebook outputs | Share notebooks with embedded secrets |

### Secret Detection Tools

| Tool | Use Case |
|------|----------|
| **gitleaks** | Pre-commit and CI scanning |
| **trufflehog** | Git history scanning |
| **detect-secrets** | Yelp's secret scanner |
| **git-secrets** | AWS credential scanner |
