# Rust

Rust's Cargo is often cited as one of the best package managers in any ecosystem. This appendix covers Cargo's dependency management, security features, and best practices.

---

## Cargo Fundamentals

Cargo handles building, testing, publishing, and dependency management.

### Project Structure

```
my-project/
├── Cargo.toml      # Package manifest
├── Cargo.lock      # Locked versions
├── src/
│   └── main.rs     # Binary entry point (or lib.rs for libraries)
└── target/         # Build artifacts (not committed)
```

### Cargo.toml

```toml
[package]
name = "my-project"
version = "0.1.0"
edition = "2021"
authors = ["You <you@example.com>"]
license = "MIT"
description = "What this does"
repository = "https://github.com/you/my-project"

[dependencies]
serde = "1.0"
tokio = { version = "1.0", features = ["full"] }
reqwest = { version = "0.11", default-features = false, features = ["json"] }

[dev-dependencies]
criterion = "0.5"

[build-dependencies]
cc = "1.0"
```

### Dependency Types

| Section | Purpose |
|---------|---------|
| `[dependencies]` | Runtime dependencies |
| `[dev-dependencies]` | Tests, benchmarks, examples |
| `[build-dependencies]` | Build scripts (build.rs) |

## Version Specification

### Caret Requirements (Default)

```toml
# ^1.2.3 means >=1.2.3 and <2.0.0
serde = "1.2.3"
serde = "^1.2.3"  # Explicit, same meaning
```

The default `^` allows updates that don't break semver:

| Specifier | Allows |
|-----------|--------|
| `^1.2.3` | `>=1.2.3, <2.0.0` |
| `^0.2.3` | `>=0.2.3, <0.3.0` |
| `^0.0.3` | `>=0.0.3, <0.0.4` |

### Other Specifiers

```toml
# Tilde: patch updates only
serde = "~1.2.3"  # >=1.2.3, <1.3.0

# Wildcard
serde = "1.*"     # >=1.0.0, <2.0.0

# Exact
serde = "=1.2.3"  # Only 1.2.3

# Comparison
serde = ">=1.2, <1.5"
```

### Cargo.lock

The lock file records exact versions resolved:

```toml
[[package]]
name = "serde"
version = "1.0.188"
source = "registry+https://github.com/rust-lang/crates.io-index"
checksum = "cf9e0fcba69a370ber..."
dependencies = [
 "serde_derive",
]
```

**Commit Cargo.lock for:**
- Applications
- End-user binaries

**Don't commit for:**
- Libraries (let consumers resolve their own versions)

## Features

Cargo features enable conditional compilation and optional dependencies.

### Defining Features

```toml
[features]
default = ["json"]
json = ["dep:serde_json"]
async = ["tokio", "async-trait"]

[dependencies]
serde_json = { version = "1.0", optional = true }
tokio = { version = "1.0", optional = true }
async-trait = { version = "0.1", optional = true }
```

### Using Features

```toml
# Enable specific features
tokio = { version = "1.0", features = ["rt-multi-thread", "macros"] }

# Disable default features
serde = { version = "1.0", default-features = false, features = ["derive"] }
```

```bash
# Build with feature
cargo build --features async

# Build without default features
cargo build --no-default-features
```

## Security

### cargo-audit

```bash
# Install
cargo install cargo-audit

# Scan for vulnerabilities
cargo audit

# JSON output
cargo audit --json
```

Output references the RustSec Advisory Database.

### cargo-deny

More comprehensive checking:

```bash
# Install
cargo install cargo-deny

# Create config
cargo deny init

# Check
cargo deny check
```

```toml
# deny.toml
[advisories]
vulnerability = "deny"
unmaintained = "warn"

[licenses]
allow = ["MIT", "Apache-2.0"]
deny = ["GPL-3.0"]

[bans]
multiple-versions = "warn"
deny = [
    { name = "openssl" },  # Prefer rustls
]
```

### cargo-vet

Supply chain auditing:

```bash
cargo install cargo-vet

# Initialize
cargo vet init

# Check audit status
cargo vet

# Trust specific crates
cargo vet certify crate-name version
```

Tracks which dependencies have been audited.

## Workspaces

For multi-crate projects:

```toml
# Root Cargo.toml
[workspace]
members = [
    "crate-a",
    "crate-b",
    "crate-c",
]

[workspace.dependencies]
serde = "1.0"
tokio = "1.0"
```

```toml
# crate-a/Cargo.toml
[package]
name = "crate-a"
version = "0.1.0"

[dependencies]
serde = { workspace = true }  # Uses workspace version
```

Benefits:
- Shared dependency versions
- Single Cargo.lock for whole workspace
- Shared target directory

## Build Optimization

### Release Builds

```bash
# Debug build (fast compile, slow run)
cargo build

# Release build (slow compile, fast run)
cargo build --release
```

### Profile Configuration

```toml
# Cargo.toml
[profile.release]
lto = true          # Link-time optimization
codegen-units = 1   # Better optimization
panic = "abort"     # Smaller binary
strip = true        # Remove symbols
```

### Minimizing Binary Size

```toml
[profile.release]
opt-level = "z"     # Optimize for size
lto = true
codegen-units = 1
panic = "abort"
strip = true
```

## Publishing to crates.io

### Preparation

```toml
[package]
name = "my-crate"
version = "1.0.0"
edition = "2021"
license = "MIT OR Apache-2.0"  # Required
description = "..."             # Required
repository = "https://..."      # Recommended
documentation = "https://..."   # Recommended
readme = "README.md"
keywords = ["keyword1", "keyword2"]
categories = ["category"]
```

### Publishing

```bash
# Login (once)
cargo login

# Dry run
cargo publish --dry-run

# Publish
cargo publish
```

**Once published, versions can't be deleted.** You can only yank them (hide from new dependency resolution).

```bash
cargo yank --version 1.0.0
cargo yank --version 1.0.0 --undo
```

## CI Integration

```yaml
# GitHub Actions
name: Rust

on: [push, pull_request]

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Rust
        uses: dtolnay/rust-toolchain@stable

      - name: Cache
        uses: Swatinem/rust-cache@v2

      - name: Check
        run: cargo check

      - name: Test
        run: cargo test

      - name: Clippy
        run: cargo clippy -- -D warnings

      - name: Format
        run: cargo fmt -- --check

      - name: Audit
        run: |
          cargo install cargo-audit
          cargo audit
```

## Common Commands

```bash
# Build
cargo build
cargo build --release

# Test
cargo test
cargo test --release

# Run
cargo run
cargo run --release

# Documentation
cargo doc --open

# Linting
cargo clippy

# Formatting
cargo fmt

# Update dependencies
cargo update

# Check without building
cargo check

# Tree of dependencies
cargo tree

# Why is this dependency included?
cargo tree -i package-name
```

## Best Practices Checklist

- [ ] Cargo.lock committed (for binaries)
- [ ] Minimal feature sets enabled
- [ ] `cargo audit` in CI
- [ ] `cargo clippy` in CI
- [ ] `cargo fmt` enforced
- [ ] Edition up to date (2021)
- [ ] License and description for published crates

## Quick Reference

### Version Specifiers

| Specifier | Meaning |
|-----------|---------|
| `"1.2.3"` or `"^1.2.3"` | `>=1.2.3, <2.0.0` |
| `"~1.2.3"` | `>=1.2.3, <1.3.0` |
| `"1.*"` | `>=1.0.0, <2.0.0` |
| `"=1.2.3"` | Exactly `1.2.3` |
| `">=1.2, <1.5"` | Range |

### Essential Commands

```bash
cargo build             # Compile
cargo test              # Run tests
cargo check             # Fast compilation check
cargo clippy            # Linting
cargo fmt               # Format code
cargo audit             # Security audit
cargo tree              # Dependency tree
cargo update            # Update Cargo.lock
```

### Feature Syntax

```toml
# Enable features
dep = { version = "1.0", features = ["a", "b"] }

# Disable defaults
dep = { version = "1.0", default-features = false }

# Optional dependency
dep = { version = "1.0", optional = true }
```
