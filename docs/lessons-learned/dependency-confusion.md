# Dependency Confusion

**The Lesson:** If your internal package names exist on public registries, someone else can publish malicious code under those names.

---

## What It Is

Dependency confusion exploits how package managers resolve names. When you request a package, the manager typically checks multiple sources: your private registry (if configured) and public registries like npm or PyPI.

If an attacker knows the name of your internal package—and that name doesn't exist publicly—they can register it on the public registry with a higher version number. Many package managers will prefer the "newer" public version over your internal one.

Your build now installs the attacker's code instead of yours.

## The Discovery

In February 2021, security researcher Alex Birsan published research demonstrating this attack against major tech companies.[^birsan-dependency-confusion] By discovering internal package names through various reconnaissance techniques, he was able to get his code executed on internal systems at:

- Apple
- Microsoft
- PayPal
- Shopify
- Netflix
- Tesla
- Uber
- And dozens more

He earned over $130,000 in bug bounties from companies whose build systems executed his proof-of-concept code.

## How It Works

### Discovery Phase

Attackers find internal package names through:

**Public code leaks:** Internal package names in public GitHub repos (accidentally committed package.json, requirements.txt, etc.)

**Error messages:** Stack traces that mention package names.

**Documentation:** Internal wikis or docs accidentally exposed.

**JavaScript source maps:** Bundled JavaScript that reveals import paths.

**Job postings:** "Experience with our internal X library required."

### Attack Phase

1. **Register the name publicly.** If `@mycompany/internal-auth` is the internal package, register `internal-auth` on npm (without the scope).

2. **Use a high version number.** Version 99.0.0 will be "newer" than any internal version.

3. **Add payload.** Include code that executes during installation (postinstall scripts) or import.

4. **Wait.** When the target's build system runs, it may resolve to your public package.

### Why It Succeeds

**Default resolver behavior:** Many package managers check public registries by default, even when private registries are configured.

**Version comparison:** Higher version numbers are considered "better" without regard to source.

**Namespace confusion:** Internal packages often don't use scoped names (`@company/package`) that would prevent public collision.

**CI/CD automation:** Build systems run unattended, executing whatever the package manager resolves.

## Affected Ecosystems

The attack works differently across package managers:

**npm:** Vulnerable if internal packages don't use scoped names (`@scope/package`). Scoped packages are protected—only the scope owner can publish to them.

**Python/pip:** Particularly vulnerable. pip's `--extra-index-url` flag adds sources but doesn't prioritize them. A higher version on PyPI can win over a private index.

**Ruby/Bundler:** Less vulnerable by default, but custom configurations can be exploited.

**Go:** Less vulnerable due to the module path system (packages are namespaced by repository URL).

## Prevention

### Use scoped/namespaced packages

**npm:** Use organization scopes: `@mycompany/package-name`

**Python:** Use unique prefixes unlikely to collide: `mycompany-internal-package`

**Go:** Use your organization's domain in module paths

### Configure package managers correctly

**Python:** Use `--index-url` (replaces PyPI) instead of `--extra-index-url` (adds to PyPI). Or use explicit source mapping.

```ini
# pip.conf - SAFER: replaces public PyPI
[global]
index-url = https://private.registry.example.com/simple/
```

**npm:** Configure scopes explicitly:

```json
// .npmrc
@mycompany:registry=https://private.registry.example.com/
```

### Pre-register public names

If you have internal packages with generic names, consider registering placeholder packages on public registries. Even an empty package prevents attackers from claiming the name.

### Monitor for squatting

Watch public registries for packages matching your internal names. Some security tools automate this monitoring.

### Network controls

Block or alert on unexpected outbound connections from build systems. If your build suddenly reaches out to PyPI when it should only talk to your private registry, that's a red flag.

## The Graybeard's Take

Dependency confusion is clever because it exploits trust assumptions nobody questioned.

Package managers were designed when "installing a package" meant downloading from one central place. Private registries were bolted on later. The resolution logic wasn't designed for a world where multiple sources might have the same package name with different contents.

Birsan's research was a wake-up call. Suddenly, every organization with internal packages had to ask: could someone guess these names? Is our resolver configured correctly? What happens if there's a version conflict?

The fix is straightforward—use namespaces, configure your package manager correctly, don't trust default behavior. But lots of organizations learned these lessons the hard way.

If you have internal packages, audit your resolver configuration. Today. Before someone else discovers what names you're using.

---

## Key Defenses

| Defense | npm | Python | Go |
|---------|-----|--------|-----|
| Namespacing | Use `@scope/name` | Use unique prefixes | Module path is namespaced |
| Registry config | Scope-specific registries | `--index-url` not `--extra-index-url` | `GOPROXY` settings |
| Placeholder packages | Pre-register names | Pre-register names | N/A (path-based) |
| Version pinning | Lock files | Lock files | go.sum |

---

[^birsan-dependency-confusion]: See [Alex Birsan Dependency Confusion Research](../reference/sources.md#birsan-dependency-confusion)
