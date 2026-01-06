<div class="hero hero-half" markdown>
  <img src="../assets/images/reference.webp" alt="Art deco blueprint room with technical drawings">
  <div class="hero-overlay">
    <h1>Reference</h1>
  </div>
</div>


Quick-access resources for when you need to look something up.

!!! terminal "At 3 AM"
    Reference sections exist for the moments when you've forgotten something important and need the answer now. I've needed everything in here at some point—usually at 3 AM during an incident. Bookmark the pages. Print the checklists. Future you will be grateful.

## What's Here

<div class="grid cards two-column" markdown>

-   :material-checkbox-marked-outline:{ .lg .middle } **[Checklists](checklists.md)**

    ---

    Actionable checklists for common tasks: evaluating dependencies, updates, container security, releases.

-   :material-tools:{ .lg .middle } **[Tools](tools.md)**

    ---

    Reference guide to tools for dependency analysis, SBOM generation, vulnerability scanning, and reproducibility.

-   :material-book-alphabet:{ .lg .middle } **[Glossary](glossary.md)**

    ---

    Definitions of terms used throughout this guide. Common terms also appear as tooltips.

-   :material-bookshelf:{ .lg .middle } **[Further Reading](further-reading.md)**

    ---

    Books, standards, frameworks, and organizations for deeper exploration.

-   :material-format-quote-close:{ .lg .middle } **[Sources](sources.md)**

    ---

    Bibliography of citations referenced throughout the guide.

</div>

## Quick Links

### When You Need to Evaluate a Dependency

1. Check the [New Dependency Checklist](checklists.md#new-dependency-checklist)
2. Review [Evaluating Dependencies](../concepts/evaluating-dependencies.md) for the framework
3. Use [Tools: Dependency Analysis](tools.md#dependency-analysis) for inspection

### When You Need to Respond to a Vulnerability

1. Check if you're affected using your SBOM (see [SBOM chapter](../security/sbom.md))
2. Follow the [Vulnerability Response Workflow](../security/vulnerability-management.md#the-response-workflow)
3. Update using the [Dependency Update Checklist](checklists.md#dependency-update-checklist)

### When You're Starting a New Project

1. Review [The Build Environment](../concepts/build-environment.md)
2. Set up dependency management ([Versioning and Lock Files](../concepts/versioning-and-lockfiles.md))
3. Configure vulnerability scanning ([Security Practices](../security/security-practices.md))
4. Consider ecosystem-specific guidance in [Appendices](../appendices/index.md)
