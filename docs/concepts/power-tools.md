---
title: Power Tools
---

# Power Tools

You're not vibe coding. You know what you're doing. You've been writing code for years, you understand the problem domain, and you're using AI to work faster—not to think for you. The AI is a power tool, not a crutch.

This chapter is for you.

!!! terminal "Respect the Blade"
    I've used a table saw for decades. I know how it works. I know what it can do. And I know that the moment I stop respecting it—the moment I get comfortable, reach across the blade without thinking, skip the push stick because I'm in a hurry—that's when I lose fingers. Experience doesn't make you immune to the tool. It just means you've internalized the habits that keep you safe. The danger isn't ignorance. It's complacency.

---

## The Macro Comparison

Experienced developers often compare AI-assisted coding to macros, templates, or code generation tools they've used before. T4 templates in C#. Yeoman scaffolds. Rails generators. "It's just faster scaffolding," the argument goes. "I know what I want; the AI just types it for me."

This comparison is partially correct—and partially dangerous.

### Where It Holds

**Boilerplate generation.** If you're scaffolding a REST endpoint you've written a hundred times, the AI is doing what a template would do: producing predictable structure from a known pattern. You understand the output. You'd catch obvious errors.

**Language translation.** Converting a function from Python to Go, or porting a component between frameworks you know well. The AI accelerates; your expertise validates.

**Repetitive patterns.** CRUD operations, test scaffolds, configuration files. The kind of code where the structure is fixed and only the names change.

### Where It Breaks

**Templates are deterministic.** Run the same T4 template twice, you get the same output. Same Yeoman generator, same scaffold. You can read the template and know exactly what it produces.

AI is stochastic. Same prompt, different day, different output. The AI might choose a different library, structure the code differently, handle edge cases another way. You can't read the "template" because there isn't one—there's a probability distribution over possible outputs.

**Templates don't make dependency decisions.** A Rails generator adds the dependencies Rails needs. It doesn't decide that your authentication should use Devise, or that your background jobs should use Sidekiq. Those are your choices.

AI makes choices. It picks libraries based on training data patterns, not your preferences. It might reach for `axios` when you'd use `fetch`. It might add `lodash` when you'd write the three lines yourself. It might scaffold your Nuxt 4 site with 1,500 dependencies because that's what the training data said Nuxt sites look like.

**Templates don't have training lag.** A well-maintained template reflects current best practices because someone updates it. The AI's training data has a cutoff. It might suggest deprecated APIs, outdated libraries, or patterns that were best practice two years ago.

---

## The Real Risk: Review Fatigue

Here's what actually happens when experienced developers use AI:

You prompt for a function. The AI produces 50 lines. You scan it. The structure looks right. The logic seems correct. It does what you asked. You move on.

Now ask yourself: would you have reviewed those 50 lines as carefully if you'd written them yourself, character by character?

When you type code, you're making micro-decisions constantly. Each line is a choice. You notice when something feels off because you're in the flow of creation.

When you review AI-generated code, you're validating someone else's choices. That's a different cognitive mode—and it's exhausting. Studies on code review consistently show that attention degrades after the first few hundred lines. AI can generate hundreds of lines in seconds.

**The danger isn't that AI writes bad code.** Often it writes perfectly functional code. The danger is that it writes code you wouldn't have written—subtly different choices, slightly different patterns—and you approve it because it *looks* right.

!!! terminal "Looks Right"
    I've caught myself doing this. The AI generates a function, I scan it, looks good, ship it. A week later I'm debugging something and I look at that function and think: "Why did I do it this way? This isn't how I'd write this."

    I didn't write it. I *approved* it. And in that moment of approval, I wasn't thinking as carefully as I would have been if I'd written it myself. The code worked. The tests passed. But it wasn't *my* code—it was code I'd accepted.

    That's the gap. Not between working and broken. Between intentional and incidental.

### The Rebase Incident

It's not just code. It's actions.

You're working with an AI assistant. There's a merge conflict. The AI says "I'll fix this" and proposes `git pull --rebase`. You know what a rebase is. The AI knows what a rebase is. You click approve.

Your `.env` file—the one with the API keys, the one that wasn't committed because you're not an idiot—gets overwritten.

If you'd been typing commands yourself, you'd have thought: "Wait, I have uncommitted changes. Let me stash first." The muscle memory is there. You've done it a thousand times. But you weren't typing. You were approving. And in approval mode, you trusted that the AI had considered what you would have considered.

It hadn't. It saw a merge conflict and proposed the standard fix. It didn't know about your `.env`. It didn't check for uncommitted files. It did exactly what you asked—fix the conflict—and nothing you didn't ask.

**You knew what a rebase does. You still lost the file.** That's the power tool problem in one sentence. Expertise doesn't protect you when you're not the one holding the tool.

---

## The Supply Chain Angle

Every dependency the AI adds is a dependency you didn't consciously choose.

When you type `pip install pandas`, you're making a decision. You know you're adding pandas. You might even know you're adding numpy and python-dateutil as transitive dependencies.

When AI scaffolds your project, dependencies appear. You asked for "a web scraper" and now you have `requests`, `beautifulsoup4`, `lxml`, `certifi`, `charset-normalizer`, `idna`, `urllib3`, and `soupsieve`. Did you choose those? Or did you inherit them?

The scaffold might be exactly what you would have built yourself. But *would you have noticed* if one of those packages was different from what you'd have chosen? Would you have noticed if there was one extra package you didn't need?

### The 1,500 Dependency Problem

Consider: you ask an AI to scaffold a Nuxt 4 application with a Strapi backend. You understand Nuxt. You know what Strapi does. You're not vibe coding—you're accelerating. The AI didn't make any exotic choices. It set up exactly what you asked for.

The Docker build pulls in 1,500 dependencies.

The AI didn't pick those 1,500 packages. *You* did—by choosing Nuxt and Strapi. The AI just typed faster than you would have. But here's the thing: when you set up a project by hand, you watch the dependencies scroll by. You see `npm install` churning. You have a moment to think: "That's a lot of packages."

When AI scaffolds it, you skip straight to "it works." The 1,500 dependencies are just as real, but you never had that moment of awareness. You never saw the scroll. You never thought "wait, do I need all this?"

This isn't about AI making bad choices. It's about AI making the setup so frictionless that you skip the part where you'd normally pause and think. The [true cost of free](true-cost-of-free.md) applies whether you typed the commands yourself or had AI type them for you—but AI makes it easier to not notice the cost.

---

## Safety Protocols

Power tools have safety features. Blade guards. Emergency stops. Push sticks. You can remove them—pros sometimes do—but they exist because one moment of inattention shouldn't cost you a finger.

Here are the safety protocols for AI-assisted development:

### Keep the Guard On: Review Imports

Before you approve AI-generated code, look at the imports. Every `import` and `require` is a dependency decision. Ask:

- Did I ask for this library, or did the AI choose it?
- Is this the library I would have chosen?
- Do I actually need this, or is it solving a problem I could solve in five lines?

The imports are your blade guard. Don't skip them.

### Use Push Sticks: Lock Your Dependencies

The moment AI-generated code works, lock your dependencies. Run `pip freeze`, commit your `package-lock.json`, update your `go.sum`.

The AI's choices are now recorded. Future builds are reproducible. And when you audit later—because you will audit later—you'll know exactly what you're running.

### Respect the Emergency Stop: Understand Before You Ship

If you don't understand why the AI made a choice, don't ship it. Ask it to explain. Rewrite it yourself if needed. The point of using AI is to go faster, not to go blind.

The table saw has an emergency stop because sometimes you need to halt everything, right now, before the situation gets worse. Your emergency stop is the willingness to throw away AI-generated code that you can't fully explain.

### Check Your Blade: Training Data Lag

The AI's training data has a cutoff. Libraries change. Best practices evolve. What was correct two years ago might be deprecated today.

For anything security-sensitive or infrastructure-critical, verify against current documentation. The AI might be suggesting the equivalent of a saw blade that's been recalled.

---

## The Expertise Trap

Here's the uncomfortable truth: expertise makes you *more* vulnerable to AI-assisted mistakes, not less.

A novice using AI doesn't trust their judgment, so they double-check everything. They're slow, careful, uncertain. They catch mistakes because they're looking for them.

An expert using AI trusts their judgment. They scan quickly, pattern-match against experience, and approve code that "looks right." They're fast, confident, efficient. And occasionally, they approve something they shouldn't have—because their expertise told them it was fine, and they didn't look closely enough to see that it wasn't.

The novice's problem is that they don't know what they're doing. The expert's problem is that they *think* they know what the AI is doing.

!!! terminal "Experience and Complacency"
    I've seen more workshop accidents from experienced carpenters than from beginners. The beginner is scared of the saw. They're careful, tentative, hyper-aware of the blade. The experienced carpenter has made a thousand cuts. They know the tool. They trust themselves.

    And then one day they reach across the blade to grab the offcut before it falls, and now they're explaining to the ER nurse that yes, they've been doing this for twenty years, and no, they don't know why they did that.

    AI is the same. You know what you're doing. You've shipped code for years. And that's exactly why you might approve something you shouldn't—because your expertise says it's fine, and you've learned to trust your expertise.

    Don't stop trusting your expertise. But remember that your expertise is in *your* code, not in code you approved but didn't write.

---

## When to Take Off the Guard

Sometimes you *do* remove the safety features. Experienced woodworkers sometimes remove blade guards for specific cuts that require visibility or clearance. They know the risk, they've made a deliberate choice, and they compensate with extra attention.

The equivalent for AI-assisted development:

**Prototyping and exploration.** When you're just trying things, the dependency graph doesn't matter yet. Let the AI scaffold freely. But know that the prototype is not production—when you promote it, you audit it.

**Throwaway code.** Scripts that run once. Demo applications. Things that will never see production. The risk calculation is different when the code's lifetime is measured in hours.

**Learning and experimentation.** Using AI to understand a new framework or library. The code exists to teach you, not to ship. Generate freely, then understand what was generated.

But when you take off the guard, *know that you've taken it off*. The danger isn't in making exceptions. It's in forgetting that you made them.

---

## Key Takeaways

- [ ] AI-assisted coding is not the same as code generation templates—AI is stochastic and makes dependency choices
- [ ] Review fatigue is real: you don't scrutinize AI code as carefully as code you wrote yourself
- [ ] Every AI-generated import is a dependency decision you didn't consciously make
- [ ] Expertise makes you *more* vulnerable to approval errors, not less
- [ ] Safety protocols exist because one moment of inattention shouldn't cost you the project

You're not vibe coding. You know what you're doing. But the power tool doesn't know what you intended—it only knows what you asked for. Respect the blade.
