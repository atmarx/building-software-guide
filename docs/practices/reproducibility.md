# Reproducibility

"It worked yesterday" is not a debugging strategy. Reproducibility means getting the same results from the same inputs—today, tomorrow, and five years from now. This chapter covers how to achieve it.

---

## What Reproducibility Means

Reproducibility has different levels:

| Level | Definition | Example |
|-------|------------|---------|
| **Same machine** | Same results when you run it again | "I ran it twice, same output" |
| **Same environment** | Same results on identical setups | "My colleague's container got the same results" |
| **Different environment** | Same results on different systems | "It works on Linux and macOS" |
| **Future** | Same results months or years later | "We can verify the 2023 analysis in 2026" |

Each level is harder than the last. Most software achieves the first. Research and regulated environments often need the last.

## Sources of Non-Reproducibility

### Floating Dependencies

```bash
# requirements.txt
pandas>=2.0

# Today: resolves to pandas 2.0.3
# Tomorrow: might resolve to pandas 2.1.0 (different behavior)
```

Without pinned versions, you're not specifying what you depend on—you're making a wish.

**Fix: Lock files.**

```bash
# Use pip-tools, Poetry, or uv
pip-compile requirements.in > requirements.txt
# requirements.txt now has exact versions
```

See [Versioning and Lock Files](../concepts/versioning-and-lockfiles.md) for details.

### System Dependencies

Your code might work because of system libraries you didn't notice:

```python
# Works on your machine because libssl 1.1 is installed
# Fails on colleague's machine with libssl 3.0
import ssl
```

**Fix: Containerization or explicit documentation.**

```dockerfile
FROM python:3.11-slim
# Explicit system dependencies
RUN apt-get update && apt-get install -y libssl1.1
```

### Randomness

ML training, simulations, testing—many processes involve randomness.

```python
# Non-reproducible
import random
result = random.choice([1, 2, 3, 4, 5])

# Reproducible
import random
random.seed(42)
result = random.choice([1, 2, 3, 4, 5])  # Always 1
```

**Fix: Seed random number generators.**

```python
import numpy as np
import random
import torch

def set_seed(seed):
    random.seed(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)
    if torch.cuda.is_available():
        torch.cuda.manual_seed_all(seed)
```

Document which seed was used for any published results.

### Timestamps and Dates

```python
# Non-reproducible
from datetime import datetime
timestamp = datetime.now()

# Test passes on Monday, fails on Tuesday
def is_business_day():
    return datetime.now().weekday() < 5
```

**Fix: Inject time dependencies.**

```python
def is_business_day(current_time=None):
    if current_time is None:
        current_time = datetime.now()
    return current_time.weekday() < 5

# Testable
assert is_business_day(datetime(2024, 1, 15)) == True  # Monday
```

### Parallel Execution

```python
# Results depend on execution order
results = []
with ThreadPoolExecutor() as executor:
    futures = [executor.submit(process, item) for item in items]
    for future in futures:
        results.append(future.result())  # Order not guaranteed
```

**Fix: Maintain deterministic ordering.**

```python
# Collect results with original indices
results = [None] * len(items)
with ThreadPoolExecutor() as executor:
    futures = {executor.submit(process, item): i for i, item in enumerate(items)}
    for future in as_completed(futures):
        results[futures[future]] = future.result()
```

### External Dependencies

```python
# Results depend on external API
response = requests.get("https://api.weather.com/current")
temperature = response.json()['temp']
```

**Fix: Cache or mock external calls.**

```python
# Cache responses
@lru_cache
def get_weather(location, date):
    # Same inputs = same outputs
    return cached_weather_data.get((location, date))
```

## Reproducibility Strategies

### Pin Everything

The nuclear option: pin every version of everything.

```bash
# Python: Full pin with hashes
pip-compile --generate-hashes requirements.in

# Node: Use npm ci with package-lock.json
npm ci

# Docker: Pin base image by digest
FROM python:3.11-slim@sha256:abc123...
```

**Pros:** Maximum reproducibility
**Cons:** Security updates require explicit action

### Lock Files + Documented Environment

The practical middle ground:

```
project/
├── requirements.in       # What you want
├── requirements.txt      # What you got (locked)
├── Dockerfile           # Environment specification
├── .python-version      # Runtime version
└── ENVIRONMENT.md       # What's not captured
```

```markdown
# ENVIRONMENT.md

## System Requirements
- Ubuntu 22.04 LTS or macOS 13+
- Python 3.11.x
- 8GB RAM minimum

## Known Dependencies
- CUDA 11.8 required for GPU support
- libffi-dev required for cffi package

## Reproducibility Notes
- RNG seed: 42 for all published results
- Data version: dataset-v2.3.0
```

### Containers for Full Isolation

Containers capture the entire runtime environment:

```dockerfile
FROM python:3.11-slim

# System dependencies
RUN apt-get update && apt-get install -y \
    libffi-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Application
COPY . /app
WORKDIR /app
```

**Build and tag:**
```bash
docker build -t myproject:v1.0.0 .
docker push myregistry/myproject:v1.0.0
```

The image is a snapshot. `myproject:v1.0.0` will behave the same today and in five years.

## Research Reproducibility

Research has additional reproducibility requirements: the ability to verify results, replicate experiments, and build on prior work.[^papers]

### Data Versioning

Code is versioned by git. Data needs versioning too.

**DVC (Data Version Control):**
```bash
# Track large files
dvc add data/raw/dataset.csv

# Creates data/raw/dataset.csv.dvc (pointer file)
# Actual data stored in remote storage

git add data/raw/dataset.csv.dvc
git commit -m "Add dataset v1.0"
```

**Manual versioning:**
```
data/
├── raw/
│   └── v1.0/
│       ├── dataset.csv
│       └── MANIFEST.md
└── processed/
    └── v1.0/
        ├── features.parquet
        └── MANIFEST.md
```

### Experiment Tracking

Track what you ran and what you got:

```python
# Using MLflow
import mlflow

with mlflow.start_run():
    mlflow.log_param("learning_rate", 0.01)
    mlflow.log_param("epochs", 100)
    mlflow.log_param("seed", 42)

    # Train model...

    mlflow.log_metric("accuracy", 0.95)
    mlflow.log_artifact("model.pkl")
```

Every run is logged with parameters, metrics, and artifacts.

### Dependency Snapshots

For publications, capture the exact environment:

```bash
# Full dependency list
pip freeze > requirements-frozen.txt

# Python version
python --version > python-version.txt

# System info
uname -a > system-info.txt
lscpu >> system-info.txt

# Create reproducibility bundle
tar -czvf reproducibility-bundle.tar.gz \
    requirements-frozen.txt \
    python-version.txt \
    system-info.txt \
    src/ \
    data/processed/
```

Archive this with the publication.

### Workflow Managers

For complex pipelines, use workflow managers:

**Snakemake:**
```python
# Snakefile
rule process_data:
    input: "data/raw/input.csv"
    output: "data/processed/output.csv"
    shell: "python scripts/process.py {input} {output}"

rule train_model:
    input: "data/processed/output.csv"
    output: "models/model.pkl"
    shell: "python scripts/train.py {input} {output}"
```

**Nextflow, Luigi, Airflow:** Similar concepts, different ecosystems.

Workflow managers track dependencies between steps, enabling partial re-runs and parallel execution.

## Testing Reproducibility

### Reproducibility Tests

Add tests that verify reproducibility:

```python
def test_model_training_reproducible():
    """Same seed should produce same model."""
    set_seed(42)
    model1 = train_model(data)

    set_seed(42)
    model2 = train_model(data)

    assert np.allclose(model1.weights, model2.weights)
```

### Determinism Checks

```python
def test_function_deterministic():
    """Same inputs should produce same outputs."""
    input_data = load_test_data()

    result1 = process(input_data)
    result2 = process(input_data)

    assert result1 == result2
```

### Environment Parity Tests

```bash
#!/bin/bash
# test_reproducibility.sh

# Run in container
docker run --rm myproject:v1.0.0 python tests/reproducibility.py

# Run locally
python tests/reproducibility.py

# Compare outputs
diff output_container.txt output_local.txt
```

## Documentation for Reproducibility

### README Requirements Section

```markdown
## Requirements

- Python 3.11.x (tested with 3.11.4)
- 16GB RAM for full dataset processing
- NVIDIA GPU with CUDA 11.8 for training (CPU fallback available)

## Installation

```bash
# Clone with submodules
git clone --recurse-submodules https://github.com/user/project.git

# Create environment
python -m venv venv
source venv/bin/activate

# Install locked dependencies
pip install -r requirements.txt
```

## Reproducing Results

```bash
# Set seed for reproducibility
export RANDOM_SEED=42

# Run experiment
python src/train.py --config configs/paper_experiment.yaml
```

Expected output: accuracy ~0.95 ± 0.01
```

### CITATION.cff

For academic work, include citation information:

```yaml
cff-version: 1.2.0
message: "If you use this software, please cite it as below."
authors:
  - family-names: "Smith"
    given-names: "Jane"
title: "My Research Project"
version: 1.0.0
date-released: 2024-01-15
url: "https://github.com/user/project"
```

## The Graybeard's Take

I've seen too many projects where "reproducing the results" required the original author's machine, because only that machine had the exact right combination of dependencies, system libraries, and environment quirks.

Reproducibility isn't just about scientific integrity—though that matters. It's about being able to debug your own work six months from now. It's about onboarding new team members without a week of "it works on my machine" conversations. It's about not rebuilding your environment from scratch every time you get a new laptop.

The effort you put into reproducibility pays for itself. Lock your dependencies. Document your environment. Seed your randomness. Your future self will thank you—and so will everyone who tries to build on your work.

---

## Quick Reference

### Reproducibility Checklist

- [ ] Dependencies locked (lock file committed)
- [ ] Runtime version pinned (.python-version, .nvmrc, etc.)
- [ ] Random seeds documented and set
- [ ] System dependencies documented
- [ ] Data versioned or archived
- [ ] Environment documented (OS, hardware requirements)
- [ ] Reproducibility tested

### Common Reproducibility Killers

| Issue | Solution |
|-------|----------|
| Floating dependencies | Lock files |
| System library differences | Containers |
| Random variation | Seed RNGs |
| Timestamp dependencies | Inject time |
| External API calls | Cache or mock |
| Parallel non-determinism | Deterministic ordering |
| Hardware differences | Document requirements |

### Tools by Ecosystem

| Language | Lock File Tool | Version Manager |
|----------|---------------|-----------------|
| Python | pip-tools, Poetry, uv | pyenv, mise |
| Node.js | npm (package-lock.json) | nvm, mise |
| Ruby | Bundler | rbenv, mise |
| Rust | Cargo (Cargo.lock) | rustup |
| Go | go.mod, go.sum | Built-in |

---

[^papers]: See [Toward Reproducible Research](../reference/sources.md#reproducibility)
