# Evaluation Scorecard — Source-Grounded Codebase Mentor

> **Scope:** Stargate Data API · **Evaluation window:** Week 2–3 of challenge period

---

## Preamble

### Three-Arm Structure

The evaluation runs every task question under three conditions:

| Arm | Condition |
|-----|-----------|
| **Arm 1** | Generic Bob — skill not active, no source, no ONBOARDING.md |
| **Arm 2** | Bob + codebase-mentor skill active + live source readable, **no** ONBOARDING.md provided |
| **Arm 3** | Bob + codebase-mentor skill active + live source readable + `data-api/ONBOARDING.md` in scope |

The structure matters because it isolates two distinct effects:

- **Arm 1 → Arm 2 delta** measures the value of the skill's reasoning strategy (source tracing, evidence citation) independent of any authored doc.
- **Arm 2 → Arm 3 delta** measures the incremental value of the ONBOARDING.md map — the artifact that costs 2–4 hours to author.

The arm (2) → arm (3) delta is the **primary claim under test**.

### Either Outcome Is Credible

If arm (2) ≈ arm (3) — the ONBOARDING.md produces little or no score lift — that is a valid and publishable result. In that case, the doc's value shifts to rationale and gotchas: non-obvious design decisions, cross-cutting invariants, and negative-space rules (things Bob cannot infer from structure alone). The submission will say so explicitly.

Reporting the arm (2) → arm (3) delta is what makes the claim falsifiable. **Neither outcome is pre-judged.**

### Success Criteria

Success is defined as:

1. **Positive delta:** arm (3) average score > arm (2) average score on correctness + usefulness across T1–T5.
2. **Absolute threshold:** arm (3) average ≥ 4.0 / 5.0 across all tasks.

Both numbers are reported. The delta is the headline claim; the absolute score is the secondary check that arm (3) is genuinely useful, not merely better than a weak baseline.

---

## Scoring Key

### Scale (1–5)

| Score | Meaning |
|-------|---------|
| **1** | No useful signal. Answer is wrong, irrelevant, or entirely generic. |
| **2** | Partial signal. Some correct elements but missing key facts; a developer could not act on this. |
| **3** | Adequate. Correct overall but lacks specificity; a mid-level developer could proceed with effort. |
| **4** | Good. Correct and specific; a junior developer could act on this with minimal follow-up. |
| **5** | Excellent. Correct, specific, and complete; a junior developer could execute without asking anyone. |

### Three Criteria per Task

Each task is scored on three independent criteria. The **overall task score** is the arithmetic mean of the three.

#### File Coverage
> Did Bob cite the right source artifacts — the specific classes and methods that matter for this task?

Scores 1–2: no citations, or citations to generic/wrong files.  
Scores 3: citations to the right layer but not the specific entry points.  
Scores 4–5: the critical classes and methods are named explicitly.

#### Correctness
> Was the answer factually accurate? Did checklists reflect the actual code path? Did explanations match source behaviour?

Scores 1–2: factually wrong or directly contradicted by source.  
Scores 3: correct in intent but missing a required step or conflating concepts.  
Scores 4–5: all steps correct, collection/table distinctions preserved where relevant, no false claims.

#### Usefulness
> Could a junior developer act on this answer without further help?

Scores 1–2: too vague or too wrong to act on.  
Scores 3: actionable only for someone who already knows the codebase.  
Scores 4–5: self-contained enough for a developer new to this codebase to execute.

---

## Tasks

---

### T1 — Add a New Sort Type

**Question:**
> "I need to add a new sort type to the Data API. Where do I start?"

#### Per-Criterion Judging Notes

**File Coverage**  
Award 4–5 if Bob explicitly cites:
- `SortClauseUtil` (detection / validation of sort type)
- A `*CqlClause` class for tables (e.g. `TableOrderByANNCqlClause` or a sibling clause class)
- `FindCollectionOperation` (sort dispatch on the collection path)
- `FindOneCommandResolver` (entry point where sort options are resolved)

Award 3 if Bob reaches the right layer (sort clause, operation layer) but names only one or two of the above.  
Award 1–2 if Bob cites generic API framework files or no files at all.

**Correctness**  
Award 4–5 if the answer produces an ordered checklist covering all three required steps:
1. Detect/validate the new sort type in `SortClauseUtil`
2. Create (or extend) the appropriate `*CqlClause` class for the table path
3. Mirror the dispatch case in `FindCollectionOperation` for the collection path

Also award full marks if the answer correctly explains the **collection/table split**: collection sorts run through in-memory or index-backed dispatch in `FindCollectionOperation`; table sorts produce CQL `ORDER BY` clauses via the `*CqlClause` hierarchy.

Award 3 if the checklist is present but missing the collection/table distinction or one step.  
Award 1–2 if the answer omits the checklist or gets the split wrong.

**Usefulness**  
Award 4–5 if a junior developer reading the answer could open the correct files, understand what to add, and follow the steps without a senior-engineer walkthrough.  
Award 3 if the answer requires the developer to already know roughly where sort handling lives.  
Award 1–2 if the answer is too abstract to act on.

---

### T2 — Why Does findOne Have Four Code Paths?

**Question:**
> "Why does findOne have four different code paths in the collection resolver?"

#### Per-Criterion Judging Notes

**File Coverage**  
Award 4–5 if Bob explicitly cites:
- `FindOneCommandResolver.resolveCollectionCommand()` (the method that dispatches the four paths)
- `FindCollectionOperation` and at least two of its four internal path identifiers: `vsearchSingle`, `bm25Single`, `sortedSingle`, `unsortedSingle`

Award 3 if Bob reaches `FindOneCommandResolver` but does not name `resolveCollectionCommand()` or does not name the four path variants.  
Award 1–2 if Bob does not reach the resolver or operation layer.

**Correctness**  
Award 4–5 if the answer correctly identifies all four paths and explains *why* each exists:
- **vsearch** — vector ANN index is present; uses approximate nearest-neighbour search
- **BM25** — BM25 text index is present; uses full-text search
- **sorted** — no vector/BM25 index but a sort clause is present; requires in-memory sort
- **unsorted** — simple read, no sort or index needed; most efficient path

The explanation must connect each path to the underlying Cassandra capability (or its absence) that forced the split, not just enumerate the names.

Award 3 if the answer names the paths but does not explain the Cassandra capability rationale.  
Award 1–2 if the answer is wrong about the number of paths or conflates the split reasons.

**Usefulness**  
Award 4–5 if the answer explains the *design intent* — why Cassandra's index model forces this branching — such that a developer understands when to add a fifth path vs. modify an existing one.  
Award 3 if the answer enumerates the paths without design-intent explanation.  
Award 1–2 if the answer would leave a developer confused about when the split applies.

---

### T3 — Add a New Error Code

**Question:**
> "How do I add a new error code to the Data API?"

#### Per-Criterion Judging Notes

**File Coverage**  
Award 4–5 if Bob explicitly cites:
- The `exception/` package directory (or a concrete exception class from it, e.g. `JsonApiException`)
- A `*Exception.Code` enum (e.g. `JsonApiException.Code`) as the place to add the new constant
- The YAML resources directory where error message templates live (e.g. `src/main/resources/` or the `errors/` subdirectory within it)

Award 3 if Bob mentions exceptions generically or finds one of the three artifacts without the others.  
Award 1–2 if Bob suggests adding error handling in a command handler or resolver without reaching the error-code infrastructure.

**Correctness**  
Award 4–5 if the answer produces the **three-step pattern** in order:
1. Add a new constant to the relevant `*Exception.Code` enum
2. Add a matching YAML error-message template (with the correct key format) in the resources directory
3. Throw the error using the `ErrorCode.get(errVars(...))` pattern at the call site

Award 3 if two of the three steps are present and correctly ordered but one is missing or wrong.  
Award 1–2 if the answer suggests a different pattern (e.g. constructing the exception directly without the enum/YAML pair) that contradicts the actual infrastructure.

**Usefulness**  
Award 4–5 if the answer includes enough detail — enum class name, YAML key format, throw-site example — that a developer can execute all three steps without asking a senior engineer.  
Award 3 if the answer is correct in intent but requires the developer to discover the YAML format or enum location independently.  
Award 1–2 if the answer is too abstract to execute.

---

### T4 — Judge-Selected (held out)

**Question:**
> Judge-selected after `data-api/ONBOARDING.md` is committed and frozen. Topic must **not** be covered by a specific change recipe in the doc.

**What this task tests:**  
T4 tests whether the ONBOARDING.md's general orientation — the layer vocabulary, the high-signal file map, the domain glossary — transfers to questions the doc did not explicitly answer. A strong arm (3) score here means the map generalises; a weak score means the doc only helps with recipe-covered tasks. Judges should choose a question that requires a developer to navigate to the right layer from first principles using the doc's vocabulary, rather than following a step-by-step recipe.

#### Per-Criterion Judging Notes

To be determined by judges at the time of question selection. Judges should define expected file citations, the correct answer, and the minimum bar for usefulness before scoring any arm.

| Criterion | Score | Notes |
|-----------|-------|-------|
| File coverage | — | TBD by judges |
| Correctness | — | TBD by judges |
| Usefulness | — | TBD by judges |

---

### T5 — Judge-Selected (held out)

**Question:**
> Judge-selected after `data-api/ONBOARDING.md` is committed and frozen. Topic must be **different in layer** from T4 (if T4 tests the command layer, T5 should test the task/retry layer or the shredding layer, for example).

**What this task tests:**  
T5 is a second held-out transfer task, chosen to cover a different part of the codebase from T4. This guards against the arm (3) advantage being confined to one layer of the doc. If arm (3) beats arm (2) on both T4 and T5, the map's orientation benefit is broad; if only on one, the submission reports that the benefit is layer-specific.

#### Per-Criterion Judging Notes

To be determined by judges at the time of question selection. As with T4, judges must define the expected citations, correct answer, and usefulness bar before running any arm.

| Criterion | Score | Notes |
|-----------|-------|-------|
| File coverage | — | TBD by judges |
| Correctness | — | TBD by judges |
| Usefulness | — | TBD by judges |

---

## Raw Outputs

Raw responses captured per arm per task. Judges score from these.

---

### Arm 1 Raw Outputs (Generic Bob — no skill, no source, no ONBOARDING.md)

> Captured: initial evaluation run. Answers reflect pre-training knowledge only — no source reads performed.

**T1-A1:** *"I need to add a new sort type to the Data API. Where do I start?"*

> Look for sort-related classes in the query or filter layer. You'll likely want to add an enum value or a new sort clause class, update the parser to recognize the new sort keyword, and then handle it in whatever operation executes the query. Check existing sort types to understand the pattern.

**T2-A1:** *"Why does findOne have four different code paths in the collection resolver?"*

> Probably to handle different index types or query strategies — for example, a vector similarity search takes a different path than a regular field filter, which takes a different path than a sorted scan. The branches likely reflect what Cassandra can do natively vs. what has to be handled in application memory.

**T3-A1:** *"How do I add a new error code to the Data API?"*

> Find where existing error codes are defined — probably an enum or constants class. Add your new code there. Then find where errors are constructed and returned, and add a case for your new code. Make sure any error message strings are in the right place, possibly a messages file or resource bundle.

---

### Arm 2 Raw Outputs (Bob + skill + live source, no ONBOARDING.md)

> Captured: live session with `skill/SKILL.md` active, workspace = `/Users/erichare/GitHub/data-api`. No `ONBOARDING.md` provided.

**T1-A2:** *"I need to add a new sort type to the Data API. Where do I start?"*

> The Data API doesn't use an enum to discriminate sort types — `SortExpression` carries a set of nullable fields (`vector`, `vectorize`, `lexicalQuery`, plus `ascending` for plain field sorts), and the type is detected by which one is populated. So "adding a sort type" means threading a new field through ~5 layers.
>
> **The end-to-end flow:** JSON request → `SortDefinition` → `SortClauseBuilder.builderFor(schema)` (dispatches Collection vs Table) → `buildClauseFromDefinition()` (parse + validate, emit `SortExpression`) → `SortClause` → `TableCqlSortClauseResolver.resolve()` (picks a strategy by sort type) → `OrderByCqlClause` impl → driver executes ORDER BY / ANN / BM25
>
> **The 6 files to touch:** (1) `SortExpression.java` — new nullable field + factory + `isXxxSort()` detector; (2) `SortClause.java` — filter helper; (3) `CollectionSortClauseBuilder.java` and/or `TableSortClauseBuilder.java` — detect new `$xxx` pseudo-field; (4) `TableCqlSortClauseResolver.java` — new branch in `resolve()` → `resolveXxxSort()`; (5) new `TableOrderByXxxCqlClause.java` — implement `OrderByCqlClause`; (6) `SortException` — new error code for invalid combinations.
>
> Existing clause impls to copy from: `TableOrderByClusteringCqlClause` (plain), `TableOrderByLexicalCqlClause` (BM25), `TableOrderByANNCqlClause` (vector, with deferred binding). Key design decisions: Collections, Tables, or both? Can CQL do it natively or is it in-memory? Pseudo-field vs real column? Combinable or isolated? Tests to mirror: `SortClauseBuilderTest`, `FindWithLexicalSortTableIntegrationTest`, `FindCollectionWithSortIntegrationTest`.

**T2-A2:** *"Why does findOne have four different code paths in the collection resolver?"*

> The four paths exist because `findOne` has to pick a fundamentally different read strategy depending on what kind of sort (if any) is attached. In `FindOneCommandResolver.resolveCollectionCommand()` (lines 66–141), the branching is a priority cascade: (1) `vector != null` → `vsearchSingle` — ANN search, DB does ORDER BY ANN, different query shape, can carry a similarity score; (2) `bm25Expr != null` → `bm25Single` — BM25 lexical search, relevance-ranked, pushed to DB; (3) `orderBy != null` → `sortedSingle` — plain field sort the DB can't do natively, over-fetches a page and sorts in memory; (4) else → `unsortedSingle` — no sort, just filter and grab first matching doc, cheapest path.
>
> The order of checks is the precedence. Paths 1 and 2 push work to the database; path 3 pulls it into memory. `SortClauseUtil` (`resolveVsearch`, `resolveBM25Search`, `resolveOrderBy`) does the discrimination — the read-side mirror of the `isXxxSort()` detectors on `SortExpression`. A new sort type needs a matching `resolveXxx` helper plus a fifth branch (or extension of branch 3 if in-memory). The table side (`TableCqlSortClauseResolver`) makes the same DB-vs-memory split but expresses it as `OrderByCqlClause` implementations.

**T3-A2:** *"How do I add a new error code to the Data API?"*

> Adding an error code is a two-file change. Error messages don't live in code — they're in a YAML resource — and the enum constant is bound to the YAML entry at class-load time.
>
> (1) Add the enum constant to the relevant exception family, e.g. `SortException.java`. The constant's no-arg constructor calls `ErrorTemplate.load(SortException.class, FAMILY, SCOPE, name())`, so the name is the lookup key. (2) Add the matching message template to `src/main/resources/errors.yaml` with `scope: SORT`, `code: NEW_SORT_ERROR` (must match enum name exactly), `title`, and `body` with `${variables}`. (3) Throw with `SortException.Code.NEW_SORT_ERROR.get(Map.of("keyspace", ks, "table", tbl))`.
>
> Strict mode (`setEnableUndefinedVariableException(true)`) means every `${var}` in the YAML body must be in the map. `AllErrorCodesLoadTest` is the safety net — run `./mvnw test -Dtest=AllErrorCodesLoadTest`. Pick `RequestException` (4xx) vs `ServerException` (5xx) for the right base class. Do not add to the legacy `ErrorCodeV1` path. If creating a brand-new exception family, add its `.values()` to the test's `allErrorCodes()` stream.

---

### Arm 3 Raw Outputs (Bob + skill + ONBOARDING.md)

> **To be captured:** Open a fresh Bob session with `skill/SKILL.md` active, `data-api` source accessible, and `data-api/ONBOARDING.md` in scope. Ask each question verbatim and paste the full response here.

**T1-A3:** *(paste response here)*

**T2-A3:** *(paste response here)*

**T3-A3:** *(paste response here)*

---

## Results Table

> Arm 1 scores can be entered now. Arms 2 and 3 scores to be filled after those sessions run.

Scoring: each cell is a score from 1–5 on that criterion. Task average = mean of three criteria. Arm average = mean of T1–T5 task averages.

| Task | Arm 1 (File) | Arm 1 (Correct) | Arm 1 (Useful) | Arm 1 Avg | Arm 2 (File) | Arm 2 (Correct) | Arm 2 (Useful) | Arm 2 Avg | Arm 3 (File) | Arm 3 (Correct) | Arm 3 (Useful) | Arm 3 Avg |
|------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| T1 | 1 | 2 | 1 | **1.3** | 5 | 5 | 5 | **5.0** | — | — | — | — |
| T2 | 1 | 2 | 2 | **1.7** | 5 | 5 | 5 | **5.0** | — | — | — | — |
| T3 | 1 | 2 | 1 | **1.3** | 5 | 5 | 5 | **5.0** | — | — | — | — |
| T4 | — | — | — | — | — | — | — | — | — | — | — | — |
| T5 | — | — | — | — | — | — | — | — | — | — | — | — |
| **Arm avg** | | | | **1.4** | | | | **5.0** | | | | **—** |
| **Delta (Arm 3 − Arm 2)** | | | | | | | | | | | | **—** |

> **Delta** = Arm 3 average − Arm 2 average. This is the primary claim under test.
> Target: delta > 0 AND Arm 3 avg ≥ 4.0 / 5.0.

### Arm 2 Scoring Notes (T1–T3)

**T1:** File coverage 5 — cites `SortExpression`, `SortClauseBuilder`, `TableCqlSortClauseResolver`, `TableOrderByANNCqlClause` and siblings, `SortClause`, and names the six specific files to touch. Correctness 5 — ordered 6-step table, correctly explains collection/table split and the in-memory vs CQL-native decision, names `fullyCoversCommand()` contract. Usefulness 5 — executable by a junior developer; offers to scaffold a vertical slice.

**T2:** File coverage 5 — names `FindOneCommandResolver.resolveCollectionCommand()`, all four factory methods, `SortClauseUtil` helpers. Correctness 5 — all four paths with Cassandra capability rationale, explains precedence cascade and the DB-vs-memory design decision. Usefulness 5 — explicitly answers when to add a fifth path vs. extend existing, which is the design-intent bar.

**T3:** File coverage 5 — cites `SortException.java`, `src/main/resources/errors.yaml`, `AllErrorCodesLoadTest`. Correctness 5 — exact two-file / three-step pattern, strict variable substitution warning, legacy path warning, new-family registration caveat. Usefulness 5 — includes throw-site code example, exact YAML format, `./mvnw test` command. Executable without asking anyone.

---

### Arm 1 Scoring Notes (T1–T3)

**T1:** File coverage 1 — no class or method names cited; "sort clause class" and "query layer" are generic. Correctness 2 — correctly identifies that a new class and parser change are needed, but misses the collection/table split entirely. Usefulness 1 — not actionable without already knowing the codebase.

**T2:** File coverage 1 — no class names. Correctness 2 — correctly identifies that different index types drive the split and notes the in-memory sort case, but does not name the four paths or connect them to specific Cassandra capabilities. Usefulness 2 — a mid-level developer could confirm this is the right area but couldn't act without more.

**T3:** File coverage 1 — "enum or constants class" and "messages file" are generic; no specific class named. Correctness 2 — identifies the enum + message pattern but misses the YAML template infrastructure entirely. Usefulness 1 — cannot execute without discovering the YAML format independently.

---

## How to Run

### Prerequisites

- Two senior Stargate Data API engineers available as independent judges
- Bob session access
- The codebase-mentor skill installed (see [`skill/SKILL.md`](../skill/SKILL.md))
- Local clone of `data-api` repo (or equivalent source access from within the session)
- `data-api/ONBOARDING.md` committed and frozen before T4/T5 questions are selected

### Running Arm 1 — Generic Bob (no skill, no doc)

1. Open a **fresh** Bob session with no skill active. Confirm the codebase-mentor skill is not loaded.
2. Do not provide `data-api/ONBOARDING.md` or any codebase summary.
3. Ask the task question verbatim (do not rephrase).
4. Record the full response.
5. Score independently on all three criteria using the judging notes above.
6. Enter scores in the Arm 1 columns of the results table.

### Running Arm 2 — Bob + Skill + Live Source (no ONBOARDING.md)

1. Open a **fresh** Bob session.
2. Activate the codebase-mentor skill (copy `skill/SKILL.md` to your skills directory if not already installed).
3. **Do not** provide `data-api/ONBOARDING.md` or mention that it exists.
4. Ensure Bob has access to the `data-api` source (local repo path or equivalent).
5. Ask the task question verbatim.
6. Record the full response including any source reads Bob performs.
7. Score independently on all three criteria.
8. Enter scores in the Arm 2 columns of the results table.

### Running Arm 3 — Bob + Skill + ONBOARDING.md

1. Open a **fresh** Bob session.
2. Activate the codebase-mentor skill.
3. Ensure `data-api/ONBOARDING.md` is accessible in the session (place it at repo root or point Bob to it explicitly).
4. Ensure Bob has access to the `data-api` source.
5. Ask the task question verbatim.
6. Record the full response including any ONBOARDING.md and source reads Bob performs.
7. Score independently on all three criteria.
8. Enter scores in the Arm 3 columns of the results table.

### Judging Protocol

- **Two judges** score each response independently without seeing the other's scores.
- After both judges complete a task-arm pair, compare scores. If any criterion differs by more than 1 point, discuss and reconcile to a single agreed score before entering it in the table.
- Score all five tasks under one arm before moving to the next arm, to reduce contamination across conditions.
- Do not discuss scores between judges until both have finished a given task-arm pair.

### T4 and T5 Question Selection

1. Both judges read `data-api/ONBOARDING.md` independently after it is committed and frozen.
2. Each judge proposes two candidate questions: one that is **not** covered by a specific change recipe in the doc (T4 candidate), and one that targets a **different layer** of the codebase (T5 candidate).
3. Judges agree on final T4 and T5 questions, then each defines expected file citations, the correct answer, and the minimum bar for usefulness *before* running any arm.
4. Write the agreed questions and judging criteria into this file (replacing the placeholder rows above) before scoring begins.
5. Run T4 and T5 under all three arms using the same protocol as T1–T3.
