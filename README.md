# Impeccable for MiniMax Code

[Impeccable](https://impeccable.style/) is a design skill for AI coding agents — 24
commands covering new work, critique, audit, polish, hardening, and visual
iteration, plus a deterministic detector with 61 anti-pattern rules.

Upstream ships builds for Claude Code, Cursor, Codex, Gemini CLI, Copilot,
OpenCode and others. **This fork adds MiniMax Code as a supported harness.**

## Why a fork

MiniMax Code resolves skills from `~/.minimax/skills/<name>/SKILL.md` and has no
`/impeccable <command>` slash namespace, no provider hook manifest format, and a
stricter frontmatter schema. Upstream's installer has no `minimax` provider:

```
$ npx impeccable install --providers=minimax
Unknown provider(s): minimax
```

So an upstream install either lands in an unused directory or doesn't happen at
all. This fork makes the skill work natively.

## What changed vs upstream

| Area | Upstream | This fork |
|---|---|---|
| Install path | `<repo>/.github/skills/impeccable/` | `~/.minimax/skills/impeccable/` |
| Frontmatter | `name`, `description`, `version`, `user-invocable`, `argument-hint`, `license` | `name`, `description`, `version`, `license`, `descriptions.ru-Hans` |
| Script paths | Provider-prefixed literals (`.claude/skills/impeccable/scripts/…`) | `<skill-base-dir>/scripts/…` placeholder — location-independent |
| Command invocation | `/impeccable <command>` slash commands | Plain-language request, or a direct engine call |
| Runtime metadata | Provider manifests | `_meta.json` with `platform: "minimax"` |
| Hooks | Per-provider hook manifest | Not wired; `detect` runs on demand |
| Agent subagents | Copilot/Claude/Cursor agent files | Not included |

The design content — every command playbook, the craft floor, the detector — is
unchanged from upstream.

## Install

```sh
git clone https://github.com/aa-blinov/impeccable-mcode.git
./impeccable-mcode/install.sh
```

Or without cloning:

```sh
curl -fsSL https://raw.githubusercontent.com/aa-blinov/impeccable-mcode/main/install.sh | sh
```

Existing install? Re-run with `IMPECCABLE_FORCE=1`, or `./uninstall.sh` first.
To install somewhere other than the user scope:

```sh
IMPECCABLE_SKILL_HOME=/custom/path ./install.sh
```

**Start a new session afterwards** — MiniMax Code loads skills at session start.

## Use

There is no slash command. Ask in plain language:

```
audit the study screen
polish the landing page
why does the stats page feel flat
adapt this for mobile
```

The verb routes to the matching playbook in `reference/`.

For machine-readable output, call the engine directly — resolve
`<skill-base-dir>` from the `Location:` header that `skill({ name: "impeccable" })`
returns:

```sh
~/.minimax/skills/impeccable/scripts/impeccable detect src/
~/.minimax/skills/impeccable/scripts/impeccable detect --json src/
~/.minimax/skills/impeccable/scripts/impeccable context
~/.minimax/skills/impeccable/scripts/impeccable doctor
```

The engine binary is not in this repo. The bundled launcher downloads the right
platform build from the pinned upstream release on first run and caches it under
`~/.impeccable/bin/`. Warm it up explicitly if you want:

```sh
cd <your project> && ~/.minimax/skills/impeccable/scripts/impeccable --version
```

## Project context

Impeccable reads two files from your project root:

- **`PRODUCT.md`** — durable product truth: audience, purpose, constraints. Write it with the `init` playbook.
- **`DESIGN.md`** — the incumbent visual system: tokens, typography, components. Write it with `document`.

Both are optional. Without them the skill still runs, but it has less to design
against. See `reference/init.md` and `reference/document.md`.

## Uninstall

```sh
./uninstall.sh                  # skill directory only
./uninstall.sh --purge-cache    # also the shared ~/.impeccable engine cache
```

## Attribution

Impeccable is created by [pbakaus](https://github.com/pbakaus) and licensed
Apache-2.0. This fork contains no upstream design content of its own — it is a
packaging and portability change. Please file issues about command behaviour or
detector output upstream, and issues about MiniMax Code packaging here.

## License

Apache-2.0, matching upstream.
