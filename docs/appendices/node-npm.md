# Node.js and npm

Node.js and npm form one of the largest software ecosystems. This appendix covers npm-specific dependency management, security practices, and common pitfalls.

---

## The npm Ecosystem

npm hosts over 2 million packages. This abundance is both a strength and a risk—there's a package for everything, but quality varies wildly.

### Package Sources

**npm registry (registry.npmjs.org):** The default public registry. Anyone can publish.

**Scoped packages:** `@organization/package-name`. Can be public or private. Provides namespace protection.

**Private registries:** Enterprise alternatives (Artifactory, Verdaccio, npm Enterprise).

### Package Anatomy

```
my-package/
├── package.json        # Metadata, dependencies
├── package-lock.json   # Locked versions
├── node_modules/       # Installed dependencies (not committed)
├── index.js            # Main entry point
├── lib/                # Source code
└── README.md
```

## Dependency Management

### package.json

```json
{
  "name": "my-project",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.2",
    "lodash": "~4.17.21"
  },
  "devDependencies": {
    "jest": "^29.0.0",
    "eslint": "^8.0.0"
  },
  "optionalDependencies": {
    "fsevents": "^2.3.0"
  }
}
```

**Dependency types:**

| Type | When Installed | Use For |
|------|----------------|---------|
| `dependencies` | Always | Runtime requirements |
| `devDependencies` | `npm install` (not `--production`) | Build tools, tests |
| `optionalDependencies` | When available | Platform-specific |
| `peerDependencies` | User must install | Plugin compatibility |

### Version Specifiers

| Specifier | Meaning | Example |
|-----------|---------|---------|
| `^4.18.2` | Minor updates OK | 4.18.2 to <5.0.0 |
| `~4.17.21` | Patch updates OK | 4.17.21 to <4.18.0 |
| `4.18.2` | Exact version | Only 4.18.2 |
| `>=4.0.0` | Minimum | 4.0.0 or higher |
| `*` | Any | Anything (dangerous) |

**The `^` default is dangerous:**

```bash
# When you install
npm install lodash
# package.json gets: "lodash": "^4.17.21"
# Tomorrow, 4.18.0 could install instead
```

**Use exact versions for production:**

```bash
npm install --save-exact lodash
# package.json gets: "lodash": "4.17.21"
```

### Lock Files

`package-lock.json` records exact versions of everything installed:

```json
{
  "name": "my-project",
  "lockfileVersion": 3,
  "packages": {
    "node_modules/lodash": {
      "version": "4.17.21",
      "resolved": "https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz",
      "integrity": "sha512-..."
    }
  }
}
```

**Always commit package-lock.json.**

### Installing Dependencies

```bash
# Development: uses lock file, may update it
npm install

# CI/Production: uses lock file exactly
npm ci

# Add a package
npm install express

# Add as dev dependency
npm install --save-dev jest

# Add exact version
npm install --save-exact lodash@4.17.21
```

**`npm ci` vs `npm install`:**

| | npm install | npm ci |
|---|-------------|--------|
| Uses lock file | Yes, may update | Yes, strict |
| Speed | Slower | Faster |
| node_modules | Preserves | Deletes first |
| Use in CI | No | Yes |

## Security

### npm audit

```bash
# Check for vulnerabilities
npm audit

# JSON output for automation
npm audit --json

# Auto-fix where possible
npm audit fix

# Force fixes (may include breaking changes)
npm audit fix --force
```

### Vulnerability Response

When `npm audit` finds issues:

```bash
# See what's affected
npm audit

# Check if update is safe
npm outdated vulnerable-package

# Update specific package
npm update vulnerable-package

# If transitive dependency, use overrides
```

**Overrides for transitive dependencies:**

```json
{
  "overrides": {
    "vulnerable-package": "2.0.1"
  }
}
```

This forces a specific version even if a direct dependency requests something else.

### Supply Chain Security

**Verify package provenance:**

npm supports provenance attestations for packages published from CI:

```bash
# Check if package has provenance
npm view lodash --json | jq '.attestations'
```

**Use scoped packages for internal code:**

```bash
# Publish under your org scope
npm publish --access public  # @yourorg/package

# This prevents dependency confusion attacks
```

**Lock registry:**

```ini
# .npmrc
registry=https://registry.npmjs.org/
@yourorg:registry=https://npm.yourcompany.com/
```

### Dependency Review

Before adding a package:

```bash
# Check package info
npm view package-name

# Check download stats
npm view package-name downloads

# Check repository
npm view package-name repository

# Check for known vulnerabilities
npm audit package-name
```

**Red flags:**
- Very few downloads
- No repository link
- Recent ownership change
- Name similar to popular package (typosquatting)

## Alternative Package Managers

### Yarn

```bash
# Install
yarn install

# Add package
yarn add lodash

# CI install (like npm ci)
yarn install --frozen-lockfile

# Uses yarn.lock instead of package-lock.json
```

### pnpm

```bash
# Install
pnpm install

# Add package
pnpm add lodash

# Uses pnpm-lock.yaml
# Saves disk space via hard links
```

**Feature comparison:**

| Feature | npm | Yarn | pnpm |
|---------|-----|------|------|
| Lock file | package-lock.json | yarn.lock | pnpm-lock.yaml |
| Workspaces | Yes | Yes | Yes |
| Plug'n'Play | No | Yes | No |
| Disk efficiency | Low | Medium | High |
| Speed | Good | Good | Better |

## Common Issues

### Phantom Dependencies

```javascript
// Works because lodash is a transitive dependency
const _ = require('lodash');

// But if the parent dependency removes lodash, this breaks
// Solution: Declare all dependencies you use directly
```

### Peer Dependency Warnings

```
npm WARN react-dom@18.2.0 requires react@^18.2.0
```

Fix: Install the peer dependency yourself.

```bash
npm install react@18.2.0
```

### Engine Requirements

```json
{
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=9.0.0"
  }
}
```

Enforce with:

```ini
# .npmrc
engine-strict=true
```

### Cleaning Up

```bash
# Remove unused packages
npm prune

# Clear cache
npm cache clean --force

# Check for outdated
npm outdated
```

## Best Practices Checklist

- [ ] `package-lock.json` committed
- [ ] Using `npm ci` in CI/CD
- [ ] `npm audit` in CI pipeline
- [ ] No `*` or unbound versions
- [ ] Direct dependencies explicitly declared
- [ ] `.npmrc` locks registry configuration
- [ ] Security updates applied promptly
- [ ] Private packages use scoped names

## Quick Reference

### Essential Commands

```bash
npm ci                    # CI install (use in pipelines)
npm audit                 # Check vulnerabilities
npm outdated              # Check for updates
npm update package-name   # Update specific package
npm ls package-name       # See dependency tree
npm view package-name     # Package info
```

### Version Cheat Sheet

| Want | Use |
|------|-----|
| Exact version | `1.2.3` |
| Patch updates | `~1.2.3` |
| Minor updates | `^1.2.3` |
| Latest | `*` (don't) |

### File Purposes

| File | Purpose | Commit? |
|------|---------|---------|
| package.json | Dependencies you want | Yes |
| package-lock.json | Dependencies you got | Yes |
| node_modules/ | Installed code | No |
| .npmrc | npm configuration | Usually yes |
