# Product

<!-- impeccable:product-schema 1 -->

## Platform

adaptive

The repository ships no interface of its own: it is a skill package that a
MiniMax Code session loads from `~/.minimax/skills/impeccable/`. The launcher
is POSIX `sh` with a `cmd` counterpart, the engine is a self-contained binary
for macOS, Linux or Windows, and the package runs wherever the runtime runs.
The interfaces the skill designs for are web, iOS and Android.

## Users

The person working in MiniMax Code on a frontend, and the agent beside them.
The situation: the agent writes interfaces that look generated, the person
wants a deliberate design pass, and the request goes out as a sentence
("audit the study screen") rather than as a command.

The second audience is the person who tried to install Impeccable in MiniMax
Code and could not. Upstream's installer answers
`npx impeccable install --providers=minimax` with
`Unknown provider(s): minimax`, and an upstream install either lands in a
directory this runtime never reads or does not happen at all. That is the
person this repository was written for.

The third audience is nobody yet. The repository has two commits, one tag
(`v0.1.0`, dated 2026-10-01), no release and nowhere to count installs.

## Product Purpose

The fork makes the Impeccable design skill work natively in MiniMax Code. It
installs the skill into the directory the runtime resolves, gives the
frontmatter this runtime accepts, and rewrites the script paths so the same
skill directory works on any machine.

Success for the user: the agent loads the right playbook when they ask for
design work, and the detector answers when they want the facts. Success for
the product: the install is one script, the design content stays upstream's,
and the difference between this fork and upstream is a diff small enough to
read in one sitting.

## Positioning

Upstream ships builds for Claude Code, Cursor, Codex, Gemini CLI, Copilot and
others, and its installer has no `minimax` provider. This repository is the
MiniMax Code build of the same skill, and the packaging change is the whole
of it.

The second difference is the invocation. The playbooks say
`/impeccable <command>`, and this harness has no such namespace, so `SKILL.md`
defines that form to mean a plain-language request, or a direct engine call
when machine output is what is wanted.

The third is location independence. 61 script call sites across 14 markdown
files are written against `<skill-base-dir>` rather than a provider-prefixed
literal, so the skill directory works wherever it was installed.

What this repository does not have: the playbooks, the craft floor and the
detector rules are upstream's, and a neighbour could not copy them without
copying upstream's work.

## Operating Context

The user installs the skill with `install.sh` and opens a new session, because
the runtime builds the skill catalog when a session starts. The engine is
fetched on the first use, so the first request in a session can take a moment
while the binary downloads and its checksum is verified.

The skill then works in the user's own project, in the project directory. It
reads two files there: `PRODUCT.md` and `DESIGN.md`. It writes working files
under `.impeccable/` in that project.

The person using it is in a terminal, in their own repository, usually
mid-task. The skill must not ask for a slash command that cannot be typed,
and it must not rewrite the project's product truth on its own.

## Capabilities and Constraints

Confirmed by the code:

- 23 commands, in the table in `SKILL.md` and in
  `scripts/command-metadata.json`.
- 39 markdown files under `reference/`: the playbooks, the craft floor, the
  routing menu, the iOS and Android guides, the live-mode setup and four
  agent roles rewritten to run inline.
- The install target is `~/.minimax/skills/impeccable/`, and the install is a
  file copy.
- `install.sh` and `uninstall.sh` are POSIX shell, and `scripts/impeccable.cmd`
  is the Windows launcher.
- The launcher resolves the engine in five places and verifies a download
  against its `.sha256` sidecar before it runs.
- The engine version is pinned in `scripts/VERSION` (`0.1.5`), and the skill
  version is `4.3.1`.
- The frontmatter carries `name`, `description`, `version`, `license` and
  `descriptions.ru-Hans`.
- `_meta.json` records `platform: "minimax"`, the licence and the upstream
  repository.
- The detector scan, `doctor`, the hook configuration, the live-mode server
  and the image helpers are engine verbs, not scripts in this repository.
- The detector and live mode are web-only; the native references are guidance
  for iOS and Android projects.

Deliberately not true, and worth knowing before a change:

- There is no `/impeccable` namespace, so a slash command inside a playbook
  names the playbook, not the runtime.
- The hook is not installed. The detector runs when it is asked to.
- The agent roles run in the same session, because this harness has no
  subagents.
- The engine binary is not in the repository and is not built here.
- There is no CI, no test suite and no release process in this repository.

Open questions, for the owner rather than for a guess:

- Whether `_meta.json` should carry the skill version (`4.3.1`) or the engine
  version (`0.1.5`), given that the installer writes the second one into the
  `version` field.
- Whether the fork should follow upstream releases with tags, or keep the
  single `v0.1.0` tag and record the base in the README.
- Whether the four degraded agent roles should be regenerated when upstream
  changes its agent set.
- Whether the install should keep the `cp` fallback in `install.sh`, which
  copies over the top without deleting, or require rsync.

## Brand Commitments

**Name:** Impeccable. The repository title is "Impeccable for MiniMax Code",
and the skill itself is named `impeccable`.

**Tone:** upstream's. The skill speaks as an opinionated design director:
direct, specific, no hedging. The fork's own writing is plainer, because it
documents packaging rather than design.

**Attribution:** the playbooks, the craft floor and the detector are
upstream's, and the `LICENSE` file carries upstream's Apache-2.0 text with
the copyright line for Paul Bakaus. A change to any of them in this
repository is a patch to somebody else's work and has to be visible as one.
Issues about command behaviour or detector output go upstream; issues about
MiniMax Code packaging go here.

## Evidence on Hand

- `SKILL.md` holds the frontmatter, the command table, the routing rules and
  the four modes.
- `reference/` holds 39 markdown files, upstream's design content.
- `scripts/command-metadata.json` holds the description and the argument hint
  of each of the 23 commands.
- `scripts/VERSION` holds the engine version `0.1.5`, and `_meta.json` holds
  the skill version `4.3.1` and `platform: "minimax"`.
- `scripts/data/font-index.json` holds 3,076 font metric entries, and
  `scripts/data/font-index-failures.json` holds the 17 families that could not
  be indexed.
- The install was verified from a clean clone with no local binary and an
  empty engine cache, according to the commit message: the launcher
  self-downloaded, and `detect` and `doctor` both reported correctly.
- The upstream base is skill `v4.3.1` and engine `v0.1.5`, recorded in the
  README and in the commit message.

Absent, and not to be invented: no install counts, no usage numbers, no
testimonials, no screenshots, no CI badge, and no comparison with other
skills. The upstream README counts 24 commands; the command table and the
metadata in this repository hold 23, and the detector's 61 rules live in the
engine binary, which this repository does not carry, so neither number can be
checked from the files here.

## Product Principles

1. **The fork stays a fork.** The design content is upstream's, and the diff
   against the upstream base is the whole product. A change that edits a
   playbook is a patch to somebody else's work.
2. **The harness's vocabulary is the product.** A request in words routes to a
   playbook, and the skill never asks for a command the runtime cannot type.
3. **Location independence.** The skill works from whatever path the runtime
   installed it in, so the call sites are written against a placeholder and
   never against a provider-prefixed literal.
4. **The download fails closed.** A binary that cannot be verified against its
   checksum does not run, and the launcher says so before it exits.
5. **The gaps are written down.** The command count, the rule count and the
   two version numbers each come with their source, and what the repository
   does not have is listed rather than smoothed over.

## Accessibility & Inclusion

- **The package has no interface of its own.** It adds text to a session, so
  the accessibility work falls on the code the agent writes. The audit
  playbook and the craft floor carry that work upstream, and the contrast,
  focus and motion rules are theirs.
- **The skill triggers on Russian requests.** The `descriptions.ru-Hans`
  frontmatter block is the one inclusion decision this fork makes. Whether
  the playbooks themselves should be translated is open: they are English, and
  the fork copies them unchanged.
- **The configuration surface is text.** Environment variables, a JSON file
  and a request in words. Nothing depends on a colour, on a pointer position
  or on a path through a window.
- **No accessibility standard has been set for the fork itself**, because
  there is no screen to set one for.
