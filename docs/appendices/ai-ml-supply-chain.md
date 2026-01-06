# AI/ML Supply Chain

Machine learning adds new dimensions to the supply chain: models, datasets, training pipelines, and inference frameworks. Each is a dependency that can fail, be compromised, or disappear.

!!! terminal "Downloading Weights from Strangers"
    You're downloading model weights from strangers on the internet and running them on your machine. Think about that for a moment. That Hugging Face model could have been trained on anything by anyone. Pickle files can execute arbitrary code. Datasets might contain poisoned examples designed to create backdoors. ML supply chain is the Wild West—all the software supply chain problems plus entirely new categories of risk.

---

## The ML Dependency Stack

Traditional software has code dependencies. ML has more:

| Layer | Examples | Risks |
|-------|----------|-------|
| **Code** | PyTorch, TensorFlow, scikit-learn | Same as any software |
| **Models** | GPT-2, ResNet, BERT | Provenance, poisoning, bias |
| **Datasets** | ImageNet, Common Crawl | Bias, licensing, privacy |
| **Compute** | CUDA, cuDNN, hardware | Availability, reproducibility |
| **Weights** | Pre-trained parameters | Integrity, versioning |

Each layer can introduce vulnerabilities, biases, and failure modes.

## Model Supply Chain

### Where Models Come From

**Hugging Face Hub:** Largest collection of open models. Anyone can upload.

**Official releases:** Model authors publish directly (OpenAI, Meta, Google).

**Third-party training:** Someone else trained it on unknown data.

### Model Risks

**Provenance unknown:** Who trained this? On what data? With what objectives?

**Poisoning attacks:** Models can be trained to behave maliciously on specific inputs while appearing normal on others.[^poisoning]

**Backdoors:** Hidden behaviors triggered by specific patterns.

**Weight tampering:** Modified weights after training.

**Bias:** Models inherit biases from training data.

### Model Verification

**Checksums:** Verify downloaded weights match expected hashes.

```python
import hashlib

def verify_model(filepath, expected_hash):
    sha256 = hashlib.sha256()
    with open(filepath, 'rb') as f:
        for chunk in iter(lambda: f.read(4096), b''):
            sha256.update(chunk)
    return sha256.hexdigest() == expected_hash
```

**Provenance documentation:** Require model cards with training details.

```yaml
# Model Card (modelcard.yaml)
model_name: my-model
training_data:
  - dataset: imagenet-1k
    version: "2012"
    license: custom-academic
training_compute: 8x A100, 72 hours
carbon_footprint: estimated 450 kg CO2
```

**Behavioral testing:** Test models against known-good outputs.

## Dataset Supply Chain

### Dataset Risks

**Privacy leakage:** Training data may contain personal information that models memorize.[^privacy]

**License violations:** Dataset may include copyrighted material.

**Label poisoning:** Incorrect labels degrade model quality.

**Data drift:** Real-world distribution differs from training data.

### Dataset Best Practices

**Version your datasets:**

```bash
# Using DVC
dvc add data/training/
git add data/training.dvc
git commit -m "Dataset v2.0"
```

**Document provenance:**

```yaml
# data/MANIFEST.yaml
dataset:
  name: customer-transactions
  version: "2.0.0"
  created: "2024-01-15"
  sources:
    - system: transactions-db
      query: "SELECT * FROM transactions WHERE year >= 2023"
      date_extracted: "2024-01-15"
  preprocessing:
    - removed PII columns: [email, phone, address]
    - aggregated to daily level
  validation:
    row_count: 1_250_000
    date_range: "2023-01-01 to 2023-12-31"
```

**Hash datasets:**

```python
import hashlib
import pandas as pd

def hash_dataframe(df):
    return hashlib.sha256(
        pd.util.hash_pandas_object(df).values.tobytes()
    ).hexdigest()
```

## Framework Dependencies

### The Heavy Dependency Problem

ML frameworks have enormous dependency trees:

```bash
# Installing PyTorch can pull in hundreds of packages
pip install torch
# Plus CUDA, cuDNN, NCCL for GPU support
```

### Framework Versioning

```txt
# requirements.txt - pin precisely
torch==2.1.0
torchvision==0.16.0
torchaudio==2.1.0
# These versions must be compatible
```

**PyTorch/CUDA compatibility matrix:**

| PyTorch | CUDA | cuDNN |
|---------|------|-------|
| 2.1.x | 11.8, 12.1 | 8.x |
| 2.0.x | 11.7, 11.8 | 8.x |
| 1.13.x | 11.6, 11.7 | 8.x |

Version mismatches cause silent failures or cryptic errors.

### Native Dependencies

ML often requires native libraries:

```dockerfile
# Dockerfile for ML workloads
FROM nvidia/cuda:12.1-cudnn8-devel-ubuntu22.04

# System dependencies
RUN apt-get update && apt-get install -y \
    python3.11 \
    python3-pip \
    libopenblas-dev \
    libomp-dev

# Python dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt
```

## Reproducibility Challenges

### Sources of Non-Reproducibility

**Hardware differences:** GPU vs CPU, different GPU architectures.

```python
# Results differ between devices
torch.backends.cudnn.deterministic = True
torch.backends.cudnn.benchmark = False
torch.use_deterministic_algorithms(True)
```

**Non-deterministic operations:** Some operations are non-deterministic by design for performance.

```python
# Set seeds everywhere
import random
import numpy as np
import torch

def set_seed(seed):
    random.seed(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)
    torch.cuda.manual_seed_all(seed)
    # For complete reproducibility
    os.environ['CUBLAS_WORKSPACE_CONFIG'] = ':4096:8'
```

**Floating point non-associativity:** (a + b) + c ≠ a + (b + c) in floating point.

### Experiment Tracking

Track everything:

```python
import mlflow

with mlflow.start_run():
    # Log parameters
    mlflow.log_params({
        'learning_rate': 0.001,
        'batch_size': 32,
        'epochs': 100,
        'seed': 42,
    })

    # Log environment
    mlflow.log_artifact('requirements.txt')
    mlflow.log_param('torch_version', torch.__version__)
    mlflow.log_param('cuda_version', torch.version.cuda)

    # Train...

    # Log metrics
    mlflow.log_metrics({
        'accuracy': 0.95,
        'loss': 0.12,
    })

    # Log model
    mlflow.pytorch.log_model(model, 'model')
```

## Security Considerations

### Model Serialization

**Pickle is dangerous:**

```python
# Models are often saved with pickle
torch.save(model, 'model.pt')  # Uses pickle internally

# Pickle can execute arbitrary code on load
# Only load models from trusted sources
```

**Safer alternatives:**

```python
# Save only weights (safer)
torch.save(model.state_dict(), 'weights.pt')

# Load into known architecture
model = MyModel()
model.load_state_dict(torch.load('weights.pt'))
```

### Model Scanning

Some tools scan models for malicious payloads:

```bash
# Fickling - analyze pickle files for code execution
pip install fickling
fickling model.pt

# ModelScan - broader model security scanning
pip install modelscan
modelscan model.pt
```

### Inference Security

**Input validation:**

```python
def predict(input_data):
    # Validate input shape
    if input_data.shape != expected_shape:
        raise ValueError(f"Expected shape {expected_shape}")

    # Validate input range
    if input_data.min() < -1 or input_data.max() > 1:
        raise ValueError("Input must be normalized to [-1, 1]")

    return model(input_data)
```

**Resource limits:**

```python
# Prevent DoS via large inputs
MAX_INPUT_SIZE = 1024 * 1024  # 1MB

def predict_safe(input_data):
    if len(input_data) > MAX_INPUT_SIZE:
        raise ValueError("Input too large")
    # Process...
```

## Model Cards and Documentation

### What to Document

```markdown
# Model Card: sentiment-classifier-v1

## Model Description
- **Model type:** DistilBERT fine-tuned for sentiment classification
- **Training data:** IMDb reviews dataset (50k examples)
- **Intended use:** English movie review sentiment analysis

## Training Details
- **Framework:** PyTorch 2.1.0
- **Training compute:** 1x A100 GPU, 4 hours
- **Hyperparameters:** learning_rate=2e-5, batch_size=16, epochs=3

## Evaluation
| Metric | Value |
|--------|-------|
| Accuracy | 92.5% |
| F1 Score | 0.92 |

## Limitations
- English only
- Trained on movie reviews; may not generalize to other domains
- May exhibit biases present in IMDb reviews

## Ethical Considerations
- Should not be used for decisions affecting individuals
- Review sentiment is subjective; model reflects training data biases
```

### Provenance Chain

Document the full lineage:

```yaml
# provenance.yaml
model:
  name: sentiment-classifier-v1
  version: "1.0.0"
  created: "2024-01-15"

base_model:
  name: distilbert-base-uncased
  source: huggingface
  version: "1.0"
  sha256: abc123...

training_data:
  name: imdb-reviews
  version: "1.0"
  source: huggingface/datasets
  sha256: def456...

dependencies:
  torch: "2.1.0"
  transformers: "4.35.0"
  datasets: "2.15.0"

training:
  script: train.py
  script_sha256: ghi789...
  random_seed: 42
  gpu: "NVIDIA A100"
  duration_hours: 4
```

!!! terminal "Silent Failures"
    ML failures are often silent. A poisoned model still produces outputs—just wrong ones for certain inputs. A biased dataset produces a biased model that seems to work fine until it doesn't. You won't get an error message. You'll get wrong answers that look plausible. Treat ML artifacts with the same skepticism you'd apply to running code from the internet—because that's exactly what they are.

---

## Quick Reference

### ML Dependency Checklist

- [ ] Framework versions pinned (PyTorch, TensorFlow, etc.)
- [ ] CUDA/cuDNN versions documented
- [ ] Model weights verified with checksums
- [ ] Dataset provenance documented
- [ ] Random seeds set and documented
- [ ] Training script versioned
- [ ] Model card created
- [ ] Experiment tracked (MLflow, W&B, etc.)

### Security Checklist

- [ ] Models from trusted sources only
- [ ] Avoid loading pickled objects from untrusted sources
- [ ] Input validation for inference
- [ ] Resource limits for inference
- [ ] Model scanned for malicious payloads

### Reproducibility Checklist

- [ ] All random seeds set
- [ ] Deterministic mode enabled
- [ ] Hardware requirements documented
- [ ] Exact package versions in requirements.txt
- [ ] Dataset version pinned
- [ ] Training logs preserved

---

[^poisoning]: See [BadNets: Identifying Vulnerabilities in the Machine Learning Model Supply Chain](../reference/sources.md#ml-security)
[^privacy]: See [Extracting Training Data from Large Language Models](../reference/sources.md#ml-privacy)
