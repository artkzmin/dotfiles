# Language
- Always respond and write documentation in Russian.
- Do not use em dash `—` or en dash `–`; use `-` instead. Do not use curly quotes `“”`; use straight quotes `""`.

# AI && MCP
- When accessing a database through MCP or direct queries, use read-only operations only. Never modify the database.
- When planning and working on a repository, save context by breaking the task into subtasks handled by separate subagents. If you use subagents, use the `gpt-5.4 xhigh` model for them. Ideally, each subagent should spend no more than 100-150k tokens on one subtask.
- Always wait for subagents to finish their work and never terminate them early, even if you already have enough data without their results. This is required to save context.
- Never inspect `archive/`, `tmp/`, `tmp.md`, or `todo.md` unless the user explicitly asks you to do so.
- If you do not know something or are unsure, say so. Do not make up answers.

# Shell
- Prefix shell commands with `rtk` by default. Run commands without `rtk` only when raw output is required or `rtk` changes execution semantics.
- Available `rtk` subcommands: `ls`, `tree`, `read`, `smart`, `git`, `gh`, `aws`, `psql`, `pnpm`, `err`, `test`, `json`, `deps`, `env`, `find`, `diff`, `log`, `dotnet`, `docker`, `kubectl`, `summary`, `grep`, `init`, `wget`, `wc`, `gain`, `cc-economics`, `config`, `jest`, `vitest`, `prisma`, `tsc`, `next`, `lint`, `prettier`, `format`, `playwright`, `cargo`, `npm`, `npx`, `curl`, `discover`, `session`, `telemetry`, `learn`, `run`, `proxy`, `pipe`, `trust`, `untrust`, `verify`, `ruff`, `pytest`, `mypy`, `rake`, `rubocop`, `rspec`, `pip`, `go`, `gt`, `golangci-lint`, `hook-audit`, `rewrite`, `hook`, `help`.

# Git
- Write commit messages in English using Conventional Commits.
- Never push on your own.

# Code Style
- Do not end comments with periods.

## Python
- Do not use `from __future__ import ...`.
- For Python projects, use this stack by default: `PostgreSQL, FastAPI, SQLAlchemy 2.x, Alembic, Pydantic v2, Redis, Celery, Docker, Docker Compose, pytest, uv` as the package manager, `ruff`, `black`, `mypy`. Ask me before replacing anything.

### Alembic
- In migrations, use constants only when they are used in both `upgrade` and `downgrade`. If a value needs to be extracted into a variable used only inside one function, use a lower-case local variable. Use `NEW`/`new` and `OLD`/`old` prefixes when values represent new or old data.
- In Alembic migrations, use `sa.text(...).params(...)` instead of `sa.text(...).bindparams(...)`.
- When creating a migration, write the current timestamp into it.
- Do not write a comment in the docstring at the beginning of a migration.

## SQL
- Write SQL in lower case.

## Frontend
- Use this frontend stack: `React + Next.js + TypeScript`.
- SEO optimization is important.
