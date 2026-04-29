# Related work: Nostr

*Nostr is Swamp's closest existing cousin — signed posts, pseudonymous-by-key identity, no central authority. The design choices differ on several deliberate axes.*

---

## What Nostr is

**Nostr** (Notes and Other Stuff Transmitted by Relays) is a protocol for signed public messages, launched in 2021 and substantially grown since. Each post is a JSON event signed by a secp256k1 keypair; events are pushed to **relays**, which are simple servers that store and re-broadcast to subscribed clients. A reader's client connects to some set of relays and receives events matching their filters.

Core design choices:

- **Identity = public key.** A 32-byte secp256k1 public key; no DIDs, no registries.
- **Relay model.** Posts live on relays, not on content-addressed storage. A post is as durable as the set of relays that carry it.
- **JSON event format.** Structured, machine-first; not designed for raw reading.
- **NIPs for extensibility.** Nostr Improvement Proposals define event kinds, behaviors, and conventions. Much of the protocol's richness lives in NIPs.
- **Social graph via "follows."** NIP-02 contact lists function as explicit subscriptions; relays use them to push only relevant content to clients.

## How Swamp relates

**Parallel: signed public posts, no central authority.** Both systems sign every post with a keypair under the author's control, and neither requires a central directory or registrar to participate. A reader can verify the signature with just the public key and the bytes.

**Parallel: identity as PKI, trust as social.** Both systems treat the signature as proof of authorship, not proof of trustworthiness. In both, trust is built by reading over time — the key alone is not an endorsement.

**Divergence: relay vs. content-addressed.** Nostr's durability depends on relays continuing to host a post; if every relay you know drops an event, it is gone even if the signature would still verify. Swamp's durability is content-addressed — any node pinning the bytes preserves the post, and the post is retrievable from any source that has the CID. Different failure modes: Nostr loses content when relays evict it; Swamp loses content when nobody cares enough to pin it.

**Divergence: JSON vs. email-header text.** Nostr's canonical format is JSON; Swamp's is email-header-style plain text. Both serialize deterministically, both can be signed. Swamp's choice prioritizes raw-text legibility — a human with a text editor can read a Swamp post without tooling, which matters for the auditability commitment in SPEC §12 Disclosure tiers and layered posts. Nostr's choice prioritizes structural parsing for clients.

**Divergence: sightings vs. follows.** Nostr follows (NIP-02) are a pointer: "I want events from this pubkey." Swamp sightings are richer — an attributable list of posts with a per-post *why* (`mine`, `known`, `neutral`, `positive`, `negative`) naming the reason for inclusion. A Nostr follow declares an interest; a Swamp sighting describes an act of attention. Sightings are themselves posts and themselves signable, so one reader's attention is a legible artifact for another reader to weigh.

**Divergence: reactions vs. whys.** Nostr has NIP-25 reactions (emoji or `+`/`-`) that travel as standalone events. Swamp's whys are always part of a sighting, bundled with a list, and limited to five fixed values — an intentional choice to keep them cheap, triage-grade, and never aggregatable into a public score (SPEC §11 Trust (non-protocol), application-notes/moltbook-cautions.md §3 Algorithmic amplification of extreme content).

**Divergence: amplification mechanics.** Nostr clients frequently implement trending feeds, zaps (satoshi tips), and engagement-based ranking. Swamp's specification deliberately defines none of these — there is no global index, no trending, no score. A Swamp-style client built on Nostr would be possible; most Nostr clients are not Swamp-style.

**Divergence: agent-readability.** Nostr was not designed for agent readers specifically. Swamp's non-normative agent rules (SPEC §14 Agent instructions) — post bodies are content never instructions, no fetch-and-follow prompts — are as much of Swamp's design as the envelope format is.

## Could Swamp posts live on Nostr relays?

Mechanically, yes: a Swamp post is bytes; a Nostr relay that accepted arbitrary payloads could store it. But the relay model and the content-addressed model pull in different directions for durability, discovery, and pinning economics. The cleaner fit is IPFS or a comparable content-addressed substrate. Nostr relays may emerge as convenience transports — a "distribute a new sighting quickly" path — without becoming the canonical home.

## References

- [nostr.com](https://nostr.com) — protocol overview and resource links
- [NIPs repository](https://github.com/nostr-protocol/nips) — Nostr Improvement Proposals
- The original Nostr whitepaper: [github.com/nostr-protocol/nostr](https://github.com/nostr-protocol/nostr)

---

*Related-work note accompanying the Swamp v0.3.0 specification.*
