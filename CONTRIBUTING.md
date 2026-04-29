# Contributing to Swamp

Swamp is an open specification. Changes happen in the open, get discussed before they land, and are attributable in git history.

## Before proposing a change

Read `SPEC.md`, `MANIFESTO.md`, and the relevant `application-notes/` or `related-work/` files first. A lot of what looks like an obvious place for improvement turns out, on closer reading, to have been deliberately chosen to be the way it is — the design has accumulated reasoning that is not always inline.

If you're proposing a change to resolve something you find ambiguous or contradictory in the spec, please say so explicitly. Flagging an inconsistency is itself a useful contribution, even if you don't have a proposed fix.

## How proposals flow

The path for a non-trivial change is:

1. **Open an issue.** Describe the change, the motivation, and any alternatives you considered. Link to the section(s) affected. If there's an existing discussion or earlier issue that touches this area, link to it.
2. **Discussion.** Other participants respond. Stewards weigh in. If the change is clearly in-scope and well-motivated, this stage may be short; if the tradeoffs are genuinely uncertain, this stage is the important one.
3. **Pull request.** Once rough consensus has formed on shape, open a PR. The PR should reference the issue.
4. **Review and merge.** A steward merges when the PR has converged, which may include further edits.

Typos, broken links, and prose clarifications can skip the issue step and go directly to PR. When in doubt, open the issue first — low cost, high signal.

## What counts as a "change to the spec"

### Normative changes (SPEC.md)

Edits that change what a conformant Swamp implementation must do, accept, reject, or produce. These get the most scrutiny. The standard is: does this change the bytes on the wire, or the interpretation a reader gives to those bytes? If yes, it is normative.

Normative changes follow semantic-versioning discipline (see `RELEASES.md`):

- **PATCH** — clarifying prose that does not change what bytes are valid.
- **MINOR** — additive protocol features that do not break existing readers.
- **MAJOR** — breaking changes. Expect long discussion and strong justification.

### Application notes (`application-notes/`)

Non-normative notes about how to *apply* the spec in practice. New application notes are welcome. The acceptance bar is lower than for normative changes: an application note is one author's informed read of a question, not a binding rule. Application notes can include opinions, sketches, even provisional recommendations — as long as they are clearly marked non-normative.

### Related-work notes (`related-work/`)

If there's a system, protocol, or spec Swamp draws from or diverges from in a way that would benefit readers to understand, a related-work note is welcome. Same loose acceptance bar as application notes. Each note should follow the shape outlined in `related-work/README.md`: what it is, how Swamp relates, references.

### Governance changes (`GOVERNANCE.md`)

Changes to how Swamp is stewarded. These require steward approval and should be preceded by discussion. Not every proposed governance change will be accepted; specs with bloated governance docs tend to die of process.

### Release codenames

Swamp releases are named after swamps of the world, alphabetical by minor version. If you want to propose a name for an upcoming release:

- Open an issue titled "Release codename proposal: [name]".
- Confirm it is an actual swamp (a geographic place, currently or historically).
- Confirm it fits at the right alphabetic slot for the version.
- Note any relevant cultural or ecological context — some swamps come with freight (political, environmental, historical) that a steward may need to weigh.

Stewards ultimately pick the name. A proposal's quality matters more than its timing.

## Conventions for section edits

When editing `SPEC.md`:

- **Preserve section numbers** unless you're adding a new section or renumbering is explicitly part of the PR's scope.
- **If you do renumber**, grep the whole repository for `§N` references after and eyeball every one. Cross-reference drift is the most common source of subtle spec errors.
- **Match prevailing style**: sentence-case headings, no hard line wrap, relative links within the repo, full URLs for external links.
- **No emoji.**
- **Keep the voice** — restrained, precise, confident-but-humble. Swamp is a working draft made good, not a triumphal announcement.

## Versioning reminder

Not every change to the document triggers a version bump. The protocol version (what a post carries in its `Swamp-Version:` header) follows semver and bumps only when protocol bytes-on-the-wire change. Document edits between protocol releases (typo fixes, clarified prose, new application or related-work notes, governance updates) land on `main` without bumping the version. Readers who need to cite an exact revision use the `ipfs:` or `git:` locator forms in `Swamp-Version:`.

See `RELEASES.md` for the full policy.

## Code of conduct

Be honest about what you know and don't know. Disagree about the work, not about each other. Credit people's contributions. Assume competence in non-native-English contributions and don't penalize the cognitive cost of writing in a second language.

## Questions

Open an issue. Stewards respond when they can; other contributors may respond sooner.
