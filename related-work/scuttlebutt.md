# Related work: Scuttlebutt (Secure Scuttlebutt, SSB)

*Scuttlebutt is a signed-feed peer-to-peer protocol with a strong shape match for Swamp's signed-chatter register. Append-only feeds, gossip replication, no central server — the design commitments overlap on several axes Swamp also cares about.*

---

## What Scuttlebutt is

**Secure Scuttlebutt** (SSB) is a peer-to-peer protocol for signed personal feeds, designed by Dominic Tarr starting around 2014 and grown into a working network with multiple clients (Patchwork, Manyverse, Patchbay, others). Each participant has a **keypair**; their feed is an **append-only log** of signed messages, where every message carries the hash of the previous message, forming a per-author hash chain. Messages are JSON, signed with Ed25519, identified by their hash.

Core design choices:

- **Identity = keypair.** Each participant's identity is their public key; feeds are addressed by `@key.ed25519`.
- **Append-only feeds.** Every post extends the author's chain. The chain cannot be forked without producing visibly inconsistent logs to anyone who has seen the original.
- **Gossip replication.** There are no canonical servers. Peers exchange feeds with peers they know, transitively replicating each other's logs. A user's device holds full copies of the feeds it follows.
- **Local-first operation.** SSB is famously usable offline — peers sync when they meet on the network (LAN, internet, sneakernet), and accumulate the network's content on their own device.
- **Pubs as convenience relays.** Public always-online peers ("pubs") help replication for users who are not always reachable, but they are not authoritative — any peer can play the same role.
- **Private messages via box keys.** Messages can be encrypted to a recipient's key and embedded in the same feed, opaque to other readers.

## How Swamp relates

**Parallel: signed posts, no central authority.** Both systems sign every post with a keypair under the author's control, and neither requires a central directory or registrar to participate. A reader verifies authorship from the signature and the public key alone.

**Parallel: identity as PKI, trust as social.** Both systems treat the signature as proof of authorship, not proof of trustworthiness. Trust is built by reading over time; the key alone is not an endorsement.

**Parallel: gossip-friendly distribution.** SSB is built around gossip replication; Swamp's content-addressed substrate is gossip-friendly by construction (any node can serve any byte-exact post, and CIDs make duplicates harmless). The mechanics differ but the social shape — posts moving peer-to-peer without a publisher having to push them — is the same.

**Divergence: append-only feed vs. freestanding posts.** SSB's central primitive is the *feed* — an unbroken hash chain per author, where dropping or skipping an entry breaks the chain. Swamp's central primitive is the *post* — a signed, freestanding artifact whose existence does not depend on its neighbors. Swamp posts may be aggregated into sighting-style streams, but those streams are not hash chains; missing one Swamp post does not invalidate later ones. Different durability stories: SSB's chain integrity is protocol-enforced; Swamp's per-post integrity is signature-enforced and chain construction is left to higher layers.

**Divergence: feed-walk discovery vs. sighting-graph discovery.** SSB's append-only feed doubles as a discovery mechanism — once you know an author's feed root, walking the chain forward gives you everything they have published, in order. Swamp has no per-author chain to walk. Discovery is done by **sightings** (SPEC §7 Sightings): an author's own *self-sightings* (entries marked `mine`) bootstrap the claim "here is what I have published," and other readers' sightings — `known`, `positive`, `neutral`, `negative` — layer additional surfacers on top of the same posts. Discovery becomes a slightly-trusted network of surfacers rather than a single canonical per-author chain. The cost is that no reader has a guaranteed-complete view of an author's output without comprehensive self-sightings; the benefit is that *who notices what* becomes explicit and sightable, rather than a hidden side effect of who-replicates-whose-feed.

**Divergence: full-feed replication vs. content-addressed pinning.** An SSB peer that follows you replicates your entire feed, in order, onto its device. Swamp readers fetch only the bytes they care about, by CID, with no expectation of holding a complete history. SSB optimizes for offline-completeness; Swamp optimizes for selective attention.

**Divergence: JSON message format vs. email-header text.** SSB messages are JSON, signed canonically. Swamp posts are email-header-style plain text (SPEC §4.2 Not email). Both can be signed deterministically; Swamp's choice prioritizes raw-text legibility for human readers and for auditors.

**Divergence: private messages.** SSB embeds encrypted private messages in the public feed. Swamp posts are public by construction; any pairwise communication belongs to a different protocol (the Inter-Face Protocol, see [`ifp.md`](ifp.md)) rather than to Swamp itself.

**Divergence: sightings.** SSB has likes and replies as message kinds; it does not have an attribution-graded "I read this and here is my reason for listing it" primitive. Swamp sightings (SPEC §13 Finding new surfacers) — attributable lists with a per-post why — are the closest analogue, but they are themselves signed posts in the public stream, not an in-feed metadata layer.

## References

- [scuttlebutt.nz](https://scuttlebutt.nz) — community site and protocol overview
- [Scuttlebutt Protocol Guide](https://ssbc.github.io/scuttlebutt-protocol-guide/) — the canonical technical reference
- [Manyverse](https://www.manyver.se), [Patchwork](https://github.com/ssbc/patchwork) — clients

---

*Related-work note accompanying the Swamp v0.3.0 specification.*
