# Documentation

The documents of `impeccable-mcode`, a package that makes the Impeccable
design skill work in MiniMax Code. It is a skill payload, two launchers and
two install scripts; the engine it calls is an upstream binary that this
repository does not carry.

| Document | What it covers |
| --- | --- |
| [architecture.md](architecture.md) | The payload, the launcher, the install scripts and the boundaries between the fork and upstream. |
| [screenshots/README.md](screenshots/README.md) | Whether the repository carries images, and which ones. |
| [../README.md](../README.md) | The front door: the install, the commands, the environment variables and the paths. |
| [../AGENTS.md](../AGENTS.md) | The traps, the commands and the rules of the fork. |
| [../PRODUCT.md](../PRODUCT.md) | The product truth: who it is for, and what it promises. |
| [../DESIGN.md](../DESIGN.md) | The live-mode overlay's tokens, and the fact that the fork has no visual identity of its own. |

This folder holds documents only. The skill has no landing page, because it
is installed into a runtime rather than visited.

## Reading order

New here: [../README.md](../README.md), then
[architecture.md](architecture.md). The README has the install table and the
command list.

Changing the code: [architecture.md](architecture.md) first, to see which
files are the fork's and which are upstream's, then [../AGENTS.md](../AGENTS.md)
for the traps. The traps in this repository are mostly about the boundary
with upstream, so read them before touching a playbook.

Looking for the reason a change was made: [../PRODUCT.md](../PRODUCT.md).
