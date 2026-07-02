---
name: onboard
description: Generate a draft ONBOARDING.md for the current repo by scanning live source, then interviewing the developer for the context source can't provide (gotchas, ownership). Use when asked to create, generate, or bootstrap an ONBOARDING.md, or to onboard a codebase into the codebase-mentor skill.
argument-hint: "[source-root]"
---

# Generate an ONBOARDING.md Draft

Produce a complete, symbol-anchored `ONBOARDING.md` at the root of the current repo. Most of the document is drafted from live source; the parts source cannot provide — known gotchas, document ownership — come from a short interview with the developer.

The section structure and fill-in rules are defined in the bundled template `ONBOARDING.template.md`, with section-by-section guidance in `AUTHORING_GUIDE.md`. Both live in the `codebase-mentor` skill directory that sits next to this one (`${CLAUDE_PLUGIN_ROOT}/skills/codebase-mentor/` in a plugin install). Read both before drafting.

If an `ONBOARDING.md` already exists at the repo root, stop and ask whether to regenerate it or run a freshness scan instead (Mode 4 of the codebase-mentor skill). Never overwrite it without confirmation.

If the developer passed an argument, treat it as the source root to scan; otherwise use the repo root.

---

## Rules

All rules of the codebase-mentor skill apply here, most importantly:

- **Accuracy contract:** every class, method, or file named in the draft must have been read or grepped in this session. Never fill a section from what codebases "typically" look like.
- **Symbol anchors, not line numbers:** cite `ClassName.methodName()`, never line numbers.
- **Target length 400–800 words.** Brevity beats completeness — this is a map, not a manual.
- Never invent content for sections the interview or source cannot support. Leave an explicit `<!-- TODO -->` with a note instead.

---

## Step 1 — Scan the repo

1. Identify the project type from build/config files (`pom.xml`, `package.json`, `pyproject.toml`, `go.mod`, etc.) and the directory layout.
2. Find the entry points: `main` functions, HTTP route registrations, CLI definitions, job schedulers — whatever starts execution.
3. Trace **one representative execution path** end-to-end through live source, reading each class/function at each hop. Pick the path a new engineer is most likely to ask about (the most common request, the core job run).
4. Identify the architectural layers the trace passed through, and the key symbol that defines each layer's contract.
5. Note recurring patterns a change would follow (e.g., "every command has a resolver registered in X") — these become change recipes.

## Step 2 — Draft the source-derived sections

Using the template's section structure, draft from what you read in Step 1:

- **Section 1 — Codebase Purpose:** one to three sentences; who calls it, what it returns.
- **Section 2 — Layer Map:** table of layers, outermost first, one key symbol each.
- **Section 3 — Execution Lifecycle:** the traced path, one numbered step per hop, each naming a real `Class.method()`.
- **Section 4 — Domain Vocabulary:** 5–10 project-specific terms found in the source, each with the key class that embodies it where one exists.
- **Section 5 — Common Change Recipes:** 3–5 recipes derived from the patterns found in Step 1.5, each an ordered checklist of symbols to touch. Verify every step against an existing example in source.
- **Section 6 — High-Signal Files:** the best one or two entry-point symbols per likely question type.

## Step 3 — Interview the developer

Ask the developer for what source cannot provide. Use the AskUserQuestion tool where available; otherwise ask in plain conversation. Keep it to three questions:

1. **Known gotchas (Section 7):** "What mistakes do senior engineers keep catching in code review on this repo? What invariants aren't visible from reading the source?" For each answer, capture rule / why / what breaks. If the developer has none, leave Section 7 with a `<!-- TODO: interview a senior reviewer -->` marker — do not invent gotchas.
2. **Document owner:** name, team, and review cadence for the owner block.
3. **Representative path check:** confirm the execution path you traced in Step 1 is the one a new engineer most needs; re-trace a different one if not.

## Step 4 — Write and self-verify

1. Write the completed document to `ONBOARDING.md` at the repo root. No `[PLACEHOLDER]` markers may remain except explicit `<!-- TODO -->` notes agreed with the developer.
2. Self-verify: run the codebase-mentor skill's **Mode 4 freshness scan** against the draft you just wrote. Every structural claim must come back ✅ Current. Fix any ⚠️ Stale entry before finishing — a freshly generated document with stale claims is a drafting error.
3. Report to the developer: word count, sections completed, sections left as TODO, and the scan result.
