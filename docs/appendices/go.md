# Go

Go's module system is refreshingly simple compared to other ecosystems. This appendix covers Go's approach to dependency management.

---

## Go Modules

Since Go 1.11, modules are the standard for dependency management. A module is a collection of packages with a `go.mod` file.

### Module Basics

```bash
# Initialize a module
go mod init github.com/you/project

# This creates go.mod
```

```go
// go.mod
module github.com/you/project

go 1.21

require (
    github.com/gin-gonic/gin v1.9.1
    github.com/lib/pq v1.10.9
)
```

### Adding Dependencies

Dependencies are added automatically when you import them:

```go
// main.go
import "github.com/gin-gonic/gin"
```

```bash
# This downloads and adds to go.mod
go mod tidy
```

Or explicitly:

```bash
go get github.com/gin-gonic/gin@v1.9.1
```

### The Two Lock Files

**go.mod:** What you depend on (like package.json).

**go.sum:** Cryptographic hashes of dependencies (like package-lock.json).

```
// go.sum
github.com/gin-gonic/gin v1.9.1 h1:...
github.com/gin-gonic/gin v1.9.1/go.mod h1:...
```

**Always commit both files.**

## Version Selection

Go uses Minimal Version Selection (MVS): if multiple dependencies require the same module, Go selects the *minimum* version that satisfies all requirements.

```
Your project requires:
  - A requires X >= 1.0
  - B requires X >= 1.2

Go selects X 1.2 (minimum that satisfies both)
```

This is deterministic and avoids the "I got a different version" problem.

### Version Specifiers

```bash
# Latest version
go get github.com/pkg/errors@latest

# Specific version
go get github.com/pkg/errors@v0.9.1

# Specific commit
go get github.com/pkg/errors@abc123

# Branch (usually avoid)
go get github.com/pkg/errors@main
```

### Updating Dependencies

```bash
# Update all dependencies
go get -u ./...

# Update specific dependency
go get -u github.com/gin-gonic/gin

# Update to specific version
go get github.com/gin-gonic/gin@v1.9.1

# Update only patch versions
go get -u=patch ./...
```

## Security

### Checksum Database

Go verifies downloads against a checksum database (sum.golang.org):

```bash
# go.sum contains hashes
github.com/gin-gonic/gin v1.9.1 h1:4+fr/el88TOO3ewCmQr8cx/CtZ/umlIRIs5M4NTNjf8=
```

If someone compromises a module, the hash won't match. The download fails.

### Vulnerability Scanning

```bash
# Built-in vulnerability scanner (Go 1.18+)
go install golang.org/x/vuln/cmd/govulncheck@latest
govulncheck ./...
```

Output shows:
- Which vulnerabilities affect your code
- Whether vulnerable code paths are actually reachable

### Private Modules

For private repositories:

```bash
# Set GOPRIVATE
go env -w GOPRIVATE=github.com/yourorg/*

# Or in environment
export GOPRIVATE=github.com/yourorg/*
```

This skips the checksum database for private modules (it can't verify them anyway).

## Dependency Management

### Viewing Dependencies

```bash
# List all dependencies
go list -m all

# Why is this dependency here?
go mod why -m github.com/some/dependency

# Dependency graph
go mod graph
```

### Cleaning Up

```bash
# Remove unused dependencies, add missing ones
go mod tidy

# Verify dependencies match go.sum
go mod verify
```

### Vendoring

Go supports vendoring (copying dependencies into your repo):

```bash
# Create vendor directory
go mod vendor

# Build using vendored dependencies
go build -mod=vendor
```

**When to vendor:**

- Reproducibility requirements (can build offline)
- Compliance requirements (audit all code)
- CI performance (no downloads)

**When not to:**

- Most projects—module system is sufficient
- Rapid development (vendor sync overhead)

## Module Proxies

### The Proxy Chain

By default, Go downloads through proxy.golang.org:

```
Your machine → proxy.golang.org → GitHub/etc.
```

Benefits:
- Faster downloads (cached)
- Immutability (once published, can't change)
- Availability (survives if source goes down)

### Private Proxies

For organizations:

```bash
# Use private proxy for your org
export GOPROXY="https://proxy.yourorg.com,https://proxy.golang.org,direct"
export GONOSUMDB="github.com/yourorg/*"
```

### Direct Downloads

```bash
# Skip proxy entirely
export GOPROXY=direct
```

Use for private modules or when the proxy is unavailable.

## Common Patterns

### Replacing Dependencies

For forks or local development:

```go
// go.mod
replace github.com/original/module => github.com/yourfork/module v1.0.0

// Or local path
replace github.com/original/module => ../local-module
```

**Remove replacements before publishing.**

### Excluding Versions

Block specific versions:

```go
// go.mod
exclude github.com/broken/module v1.2.0
```

### Retracting Versions

If you maintain a module and release a bad version:

```go
// go.mod (of your module)
retract (
    v1.0.0 // Security vulnerability
    [v1.1.0, v1.1.5] // Broken range
)
```

## Building and Compilation

### Reproducible Builds

Go builds are reproducible by default:

```bash
# Same inputs → same binary
go build -trimpath -o app .

# Verify
sha256sum app
```

The `-trimpath` flag removes machine-specific paths.

### Static Binaries

Go produces static binaries by default (usually):

```bash
# Fully static (for alpine/scratch containers)
CGO_ENABLED=0 go build -o app .
```

No runtime dependencies. The binary is the deployment artifact.

### Cross-Compilation

```bash
# Build for Linux from macOS
GOOS=linux GOARCH=amd64 go build -o app-linux .

# Build for Windows
GOOS=windows GOARCH=amd64 go build -o app.exe .
```

## CI Integration

```yaml
# GitHub Actions
name: Go

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Go
        uses: actions/setup-go@v4
        with:
          go-version: '1.21'

      - name: Download dependencies
        run: go mod download

      - name: Build
        run: go build -v ./...

      - name: Test
        run: go test -v ./...

      - name: Vulnerability scan
        run: |
          go install golang.org/x/vuln/cmd/govulncheck@latest
          govulncheck ./...
```

## Best Practices Checklist

- [ ] `go.mod` and `go.sum` committed
- [ ] Run `go mod tidy` before commits
- [ ] `govulncheck` in CI pipeline
- [ ] GOPRIVATE set for private repos
- [ ] No `replace` directives in published modules
- [ ] Pin Go version in CI

## Quick Reference

### Essential Commands

```bash
go mod init module-name      # Initialize module
go mod tidy                   # Clean up dependencies
go get package@version        # Add/update dependency
go mod verify                 # Verify checksums
govulncheck ./...             # Vulnerability scan
go mod graph                  # View dependency graph
go mod why -m package         # Why is this a dependency?
```

### Version Selectors

| Selector | Meaning |
|----------|---------|
| `@latest` | Latest release |
| `@v1.2.3` | Specific version |
| `@abc123` | Specific commit |
| `@main` | Branch tip (avoid) |

### Environment Variables

| Variable | Purpose |
|----------|---------|
| `GOPROXY` | Module proxy URL |
| `GOPRIVATE` | Private module patterns |
| `GONOSUMDB` | Skip checksum DB for these |
| `GOFLAGS` | Default flags for go commands |
