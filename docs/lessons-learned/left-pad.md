# left-pad (2016)

**The Lesson:** Transitive dependencies are invisible risk. Trivial code still has dependency weight.

!!! terminal "Invisible Weight"
    Nobody thinks about their dependencies' dependencies. Until all of those invisible assumptions suddenly become visible at the worst possible moment.

---

## What Happened

On March 22, 2016, Azer Koçulu unpublished all 273 of his npm packages.[^koculu-medium] One of them was `left-pad`—an 11-line function that pads strings with spaces or zeros on the left side.

Within minutes, builds started failing across the internet. Babel broke. React Native broke. Thousands of projects that had never heard of `left-pad` suddenly couldn't build.[^register-left-pad]

The function itself was trivial:

```javascript
function leftPad(str, len, ch) {
  str = String(str);
  var i = -1;
  if (!ch && ch !== 0) ch = ' ';
  len = len - str.length;
  while (++i < len) {
    str = ch + str;
  }
  return str;
}
```

Eleven lines. No dependencies of its own. And yet when it disappeared, the JavaScript ecosystem ground to a halt.

## Why It Happened

Koçulu's dispute wasn't about `left-pad`. He'd created a package called `kik`, and Kik Interactive (the messaging company) sent him a takedown request through npm. When npm complied—transferring the package name to the company—Koçulu rage-quit, unpublishing everything he'd ever contributed.[^koculu-medium]

The `left-pad` package had been downloaded 2.5 million times in the month before its removal.[^npmjs-left-pad] But almost nobody installed it directly. It came in as a transitive dependency—a dependency of a dependency of a dependency. Most developers had no idea it existed in their projects.

## Why It Mattered

This incident exposed several uncomfortable truths about modern software development:

**The dependency graph is invisible.** Developers were adding packages they knew—Babel, React—without realizing those packages depended on hundreds of other packages. The average npm project in 2016 had over 100 transitive dependencies. Today it's often closer to 1,000.[^npm-dependency-growth]

**Trivial packages accumulate.** The JavaScript ecosystem had developed a culture of publishing tiny single-function packages. `is-odd`, `is-even`, `is-number`. Individually reasonable, collectively they created a fragile web of dependencies that any single maintainer could disrupt.

**Unpublishing was too easy.** Before this incident, npm allowed package authors to unpublish at will, regardless of how many projects depended on their code. The ecosystem had built critical infrastructure on assumptions that turned out to be false.

**There was no warning.** Projects didn't fail gracefully. They just stopped building. No fallback, no cached copies, no time to react.

## What Changed

npm changed its unpublish policy within hours of the incident.[^npm-unpublish-policy] Packages with dependents, or packages older than 24 hours with significant downloads, can no longer be unpublished without npm support intervention. Once code is in the registry and being used, it stays.

The incident also sparked conversations about:

- **Dependency hygiene** — Do you really need a package for 11 lines of code?
- **Vendoring and caching** — Should your builds depend on external registries being available?
- **Lock files** — At least know *which* versions you depend on, so you can debug when things break.

!!! terminal "Eleven Lines"
    I've watched this pattern before. Not with npm specifically—the ecosystem didn't exist when I started—but the dynamic is old.

    Every time a platform makes sharing easy, people share too much. Every time adding a dependency is frictionless, people add too many. And every time someone asks "should I really depend on this?", the answer comes back "why not, it's free."

    Except it's not free. You're trusting unknown code, written by unknown people, maintained on their schedule, available at their discretion. When Koçulu unpublished his packages, he was within his rights. The ecosystem just assumed he wouldn't.

    The lesson isn't "don't use dependencies." That ship sailed decades ago. The lesson is: **know what you're depending on, and have a plan for when it disappears.** Eleven lines of code. That's all it took.

---

## Timeline

| Date | Event |
|------|-------|
| March 22, 2016 | Koçulu unpublishes all packages after `kik` dispute |
| March 22, 2016 | Builds fail across npm ecosystem |
| March 22, 2016 | npm re-publishes `left-pad` to restore builds |
| March 23, 2016 | npm announces new unpublish policy |

---

[^koculu-medium]: Koçulu, Azer. "I've Just Liberated My Modules." Medium. March 2016. (Original post has been deleted; archived versions available.)

[^register-left-pad]: See [left-pad Incident](../reference/sources.md#left-pad)

[^npmjs-left-pad]: npm download statistics, archived March 2016.

[^npm-dependency-growth]: Various analyses of npm dependency growth, including "The State of JavaScript" surveys 2016-2024.

[^npm-unpublish-policy]: npm. "Changes to npm's Unpublish Policy." March 2016. https://blog.npmjs.org/post/141577284765/kik-left-pad-and-npm
