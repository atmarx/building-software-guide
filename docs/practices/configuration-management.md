# Configuration Management

Hardcoded values are technical debt. This chapter covers how to externalize configuration, manage environment-specific settings, and avoid the traps that turn configuration into chaos.

---

## Why Configuration Matters

Configuration controls behavior without changing code:

- **Database connections** — Dev, staging, production
- **API endpoints** — Local services, external APIs
- **Feature flags** — Enable/disable functionality
- **Logging levels** — Debug in dev, error in prod
- **Resource limits** — Timeouts, memory caps, concurrency

When configuration is done well, the same code artifact runs everywhere. When it's done poorly, you're editing code to deploy to different environments.

## The Configuration Hierarchy

Configuration comes from multiple sources. Most frameworks use a hierarchy:

```
Priority (highest to lowest):
1. Command-line arguments
2. Environment variables
3. Environment-specific config files (.env.production)
4. Local config files (.env.local, .env)
5. Default config files (config/default.json)
6. Hardcoded defaults in code
```

Higher priority sources override lower ones. This lets you:

- Set sensible defaults in code
- Override defaults in config files
- Override config files for environments
- Override everything with environment variables for deployment

## Environment Variables

The most universal configuration mechanism.

### Reading Environment Variables

```python
import os

# Basic access
database_url = os.environ.get('DATABASE_URL')

# With default
debug_mode = os.environ.get('DEBUG', 'false').lower() == 'true'

# Required (fail fast)
api_key = os.environ['API_KEY']  # Raises KeyError if missing

# Better: explicit validation
def get_required_env(name):
    value = os.environ.get(name)
    if value is None:
        raise ValueError(f"Required environment variable {name} is not set")
    return value
```

```javascript
// Node.js
const databaseUrl = process.env.DATABASE_URL;
const port = parseInt(process.env.PORT || '3000', 10);

// With validation
function requireEnv(name) {
  const value = process.env[name];
  if (!value) {
    throw new Error(`Required environment variable ${name} is not set`);
  }
  return value;
}
```

### Setting Environment Variables

**Shell (temporary):**
```bash
export DATABASE_URL=postgres://localhost:5432/mydb
python app.py
```

**Inline (single command):**
```bash
DATABASE_URL=postgres://localhost:5432/mydb python app.py
```

**Docker:**
```bash
docker run -e DATABASE_URL=postgres://db:5432/mydb myimage
```

**Docker Compose:**
```yaml
services:
  app:
    environment:
      - DATABASE_URL=postgres://db:5432/mydb
    env_file:
      - .env
```

## .env Files

Environment files provide a convenient way to manage environment variables during development.

### Structure

```bash
# .env
# Comments start with #

# Database
DATABASE_URL=postgres://localhost:5432/mydb
DATABASE_POOL_SIZE=10

# External APIs
API_KEY=sk-dev-abc123
API_TIMEOUT=30

# Feature flags
ENABLE_BETA_FEATURES=true
```

### Loading .env Files

**Python (python-dotenv):**
```python
from dotenv import load_dotenv
import os

# Load .env file
load_dotenv()

# Now os.environ has the values
database_url = os.environ.get('DATABASE_URL')
```

**Node.js (dotenv):**
```javascript
require('dotenv').config();

// process.env now has the values
const databaseUrl = process.env.DATABASE_URL;
```

### Environment-Specific Files

Common pattern:

```
.env                  # Shared defaults, committed (no secrets!)
.env.local            # Local overrides, not committed
.env.development      # Development-specific
.env.production       # Production-specific (CI/CD only)
```

Load order (python-dotenv):
```python
from dotenv import load_dotenv

# Load in order, later files override earlier
load_dotenv('.env')  # Defaults
load_dotenv('.env.local', override=True)  # Local overrides
```

### What Goes in .gitignore

```gitignore
# Always ignore files with secrets
.env.local
.env.*.local
.env.production

# Safe to commit (if no secrets)
# .env
# .env.example
```

**Critical:** Never commit files with real credentials. Create `.env.example` with placeholder values for documentation.

```bash
# .env.example (committed)
DATABASE_URL=postgres://user:password@localhost:5432/dbname
API_KEY=your-api-key-here
```

## Configuration Files

For complex configuration, files work better than environment variables.

### Common Formats

**JSON:**
```json
{
  "database": {
    "host": "localhost",
    "port": 5432,
    "name": "mydb"
  },
  "logging": {
    "level": "info",
    "format": "json"
  }
}
```

Pros: Ubiquitous, easy to parse
Cons: No comments, verbose

**YAML:**
```yaml
database:
  host: localhost
  port: 5432
  name: mydb

logging:
  level: info
  format: json
```

Pros: Readable, comments allowed
Cons: Whitespace-sensitive, security concerns with untrusted input

**TOML:**
```toml
[database]
host = "localhost"
port = 5432
name = "mydb"

[logging]
level = "info"
format = "json"
```

Pros: Readable, explicit types, comments
Cons: Less common, nested structures awkward

### Loading Configuration

**Python:**
```python
import json
import yaml
import tomllib  # Python 3.11+

# JSON
with open('config.json') as f:
    config = json.load(f)

# YAML
with open('config.yaml') as f:
    config = yaml.safe_load(f)  # safe_load, not load!

# TOML
with open('config.toml', 'rb') as f:
    config = tomllib.load(f)
```

**Node.js:**
```javascript
const fs = require('fs');
const yaml = require('js-yaml');

// JSON (native)
const config = require('./config.json');

// YAML
const config = yaml.load(fs.readFileSync('./config.yaml', 'utf8'));
```

## Structured Configuration

### Validation

Don't trust configuration. Validate it.

**Python with Pydantic:**
```python
from pydantic import BaseSettings, PostgresDsn

class Settings(BaseSettings):
    database_url: PostgresDsn
    api_key: str
    debug: bool = False
    port: int = 8000

    class Config:
        env_file = '.env'

# Validation happens on instantiation
settings = Settings()  # Raises ValidationError if invalid
```

**Node.js with Zod:**
```javascript
const { z } = require('zod');

const configSchema = z.object({
  DATABASE_URL: z.string().url(),
  API_KEY: z.string().min(1),
  DEBUG: z.coerce.boolean().default(false),
  PORT: z.coerce.number().int().default(8000),
});

const config = configSchema.parse(process.env);
```

### Fail Fast

Applications should fail immediately if configuration is invalid:

```python
def load_config():
    """Load and validate configuration. Fail fast if invalid."""
    try:
        settings = Settings()
    except ValidationError as e:
        print(f"Configuration error: {e}")
        sys.exit(1)
    return settings

# At startup
config = load_config()  # App won't start with bad config
```

Failing at startup is better than failing at runtime when the missing config is first accessed.

## Configuration Anti-Patterns

### Magic Values in Code

```python
# Bad: Magic values scattered in code
def connect_db():
    return psycopg2.connect(
        host="localhost",
        port=5432,
        database="mydb"
    )

# Good: Configuration injected
def connect_db(config):
    return psycopg2.connect(
        host=config.database.host,
        port=config.database.port,
        database=config.database.name
    )
```

### Configuration in the Wrong Layer

```python
# Bad: Business logic knows about environment
def calculate_tax(amount):
    if os.environ.get('ENV') == 'production':
        rate = 0.08
    else:
        rate = 0.0
    return amount * rate

# Good: Rate is configuration, passed in
def calculate_tax(amount, tax_rate):
    return amount * tax_rate
```

### Mixing Secrets and Configuration

```yaml
# Bad: Secrets mixed with config
database:
  host: localhost
  password: supersecret123

# Good: Secrets referenced, not embedded
database:
  host: localhost
  password: ${DATABASE_PASSWORD}  # Resolved at runtime
```

### Environment Sprawl

```python
# Bad: Checking environment everywhere
if os.environ.get('ENV') == 'production':
    # production code
elif os.environ.get('ENV') == 'staging':
    # staging code
else:
    # development code

# Good: Behavior controlled by specific config, not environment name
if config.enable_email_sending:
    send_email(...)
```

The environment name should select which configuration to load. The configuration itself should control behavior.

## Feature Flags

Feature flags let you enable/disable functionality without deploying new code.

### Simple Implementation

```python
class FeatureFlags:
    def __init__(self):
        self.flags = {
            'new_checkout': os.environ.get('FF_NEW_CHECKOUT', 'false') == 'true',
            'beta_search': os.environ.get('FF_BETA_SEARCH', 'false') == 'true',
        }

    def is_enabled(self, flag_name):
        return self.flags.get(flag_name, False)

flags = FeatureFlags()

if flags.is_enabled('new_checkout'):
    use_new_checkout()
else:
    use_old_checkout()
```

### When to Use Feature Flags

- **Gradual rollouts** — Enable for 10% of users, then 50%, then 100%
- **Kill switches** — Disable problematic features without deploying
- **A/B testing** — Different experiences for different users
- **Trunk-based development** — Merge incomplete features behind flags

### Feature Flag Hygiene

Flags are technical debt. Manage them:

```python
# Document flags with expiration
FEATURE_FLAGS = {
    'new_checkout': {
        'description': 'New checkout flow',
        'owner': 'payments-team',
        'expires': '2024-06-01',  # Remove by this date
    }
}
```

Remove flags when features are fully rolled out. Stale flags accumulate and obscure code.

## Environment Parity

Development, staging, and production should be as similar as possible.

### The Parity Principle

| Aspect | Development | Production |
|--------|-------------|------------|
| Database | Same version | Same version |
| Services | Same services (containerized) | Same services |
| Configuration | Different values | Different values |
| Structure | Same structure | Same structure |

The *values* differ (different URLs, different credentials). The *structure* should be identical.

### Docker for Parity

```yaml
# docker-compose.yml
services:
  app:
    build: .
    environment:
      - DATABASE_URL=postgres://db:5432/mydb
  db:
    image: postgres:15  # Same version as production
```

The same Dockerfile, same database version, same service architecture. Only configuration differs.

## The Graybeard's Take

I've seen configuration done every possible way. The worst is when configuration is scattered—some in code, some in files, some in environment variables, some in a database, with no clear hierarchy.

The best configuration systems are boring. Environment variables for simple cases. Validated, typed configuration objects for complex cases. Clear separation between what's code and what's configuration. Fail-fast on invalid configuration.

Configuration is one of those things that seems simple until it isn't. A few hardcoded values become dozens, then hundreds. By the time you realize you need a system, you've already built three incompatible half-systems.

Start with a clear pattern. Load configuration in one place. Validate it. Pass it explicitly to the code that needs it. When you need more complexity—feature flags, dynamic config, per-user settings—you'll have a foundation to build on.

---

## Quick Reference

### Configuration Sources

| Source | Use For | Secrets OK? |
|--------|---------|-------------|
| Code defaults | Sensible fallbacks | Never |
| Config files | Complex structure | No (committed) |
| .env files | Developer convenience | Local only |
| Environment vars | Deployment config | Yes (not logged) |
| Secrets managers | Sensitive data | Yes |

### Validation Checklist

- [ ] All required configuration is validated at startup
- [ ] Invalid configuration fails fast with clear errors
- [ ] Types are validated (not just presence)
- [ ] Secrets are not logged or exposed in errors
- [ ] Default values are documented

### Environment Variable Naming

```bash
# Use prefixes for grouping
DB_HOST=localhost
DB_PORT=5432
DB_NAME=mydb

API_KEY=abc123
API_TIMEOUT=30

FF_NEW_FEATURE=true  # Feature flags
```

Convention: UPPER_SNAKE_CASE, prefixed by component.
