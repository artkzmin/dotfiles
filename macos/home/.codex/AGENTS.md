# Strict Rules

## Language

* Respond to the user in Russian.
* Write any documentation you create in Russian.
* Never use the em dash `—` or en dash `–`; use `-`.
* Never use curly quotes `“”`; use straight quotes `""`.

## AI && MCP

* Never perform tasks that you delegated to subagents. Always wait for subagents to finish their work and never terminate them early, even if you already have enough data without their results. This is required to save context.
* Never inspect `archive/`, `tmp/`, `tmp.md`, `todo.md`, or `tmp.py` unless explicitly asked to do so.
* If you do not know something or are unsure, say so. Do not make up answers.

## Git

* Write commit messages in English using Conventional Commits.

## Shell

* By default, add the `rtk` prefix to shell commands for compact output and tracking; run commands without `rtk` only when exact raw output is required or when `rtk` changes execution semantics. Supported `rtk` targets: `ls`, `tree`, `read`, `smart`, `git`, `gh`, `glab`, `aws`, `psql`, `pnpm`, `npm`, `npx`, `err`, `test`, `json`, `deps`, `env`, `find`, `grep`, `rg`, `diff`, `log`, `dotnet`, `docker`, `kubectl`, `oc`, `summary`, `init`, `wget`, `wc`, `gain`, `cc-economics`, `config`, `jest`, `vitest`, `prisma`, `tsc`, `next`, `lint`, `prettier`, `format`, `playwright`, `cargo`, `curl`, `discover`, `session`, `telemetry`, `learn`, `run`, `proxy`, `pipe`, `trust`, `untrust`, `verify`, `ruff`, `pytest`, `mypy`, `rake`, `rubocop`, `rspec`, `pip`, `go`, `gt`, `golangci-lint`, `gradlew`, `mvn`, `bundle`, `pulumi`, `hook-audit`, `rewrite`, `hook`, `help`.

## Code Style

* Do not end comments with a period.

### Python

* Do not use `from __future__ import ...`.
* Do not use relative imports when they can be avoided.

### SQL

* Write in lowercase.

## Context7

Use Context7 MCP to fetch current documentation whenever the user asks about a library, framework, SDK, API, CLI tool, or cloud service - even well-known ones like React, Next.js, Prisma, Express, Tailwind, Django, or Spring Boot. This includes API syntax, configuration, version migration, library-specific debugging, setup instructions, and CLI tool usage. Use even when you think you know the answer - your training data may not reflect recent changes. Prefer this over web search for library docs.
Do not use for: refactoring, writing scripts from scratch, debugging business logic, code review, or general programming concepts.

### Steps

1. Always start with `resolve-library-id` using the library name and what to look up in the library's documentation, unless the user provides an exact library ID in `/org/project` format
2. Pick the best match (ID format: `/org/project`) by: exact name match, description relevance, code snippet count, source reputation (High/Medium preferred), and benchmark score (higher is better). If results don't look right, try alternate names or queries (e.g., "next.js" not "nextjs", or rephrase the question). Use version-specific IDs when the user mentions a version
3. `query-docs` with the selected library ID and what to look up in the library's documentation (not single words), scoped to a single concept. If the question spans multiple distinct concepts (e.g. routing and auth and caching), make a separate `query-docs` call per concept with the same library ID, unless the question is about how the concepts interact - combined queries dilute ranking and return shallow results for each topic
4. Answer using the fetched docs
