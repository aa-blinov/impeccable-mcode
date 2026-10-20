# AGENTS.md — agent context for `impeccable-mcode`

A skill package for MiniMax Code: upstream's Impeccable design skill, 39
markdown files of playbooks and references, two launchers and a metadata file,
with the install path, the frontmatter and the script paths rewritten for this
harness. The engine it calls is an upstream binary that this repository does
not carry.

This file is what you need to work on the fork without reading all of it.

## Run / build / test

```bash
./install.sh                                 # install into ~/.minimax/skills/impeccable
./uninstall.sh                               # remove it
./uninstall.sh --purge-cache                 # remove it and the ~/.impeccable cache
sh -n install.sh uninstall.sh scripts/impeccable   # the only check that exists
```

Once the skill is installed, the engine answers for itself:

```bash
~/.minimax/skills/impeccable/scripts/impeccable --version   # fetch the engine and report its version
~/.minimax/skills/impeccable/scripts/impeccable detect src/  # scan a directory
~/.minimax/skills/impeccable/scripts/impeccable context       # load the project context
```

On Windows the launcher is `scripts\impeccable.cmd`, and it takes the same
arguments.

There is no package manifest, no dependency, no build step and no test suite.
The repository is markdown, two POSIX shell scripts, one `cmd` script, and the
browser bundles that live mode injects.

## Where things live

| Path | What it holds |
| --- | --- |
| `SKILL.md` | The entry point MiniMax Code loads. Frontmatter, the 23-command table, the routing rules, the four modes. |
| `reference/` | The 39 playbooks and shared references, upstream's design content, unchanged. |
| `reference/craft-floor.md` | The quality floor and the bans every UI edit is held against. |
| `reference/new-work.md` | The largest playbook in the repository, the path for a new surface or a replacement visual world. |
| `reference/degraded/` | Four upstream agent roles rewritten to run in one session, because this harness has no subagents. |
| `scripts/impeccable` | The POSIX launcher: resolves the engine, verifies a download, execs it. |
| `scripts/impeccable.cmd` | The Windows launcher. Same cache, same engine, different shell. |
| `scripts/VERSION` | The engine version, `0.1.5`. The launcher downloads exactly this build. |
| `scripts/command-metadata.json` | The description and the argument hint of each of the 23 commands. |
| `scripts/data/font-index.json` | Upstream's font metrics index, 3,076 entries. |
| `scripts/data/font-index-failures.json` | The 17 families that could not be indexed, all with the reason "not loaded or no lettering". |
| `scripts/live-browser.js` | The live-mode overlay that is injected into the page. |
| `scripts/live-browser-dom.js` | The DOM helpers behind the overlay, split out so they can be tested without it. |
| `scripts/live-browser-ignores.js` | The browser-side resolution of the project's detector waivers. |
| `scripts/live-browser-session.js` | The durable session state of a live-mode run, in `localStorage`. |
| `scripts/modern-screenshot.umd.js` | The screenshot bundle the overlay uses. |
| `install.sh`, `uninstall.sh` | The install into the MiniMax Code user scope, and the removal. |
| `_meta.json` | The runtime metadata MiniMax Code reads. |

## Traps

- **The engine binary is not in this repository.** `scripts/impeccable`
  downloads the build for the platform from the pinned upstream release on the
  first run and keeps it under `~/.impeccable/bin/<version>/`. A missing
  binary on the first run is the normal path, not a broken install. Without
  network access, put a binary in place and point `IMPECCABLE_BIN` at it.
- **A downloaded engine runs only after the checksum matches.** The launcher
  fetches the `.sha256` sidecar, compares it with `shasum` or `sha256sum`,
  and refuses the download when the sidecar is missing, the hash tool is
  missing, or the digests differ. The Windows launcher does the same with
  `certutil`. Do not soften this into a warning: a skill that runs an
  unverified binary is a different product.
- **`<skill-base-dir>` is the skill folder, not the plugin root.** 61 call
  sites across 14 markdown files use the placeholder. It resolves to the
  directory that holds `SKILL.md`, taken from the `Location:` header that
  `skill({ name: "impeccable" })` returns, with
  `~/.minimax/skills/impeccable` as the fallback. Two levels up is wrong and
  every reference file goes missing.
- **The launcher exports `IMPECCABLE_SKILL_DIR` before it execs anything**,
  including the `IMPECCABLE_BIN` override. The engine reads `reference/*.md`
  and its own version through it, so a binary started without it never inlines
  the native platform references and never reports an update.
- **The unversioned binary and the one on PATH are probed; the override, the
  sibling binary and the pinned cache are not.** The retired 3.x npm CLI
  installed a binary with the same name and answers every verb with "Unknown
  command". The launcher runs `engine-probe` on the untrusted candidates and
  execs `IMPECCABLE_BIN`, the binary beside it and the version-pinned cache
  directly, because the hook calls it on every edit and a probe costs a
  process.
- **`IMPECCABLE_SKILL_HOME` is a base directory, not the skill directory.**
  `IMPECCABLE_SKILL_HOME=/custom/path` installs to
  `/custom/path/skills/impeccable`. The name reads like the destination and
  is not.
- **The install copy only deletes when rsync is installed.** `install.sh`
  uses `rsync -a --delete` and falls back to `find ... -exec cp -R` when
  rsync is missing. The fallback copies over the top and leaves the files the
  source no longer has, so a forced reinstall on a machine without rsync
  keeps a stale playbook.
- **Two version numbers mean two different things.** `SKILL.md` says `4.3.1`,
  the skill version, and `scripts/VERSION` says `0.1.5`, the engine version.
  `install.sh` reads `scripts/VERSION` and writes it into `_meta.json` as
  `version`, so an installed `_meta.json` reports `0.1.5` where the
  repository's own file reports `4.3.1`.
- **The Windows launcher is linear on purpose.** `scripts/impeccable.cmd` uses
  `goto` rather than parenthesised blocks, because cmd expands `%var%` when
  the block is parsed, and it avoids delayed expansion so that a `!` in an
  argument survives. A tidier rewrite breaks the download path.
- **The hook is not wired on this harness.** MiniMax Code has no provider
  hook manifest, so the detector runs on demand. `impeccable context` hands
  the session one `MANUAL_DETECTOR_REQUIRED` directive instead, and the
  `hooks` verb still edits `.impeccable/config.json` but installs no manifest.
- **The subagent roles are inlined.** The four files under
  `reference/degraded/` open with a line saying the harness has no subagent
  capability. Run the role in the same session and disclose the substitution
  in one line when you report.
- **Live mode needs a local checkout and a running page.** The injected
  `scripts/live-browser.js` reads `window.__IMPECCABLE_TOKEN__` and
  `window.__IMPECCABLE_PORT__`, which the helper server prepends. The helper
  listens on `localhost:8400`; the dev server, or a static HTML file in the
  browser, serves the application, and its port is a different thing.
- **The skill catalog is built when a session starts.** An install changes
  nothing for a session that is already running.
- **The files under `scripts/data/` are upstream's generated index.** The
  generator is not in this repository, so both files are copied rather than
  rebuilt, and a change to either is a patch to upstream's data.

## Style / safety rails

- **Never ask for a slash command.** This harness has no `/impeccable`
  namespace. A request in words routes to the playbook, and a playbook that
  says "hand off to `/impeccable polish`" means load
  `reference/polish.md` and do the work.
- **The design content is upstream's.** A change to a playbook is a patch to
  somebody else's work, and it has to be visible as one. The fork's own
  changes are the install path, the frontmatter, the script paths, the
  invocation section, `_meta.json` and the two shell scripts.
- **The frontmatter is the runtime's contract.** `descriptions.ru-Hans` is
  what makes the skill trigger on a Russian request. `user-invocable` and
  `argument-hint` are upstream's keys, and this runtime ignores them.
- **The download fails closed.** The checksum check, the empty-file check and
  the "the file was removed before execution" check all end the run with exit
  127. Leave them in place.
- **No dependencies and no build step.** The install is a file copy and the
  engine is a self-contained binary. A dependency is a file that never
  arrives on the machine that needs it.
- **Comments explain why, never what.** The launcher and the two shell
  scripts are unusually good on this point. The comment above the probe in
  `scripts/impeccable` says what the probe is for and what it costs; keep
  that.

## Where the product truth lives

[`PRODUCT.md`](PRODUCT.md) holds it. Read it before changing what the fork
does, and write the change there when the behaviour changes.
