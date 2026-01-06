# Foreword

## About the Voice

If you've read the Preface, you've met the narrator—a grizzled veteran who watched build systems and dependency management evolve from nothing into the sprawling ecosystems we have today. That voice is a deliberate choice.

I wanted this guide to feel like getting advice from someone who'd seen it all. Not a textbook, not a vendor whitepaper, but the kind of practical wisdom you'd get from a mentor who's been around long enough to know where the bodies are buried. The voice is a composite—part oral history, part lived experience, and part "the tone I wish someone had used when explaining this stuff to me."

The incidents are real. The lessons are real. The "*I've seen this before*" framing is a narrative device. Consider it pattern recognition in service of education.

## About Me

My name's Andrew, and I wrote my first code when I was still had single-digit birthdays—a batch script that let you choose from different fart sounds I had recorded, which I promptly uploaded to my local BBS's files section to share. I was *very* proud.

By sixth grade, I'd graduated to QuickBASIC, where I wrote a program to brute-force a math problem I didn't yet have the tools to solve. I looped through every possible value until I found the answer. It worked. Months later, I learned the same problem was trivial with algebra. I'd reinvented the wheel—badly—because I didn't know the wheel existed.

That pattern would repeat.

In high school, I built websites with Classic ASP and Access databases, because that's what I could figure out. Eventually I discovered .NET and "real" databases, and I looked back at my earlier work with a mix of horror and fondness. The code was terrible. But it worked, and I learned.

I read books like [*Where Wizards Stay Up Late*](https://www.simonandschuster.com/books/Where-Wizards-Stay-Up-Late/Katie-Hafner/9780684832678) and wanted to start my own ISP. I maintained pieces of my high school's website while the browser wars raged (*"it's fine in Navigator, but why does it look so bad in IE4?"*). I watched the foundational shifts in how software was built and shared, seeing the names and players without always understanding the bigger picture.

## Why This Guide Exists

I now manage infrastructure and support researchers at a university—the same kinds of systems I once hacked together as a kid, but at scale. And I watch brilliant people make the same mistakes I made, over and over.

They `pip install` packages they've never examined. They copy Dockerfiles from Stack Overflow without reading them. They build critical research pipelines on dependencies maintained by strangers, with no plan for what happens when those dependencies break. They don't think about supply chains because nobody ever taught them to.

They're not careless. They're focused on their research—engineering, biology, physics, medicine, social science—and software is just a tool to get there. They learned enough to be productive and moved on. The fundamentals of dependency management, reproducibility, and supply chain security never made it into their curriculum.

I see the same patterns I fell into: reinventing wheels badly, trusting code I didn't understand, building on foundations I'd never examined. The difference is that my bad batch scripts couldn't compromise patient data or invalidate years of research.

This guide is my attempt to bridge that gap—to explain the things I wish someone had explained to me, in language that doesn't assume you already know what a lock file is or why you should care.

## How This Was Made

I built this guide with Claude, Anthropic's AI assistant. Claude helped me research, organize, write, and maintain something resembling academic rigor.

The collaboration worked like this: I knew what I wanted to say and roughly how I wanted to say it. Claude helped me say it clearly, consistently, and with proper citations. Every claim is sourced, and every opinion is marked as opinion. The errors that remain are mine.

There's something fitting about using AI to write about software supply chains. The models themselves are built on vast quantities of open source code, trained on the very ecosystems this guide describes. The tools shape how we work, and acknowledging that feels important—especially as we try to distinguish useful resources from the flood of AI-generated noise. I hope this guide earns your trust through its substance, not just its volume.

## Companion Guide

This guide has a sibling: the [Open Source Licensing Guide](https://libre.xram.net), which covers the licensing fundamentals that underpin much of what we discuss here. If you're working with open source software—and if you're reading this, you are—understanding licenses is part of understanding your supply chain.

## License

This guide is released under [CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/)—Creative Commons Attribution-NonCommercial 4.0 International.

You're free to share and adapt this material for non-commercial purposes, as long as you give appropriate credit. If you're an educator, researcher, or developer trying to understand supply chains and dependencies better, this is for you. If you're a company that wants to use this for training materials, let's talk.

Why NonCommercial? Because I built this to help people, not to create a product. The NC clause keeps it that way while still allowing the sharing and adaptation that makes open resources valuable.

---

*— Andrew Marx, 2026*
