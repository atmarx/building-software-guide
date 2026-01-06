# Terminal Admonition Guide

This site uses a custom VT100 terminal aesthetic for all admonitions. They render as phosphor-glow text on dark backgrounds with subtle scanline effects.

## Basic Syntax

```markdown
!!! note "Custom Title"
    Your content here.
```

## Available Types

Each type has a distinct color scheme:

### Informational

!!! note "Note / Info — Cyan"
    Use `note` or `info` for supplementary information.

!!! tip "Tip / Success — Green"
    Use `tip`, `success`, `check`, or `done` for positive guidance.

!!! example "Example — Purple"
    Use `example` for demonstrations and sample code.

### Cautionary

!!! warning "Warning / Caution — Orange"
    Use `warning`, `caution`, or `attention` for things to watch out for.

!!! danger "Danger / Failure — Red"
    Use `danger`, `failure`, `fail`, or `error` for critical issues.

!!! bug "Bug — Magenta"
    Use `bug` for known issues or gotchas.

### Neutral

!!! question "Question / FAQ — Blue"
    Use `question`, `faq`, or `help` for queries and explanations.

!!! quote "Quote / Abstract — Gray"
    Use `quote`, `cite`, `abstract`, `summary`, or `tldr` for quotations.

### Default

!!! terminal "Terminal — Amber"
    Any unrecognized type (like `terminal`) uses the default amber color.

## Modifiers

### Inline Positioning

Float an admonition to the right of your content:

```markdown
!!! tip inline end "Sidebar"
    This floats to the right.
```

Float to the left:

```markdown
!!! tip inline "Left Sidebar"
    This floats to the left.
```

### Collapsible (Details)

Make admonitions collapsible using `???` instead of `!!!`:

```markdown
??? note "Click to expand"
    Hidden content revealed on click.
```

Start expanded with `???+`:

```markdown
???+ note "Starts open"
    Visible by default, but collapsible.
```

## Text Formatting

Inside admonitions, text formatting has enhanced visibility:

- **Bold text** appears brighter with stronger glow
- *Italic text* appears in orange
- [Links](#) appear in complementary colors (varies by admonition type)

!!! example "Formatting Demo"
    This shows **bold emphasis**, *italic highlights*, and a [sample link](#).

## Usage Tips

1. **Match meaning to color** — Use `danger` for actual dangers, not just emphasis
2. **Keep titles short** — The Bitwise font works best with brief, uppercase titles
3. **Use `inline end` sparingly** — Works best with short content beside longer paragraphs
4. **Consider collapsible for long content** — Use `???` for optional deep-dives

## Quick Reference

| Type | Color | Use For |
|------|-------|---------|
| `note`, `info` | Cyan | Background information |
| `tip`, `success` | Green | Best practices, positive outcomes |
| `warning`, `caution` | Orange | Potential issues |
| `danger`, `error` | Red | Critical problems |
| `example` | Purple | Code samples, demonstrations |
| `question`, `faq` | Blue | Q&A, clarifications |
| `quote`, `abstract` | Gray | Citations, summaries |
| `bug` | Magenta | Known issues |
| *(default)* | Amber | General callouts |
