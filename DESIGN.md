---
name: impeccable-mcode
description: The fork has no visual identity of its own. The one interface in the repository is upstream's live-mode overlay, and its tokens are recorded here.
colors:
  primary: "oklch(84% 0.19 80.46)"
  neutral-bg: "oklch(98% 0.005 95)"
  ink: "oklch(4% 0.004 95)"
  muted: "oklch(55% 0.018 82)"
  rule: "oklch(90% 0.008 82 / 0.6)"
typography:
  body:
    fontFamily: "system-ui, -apple-system, sans-serif"
    fontSize: "12px"
    fontWeight: 400
    lineHeight: 1.4
  title:
    fontFamily: "system-ui, -apple-system, sans-serif"
    fontSize: "13px"
    fontWeight: 500
    lineHeight: 1.4
  code:
    fontFamily: "ui-monospace, SFMono-Regular, Menlo, monospace"
    fontSize: "11px"
    fontWeight: 500
    lineHeight: 1.4
rounded:
  sm: "3px"
  md: "7px"
  lg: "10px"
spacing:
  xs: "4px"
  sm: "8px"
  md: "12px"
  lg: "14px"
---

# Design system: impeccable-mcode

## Overview

**Creative North Star: "the fork has no style of its own"**

This repository has no visual identity, and saying so is the honest record.
It is a skill package: 39 markdown files of upstream's playbooks, two
launchers, a metadata file and five browser bundles. The design content in
`reference/` is the design knowledge the skill carries, and it is upstream's.
Nothing in this repository renders on a screen on its own.

One interface does exist. The live-mode overlay, in
`scripts/live-browser.js`, is injected into the user's page when the
`live` command runs. It draws a floating bar, an element highlight, a
picker and a toast, and it has a palette, a type ramp, radii and a motion
curve. That interface is upstream's as well: the file was copied with the
rest of the payload and this fork changed its installation path, not its
appearance.

So what follows records upstream's overlay tokens as the code has them, and
marks clearly where the fork's own work begins and ends. The fork's own
contribution to the surface is: where the skill is installed, the frontmatter
the runtime reads, the script paths, the invocation section, `_meta.json` and
the two shell scripts.

Key characteristics:

- The overlay is upstream's, down to the oklch values, and a change to it
  is a patch to somebody else's work.
- The overlay's own palette is a warm gold on a paper ground, chosen to sit
  on any page without repainting it.
- The overlay never restyles the user's page. It draws above it and takes
  it back down when the run ends.
- The fork contributes packaging, and nothing that is seen.

## Colors

The overlay's tokens are declared in one object at the top of
`scripts/live-browser.js`, and every colour in the file comes from it.

- **Kinpaku gold** (`oklch(84% 0.19 80.46)`): the accent. The active
  control, the selection outline, the cycle dots and the comment tag.
- **Kinpaku pale** (`oklch(86% 0.07 84)`): the hover state of the accent.
- **Kinpaku dim** (`oklch(84% 0.19 80.46 / 0.18)`): the accent at 18
  percent, for a fill that reads as the accent without shouting.
- **Lacquer deep** (`oklch(4% 0.004 95)`): the ink. Near-black with a
  trace of warmth, so it sits on a warm page without reading blue.
- **Warm ash** (`oklch(55% 0.018 82)`): the muted text.
- **Paper** (`oklch(98% 0.005 95 / 0.92)`): the bar's own ground, 92
  percent opaque, so the page under it shows through slightly.
- **Paper solid** (`oklch(98% 0.005 95)`): the same ground, opaque, for
  the pieces that must not show the page through them.
- **Mist** (`oklch(90% 0.008 82 / 0.6)`): the hairline.
- **White** (`oklch(99% 0 0)`): the text on a filled accent.

The gold is pinned to the upstream site's own tokens, and the file says so
in a comment above the object: the overlay's accent has to match the
upstream kit's picker colors, and a theme-adjusted gold would not.

## Typography

**Display Font:** system-ui, -apple-system, sans-serif
**Body Font:** system-ui, -apple-system, sans-serif
**Code Font:** ui-monospace, SFMono-Regular, Menlo, monospace

The overlay draws at four sizes and nothing else: 9.5 pixels for the
smallest label, 10 and 10.5 for the tags and the secondary text, 11 for
the monospace labels and the control text, 12 for the body of a panel, 13
for the primary line of the bar, and 14 for the close control. The line
height is 1.4 throughout.

The monospace family is used where the text is a value rather than a
sentence: the file path in a tag, the size in the screenshot controls, the
value in the picker. Weight 600 for the labels that carry an identity, 500
for the rest.

## Layout

The overlay is a fixed bar that sits at the top of the viewport, and it
morphs between three states without moving: configure, generating and
cycling. Its width follows its content, and the controls inside it are
laid out in a row with 8 pixels between them.

The other three pieces are positioned against the user's element rather
than against the page: the highlight outline is drawn around the element
under the pointer, the picker follows the pointer, and the toast sits at
the bottom of the viewport.

The z-index ladder is fixed and the reason is written in the file: the
detect overlays sit at 99999, so the overlay's own layers have to be above
them.

| Layer | z-index |
| --- | --- |
| Highlight | 100001 |
| Bar | 100005 |
| Picker | 100007 |
| Toast | 100010 |

## Elevation & Depth

One shadow in the whole file: `0 16px 36px -12px oklch(0% 0 0 / 0.6)`, on
the picker. The comment above it says what it is for: a quiet neutral
elevation, with no gold halo, because the gold is reserved for the brand
mark and the active control and not for a container outline.

Everything else is flat. The bar and the panels separate themselves from
the user's page with a hairline and a paper ground, not with a shadow.

## Shapes

There is no single radius. The overlay uses what the shape needs:

- 3 pixels for the tags and the small chips.
- 5 pixels for the compact buttons.
- 6 pixels for a button row.
- 7 pixels for the panels and the popovers.
- 8 pixels for the toast and the cards.
- 10 pixels for the bar's own corners, with the bottom corners square when
  the bar grows a second row.
- 50 percent for the dots and the circular controls.
- 999 pixels for the pill that carries the configure action.

## Components

### The bar

- **Shape:** a fixed bar with 10 pixel corners, a paper ground at 92
  percent, and a hairline.
- **States:** configure, generating and cycling. The bar does not change
  size when the state changes; the contents swap.
- **Configure:** a pill that opens the picker, with the action next to it.
- **Generating:** a row of dots that fill while the variant is written.
- **Cycling:** the previous and next controls, the accept and discard
  controls, and the dots for each variant.

### The highlight

- **Shape:** a 2 pixel outline in the brand gold with a 3 pixel radius,
  drawn around the element under the pointer.
- **Motion:** the outline moves and resizes with a 140 millisecond
  transition on each of the four properties, and the opacity takes 150.

### The picker

- **Shape:** a panel with 7 pixel corners and the one shadow in the file.
- **Content:** the action the user chooses, a text field, and the knobs for
  the options the action takes.
- **Position:** it follows the pointer and never opens over the bar.

### The toast

- **Shape:** a panel with 8 pixel corners, anchored to the bottom of the
  viewport.
- **Use:** it reports the outcome of an action, including the case where a
  variant was not saved.

## Do's and Don'ts

### Do:

- **Do** take the overlay's colours from the token object at the top of
  `scripts/live-browser.js`. A literal value in a rule is a second source
  of truth.
- **Do** keep the z-index ladder as it is. The detect overlays sit at
  99999.
- **Do** treat a change to the overlay as a patch to upstream, and say so
  in the diff.

### Don't:

- **Don't** restyle the user's page. The overlay draws above it and takes
  itself down again.
- **Don't** add a second shadow. There is one, on the picker, and the
  reason it is there is written next to it.
- **Don't** add a colour outside the token object.
- **Don't** treat the upstream palette as this repository's brand. The
  fork has no brand of its own, and the design content belongs to
  upstream.
- **Don't** copy the overlay's tokens into a project the skill is applied
  to. The overlay is the tool, not the result.
