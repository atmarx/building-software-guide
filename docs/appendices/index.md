# Appendices

Ecosystem-specific guidance and special topics that don't fit neatly into the main chapters.

!!! terminal "Same Problems, Different Syntax"
    Different ecosystems, same problems. I've worked in all of these. The tools change—npm, pip, cargo, go get—but the underlying challenges don't. Lock your dependencies. Scan for vulnerabilities. Know what you're running. The syntax is different; the discipline is the same.

## Ecosystem Guides

Different languages and package managers have different conventions, tools, and pitfalls.

<div class="grid cards two-column" markdown>

-   :material-nodejs:{ .lg .middle } **[Node.js/npm](node-npm.md)**

    ---

    Lock files, npm audit, provenance and signing, the npm ecosystem's particular challenges.

-   :material-language-python:{ .lg .middle } **[Python](python.md)**

    ---

    pip vs. pip-tools vs. Poetry vs. uv, virtual environments, the fragmented packaging landscape.

-   :material-language-go:{ .lg .middle } **[Go](go.md)**

    ---

    The module system, vendoring, go.sum verification, Go's distinctive approach.

-   :material-language-rust:{ .lg .middle } **[Rust](rust.md)**

    ---

    Cargo.lock handling, the crates.io trust model, build determinism.

</div>

## Special Topics

<div class="grid cards two-column" markdown>

-   :material-robot:{ .lg .middle } **[AI/ML Supply Chain](ai-ml-supply-chain.md)**

    ---

    Pre-trained models are dependencies too. Model provenance, dataset licensing, pickle risks, and ML supply chain challenges.

-   :material-flask:{ .lg .middle } **[For Researchers](for-researchers.md)**

    ---

    Reproducible research software, working solo, grant-funded sustainability, and academic code challenges.

</div>

## A Note on Ecosystem Guides

These appendices provide ecosystem-specific detail, but the principles are universal:

- Lock your dependencies
- Scan for vulnerabilities
- Understand what you're installing
- Update deliberately

The tools differ. The patterns don't.

If your ecosystem isn't covered here, apply the concepts from the main guide and consult your ecosystem's documentation. The fundamentals transfer.
