<div class="hero hero-half" markdown>
  <img src="../../assets/images/scripts-become-software.webp" alt="Art deco seed growing into mechanical tree">
  <div class="hero-overlay">
    <h1>When Scripts Become Software</h1>
  </div>
</div>

That "quick script" you wrote last month? It's now critical infrastructure. This chapter addresses the research reality: code written to answer a question becomes code that must be maintained, reproduced, and trusted.

!!! terminal "Famous Last Words"
    "I just need a quick script." I've heard this sentence precede three years of technical debt more times than I can count. The script works. The script gets used. The script becomes load-bearing. And then the person who wrote it moves on, and everyone discovers that "quick" and "temporary" were lies we told ourselves.

---

## The Lifecycle Nobody Planned

It starts innocently:

**Day 1:** "I just need a quick script to process this data."

**Week 2:** "Let me add a few parameters so I can reuse it."

**Month 2:** "My colleague wants to use it. I'll add some documentation."

**Month 6:** "We need to run this on the cluster. I'll containerize it."

**Year 1:** "Three papers depend on this. We should probably add tests."

**Year 2:** "The postdoc who wrote it graduated. Who knows how this works?"

**Year 3:** "Python 2.7 is EOL. This script only runs on Python 2.7."

Nobody planned for the script to become critical. But it did. And now it's too important to rewrite, too fragile to change, and too poorly documented to understand.

## The "Just For Now" Trap

**There's nothing more permanent than a temporary solution.**

Research code is full of "just for now" decisions:

```python
# TODO: Make this configurable
DATA_PATH = "/home/grad_student/data/experiment_2023/"

# Hardcoded because it's easier
THRESHOLD = 0.05  # What was this for again?

# This works on my machine
import sys
sys.path.append("/home/grad_student/custom_libs/")
```

Each of these is a small decision that makes sense in the moment. But they accumulate:

- Hardcoded paths break when someone else runs the code
- Magic numbers become impossible to trace
- Custom imports create hidden dependencies
- "Works on my machine" becomes "works on nobody else's machine"
- AI-generated code accepted without review—decisions made by a model that won't remember why

A year later, the script is a maze of assumptions that only make sense if you're the person who wrote it, in the environment where it was written, with the data that existed at the time.

## Why Research Code Is Different

Research code faces unique pressures:

### Exploratory by Nature

Research is exploration. You don't know what the final analysis will look like when you start. The code evolves with your understanding.

This is fine—exploration requires flexibility. But exploratory code has a way of becoming permanent without ever being designed for permanence.

### Pressure to Produce

The incentive is publishing, not maintainable code. Time spent on "engineering" is time not spent on research. Reviewers don't check your test coverage.

Result: code gets minimal attention beyond "does it produce the output I need?"

AI-assisted coding amplifies this pressure—it's even easier to prioritize speed when code appears instantly. The time saved feels like a gift; the debt deferred feels like someone else's problem.

### Solo Development

Most research code is written by one person. There's no code review, no second opinion, no "wait, why did you do it this way?"

Solo developers make consistent mistakes because there's no one to catch them.

AI assistance doesn't change this fundamental problem. The AI isn't a colleague who reviews your code—it's a tool that generates more code for you to not review. You're still alone. You just have a very confident assistant who forgets everything between conversations and doesn't own the decisions it helps you make. See [Vibe Coding](vibe-coding.md) for more on the AI-assisted development trap.

### Long Gaps Between Uses

A script might run once for a paper, then sit untouched for a year until revision is needed. By then:

- Dependencies have updated (or disappeared)
- The environment has changed
- The person who wrote it has forgotten the details
- The data might have changed too

## The Reproducibility Crisis

Science depends on reproducibility. If your results can't be reproduced, they're not science—they're anecdotes.

Software is a major threat to reproducibility:

**Dependencies change.** The same code, run with different library versions, can produce different results. Floating-point behaviors, random seeds, algorithm implementations—all can vary.

**Environments change.** Your results on macOS might differ from Linux. Your local Python might differ from the cluster's Python. The package you had in 2022 might not exist in 2024.

**Data changes.** If your analysis depends on a database query, the database might change. If it depends on downloaded files, those files might disappear.

**Documentation decays.** The setup instructions that worked in January might fail in March because they assumed things that were true then and aren't now.

### What Reproducibility Requires

At minimum:

- **Pinned dependencies** — Exact versions, not "whatever's newest"
- **Environment specification** — OS, runtime version, system libraries
- **Data provenance** — Where did the data come from? Is it still available?
- **Random seed control** — If there's randomness, it should be controllable
- **Documentation** — How to set up and run, not just what it does

These aren't luxury features. They're the difference between "science" and "a thing that happened once."

## Signs Your Script Became Software

You've crossed the threshold when:

- **Someone else needs to run it.** Not "could run it in theory" but actually needs to run it.
- **It's cited or published.** Your reputation now depends on it working.
- **Results depend on it.** Other analyses, papers, or decisions use its output.
- **It's been running for months.** Anything that runs that long is infrastructure.
- **You've forgotten how it works.** If you need to read the code to remember, it's not a "quick script" anymore.

## Making the Transition

If your script has become software, you have options:

### Option 1: Accept It and Invest

Admit that this is now important code. Invest accordingly:

- Add tests (at least for the critical paths)
- Add documentation (at least setup and usage)
- Pin dependencies (lock files, requirements.txt with versions)
- Version control (if not already)
- Make configuration explicit (no hardcoded paths)

This takes time. But it's less time than debugging mysterious failures a year from now.

### Option 2: Rewrite with Lessons Learned

Sometimes the right answer is starting over, applying what you learned:

- Design for the actual use case (which you now understand)
- Build in the flexibility you know you need
- Structure for maintainability from the start

This is expensive upfront but can save time long-term, especially if the original code is truly tangled.

### Option 3: Freeze and Document

If the code works and you don't need to change it:

- Document exactly how to run it
- Containerize the environment
- Archive the dependencies
- Mark it as "frozen—do not modify"

This isn't maintenance-free forever, but it minimizes ongoing effort.

### Option 4: Let It Die

Some scripts should be retired:

- The analysis is complete and won't be repeated
- Better tools now exist
- The effort to maintain exceeds the value

Not everything needs to be preserved. Sometimes "this was a one-time thing" is the honest answer.

## Practical Steps

### At the Start

Even for "quick scripts":

```bash
# Create a virtual environment
python -m venv venv
source venv/bin/activate

# Install and freeze dependencies
pip install pandas numpy
pip freeze > requirements.txt

# Use version control from day one
git init
git add .
git commit -m "Initial analysis script"
```

This costs minutes and saves hours.

### When It Gets Serious

When others start depending on your code:

```bash
# Add a README
echo "# Analysis Pipeline\n\n## Setup\n\n## Usage\n" > README.md

# Add basic tests
mkdir tests
touch tests/test_core.py

# Consider containerization
# Dockerfile captures the whole environment
```

### Before Publication

Before attaching code to a paper:

- [ ] Can someone else run this from the README?
- [ ] Are all dependencies pinned?
- [ ] Is the data available (or clearly described)?
- [ ] Are random seeds set for reproducibility?
- [ ] Is there a DOI or persistent identifier?

!!! terminal "Tuesday"
    I've seen too many research projects become archaeological expeditions. A paper from three years ago needs correction. The original code exists, somewhere, but: the grad student who wrote it is now a professor across the country, the server it ran on was decommissioned, the Python version it needs hasn't been available for two years, and half the dependencies have been removed from PyPI.

    These aren't hypotheticals. They're Tuesday.

    The solution isn't to turn every analysis into a software engineering project. That's not realistic, and it's not necessary. The solution is to think, for just a moment, about what happens next. Will someone need to run this again? Pin the dependencies. Will someone need to understand this? Write a README. Will this support a publication? Make it reproducible.

    These aren't heroic efforts. They're small habits that save enormous pain later. The best time to think about maintainability was when you started. The second best time is now, before that "quick script" becomes load-bearing infrastructure you can't change.

---

## Quick Reference

### Minimum Viable Sustainability

| Stage | Minimum Requirements |
|-------|---------------------|
| **Exploration** | Virtual environment, git |
| **Sharing with colleagues** | + README, requirements.txt |
| **Publication** | + Tests, containerization, DOI |
| **Long-term maintenance** | + CI/CD, documentation, handoff plan |

### Warning Signs

- :material-close-circle:{ .red-flag } "It works on my machine" (and only there)
- :material-close-circle:{ .red-flag } Hardcoded paths to specific directories
- :material-close-circle:{ .red-flag } No requirements file or lock file
- :material-close-circle:{ .red-flag } No README or setup instructions
- :material-close-circle:{ .red-flag } "I'll clean this up later" (you won't)
