# Screenshots

`impeccable-mcode` has no screenshots in this folder, and there are no
images anywhere in the repository.

The reason is that the repository has no surface of its own to photograph.
It is a skill payload: markdown playbooks, two launchers, a metadata file
and the browser bundles that the live-mode command injects into somebody
else's page. The interface it draws is upstream's live-mode overlay, and it
draws itself on the user's own page, over the user's own design.

What the repository carries instead:

- The [DESIGN.md](../../DESIGN.md), which records the overlay's tokens, the
  type ramp, the z-index ladder and the components, and says plainly that
  the identity is upstream's.
- The command table in the [SKILL.md](../../SKILL.md), where each of the 23
  commands has a description and an argument hint.
- The [README](../../README.md), with the install commands and the
  environment variables.

If a screenshot is added later, it goes in this folder and is referenced
from the README by a relative path, so it resolves on GitHub and in a local
checkout. The house-style checker verifies that every image reference
points at a file that exists, so a renamed screenshot cannot quietly break
the README.
