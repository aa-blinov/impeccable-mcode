# Impeccable for MiniMax Code

Impeccable is a design skill for AI coding agents: ask for design work in
plain language and the agent loads the playbook for it, whether that is
shaping a new surface, critiquing one, auditing the markup or hardening the
error states. A deterministic detector flags the anti-patterns that generated
interfaces tend to ship. This fork packages the skill for MiniMax Code, which
loads skills from `~/.minimax/skills/` and has no `/impeccable` slash
namespace.

[![License](https://img.shields.io/badge/license-Apache--2.0-blue)](LICENSE)
[![Tag](https://img.shields.io/github/v/tag/aa-blinov/impeccable-mcode)](https://github.com/aa-blinov/impeccable-mcode/tags)
[![Upstream](https://img.shields.io/badge/upstream-skill--v4.3.1-lightgrey)](https://github.com/pbakaus/impeccable/releases/tag/skill-v4.3.1)

---

## Quick start

```bash
curl -fsSL https://raw.githubusercontent.com/aa-blinov/impeccable-mcode/main/install.sh | sh
```

Or from a clone:

```bash
git clone https://github.com/aa-blinov/impeccable-mcode.git
./impeccable-mcode/install.sh
```

The skill lands in `~/.minimax/skills/impeccable/`. MiniMax Code reads the
skill catalog when a session starts, so open a new session after the install.

| What you want | Command | Where it goes |
| --- | --- | --- |
| Install for the current user | `./install.sh` | `~/.minimax/skills/impeccable/` |
| Install under another base directory | `IMPECCABLE_SKILL_HOME=/custom/path ./install.sh` | `/custom/path/skills/impeccable/` |
| Replace an install that is already there | `IMPECCABLE_FORCE=1 ./install.sh` | the same directory |
| Remove the skill | `./uninstall.sh` | the skill directory |
| Remove the skill and the engine cache | `./uninstall.sh --purge-cache` | `~/.minimax/skills/impeccable/` and `~/.impeccable/` |

Then ask for the work in words. The verb picks the playbook:

```
audit the study screen
polish the landing page
why does the stats page feel flat
adapt this for mobile
```

The engine is callable directly when machine output is what you want, such as
the detector's JSON:

```bash
~/.minimax/skills/impeccable/scripts/impeccable detect src/
~/.minimax/skills/impeccable/scripts/impeccable detect --json src/
~/.minimax/skills/impeccable/scripts/impeccable context
~/.minimax/skills/impeccable/scripts/impeccable doctor
```

The engine binary is not in this repository. The launcher downloads the build
for your platform from the pinned upstream release on the first run and keeps
it under `~/.impeccable/bin/`. Warm it up before the first request:

```bash
cd <your project> && ~/.minimax/skills/impeccable/scripts/impeccable --version
```

## What it does

- **Routes a plain-language request to a design playbook.** The command table in
  `SKILL.md` holds 23 commands: building (`shape`, `init`, `document`,
  `extract`), evaluating (`critique`, `audit`), refining (`polish`, `bolder`,
  `quieter`, `distill`, `harden`, `onboard`), motion and type (`animate`,
  `colorize`, `typeset`, `layout`, `delight`, `overdrive`), fixing (`clarify`,
  `adapt`, `optimize`) and iterating in the browser (`live`). The table also
  carries `craft`, a deprecated alias for an ordinary new-work request.
- **Runs a deterministic detector over the code.** `detect` reads HTML and CSS
  on disk and reports the findings without an LLM and without an API key.
  Upstream counts 61 rules; the rule set itself lives in the engine binary,
  not in this repository.
- **Keeps the product truth in the project.** `init` writes `PRODUCT.md`,
  `document` writes `DESIGN.md`, and the later commands read both before they
  touch anything.
- **Iterates on a running page.** `live` injects an overlay into a dev server
  and swaps HTML and CSS variants through hot reload.
- **Reports drift between the files and the installed version.** `doctor`
  compares `PRODUCT.md`, `DESIGN.md`, the design sidecar, the config, the
  surface briefs and the hook against what this version reads.
- **Needs no runtime beyond a shell.** The launcher is POSIX `sh` with `curl`
  or `wget`; the engine is a self-contained binary with no Node, no Bun and no
  Python.

## How it works

```
request -> SKILL.md routing -> reference/<command>.md -> engine call -> edits
```

`SKILL.md` is what MiniMax Code loads. Its frontmatter carries the keys this
runtime reads: `name`, `description`, `version`, `license`, and a
`descriptions.ru-Hans` block so the skill also triggers on a Russian request.
The body holds the command table, the routing rules and the four modes the
work is judged by.

`reference/` holds the playbooks, one per command, plus the shared references:
the craft floor that every UI edit is held against, the routing menu, the
platform guides for iOS and Android, and the live-mode setup. That content is
upstream's and unchanged here. `reference/degraded/` holds the four agent
roles rewritten to run in the same session, because this harness has no
subagents.

`scripts/impeccable` is the launcher. It looks for the platform binary in
five places, verifies a downloaded one against its `.sha256` sidecar, and
execs it. `scripts/impeccable.cmd` is the Windows counterpart, and the two
share the same engine cache. The engine does the work that needs a machine:
the detector scan, `doctor`, the hook configuration, the live-mode server and
the image helpers.

`scripts/command-metadata.json` carries the description and the argument hint
for each of the 23 commands, which is the list the harness shows. The files
under `scripts/data/` are the upstream font metrics index (3,076 entries) that
the typography work compares against, and the 17 families that could not be
indexed.

The browser side of live mode is `scripts/live-browser.js` with three helpers
beside it, injected into the page by the helper server.

## Configuration

The install is configured by environment variables, and the launcher reads
three more of its own.

| Variable | Default | What it does |
| --- | --- | --- |
| `IMPECCABLE_SKILL_HOME` | `$HOME/.minimax` | The base directory of the install. The skill lands in `$IMPECCABLE_SKILL_HOME/skills/impeccable`. |
| `IMPECCABLE_FORCE` | unset | `1` replaces an install that is already there instead of failing. |
| `IMPECCABLE_HOME` | `$HOME/.impeccable` | Where the engine cache is kept, one directory per engine version. The uninstaller purges it with `--purge-cache`. |
| `IMPECCABLE_BIN` | unset | A path to an engine binary to run instead of the cached one. |
| `IMPECCABLE_DOWNLOAD_BASE` | the upstream release channel | Where the launcher fetches the engine build from. |
| `IMPECCABLE_SKILL_DIR` | the skill directory | Set by the launcher for the engine, which reads `reference/*.md` and its own version through it. |
| `IMPECCABLE_SELF` | the launcher's own path | Set by the launcher, so the engine can name the command it came from. |

The engine reads the project's own files, not this repository's: `PRODUCT.md`
and `DESIGN.md` in the project root, and `.impeccable/config.json` for the
hook, the detector ignores and the workflow settings.

## Development

```bash
./install.sh                                 # install into the user scope
./uninstall.sh                               # remove it
sh -n install.sh uninstall.sh scripts/impeccable   # the only check that exists
```

There is no package manifest, no dependency, no build step and no test suite
here. The repository is the skill payload, the two launchers and the two
install scripts, and the engine it calls is built and released upstream. A
change to the shell scripts is checked by reading them and by the syntax check
above.

| Path | What it holds |
| --- | --- |
| `SKILL.md` | The entry point the harness loads: frontmatter, the command table, the routing rules. |
| `reference/` | The playbooks and the shared references, upstream's design content. |
| `reference/degraded/` | Four agent roles rewritten to run inline, for a harness with no subagents. |
| `scripts/impeccable` | The POSIX launcher. |
| `scripts/impeccable.cmd` | The Windows launcher. |
| `scripts/command-metadata.json` | The description and the argument hint of each command. |
| `scripts/data/` | The font metrics index and the families it could not index. |
| `scripts/live-browser.js` | The live-mode overlay injected into the page. |
| `scripts/live-browser-dom.js` | The DOM helpers behind the overlay. |
| `scripts/live-browser-ignores.js` | The browser-side resolution of the project's detector waivers. |
| `scripts/live-browser-session.js` | The durable session state of a live-mode run. |
| `scripts/modern-screenshot.umd.js` | The screenshot bundle the overlay uses. |
| `install.sh`, `uninstall.sh` | The install into the MiniMax Code user scope, and the removal. |
| `_meta.json` | The runtime metadata MiniMax Code reads. |

The fork tracks upstream skill `v4.3.1` and engine `v0.1.5`. It does not
track upstream tags: to take a change, diff against that base and re-apply
the fork's own edits, which are the install path, the frontmatter, the script
paths, the invocation section, `_meta.json` and the two shell scripts. Design
issues go upstream, packaging issues go here.

## License

Apache-2.0, matching upstream. The `LICENSE` file is upstream's, with the
copyright line for Paul Bakaus, because the playbooks, the craft floor and the
detector are upstream's work. The packaging in this repository is a
portability change and carries the same terms. See [LICENSE](LICENSE).
