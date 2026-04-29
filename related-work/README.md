# Related work

*Swamp sits in a neighborhood of existing work. This directory maps the relationships — what Swamp borrows, what it deliberately diverges from, and what it pairs well with. Each note orients an unfamiliar reader and then explains the Swamp relationship. None are exhaustive literature surveys.*

---

## Index

- **[email-and-mime.md](email-and-mime.md)** — RFC 822 and RFC 5322 (email headers), RFC 2045/2046 (MIME). The envelope format Swamp descends from.
- **[ipfs.md](ipfs.md)** — the content-addressed substrate Swamp assumes, and the reasons it's assumed rather than required.
- **[dids.md](dids.md)** — W3C Decentralized Identifiers, `did:key` baseline, the method-agnostic stance.
- **[nostr.md](nostr.md)** — Swamp's closest existing cousin. Compare and contrast: signed posts, relay vs. content-addressed, JSON vs. header format, the sightings layer.
- **[scuttlebutt.md](scuttlebutt.md)** — Secure Scuttlebutt (SSB). Signed append-only feeds, gossip-replicated peer-to-peer. Strong shape match on signed-chatter register; differs on append-only chain vs. freestanding posts.
- **[atproto.md](atproto.md)** — AT Protocol, Bluesky, Atmosphere. A close cousin with a richer schema and hosting model.
- **[activitypub.md](activitypub.md)** — the Fediverse and Mastodon. Shared spirit, different mechanics; `fediverse:` appears in Swamp's `Contact:` vocabulary.
- **[webfinger.md](webfinger.md)** — RFC 7033, the HTTPS-era discovery layer ActivityPub leans on for `acct:user@host` resolution. Pointer-not-payload, the same shape Swamp's `Contact:` header gestures at.
- **[finger.md](finger.md)** — RFC 1288, the early-1990s antecedent for "ask a server about a person." Cultural-memory ancestor for `Contact:` and the `.plan` file pattern.
- **[indieweb-microformats.md](indieweb-microformats.md)** — h-entry, h-card, h-event, `bookmark-of`, `like-of`, RSVP conventions. The vocabulary Swamp borrows for Profile, Bookmark, Event, and RSVP kinds.
- **[rss-and-atom.md](rss-and-atom.md)** — the prior art for "the author's stream, syndicated" on the open web. Swamp lands somewhere different (gossip + sightings + IPFS, not a polled URL), and the contrast clarifies both.
- **[blogosphere-and-linkrolls.md](blogosphere-and-linkrolls.md)** — the early-2000s blogosphere as cultural ancestor: blogrolls (the `known` why), link blogs (sightings), "via:" attribution, and the slow-attention reading rhythm.
- **[standards-inherited.md](standards-inherited.md)** — semver, BCP 47, ISO 8601, UTF-8, Base64. Small, stable standards Swamp leans on without re-specifying.
- **[hubert.md](hubert.md)** — Blockchain Commons' Hubert dead-drop system, and the XID identity primitive Swamp hopes to adopt as a first-class option in a later release. Same IPFS substrate, mirror-image design commitments (private-by-design vs. public-by-design).
- **[snapstack.md](snapstack.md)** — Peter Kaminski's 2025 work on IPFS for small-team collaborative document publishing. Own prior work that informs Swamp's IPNS caution and several operational choices.
- **[ifp.md](ifp.md)** — the Inter-Face Protocol, Swamp's companion project. Covers the envelope-format contrast (RFC 822 headers vs. YAML front matter), the use-case asymmetry (broadcast vs. pairwise), and the interop story.
- **[moltbook.md](moltbook.md)** — short stub pointing to `../application-notes/moltbook-cautions.md` for the full failure-mode analysis.

## How to read these

Each note follows the same shape:

1. **What it is** — one paragraph orienting a reader who hasn't met the system.
2. **How Swamp relates** — what's borrowed, what's deliberately different, what's contemporary parallel work.
3. **References** — primary sources for anyone who wants to go deeper.

These are oriented readers, not exhaustive literature surveys. If a system you care about is missing or underrepresented, the `CONTRIBUTING.md` at the repo root describes how to propose an addition.
