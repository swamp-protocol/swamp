# Application note: stores and the published tree

*Non-normative application note accompanying the Swamp v0.7.0 specification. The spec deliberately says little about where posts live: SPEC §2 Substrate names content-addressed retrieval, §4.10 Feed defines the one mutable claim, and §4.9.2 recommends sibling resolution for embedded bytes. Everything else about how authors keep and serve their material is convention. This note documents the store conventions Swamp tooling has converged on, so new tools can converge too — and names precisely which parts are contract and which are habit.*

---

## Why stores exist

The protocol defines posts, how they're identified, and how they verify. It does not define how an author keeps them, stages them, or serves them — and it shouldn't: a reader never sees your filesystem. Readers see exactly two things: bytes fetched by CID, and one feed-claim URL.

In practice, every Swamp tool to date (Airboat, Skimmer, the swamp-frog scripts, the store-repo sync scripts) has converged on the same working shape: a **store** — a directory owned by one identity — with a **published tree** inside it. The published tree is the part the world can reach; the rest is the author's workshop.

## The published tree

The published surface of a store is one flat directory:

```
public/
  bafkreiho7n2...      ← a post (signed envelope, text)
  bafkreigdbg7...      ← image bytes embedded by a post (SPEC §4.9.2)
  bafkreiab3dx...      ← a self-sighting (signed envelope, text)
  latest               ← the feed claim (SPEC §4.10)
```

That's the whole contract, and it has three clauses:

- **Every artifact is a file named by its CID**, sitting beside the others. Posts, sightings, profiles, and embedded image bytes are all peers in one flat namespace. No subdirectories by kind, no date hierarchies, no extensions on filenames — the CID is the name.
- **Exactly one file is mutable: `latest`**, the signed feed claim naming the author's most recent self-sighting. Everything else is content-addressed and therefore immutable — a changed file would be a different CID, hence a different file. Mutability lives at one bounded point and nowhere else; this is the discipline SPEC §4.10 commits to, and the tree makes it physical.
- **Siblings resolve.** Because a post and the bytes it embeds are files in the same directory, a bare-CID image target (SPEC §4.9.2) resolves relative to the URL the post itself was fetched from — on disk, on any static host, on any mirror, through any IPFS gateway. This is why the tree is flat: sibling resolution is the property, flatness is just its cheapest implementation.

**The directory's name is not part of the contract.** Local stores conventionally call it `public/` — a self-documenting reminder of what crossing into it means. Hosted surfaces mount the same tree wherever they like: `swamp.peterkaminski.wiki` serves it at `/peterkaminski/`, so the feed lives at `.../peterkaminski/latest` and every CID beside it. Readers never construct store paths from convention; they follow the feed claim and resolve siblings, so the mount point is invisible to them.

## The workshop around it

Outside the published tree, tools keep whatever working state they need, and no two tools need agree:

```
my-store/
  public/          ← the published tree (above)
  outbox/          ← unsigned drafts awaiting a signer
  following.md     ← feeds this identity follows
  ledger.md        ← a reader's session state (Skimmer)
  rules.md         ← triage rules (Skimmer)
  .skimmer/        ← tool config
```

None of this is contract. `outbox/` is a common convention worth knowing — a staging area for composed-but-unsigned envelopes, drained by a signer (a CLI like kiss, or a browser signer via `window.swamp`) which signs each draft and files the result into `public/` under its CID. But a tool with a different workshop shape breaks nothing, because nothing outside `public/` is ever served or fetched.

The one rule that matters at the boundary: **only signed, disclosure-checked material crosses into the published tree.** The directory line is the publish line.

## Hosting

The published tree is static files — no build step, no server logic, no database. Anything that serves bytes at stable URLs can host it: a static-site host, a plain web server, an object store, an IPFS gateway over a pinned copy. Current practice (the `swamp-stores` pattern) syncs `public/` into a static-hosting repo and lets the host serve it as-is.

Two headers-level courtesies make a hosted store maximally readable:

- **CORS-open** (`Access-Control-Allow-Origin: *`) — the tree is public by definition, and browser-based readers can't fetch it otherwise.
- **`text/plain` on the feed path** — so browser-native readers polling `latest` get bytes, not a download prompt. Everything in the tree is either text (envelopes) or sniffable bytes (images); no content-type ceremony is needed beyond that.

Mirrors are trivially correct: the tree is content-addressed except for `latest`, so a mirror is at worst briefly stale about which sighting is newest, never wrong about content.

## The tree is the pin-set

Durability in Swamp is "caring = pinning" (SPEC §2), and the published tree makes caring cheap: **pin or mirror the tree, and you have preserved the author's posts, sightings, profile, and every image they embedded** — without parsing a single body to inventory what's in it. Pinning tools walk the directory, not the content. This is the property SPEC §4.9.2's durability story leans on, and it's the reason embedded bytes are published as siblings rather than tucked anywhere cleverer.

## What this note is not

- **Not normative.** A tool that keeps its store differently and still serves valid feed claims and CID-addressable bytes is fully conformant. If store-tool divergence ever hurts in practice, this convention can harden into something stronger then — practice first, structure second.
- **Not a sync protocol.** How `public/` gets to a host (git push, rsync, a sync script) is tooling, not protocol.
- **Not a backup strategy.** The tree is the *published* record; authors should assume it is world-readable forever and separately back up what they can't afford to lose — especially keys, which are not in the store and never should be.
