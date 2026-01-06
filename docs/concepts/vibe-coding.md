<div class="hero hero-half" markdown>
  <img src="../../assets/images/vibe-coding.webp" alt="Art deco figure at terminal with shadows writing code">
  <div class="hero-overlay">
    <h1>Vibe Coding</h1>
  </div>
</div>

When AI writes your code, you inherit dependencies you didn't choose, patterns you don't understand, and risks you can't see.

!!! terminal "The New Blind Spot"
    I've watched software practices evolve for decades. Most changes are gradual—new tools, new frameworks, same fundamental patterns. But AI-assisted coding is different. It's not just a new tool; it's a new way of not understanding what you're building. At least when you ran `pip install`, you saw the package name. You made a choice, even if you didn't fully understand its implications. With AI-generated code, you might not even know a dependency was added. The code appears. It works. You move on. And the supply chain grows in ways you never explicitly chose.

---

## What Changed

The old model was explicit, if not always understood:

```bash
pip install pandas
```

You typed it. You saw it happen. You could look at your `requirements.txt` and see what you'd added. The decisions were yours, even if they were uninformed.

The new model is implicit:

**Prompt:** "Write me a script to analyze this CSV file."

**AI response:** Generates 50 lines of code with `import pandas`, `import numpy`, `from scipy import stats`, and maybe a few more you didn't notice.

**You:** Copy, paste, run. It works. Move on.

But now you have dependencies you never explicitly chose. You didn't evaluate pandas. You didn't decide scipy was appropriate. You didn't consider alternatives. The AI made those choices based on its training data—code written by strangers, patterns from tutorials, Stack Overflow answers from 2019.

### The Visibility Problem

Traditional dependency accumulation happens one explicit `install` at a time. You might not understand each decision, but you at least *see* them.

AI-assisted dependency accumulation happens invisibly:

- **Prompt 1:** "Help me read this JSON file." (adds `json`—fine, it's stdlib)
- **Prompt 2:** "Can you make this async?" (adds `aiohttp`, `asyncio`)
- **Prompt 3:** "I need to validate the input." (adds `pydantic` or `marshmallow`)
- **Prompt 4:** "Add some logging." (adds `loguru` or `structlog`)

By the end of the session, you have a dozen dependencies. Did you see a consolidated list? Did you approve each one? Do you even know what's in your project now?

---

## The Risks AI Introduces

| Risk | What Happens |
|------|--------------|
| **Invisible accumulation** | Dependencies added across multiple prompts without a consolidated view |
| **Hallucinated packages** | AI suggests packages that don't exist—or worse, now exist as typosquats targeting AI users |
| **Wheel reinvention** | 200 lines of hand-rolled code instead of a battle-tested library (or vice versa) |
| **Version chaos** | No pinning, no lock files, "whatever pip grabs today" |
| **Training data lag** | Patterns from 2021 using deprecated APIs or vulnerable versions |
| **Confidence without competence** | AI writes with authority; users assume correctness |

### Hallucinated Packages

AI models sometimes suggest packages that don't exist. They hallucinate plausible-sounding names based on patterns in their training data.

This creates a new attack vector: researchers have found that attackers can register packages with names that AI models commonly hallucinate. When a user follows the AI's suggestion and runs `pip install hallucinated-package`, they get malware instead of a "package not found" error.

This isn't theoretical. Studies have documented thousands of hallucinated package names across AI models—and the potential for registering them as attack vectors.

### Training Data Lag

AI models are trained on historical code. That code reflects:

- **Old API patterns**: The AI might suggest `requests.get()` without `timeout=` because older examples didn't include it
- **Deprecated libraries**: Suggesting `optparse` instead of `argparse`, or Python 2 patterns
- **Vulnerable versions**: Patterns that were fine in 2020 but have known CVEs now
- **Abandoned packages**: Suggesting libraries that were popular during training but are now unmaintained

The AI doesn't know what year it is in your `requirements.txt`. It just knows patterns from its training data.

---

## The Trust Problem

When you `pip install requests`, you're trusting:

- The `requests` maintainers
- PyPI's integrity
- Your network connection

The trust chain is visible: you → PyPI → package maintainer.

When AI suggests code, you're trusting:

- The AI model
- The AI company's training process
- Whoever wrote the code the AI learned from
- The quality of tutorials, Stack Overflow answers, and GitHub repos in the training data
- That the AI correctly synthesized patterns rather than memorizing bad examples

The trust chain now includes the AI's entire training corpus. You're implicitly trusting thousands of anonymous developers whose code the AI absorbed. And unlike a package maintainer, you can't look up their track record.

---

## Is It Still Solo Development?

Traditional solo development has known problems:

- One person, no code review
- Consistent mistakes (your blind spots are always your blind spots)
- No second opinion on design decisions

AI-assisted solo development changes this—but not in the way you might hope:

- Still one person, still no *human* review
- **Inconsistent** patterns (the AI's suggestions vary based on context)
- The AI provides opinions, but doesn't own them or remember them

**The AI isn't a colleague.** It doesn't remember what it suggested last week. It doesn't maintain consistency across your codebase. It doesn't understand your architecture, your constraints, or your security requirements. It doesn't review its own suggestions.

You're still alone. You just have a very confident intern who forgets everything between conversations.

The AI generates more code for you to not review. It adds dependencies for you to not evaluate. It makes architectural suggestions for you to not question. The fundamental problem of solo development—lack of review—isn't solved. It's amplified.

---

## The Skill Amplifier

Here's the uncomfortable truth: **AI doesn't hide lack of skill. It amplifies it.**

If you don't know how to code, your AI-produced code will show it. A skilled developer uses AI to accelerate their work. An unskilled one creates more mess faster.

It's easier for a bad contractor to destroy with a hammer than it is for a good one to build. Give that same contractor a nail gun, and destruction becomes even faster.

The AI makes you more productive at whatever you're doing—including making mistakes:

- **If you understand code review**, AI helps you write code faster that you then review
- **If you don't understand code review**, AI helps you ship unreviewed code faster
- **If you understand security**, AI helps you implement secure patterns more quickly
- **If you don't understand security**, AI helps you create vulnerabilities at scale
- **If you understand dependencies**, AI saves you typing
- **If you don't understand dependencies**, AI adds them invisibly while you remain unaware

AI is a force multiplier. It multiplies whatever you bring to it—skill, knowledge, bad habits, blind spots.

---

## What AI Can't Do For You

The AI cannot:

- **Evaluate whether a dependency is well-maintained** — It doesn't check commit history, issue response times, or bus factor
- **Verify the package exists** — It might suggest something it hallucinated from training patterns
- **Pin versions intentionally** — It doesn't know your project's stability requirements
- **Understand your security requirements** — It doesn't know you're handling PII or running in a regulated environment
- **Remember what it suggested last session** — Each conversation starts fresh
- **Maintain consistency** — It might suggest `requests` today and `httpx` tomorrow
- **Take responsibility when things break** — That's still you

When something goes wrong—a dependency has a CVE, a package disappears, an API changes—you're the one debugging it. The AI that suggested it is long gone.

---

## Practical Defenses

### Review Generated Code Like It's a PR

Treat AI output as a pull request from an untrusted contributor:

- [ ] What dependencies does this add?
- [ ] Are those dependencies necessary?
- [ ] Do the suggested packages actually exist?
- [ ] Are there security implications?
- [ ] Does this follow our project's patterns?

### Freeze After Generation

After an AI-assisted coding session, immediately capture your state:

```bash
pip freeze > requirements.txt
# Or better:
pip-compile --generate-hashes requirements.in
```

Don't let dependencies accumulate invisibly across sessions.

### Audit AI-Suggested Packages

Apply the same five-minute evaluation you'd apply to any dependency:

1. Does this package exist on the official registry?
2. When was it last updated?
3. Does it have more than one maintainer?
4. Are there open security issues?
5. Is there a reason the AI suggested *this* package over alternatives?

If the AI suggests a package, ask it *why*. If it can't give a good reason, that's a red flag.

### Question Architectural Decisions

AI tends to suggest whatever patterns dominate its training data. That's not the same as what's right for your project.

- If AI suggests adding a database, do you need one?
- If AI suggests a web framework, is that the right framework?
- If AI structures code a certain way, does that structure make sense for your use case?

### Maintain Your Own Dependency List

Don't let dependency management happen implicitly through AI suggestions. Maintain explicit files that you control:

```bash
# requirements.in - what you explicitly want
pandas>=2.0
numpy>=1.24

# requirements.txt - generated, pinned, reviewed
pandas==2.1.4
numpy==1.26.3
```

Every dependency should be a conscious decision, not a side effect of an AI conversation.

---

## Working With AI Responsibly

AI can be genuinely useful for software development. The goal isn't to avoid it—it's to use it consciously.

### Good Uses

- **Boilerplate**: Generating repetitive code patterns you understand
- **Syntax help**: "How do I do X in this language?"
- **First drafts**: Starting points that you'll review and refine
- **Exploration**: "What are some approaches to this problem?"

### Dangerous Uses

- **Architecture decisions**: Letting AI design your system structure
- **Dependency selection**: Accepting whatever packages AI suggests
- **Security-critical code**: Trusting AI with authentication, encryption, input validation
- **Blindly running generated code**: Copy-paste without review

### Documentation Hygiene

Consider marking AI-generated code for future maintainers:

```python
# NOTE: Initial implementation generated with AI assistance
# Reviewed and modified: [date]
# Dependencies added: pandas, numpy (evaluated [date])
```

Future you (or your replacement) will thank present you for the context.

---

## Quick Reference

### Before Accepting AI-Generated Code

- [ ] Read the code—all of it
- [ ] Identify all imports and dependencies
- [ ] Verify suggested packages exist
- [ ] Check if dependencies are actually needed
- [ ] Look for hardcoded values, paths, credentials
- [ ] Consider security implications
- [ ] Run the code in isolation first

### Warning Signs in AI Output

- :material-close-circle:{ .red-flag } Package names you've never heard of (might be hallucinated)
- :material-close-circle:{ .red-flag } Overly complex solutions to simple problems
- :material-close-circle:{ .red-flag } Dependencies where stdlib would suffice
- :material-close-circle:{ .red-flag } Patterns that don't match your codebase style
- :material-close-circle:{ .red-flag } No error handling
- :material-close-circle:{ .red-flag } No input validation
- :material-close-circle:{ .red-flag } "This should work" comments

### Questions to Ask About AI Suggestions

1. Why this package instead of alternatives?
2. What version constraints are appropriate?
3. Is there a simpler solution without this dependency?
4. What's the maintenance status of suggested packages?
5. Does this pattern match our existing codebase?

!!! terminal "The Nail Gun"
    I'm not anti-AI. I use these tools. They can genuinely accelerate development when used well. But "used well" requires understanding what's happening. The AI is a power tool. In skilled hands, it builds faster. In unskilled hands, it demolishes faster. The tool doesn't care which. Know which one you are. And if you're still learning—there's no shame in that, everyone starts somewhere—be extra careful with the power tools until you understand what you're building and what you're risking.
