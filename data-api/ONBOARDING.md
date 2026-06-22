# ONBOARDING.md — Stargate Data API

---

## Document Owner

**Owner:** Eric Hare (Data Platform team)
**Review cadence:** Every 6 months, or after any major architectural change.
**Last reviewed:** 2025-07

---

## 1 — Codebase Purpose

The Stargate Data API is a Quarkus/Java service that accepts JSON API requests (HTTP POST) from
clients and translates them into Cassandra CQL operations executed against an Apache Cassandra
cluster. It is the sole entry point for both document-model operations (on **collections**) and
table-model operations (on regular Cassandra **tables**). The service returns structured JSON
responses and exposes the same command vocabulary to both models wherever the semantics align.

---

## 2 — Layer Map

The codebase is organized into five layers, outermost first:

| Layer | Responsibility | Key symbol |
|---|---|---|
| HTTP Resource | Deserialize the HTTP body into a `Command` POJO; delegate to the processor pipeline | `CollectionResource` |
| Processor | Metrics instrumentation, vectorization, hybrid-field expansion, error recovery | `MeteredCommandProcessor` → `CommandProcessor` |
| Resolver | Choose the optimal `Operation` implementation for a given `Command` and schema type | `CommandResolver` (interface); one concrete resolver per command, e.g. `FindOneCommandResolver` |
| Operation / Task | Build and execute CQL statements; manage state transitions and task-level retries | `FindCollectionOperation`, `BaseTask`, `TaskRetryPolicy` |
| CQL Driver | Send statements to Cassandra; driver-level retry and load balancing are transparent to layers above | `CQLSessionCache` |

---

## 3 — Execution Lifecycle

**Representative request:** `findOne` against a collection

1. **HTTP entry:** `CollectionResource.postCommand()` receives the POST body, deserializes
   it with Jackson into a `FindOneCommand` POJO, builds a `CommandContext` (carrying the
   `CollectionSchemaObject`, tenant, embedding provider, etc.), and forwards both to
   `MeteredCommandProcessor.processCommand()`.

2. **Metrics / logging wrapper:** `MeteredCommandProcessor.processCommand()` starts a Micrometer
   timer, sets up MDC logging keys, then defers to `CommandProcessor.processCommand()` inside a
   `Uni.createFrom().deferred()` block.  On completion it records tags (command name, tenant,
   error codes, sort type) and stops the timer.

3. **Pre-resolve steps:** `CommandProcessor.processCommand()` runs two synchronous steps before
   resolution: (a) `HybridFieldExpander.expandHybridField()` rewrites any `$hybrid` fields, and
   (b) `DataVectorizerService` vectorizes any `$vectorize` text to a float vector, both inline in
   the reactive pipeline.

4. **Resolution:** `CommandResolverService` looks up the `CommandResolver` registered for
   `FindOneCommand` — which is `FindOneCommandResolver`.  `CommandResolver.resolveCommand()`
   dispatches on the schema object type; for a collection it calls
   `FindOneCommandResolver.resolveCollectionCommand()`.  Inside that method the filter expression
   is resolved via `CollectionFilterResolver.resolve()`, then `SortClause.validate()` is called
   to validate sort options, and finally the correct `FindCollectionOperation` factory method
   (`vsearchSingle`, `bm25Single`, `sortedSingle`, or `unsortedSingle`) is selected based on the
   sort clause content.

   > **Note:** According to the API documentation, sort options are validated in
   > `SortClause.validate()` *before* the resolver runs, as a pre-check in the processor pipeline.

5. **Operation execution:** `CommandProcessor` calls `Operation.execute()` on the
   `FindCollectionOperation` instance.  For the unsorted path this issues a Cassandra SELECT via
   `CQLSessionCache`; for the in-memory sort path it over-fetches up to
   `operationsConfig.maxDocumentSortCount()` documents and sorts them in the JVM.

6. **Response:** The operation returns a `CommandResult` which `CommandProcessor` post-processes
   (adding any deprecation warnings), and `MeteredCommandProcessor` serializes back to the HTTP
   response as JSON.

---

## 4 — Domain Vocabulary

| Term | Definition |
|---|---|
| **Command** | An immutable POJO (no behavior) that captures a single API operation — e.g. `FindOneCommand`, `InsertOneCommand`. Behavior lives in the paired `CommandResolver`, not in the command itself. |
| **CommandContext** | A per-request carrier that binds a `Command` to its runtime environment: `SchemaObject`, `RequestContext`, embedding provider, session cache, and feature flags. Created by `CommandContext.BuilderSupplier`. |
| **Resolver** | A `CommandResolver<C>` implementation that maps a `Command` to the optimal `Operation`. There is one resolver class per command (39 concrete `*CommandResolver` implementations in `service/resolver/`). The correct resolver is located at runtime by `CommandResolverService`. |
| **Operation** | A one-shot, executable unit of work that builds and dispatches CQL statements and returns a `CommandResult`. Collection operations live under `service/operation/collections/`; table operations under `service/operation/tables/`. |
| **Task / DBTask** | A `BaseTask` subclass representing a unit of CQL work with explicit state management (`UNINITIALIZED → READY → IN_PROGRESS → COMPLETED/ERROR/SKIPPED`) and retry loops via `TaskRetryPolicy`. Tasks are the primary abstraction for table operations, but also appear in some collection paths (e.g. `IntermediateCollectionReadTask` for reranking). The codebase is mid-migration from the legacy `Operation` model to `TaskOperation`-based execution. |
| **Shredding** | The collection-only process of decomposing a JSON document into indexable atomic entries for storage in Cassandra. Entry point is `DocumentShredder.shred()`. There is no shredding step for table operations — rows map directly to CQL columns. |
| **SchemaObject** | The runtime representation of a target Cassandra entity. `CollectionSchemaObject` holds collection metadata (index config, vector config, id type); `TableSchemaObject` holds the CQL table descriptor. |
| **LWT (Lightweight Transaction)** | A Cassandra conditional write (`IF NOT EXISTS` / `IF` clause) used for upserts and conflict-safe inserts. Several collection write operations use LWTs; the driver-level retry for LWTs is separate from `TaskRetryPolicy`. |
| **Vectorize** | The process of calling an external embedding provider to convert a string field (`$vectorize`) into a float vector (`$vector`) before the CQL statement is built. Orchestrated by `DataVectorizerService`. |

---

## 5 — Common Change Recipes

### Recipe A — Add a new command

1. Create a new class (e.g. `MyNewCommand`) implementing `CollectionCommand` (or
   `TableOnlyCommand` / `GeneralCommand` as appropriate) and annotate it for Jackson `@JsonTypeName`.
2. Implement the `CommandName` enum entry for the new command, including its `CommandTarget` and
   `CommandType`.
3. Create `MyNewCommandResolver` implementing `CommandResolver<MyNewCommand>`; implement
   `resolveCollectionCommand()` and/or `resolveTableCommand()` to return the appropriate
   `Operation`.
4. Annotate `MyNewCommandResolver` with `@ApplicationScoped` so CDI registers it with
   `CommandResolverService` automatically.
5. Add or extend the `Operation` class in `service/operation/collections/` or
   `service/operation/tables/` as needed.
6. Add the YAML error templates for any new error codes the command can raise (see Recipe C).

### Recipe B — Add a new sort type (collection path)

1. Add a new `SortExpression` sub-type or extend `SortClauseUtil` with a new resolution
   method (following the pattern of `resolveVsearch()` and `resolveBM25Search()`).
2. Add the new branch in `FindOneCommandResolver.resolveCollectionCommand()` (and in
   `FindCommandResolver.resolveCollectionCommand()` if the sort also applies to multi-document
   find).
3. Add a corresponding factory method on `FindCollectionOperation` (following the pattern of
   `vsearchSingle()`, `bm25Single()`, `sortedSingle()`).
4. Update `SortClause.validate()` to accept or reject the new sort expression where applicable.
5. Update `MeteredCommandProcessor.getVectorTypeTag()` to emit the correct
   `JsonApiMetricsConfig.SortType` tag for the new sort path.

### Recipe C — Add a new error code

1. Add the SNAKE_CASE enum constant to the appropriate `Code` enum inside the relevant exception
   class (e.g. `RequestException.Code`, `DocumentException.Code`, `SortException.Code`).
2. Create or update the corresponding YAML error-template file that `ErrorTemplate.load()` reads
   at startup. The file must live in the resources directory and follow the existing
   `family/scope/CODE_NAME` naming convention.
3. At the call site, throw the error via the `ErrorCode.get(errVars(...))` pattern (following
   usages of `RequestException.Code.UNSUPPORTED_COLLECTION_COMMAND.get(...)`).
4. Verify the HTTP status override in the YAML template if the error should return a non-200
   status.

---

## 6 — High-Signal Files by Question Type

| Question type | Where to start |
|---|---|
| "How does a read request flow end-to-end?" | `CommandProcessor.processCommand()` → `FindOneCommandResolver.resolveCollectionCommand()` |
| "Where does sort dispatch happen?" | `FindOneCommandResolver.resolveCollectionCommand()` (and `FindCommandResolver` for multi-document) |
| "How does a document get written to Cassandra?" | `DocumentShredder.shred()` → `InsertCollectionOperation` |
| "How are errors defined and thrown?" | `ErrorTemplate`, then the relevant `*Exception.Code` enum (e.g. `RequestException.Code`) |
| "How do retries work at the task level?" | `TaskRetryPolicy`, `BaseTask` |
| "What controls collection vs. table routing?" | `CommandResolver.resolveCommand()` — the `switch` on `commandContext.schemaObject().type()` |
| "How is vectorize text converted to a vector?" | `DataVectorizerService` |
| "Where is per-request schema/config carried?" | `CommandContext` and `CollectionSchemaObject` / `TableSchemaObject` |

---

## 7 — Known Gotchas

### Resolver class renaming breaks saved client flows

**Rule:** Never rename a `CommandResolver` concrete class without a deprecation path, and never
change the `CommandName` API string returned by `commandName().getApiName()`.
**Why:** Some clients and operators persist the command name in logs, routing rules, and
integration tests. The `CommandResolverService` looks up resolvers by `getCommandClass()` at
startup; renaming the class itself is safe for CDI but changes import paths and breaks any code
that references the class by name (e.g. metrics tags, log patterns).
**What breaks:** Metrics dashboards keyed on the command class simple name go dark; log parsers
that match on the old name stop firing.

---

### Collection operations and table operations are intentionally separate packages

**Rule:** Do not add collection logic to `service/operation/tables/` or vice versa. The two
paths (`collections/` and `tables/`) share no concrete operation classes.
**Why:** Collections use a shredded, denormalized storage schema with a fixed set of Cassandra
columns; tables map one-to-one to CQL columns. Sharing operation code would require constant
null-checks and type-switching that would make both paths fragile.
**What breaks:** If collection-specific behavior (e.g. shredding, `$vector` index selection) is
placed in a table operation, it will silently have no effect on the table path — or worse,
throw a `ClassCastException` when the wrong `SchemaObject` type is passed in.

---

### Task-level retry and driver-level retry are independent and additive

**Rule:** `TaskRetryPolicy` operates *after* the Cassandra driver has exhausted its own retry
policy. Setting `maxRetries` in `TaskRetryPolicy` does not replace driver retries — it layers on
top of them.
**Why:** `TaskRetryPolicy.shouldRetry()` receives the `Throwable` that survived all driver-level
handling. A `WriteTimeoutException` that the driver already retried three times and then
re-threw will trigger `shouldRetry()` again if the task policy says yes.
**What breaks:** Doubling retries unexpectedly multiplies Cassandra load and can cause LWT
contention storms. Always check the driver retry policy before configuring a custom
`TaskRetryPolicy` with a non-trivial `maxRetries`.

---

### Shredding is collection-only; calling it on a table path causes silent data loss

**Rule:** `DocumentShredder.shred()` must only be called from collection write operations
(`InsertCollectionOperation`). The table path does not shred — it uses `WriteableTableRowBuilder`
to map JSON fields directly to typed CQL column values.
**Why:** Shredding produces a fixed set of Cassandra columns (`doc_json`, `exist_keys`,
`array_size`, etc.) that only exist in collection tables. Table-backed Cassandra tables have no
such columns.
**What breaks:** If `DocumentShredder.shred()` is accidentally invoked for a table write, the
resulting `WritableShreddedDocument` will be built without error, but the subsequent CQL INSERT
will target columns that don't exist in the table, causing a driver-level error that surfaces as
a confusing schema mismatch rather than a clear "wrong path" error.

---

### Error templates must be loaded from YAML at startup — runtime-only enum constants fail silently

**Rule:** Every `ErrorCode` enum constant must have a corresponding YAML entry that
`ErrorTemplate.load()` can find at startup. Adding an enum constant without the YAML file does
not throw a compile error.
**Why:** `ErrorTemplate.load()` is called in the enum constructor (at class initialization time).
If the YAML resource is missing, initialization fails with an `ExceptionInInitializerError` at
first use, not at startup — making it hard to catch in CI.
**What breaks:** The first request that reaches a code path using the undeclared error code
causes an `ExceptionInInitializerError`, which surfaces to the caller as a 500 with no useful
error body.
