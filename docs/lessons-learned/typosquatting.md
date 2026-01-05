# Typosquatting

**The Lesson:** A single typo can compromise your system. Package names aren't verified for legitimacy.

---

## What It Is

Typosquatting is simple: register package names that look like popular packages, wait for someone to make a typo.

- `lodash` → `1odash`, `lodahs`, `lodashs`
- `requests` → `reqeusts`, `request`, `python-requests`
- `tensorflow` → `tensorfow`, `tensorflows`, `tensor-flow`

When a developer types `pip install reqeusts` instead of `pip install requests`, they get the attacker's package instead of the legitimate one. If the malicious package has the same API surface, the developer might not notice until it's too late.

## How It Works

A typical typosquatting attack:

1. **Identify targets.** Find popular packages with high download counts.

2. **Generate variants.** Create plausible typos: character swaps, missing characters, added characters, homoglyphs (using `1` for `l`, `0` for `o`).

3. **Register packages.** Claim those names on package registries. Most registries don't verify that you have any relationship to similar names.

4. **Add payload.** Include malicious code that runs on install (`setup.py` in Python, `postinstall` scripts in npm) or during import.

5. **Wait.** Eventually, someone will typo their way to your package.

## Real Incidents

Typosquatting happens constantly. Some documented cases:

**npm crossenv (2017):** A package named `crossenv` mimicked the legitimate `cross-env`. It harvested npm credentials from environment variables and sent them to an attacker.[^crossenv]

**PyPI typosquats (2017-present):** Researchers have repeatedly found malicious packages on PyPI with names like `djnago` (Django), `colourama` (colorama), and hundreds of others.[^pypi-typosquatting] One study found over 10,000 potential typosquat names for popular packages.[^typosquatting-research]

**ua-parser-js variants (2021):** After the legitimate `ua-parser-js` was compromised, researchers found multiple typosquat packages waiting to catch confused users looking for alternatives.[^ua-parser-js]

## Why It Works

**Humans make typos.** This is inevitable. Under deadline pressure, copying package names from memory, working late—mistakes happen.

**Package managers don't warn.** When you install a package, pip and npm don't say "did you mean the popular package with a similar name?" They install what you asked for.

**Auto-complete can fail.** IDE auto-complete might suggest the malicious package if you've already installed it, or if the legitimate package isn't cached.

**Copy-paste from untrusted sources.** Stack Overflow answers, blog posts, and tutorials might have typos. If you copy-paste without reading carefully, you get the typo.

## Detection and Prevention

### Registry-side

Package registries have implemented various defenses:

- **Name similarity checks.** Some registries block or flag packages with names too similar to popular ones.
- **Malware scanning.** Automated analysis looks for suspicious patterns in package code.
- **Reporting mechanisms.** Users can report suspected malicious packages.

These help but aren't comprehensive. Registries see millions of packages and can't manually review each one.

### User-side

**Verify package names carefully.** Before installing, double-check spelling—especially for packages you install infrequently.

**Use lock files.** Once you've installed the correct packages, lock files prevent typos from affecting future installs.

**Install from requirements files.** Maintain reviewed lists of dependencies rather than typing names from memory.

**Check download counts.** If a package has surprisingly few downloads for something that should be popular, that's a red flag.

**Review new dependencies.** When you add a package, take 30 seconds to verify it's the right one. Check the PyPI/npm page, look at the repository link.

### Organization-side

**Private registry mirrors.** Only allow installations from approved package lists.

**Pre-commit hooks.** Scan for known malicious packages before code is committed.

**Dependency scanning.** Tools like Snyk and Socket can flag suspicious packages.

## The Graybeard's Take

Typosquatting is embarrassingly effective. You'd think we'd have solved it by now—fuzzy matching isn't hard. But registries optimize for openness (anyone can publish) over safety (verify you're not impersonating someone).

I've watched this attack vector for years, and the pattern doesn't change. Someone registers `electorn` or `djang0`, waits for the typos to roll in, and harvests whatever they can. Sometimes it's cryptocurrency miners. Sometimes it's credential theft. Sometimes it's just reconnaissance for a bigger attack.

The defense isn't sophisticated. It's attention. Read what you're typing. Read what you're installing. Take the extra five seconds to verify.

But we're all in a hurry. And that's what the attackers count on.

---

## Common Typosquat Patterns

| Pattern | Example | Target |
|---------|---------|--------|
| Character swap | `reqeusts` | requests |
| Missing character | `lodas` | lodash |
| Extra character | `lodashs` | lodash |
| Homoglyph | `1odash` | lodash |
| Wrong separator | `tensor-flow` | tensorflow |
| Common misspelling | `collor` | color |
| Namespace confusion | `python-requests` | requests |

---

[^crossenv]: npm security advisory for crossenv package, 2017.

[^pypi-typosquatting]: Various PyPI security reports, 2017-2024.

[^typosquatting-research]: See [Typosquatting Research](../reference/sources.md#typosquatting-research)

[^ua-parser-js]: See [ua-parser-js Incident](../reference/sources.md#ua-parser-js)
