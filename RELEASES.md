# Releases

*Release history, versioning policy, and the codename scheme for Swamp.*

---

## Release history

### v0.6.0 — 2026-07-11

Pre-release. The first release since v0.3.0. The wire format continues from the v0.4.0 baseline (below) — everything relative to v0.3.0 remains additive — and adds the extension mechanism:

- **Extensions (SPEC §10).** Core Swamp now defines how vocabulary grows outside the core. Extensions are published specs in their own repositories, versioned independently, declaring which core version they extend; there is no registry, no approval step, and no reserved names — competing extensions are welcome and adoption arbitrates.
- **The must-carry invariant (SPEC §10.1).** The longstanding unknown-header behavior is promoted to a named, standing promise: unknown headers are preserved, posts of unknown kinds still verify at the envelope level, and every future version of core Swamp keeps this. The one stability promise made during 0.x.
- **`ext=` Content-Type parameter (SPEC §10.2).** Extension-defined kinds carry `ext=<token>/<version>` alongside `v=` — `v=` names the envelope contract, `ext=` the body contract. Readers ignore `Content-Type:` parameters they do not recognize.
- **`Extension:` header (SPEC §10.2).** Optional, repeatable; pairs an extension token with scheme-tagged locators for its spec, mirroring the `Swamp-Version:` locator grammar. Posts using an extension SHOULD declare it; profile posts MAY advertise the extensions their author speaks.
- **Composition rules (SPEC §10.3).** Headers compose freely; the body has exactly one owner.
- **Core got smaller.** Bookmarks and events / RSVPs leave the core: both would plainly be extensions if proposed today, so they become extensions now rather than shipping in core only to be moved later. They continue as the planned `swamp-bookmarks` and `swamp-events` extensions, their spec text carried over from the former core §8 and §10. The must-carry invariant is what makes this safe: a v0.6.0 reader treats an existing `kind=bookmark` / `kind=event` / `kind=rsvp` post as an unknown kind — still verified, still carried.
- **Documentation coherence sweep.** Satellite documents (application notes, related-work notes, guides) had drifted to v0.3-era section numbering and version strings; all are aligned to v0.6.0.

Why the number jumps from v0.3.0 to v0.6.0: v0.4.0 and v0.5.0 were consumed internally (below) and the v0.5.0 designation appeared in public previews; reusing either number would have made the public timeline ambiguous. Version numbers only move forward.

### v0.5.0 — design preview; never released

Explored replacing `did:key` with Blockchain Commons' XID as the identity primitive (a clean break) and adding Tier-1 open rooms to the core. Both were concluded to belong outside mainline: XID remains a later-release candidate on its own merits (see [`ROADMAP.md`](ROADMAP.md)) and should arrive additively rather than as a break, and rooms continues as a planned extension (`swamp-rooms`) — the extension mechanism v0.6.0 ships is in part what this preview taught. The preview is preserved in the project's design archive; it does not live on a branch. No conformant tooling ever emitted `Swamp-Version: 0.5.0`.

### v0.4.0 — internal baseline; never released

Drafted 2026-05, never tagged for release; its changes ship publicly as part of v0.6.0. Discovery work: re-introduces `Feed:` and adds `Following:`.

- **`Feed:` header re-introduced**, redefined as locator-to-signed-CID-claim. The header carries a URL; a polite client GETs the URL and receives a signed Swamp envelope (`Content-Type: application/swamp; kind=feed-claim; v=0.4.0`) whose `Latest:` field names the author's most recent self-sighting CID and whose signature attests under the same key that signs the author's posts. URL-only locator for v0.4.0; DNS TXT and other forms reserved for later. Mutability lives at exactly one bounded point — the URL response — and nowhere else in the stack. The earlier v0.2 `Feed:` semantics (alternate transport for post bytes) are not revived; the new shape is locator only. SPEC §4.10 carries the full contract.
- **`Following:` post kind added.** A signed blogroll-shaped artifact: each line of the body is `<DID> <whitespace> <Feed-URL>`, naming a feed the author is following at the time of publication. Body grammar parallels sightings (line-oriented, no prose mixed in); commentary, if any, lives in a sibling `kind=post`. Distinguished by `Content-Type: application/swamp; kind=following; v=0.4.0`. Snapshot semantics (latest by author is the live view; no `Supersedes:` chain). SPEC §11.
- **Optional fragment syntax in `DID:` header values.** `did:key:z6Mk...#z6Mk...` is permitted; bare DIDs continue to work and are equivalent to the canonical-fragment form for `did:key`. Forward-compat hygiene for future DID methods with multi-key support; v0.4.0 readers parse and discard the fragment for `did:key`. SPEC §3.
- **DID method language tightened.** `did:key` is **required**; other DID methods are **reserved for future spec versions** (replacing v0.2 / v0.3's "permitted" stance). The earlier wording under-specified verifier behavior — "permitted but unsupported" let authors publish posts that no implementation could verify. v0.4.0 commits to one method and reserves space for cleanly adding others later. SPEC §3.

Wire-format additions are purely additive. A v0.3.0 reader encountering a v0.4.0 post sees `Feed:` as an unknown header (preserved per the minor-version rule), sees fragment-bearing DIDs as bare DIDs (the fragment is at the suffix), and doesn't recognize `kind=following` posts as parsable for body semantics — but envelope and signature still verify. v0.4.0 readers verify v0.3.0 posts with full parity.

### v0.3.0 — 2026-04-27

Pre-release. Substrate consolidation and post-ref simplification.

- **CID is the canonical post-ref identifier.** Post-refs everywhere (sighting bodies, threading headers, `swamp:` URIs) carry `<DID>/<CID>` rather than `<DID>/<Message-ID>`. The DID prefix is kept for at-a-glance legibility before fetch.
- **Message-ID reframed as a post-internal author handle.** Still in every post header where the author chose it, used by agents for slug-rendering at display time, search, and the author's own filing — but not the wire form of references.
- **`<reaction>` renamed to `<why>`.** Each entry in a sighting body now reads as a reason for inclusion: "because it's mine," "because I know the poster," "because I think well of it." The five values (`mine | known | neutral | positive | negative`) are unchanged. SPEC §7.2 Why values is the new title for what was §7.2 Reaction values in v0.2.
- **SPEC §5 Identifying posts** is the new title for what was §5 Message-ID vs IPFS hash. Substrate-language pass throughout (transport → substrate where the IPFS hash is being named).

Wire-format-meaningful: a v0.2.0 reader parsing v0.3.0 sighting bodies sees `<reaction> <DID>/<CID>` lines that don't match the v0.2.0 `<reaction> <DID>/<Message-ID>` grammar, and would need to be updated. Per the 0.x semver discipline ("anything MAY change at any time"), this is a deliberate consolidation before stable 1.0.

### v0.2.0 — 2026-04-27

Pre-release. Removes the `Feed:` header; profile and sighting posts absorb the affordance. SPEC §4 Post format sections renumbered down by one (§4.7–§4.10 → §4.6–§4.9).

While Swamp is in 0.x pre-release, MINOR bumps may include changes that would be breaking at 1.0. The `Feed:` removal is a wire-shape change, but readers and writers are expected to churn at this stage; the fix for stale `Feed:` headers in old posts is "ignore them."

### v0.1.0 — 2026-04-22

Initial pre-release. Froze the envelope and semantics enough to begin interoperability work in earnest:

- RFC 822-style header envelope, `Swamp-Version:` locator, canonical-bytes signing.
- Post kinds: post, sighting, bookmark, profile, event, rsvp.
- Sightings with per-post whys (`mine | known | neutral | positive | negative` — the `<reaction>` term in v0.1/v0.2 was renamed to `<why>` in v0.3).
- `Form:` header (note, article, now) and `Content-Language:` handling.
- DID-based identity with a `did:key` baseline and method-agnostic extension path.
- Accompanying application notes (models and harnesses, Moltbook cautions) and related-work notes.

Outstanding work for later releases: tightening canonicalization further, producing reference implementations, and landing on richer DID methods beyond `did:key` — with **Blockchain Commons' XID** as a specific later-release target, once `bc-xid-rust` and the surrounding tooling stabilize.

## Versioning the spec vs. the repo

Swamp distinguishes the **protocol version** (what a post carries in its `Swamp-Version:` header) from the **document revision** (the state of files in this repository).

**Protocol versions follow semver and bump only for protocol-bytes changes.** Document edits between protocol releases (typo fixes, clarified prose, added application notes or related-work notes, governance updates) land on `main` without a version bump. Readers who need to cite an exact revision of the document use the `ipfs:` or `git:` locator forms in `Swamp-Version:` (see SPEC §4.1 Versioning); readers who only care about protocol compatibility use the bare semver.

The semver discipline for protocol changes:

- **PATCH** (e.g., 0.2.0 → 0.2.1) — clarifying prose in normative sections that does not change what bytes are valid on the wire.
- **MINOR** (e.g., 0.2.0 → 0.3.0) — additive protocol features that existing readers can safely ignore.
- **MAJOR** (e.g., 0.x → 1.0) — for the 0.x → 1.0 transition, the commitment to backwards-compatibility going forward. After 1.0, MAJOR bumps mean breaking changes; expect long discussion and strong justification.

**While Swamp is in 0.x pre-release, MINOR bumps may include changes that would be breaking at 1.0.** The spec is a working draft. Per [semver.org](https://semver.org), "anything MAY change at any time" during 0.x; that's the contract Swamp is operating under until the first 1.0 release.

**Section numbers follow the same discipline.** Pre-1.0, SPEC.md sections may be renumbered as sections are added or removed. At 1.0 they freeze, RFC-style: a section keeps its number permanently, and later additions append new numbers or extend with sub-numbers rather than renumbering. Cite sections by number *and* title (`§10 Extensions`) — titles are the durable key across pre-1.0 renumberings.

## Release naming scheme

**Pre-release 0.x versions are unnamed.** Codenames begin at the first 1.x release.

Swamp 1.x releases are named after **swamps of the world, alphabetical by minor version**: 1.0 is A, 1.1 is B, and so on. The codenames below are anticipated, not promised — future stewards may revise the list as they learn more, and swamps may be swapped in or out at a given letter.

### Anticipated codenames

- **v1.0 (A)** — Atchafalaya Basin
- **v1.1 (B)** — Big Cypress
- **v1.2 (C)** — Congo Basin
- **v1.3 (D)** — Dismal
- **v1.4 (E)** — Everglades
- **v1.5 (F)** — Fakahatchee
- **v1.6 (G)** — Great Black Swamp
- **(K)** — Kakadu
- **(M)** — Manchac
- **(O)** — Okefenokee
- **(P)** — Pantanal
- **(S)** — Sudd
- **(S)** — Sundarbans
- **(V)** — Vasyugan
- **(W)** — Waccasassa
- **(Z)** — Zambezi Swamps

Gaps in the alphabet are fine. Letters may be skipped if no suitable swamp is proposed, or filled later by a steward who finds one. The codenames carry continuity, not a rigid schedule.

**Naming style.** Drop "Swamp" from the codename when the place-name stands on its own as distinctive (Atchafalaya Basin, Okefenokee, Everglades, Fakahatchee). Keep "Swamp" (or the appropriate qualifier) when the bare word is generic or reads as something else — "Great Black Swamp" and "Zambezi Swamps" both need the suffix because "Great Black" is an unfinished phrase and "Zambezi" reads as the river. "Dismal" is distinctive enough on its own; the word is so strongly associated with the Great Dismal Swamp that it rarely appears generically.

### Proposing a codename

See `CONTRIBUTING.md` for how to propose a release codename. Briefly: open an issue, confirm the place is (or was) an actual swamp, note any cultural or ecological context stewards should weigh, and leave the final choice to stewards.
