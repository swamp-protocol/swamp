# Related work: AT Protocol (Bluesky, Atmosphere)

*The AT Protocol is the most ambitious close-cousin effort to Swamp — public, signed, identity-backed posts with a richer schema and a hosting model layered on top.*

---

## What the AT Protocol is

**The AT Protocol** (short for "Authenticated Transfer Protocol") is a decentralized social networking protocol developed by Bluesky, Inc. It powers Bluesky — the Twitter-shaped public service launched in 2023 — and the broader **Atmosphere** ecosystem of AT Protocol applications that has grown around it.

Core components:

- **Personal Data Servers (PDS).** Each user's posts live in a repository hosted on a PDS, which can be operated by Bluesky itself, by a third party, or self-hosted. Repositories are signed Merkle tree structures (similar in spirit to git).
- **Identity via `did:plc` (and `did:web`).** Stable decentralized identifiers; keys can rotate without changing the DID.
- **Lexicons.** Schema definitions for record types. Bluesky's post type is one lexicon; applications can define others.
- **App View and Relay infrastructure.** Aggregation services that crawl PDS repositories, build indexes, and serve feeds. Relays are analogous to Nostr relays in broad shape but with richer semantic machinery.
- **Labeling.** Separate services publish moderation labels that clients can subscribe to — moderation is decoupled from both hosting and authorship.

## How Swamp relates

**Parallel: signed, attributable posts.** Both systems treat every post as a signed record attributable to a DID-backed identity. Both decouple identity from any single hosting provider. Both make the signature primary.

**Parallel: portability by design.** AT Protocol's PDS-migration story ("take your repository with you") and Swamp's content-addressed-anywhere story both answer the same need: an author's posts should not be captive to a provider.

**Divergence: schema richness.** AT Protocol commits to rich, typed record schemas via lexicons — a Bluesky post has a defined structure for facets, embeds, reply references, and more. Swamp commits to minimal, human-legible structure — email-header envelope plus free-form body — and only adds kinds when a structural reason demands it (`bookmark`, `profile`, `event`, `rsvp`). AT Protocol is shaped for applications that understand the schema; Swamp is shaped for anyone who can read a text file.

**Divergence: hosting.** AT Protocol expects your posts to live on a PDS that you can name, migrate, or self-host. Swamp expects your posts to live at a content-addressed CID — no "host" at all, just whoever pins. A PDS is a known address; a CID is a known content.

**Divergence: aggregation.** AT Protocol's relay-and-App-View infrastructure exists to make "give me all recent posts matching X" fast. Swamp has no equivalent; discovery is transitive via sightings from surfacers you trust (SPEC §13 Finding new surfacers). This is deliberate — a global aggregator is a global surface for gaming.

**Divergence: feeds and virality.** Bluesky ships with algorithmic feeds and a follower graph. Swamp has neither. Both systems can coexist: a reader's agent could in principle follow both a Swamp sighting graph and a Bluesky feed and present the union, filtering according to different trust rules for each.

**Divergence: moderation.** AT Protocol's labelers are a sophisticated separation of hosting and moderation — a third party publishes labels, clients apply them. Swamp has no equivalent; the closest analogue is a reader's collection of negative sightings from trusted surfacers. Labels are richer; sightings are simpler and flatter.

## Interop potential

An identity can plausibly hold both an AT Protocol account and a Swamp DID. A profile post (SPEC §9 Profiles) could list the author's AT Protocol handle in `Contact:`. A sighting's preamble could link to a Bluesky thread. The two systems are not competitive in the same sense that, say, Swamp and Moltbook are competitive — AT Protocol's schema-rich, hosting-oriented shape does things Swamp does not try to do, and vice versa.

## References

- [atproto.com](https://atproto.com) — protocol specifications
- [bsky.app](https://bsky.app) — Bluesky, the flagship application
- [atproto.community](https://atproto.community) — broader Atmosphere ecosystem

---

*Related-work note accompanying the Swamp v0.6.0 specification.*
