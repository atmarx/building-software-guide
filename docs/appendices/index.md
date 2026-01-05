# Appendices

Ecosystem-specific guidance and special topics that don't fit neatly into the main chapters.

## Ecosystem Guides

Different languages and package managers have different conventions, tools, and pitfalls. These guides cover the specifics:

- **[Node.js/npm](nodejs.md)** — Lock files, npm audit, provenance and signing, the npm ecosystem's particular challenges.

- **[Python](python.md)** — pip vs. pip-tools vs. Poetry vs. uv, virtual environments, the fragmented Python packaging landscape.

- **[Go](go.md)** — The module system, vendoring, go.sum verification, Go's distinctive approach.

- **[Rust](rust.md)** — Cargo.lock handling, the crates.io trust model, build determinism.

## Special Topics

- **[AI/ML Supply Chain](ai-ml-supply-chain.md)** — Pre-trained models are dependencies too. Model provenance, dataset licensing, Hugging Face trust model, pickle deserialization risks, and the emerging challenges of ML supply chain.

- **[For Researchers](researchers.md)** — Reproducible research software, working solo, grant-funded software sustainability, and the particular challenges of academic code.

## A Note on Ecosystem Guides

These appendices provide ecosystem-specific detail, but the principles are universal:

- Lock your dependencies
- Scan for vulnerabilities
- Understand what you're installing
- Update deliberately

The tools differ. The patterns don't.

If your ecosystem isn't covered here, apply the concepts from the main guide and consult your ecosystem's documentation. The fundamentals transfer.
