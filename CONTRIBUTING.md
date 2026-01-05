# Contributing Guide

This document captures the patterns and conventions used in this project, for human contributors and AI assistants alike.

## Voice and Tone

The guide uses a **deliberate narrative voice**: a "graybeard" software developer who has been in the industry since before "open source" had a name. This is a literary device, not a claim of authorship. See [Preface](docs/preface.md) for context.

### Voice characteristics

- **First-person perspective** — "I've watched," "I remember," "In my experience"
- **Historical context** — Reference specific years, events, people when relevant
- **Mentoring tone** — Patient, not condescending; explaining "why" not just "what"
- **Opinionated but fair** — Has preferences but acknowledges other perspectives
- **Practical wisdom** — Focuses on real-world implications, not just legal text
- **Occasional asides** — Brief personal observations that add texture

### The graybeard character

The narrator isn't just "old"—he's a specific type. Understanding who he is helps maintain consistency.

**Background:**
- Learned vi on a VT100 because that's what was available. Still uses it. (Not vim—*vi*. Though he'll admit vim is fine.)
- Respects emacs users who actually write elisp. "At least they're *building* something."
- Has watched editor wars, build system wars, framework wars. Finds them amusing now.
- Remembers when "dependency management" meant tarring up vendor libraries.

**Philosophy:**
- **Skeptical of magic** — If you can't explain what's happening underneath, you don't understand it.
- **Not anti-modern** — Uses containers, appreciates good tooling. But insists on understanding the fundamentals first.
- **Values simplicity** — Three similar lines of code are better than a premature abstraction.
- **Pragmatic about tradeoffs** — Every choice has costs. Acknowledge them.
- **Cranky but fair** — Has opinions, expresses them, but doesn't dismiss other perspectives.

**On licensing specifically:**
- Sees both the philosophical libre ideals and the practical business realities.
- Doesn't villainize companies for wanting to make money.
- Doesn't dismiss community concerns as naïve.
- Understands why copyleft exists and why permissive licenses exist. Neither is "wrong."
- Has watched enough license drama to be unsurprised by any of it.

**What he wouldn't say:**
- "Everything should be GPL" (too prescriptive)
- "Licensing doesn't matter, just ship code" (too dismissive)
- "Oracle is evil" (too editorial—he'd say "Oracle's incentives led to predictable outcomes")
- "Kubernetes is the answer" (too trendy—he'd say "Kubernetes solves specific problems; most of you don't have those problems")

**What he would say:**
- "I've seen this pattern before."
- "Let me tell you what actually happened."
- "The lesson isn't that they were wrong—it's that incentives matter."
- "You don't need to understand everything. But understand this part."

### Example voice patterns

```markdown
# Good
I've seen this mistake more times than I can count. Someone picks a license
without reading it, then discovers two years later that...

# Avoid
This section will explain the common mistake of not reading licenses carefully.
Users often discover after two years that...
```

```markdown
# Good
Back in '99, when Red Hat went public, people asked me constantly: "How can
you sell something that's free?" They were confusing gratis with libre.

# Avoid
In 1999, Red Hat's IPO raised questions about selling free software. This
confusion stemmed from the gratis/libre distinction.
```

## Citations

Citations use **footnotes** that link to a central sources page.

### Pattern

1. **Inline footnote marker** — Use `[^slug]` where the citation belongs
2. **Footnote definition** — At the bottom of the file, link to sources.md
3. **Sources entry** — Central bibliography with natural headers and slug comments

### Example

In a content file (e.g., `docs/concepts/libre-vs-gratis.md`):

```markdown
When Richard Stallman started the free software movement in 1983, he meant **libre**.[^gnu-manifesto]

Red Hat went public in 1999.[^red-hat-ipo] People were incredulous...

<!-- at bottom of file -->
[^gnu-manifesto]: See [The GNU Manifesto](../reference/sources.md#the-gnu-manifesto)
[^red-hat-ipo]: See [Red Hat IPO](../reference/sources.md#red-hat-ipo)
```

In `docs/reference/sources.md`:

```markdown
### The GNU Manifesto
<!-- slug: the-gnu-manifesto -->
Stallman, Richard. "The GNU Manifesto." March 1985.
https://www.gnu.org/gnu/manifesto.html

### Red Hat IPO
<!-- slug: red-hat-ipo -->
Various. "Red Hat IPO." August 1999. Referenced in financial news archives.
```

### Notes on sources.md

- Headers use **natural language** (Title Case), not slug-style
- HTML comments (`<!-- slug: xxx -->`) store the URL anchor for reference
- MkDocs auto-generates anchors from headers (spaces become hyphens, lowercase)
- Organize entries alphabetically by first letter
- Include author, title, date, and URL when available

## Glossary

The glossary uses **abbreviation definitions** that MkDocs auto-links throughout all pages.

### How it works

The file `docs/includes/glossary.md` contains abbreviation definitions:

```markdown
*[OSI]: Open Source Initiative - organization that reviews and approves licenses as "open source"
*[copyleft]: A licensing approach requiring derivative works to use the same license
*[permissive license]: A license that allows use with minimal restrictions
```

These are auto-appended to every page via `mkdocs.yml`:

```yaml
markdown_extensions:
  - pymdownx.snippets:
      auto_append:
        - includes/glossary.md
```

### Adding glossary terms

1. Edit `docs/includes/glossary.md`
2. Add a line: `*[Term]: Brief definition`
3. The term will now show a tooltip on hover wherever it appears

### Guidelines

- Keep definitions brief (one line)
- Define on first meaningful use in the glossary, not every variant
- Prefer terms as they commonly appear (e.g., "GPL" not "GNU General Public License")

## File Organization

```
docs/
├── index.md                 # Homepage
├── preface.md               # Author's note about voice and approach
├── concepts/                # Foundational concepts (libre/gratis, copyleft, etc.)
├── licenses/                # Software licenses
│   ├── permissive/          # MIT, BSD, Apache, ISC
│   ├── copyleft/            # GPL family, LGPL, AGPL, MPL
│   └── other/               # Unlicense, WTFPL, dual licensing
├── creative-commons/        # CC licenses (separate from software licenses)
├── guides/                  # Practical how-tos
├── lessons-learned/         # Historical case studies
├── reference/               # Comparison tables, glossary page, sources
├── includes/                # Shared content (glossary.md)
└── overrides/               # MkDocs Material theme customizations
```

### Naming conventions

- Use lowercase with hyphens: `libre-vs-gratis.md`, not `LibreVsGratis.md`
- Index files: `index.md` in each directory for section landing pages
- Keep filenames descriptive but concise

## Content Patterns

### License pages

Each license page should include:

1. **Header** — License name and a one-line summary
2. **The Basics** — What the license permits/requires/forbids
3. **Key Clauses** — Notable provisions explained in plain English
4. **When to Use** — Practical guidance on appropriate use cases
5. **Gotchas** — Common mistakes or misunderstandings
6. **History** (optional) — Origin story if interesting
7. **Footnotes** — Citations to sources.md

### Case study pages (lessons-learned)

Each case study should include:

1. **Year** — When it happened
2. **Lesson** — One-sentence takeaway
3. **What Happened** — Narrative of the events
4. **Why It Mattered** — Impact and implications
5. **The Lessons** — Bullet points of what we learned
6. **Footnotes** — Citations to sources.md

## Technical Setup

### Local development

```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
mkdocs serve
```

### Building

```bash
mkdocs build
# or
./mkdocs-build.sh
```

### Dependencies

- MkDocs with Material theme
- pymdownx extensions (snippets, footnotes, etc.)
- See `requirements.txt` for versions

## License

Content is licensed under [CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/). By contributing, you agree to license your contributions under the same terms.
