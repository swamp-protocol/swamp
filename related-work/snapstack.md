# Related work: SnapStack (Peter Kaminski, 2025)

*A Swamp-side reading of SnapStack, Peter Kaminski's earlier work on IPFS for collaborative document publishing. SnapStack is own prior work that informed several Swamp design choices; this note captures the relationship explicitly.*

---

## What SnapStack is

**SnapStack** is a lightweight workflow for small teams (2–5 people) to maintain a shared document collection ("folio") using IPFS for content and IPNS for a moving pointer to the latest version. It's "version control for documents" with cryptographic integrity and decentralized distribution, but optimized for thoughtful coordination rather than automatic merging.

### Architecture at a glance

- **Folio** — a directory of Markdown and assets, added to IPFS as a tree, yielding a **CID** for each version.
- **IPNS name** — a stable pointer that always resolves to the latest accepted CID.
- **MANIFEST.json** in every snapshot — one JSON record per version: `cid`, `parent_cid`, `version`, `timestamp`, `author`, `summary`, `files_changed`. The `parent_cid` chain forms an implicit hashchain.
- **Two publishing models:**
  - *Maintainer of Record (MoR)* — one person holds the main IPNS key, accepts proposals, publishes accepted versions.
  - *Shared Key* — everyone holds the IPNS key; optimistic concurrency control via IPNS sequence numbers prevents clobbering.
- **Snapshots, not merges.** Conflicts are prevented by soft coordination (chat locks, small PRs), not resolved algorithmically. Losers rebase.
- **Optional security layers:** signed manifests (ssh-sig / minisign / GPG), OpenTimestamps anchoring, Rekor transparency log.
- **Working scripts** in `bin/`: `add.sh`, `pin.sh`, plus `scripts/validate.sh` and `scripts/publish_latest.sh` sketched in the main doc.

### Threat model

SnapStack is designed for **small, mostly-trusted teams publishing public or semi-public documents**. The threat model is coordination failure and the occasional compromised key, not adversarial publishing. Cryptographic integrity is for tamper-evidence and audit trail, not for protecting against motivated attackers.

### Hard-won IPNS knowledge

The companion doc **`Persistent Folio Name.md`** is a careful, unsparing evaluation of IPNS for persistent naming. Summary: IPNS records expire and require active republishing every ~24h; IPNS republishing services are scarce (w3name, rolling your own node); standard pinning services don't cover IPNS. Four options compared — self-hosted node, w3name, DNSLink, ENS — with **DNSLink** recommended for most cases and **ENS** for decentralization-critical. Conclusion: "truly decentralized, low-maintenance, easy-to-use persistent addressing remains unsolved."

This is not theoretical; it is experience. Any Swamp variant that wants mutable pointers should read it first.

## Same substrate, different purpose

Both systems use IPFS. They solve overlapping but distinct problems:

| Axis | SnapStack | Swamp |
|---|---|---|
| **Unit** | A folio (directory tree) | A single post (small text file) |
| **Participants** | Small team (2–5), mutually trusting | Anyone, strangers included |
| **Coordination** | Chat-based soft locks, MoR or shared-key | None; no shared authority, no locks |
| **Mutability model** | IPNS pointer updated to latest CID | Message-ID is stable by author intent; supersession is an explicit post header |
| **Chain** | Implicit via `parent_cid` in MANIFEST.json | Per-author supersession header; no linear chain across authors |
| **Signing** | Optional layered (sigs, OTS, Rekor) | Mandatory, every post |
| **Editorial review** | Yes (MoR model); optional (shared-key) | None by protocol; lives in the trust/reading layer |
| **Conflict handling** | Rebase; loser reapplies on new base | Not applicable — no shared document |
| **Pointer persistence** | IPNS (hard in practice; see above) | No protocol-level mutable pointer; sighting graph is the discovery layer |
| **Threat model** | Trusted team, coordination failure | Mostly-honest ecosystem, some spam and attacks |

**One-sentence summary:** SnapStack publishes a shared document *collection* with careful coordination among a few trusted authors. Swamp publishes *individual* posts to a public pool, with no coordination and no shared authority.

They sit at different points on the "how many hands on the same thing" axis. SnapStack is 2–5 hands on one folio; Swamp is N hands on N individual posts.

## Things Swamp can borrow from SnapStack

### 1. The working scripts

`bin/add.sh` and `bin/pin.sh` are tested, working IPFS scaffolding. A minimal Swamp reader/writer can start from these rather than from scratch.

### 2. MANIFEST.json → post headers

Swamp's post header block (`DID:`, `Message-ID:`, `Date:`, etc.) is essentially MANIFEST.json's purpose — structured metadata sitting next to content. SnapStack's field list (`cid`, `parent_cid`, `version`, `timestamp`, `author`, `summary`, `files_changed`) maps almost cleanly onto Swamp's header design, with supersession covering the `parent_cid` role. Sanity-check Swamp's header inventory against MANIFEST.json's field list — anything SnapStack found useful that Swamp is missing is worth considering.

### 3. The optional-security stack

SnapStack's tiered security recipe is directly applicable:

- **Level 1:** signed manifests (ssh-sig / minisign / GPG). Swamp already requires this for posts.
- **Level 2:** OpenTimestamps anchoring. The defense against backdated `Date:` headers for posts where timing matters (key-rotation announcements, time-sensitive claims). SnapStack has working notes on how to actually do it.
- **Level 3:** Rekor transparency log. Worth considering as an optional layer for high-stakes posts (e.g., key-rotation announcements).

### 4. Snapshots-not-merges philosophy

Swamp already commits to this implicitly (posts are immutable once signed; supersession replaces rather than merges). SnapStack articulates *why* more clearly — semantic conflicts aren't textual, accountability requires named decisions, cryptographic integrity requires explicit approval per state. Worth borrowing the language for Swamp's design doc.

### 5. Hard-won IPNS caution

Swamp's current design does not use IPNS. Good. SnapStack's `Persistent Folio Name.md` is the prior-art reason to stay away. If anyone proposes adding IPNS-based mutable pointers to Swamp (e.g., "latest sighting from DID X"), that doc is the first reading. The short version: IPNS is not practical today without DNSLink or ENS backing, both of which defeat the decentralization story.

## Things Swamp deliberately does differently

### Individual posts, not folios

SnapStack's unit is a collection that evolves. Swamp's unit is a single post that, once published, doesn't evolve — it gets superseded or stays. This is not a bug fix for SnapStack; SnapStack's folio model is right for small-team docs. It's wrong for Swamp because Swamp has no shared document.

### No IPNS, no pointers

SnapStack needs a pointer to "latest" because the folio changes over time and consumers want the current version. Swamp doesn't need this because the discovery layer (sighting graph) does the pointer job socially. Freshness in Swamp comes from "who sighted this recently" not from "the IPNS pointer moved."

### No roles, no editorial layer

SnapStack has explicit roles (MoR, contributor, backup maintainer). Swamp has none. A poster is a poster; a surfacer is a surfacer; nobody has authority to accept or reject. The trust layer is the only filter.

### Strangers, not trusted teammates

SnapStack assumes mutual trust. Swamp assumes you might be reading someone you've never heard of. This is the core design commitment difference; everything else follows from it.

### No coordination primitive

SnapStack has soft locks, chat announcements, PubSub intent messages. Swamp has nothing of the kind — there's no shared resource to coordinate on. Every author writes their own posts; collisions are logically impossible.

### Signing is mandatory, not optional

SnapStack treats signing as a hardening layer. Swamp treats it as table stakes — an unsigned post isn't a Swamp post.

## Where the systems might meet

Several natural intersection points:

- **A SnapStack folio could be a Swamp post.** A post body could reference an IPFS CID of a folio (SnapStack) as an attachment or appendix, getting the best of both — Swamp's signed individual post wrapping SnapStack's collaborative folio. Useful for "here's my published report, and here's the Swamp post signing it into my identity."
- **OpenTimestamps infrastructure.** Both systems want the same thing — public proof of existence at time T. Any tooling one builds is reusable by the other.
- **Signed-manifest tooling.** The signing-canonicalization-verify code is largely shared.
- **The working scripts.** `bin/add.sh`, `bin/pin.sh`, and whatever minimal validators SnapStack has are useful as a jumping-off point for the first Swamp reference implementation.

## What SnapStack knows that Swamp should inherit

Several pieces of operational wisdom are not yet in Swamp's docs but probably should be, because SnapStack earned them by trying:

- **IPNS is operationally painful.** Swamp's current design avoids IPNS; keep it that way unless there's a compelling reason.
- **Remote pinning services exist and are useful** (Pinata, Lighthouse, Filebase, Storacha, others). For pinners who don't want to run their own node. Swamp's pinning story can assume these as a practical option.
- **CAR exports for archival.** SnapStack suggests stashing CAR files offsite as a belt-and-suspenders archival strategy. Swamp posts are small enough that this is cheap; agents doing long-term archival could lean on it.
- **Dual pointers for staged publishing.** SnapStack's `main-next` idea doesn't directly apply to Swamp (no shared pointer) but the pattern — have a staging address before committing to canonical — could inform agent workflows that want to draft-then-publish.
- **Retention policies matter.** SnapStack suggests "pin the last 5 releases, unpin older unless cited." Swamp analogue: pin posts your trusted surfacers recently sighted, let older ones age out unless actively referenced.

## Background sessions

Two recorded conversations on the SnapStack design wiki cover material that did not make it into the polished design docs and may be useful for anyone implementing Swamp tooling that touches the same substrate:

- [IPFS with Bill and Pete, 2025-09-16](https://snapstack.massive.wiki/blogs/ipfs_with_bill_and_pete,_2025-09-16)
- [IPFS with Bill and Pete, 2025-10-03](https://snapstack.massive.wiki/blogs/ipfs_with_bill_and_pete,_2025-10-03)

---

*Related-work note accompanying the Swamp v0.6.0 specification.*
