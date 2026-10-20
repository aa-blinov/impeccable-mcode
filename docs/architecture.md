# Architecture

How `impeccable-mcode` is put together.

## The shape

The repository is a payload, two launchers and two install scripts. There is
no package manifest, no dependency, no build step and no test suite. The
engine that does the work is an upstream binary that this repository does
not carry and does not build.

```
a request in words
    -> SKILL.md routing            the command table and the routing rules
    -> reference/<command>.md      the playbook
    -> scripts/impeccable          the launcher
    -> the engine binary           upstream's, cached under ~/.impeccable/bin
    -> edits in the user's project
```

| Path | What it holds |
| --- | --- |
| `SKILL.md` | The entry point MiniMax Code loads: the frontmatter, the table of 23 commands, the routing rules, the four modes. |
| `reference/` | 39 markdown files: the playbooks, the craft floor, the routing menu, the iOS and Android guides and the live-mode setup. Upstream's design content, unchanged. |
| `reference/degraded/` | Four upstream agent roles rewritten to run inline, because this harness has no subagents. |
| `scripts/impeccable` | The POSIX launcher: it resolves the engine, verifies a download and execs it. |
| `scripts/impeccable.cmd` | The Windows launcher. The same cache and the same engine, in a different shell. |
| `scripts/VERSION` | The engine version, `0.1.5`. The launcher downloads exactly this build. |
| `scripts/command-metadata.json` | The description and the argument hint of each of the 23 commands. |
| `scripts/data/font-index.json` | Upstream's font metrics index, 3,076 entries. |
| `scripts/data/font-index-failures.json` | The 17 families that could not be indexed. |
| `scripts/live-browser.js` | The live-mode overlay that is injected into the user's page. |
| `scripts/live-browser-dom.js` | The DOM helpers behind the overlay. |
| `scripts/live-browser-ignores.js` | The browser-side resolution of the project's detector waivers. |
| `scripts/live-browser-session.js` | The durable session state of a live-mode run, in `localStorage`. |
| `scripts/modern-screenshot.umd.js` | The screenshot bundle the overlay uses. |
| `install.sh`, `uninstall.sh` | The install into the MiniMax Code user scope, and the removal. |
| `_meta.json` | The runtime metadata MiniMax Code reads. |

## The data flow

The install is a file copy, and the first run of the engine is a download.

```
./install.sh
  |  the source directory -> $IMPECCABLE_SKILL_HOME/skills/impeccable
  |  rsync -a --delete, or a find + cp -R fallback
  v
_meta.json written with the version from scripts/VERSION
```

```
scripts/impeccable <verb>
  |  export IMPECCABLE_SKILL_DIR, IMPECCABLE_SELF
  |  look for the engine, in order:
  |    1. $IMPECCABLE_BIN
  |    2. the binary beside the launcher
  |    3. ~/.impeccable/bin/impeccable        (probed)
  |    4. ~/.impeccable/bin/$VERSION/impeccable
  |    5. impeccable on PATH                  (probed)
  |  none found: download the pinned build, verify the .sha256 sidecar, cache it
  v
exec the engine
```

The two unprobed candidates are the ones the hook calls on every edit, and a
probe costs a process. The two probed candidates are the ones that might be
the retired 3.x npm CLI, which answers every verb with "Unknown command".
The engine reads the skill directory through `IMPECCABLE_SKILL_DIR`, which
is why the launcher exports it before anything is exec'd, including the
`IMPECCABLE_BIN` override.

Live mode adds one more hop. The engine's helper server listens on
`localhost:8400` and serves `live-browser.js`, which it injects into the
user's page. The script reads `window.__IMPECCABLE_TOKEN__` and
`window.__IMPECCABLE_PORT__`, which the server prepends, and refuses to
start without them.

## Decisions worth knowing about

### The fork does not track upstream tags

It tracks upstream skill `v4.3.1` and engine `v0.1.5`, recorded in the
README and in the commit message. A change is taken by diffing against that
base and re-applying the fork's own edits, which are the install path, the
frontmatter, the script paths, the invocation section, `_meta.json` and the
two shell scripts. The cost is that an upstream release is not a merge and
has to be read.

### The download fails closed

A freshly downloaded binary runs only after its `.sha256` sidecar has been
fetched and compared, with `shasum` or `sha256sum`. A missing sidecar, a
missing hash tool, a mismatch, an empty file and a file that disappeared
before execution all end the run with exit 127. The Windows launcher does
the same with `certutil`. The cost is a machine with no hash tool cannot
install the engine from the network, and the message says so.

### The skill directory is addressed by a placeholder

61 call sites across 14 markdown files use `<skill-base-dir>`, which
resolves to the directory that holds `SKILL.md`. The runtime supplies it
from the `Location:` header of the skill lookup, with
`~/.minimax/skills/impeccable` as the fallback. A literal provider path
would break the install on every other machine.

### The frontmatter is the runtime's contract

`SKILL.md` carries `name`, `description`, `version`, `license` and a
`descriptions.ru-Hans` block, and the last one is what makes the skill
trigger on a Russian request. `user-invocable` and `argument-hint` are
upstream's keys, and this runtime ignores them.

### The hook is not installed

MiniMax Code has no provider hook manifest, so the detector runs on demand.
The `hooks` verb still edits `.impeccable/config.json` and installs no
manifest, and `impeccable context` hands the session one
`MANUAL_DETECTOR_REQUIRED` directive instead.

### The four agent roles run inline

`reference/degraded/` holds four upstream roles rewritten to run in the
same session, because this harness has no subagent capability. Each file
opens with a line saying so, and the substitution is disclosed in one line
when the role reports.

## Boundaries

- **The design content belongs to upstream.** The playbooks, the craft
  floor and the detector rules are upstream's work, and a change to any of
  them in this repository is a patch to somebody else's work. Design issues
  go upstream; packaging issues go here.
- **The engine binary is not in this repository.** The detector scan,
  `doctor`, the hook configuration, the live-mode server and the image
  helpers are engine verbs. Nothing in the repository reimplements them.
- **`SKILL.md` never asks for a slash command.** This harness has no
  `/impeccable` namespace, so a request in words is the normal path and a
  playbook that names a command means load that playbook's file.
- **The launcher exports its two variables before every exec.** An engine
  started without `IMPECCABLE_SKILL_DIR` cannot find `reference/*.md` and
  cannot report its own version.
- **The install scripts do not build anything.** They copy files and write
  one JSON file. A dependency is a file that never arrives on the machine
  that needs it.
- **The files under `scripts/data/` are copied, not generated.** The
  generator is upstream's and is not in this repository.
