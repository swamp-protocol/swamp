# Application note: Self-sightings and the stream of sightings

*Two things are easy to confuse: a **self-sighting** (a line-level claim of authorship within a sighting) and the **stream of sightings** a publisher accumulates over time. Spec readers and implementers — including the spec's own authors — have inadvertently flattened them into a single thing called "the self-sighting." This note pulls them apart, names what each is for, and recommends a publishing rhythm appropriate to Swamp's bootstrap stage.*

---

## Why this note exists

Two concepts arrive together the first time you stand up a Swamp identity, and they're easy to merge into one. The merger leads to subtle but real mistakes: stitching successive sightings into a `Supersedes:` chain, treating "the self-sighting" as a singleton document, and worrying that you have to re-announce your entire post history forever.

None of those follow from the spec when the two concepts are kept separate. The spec is structurally right; the wrinkle is in how the surrounding docs (and the authors' own thinking) compress the model into a single thing called "the self-sighting" — using one phrase as if it named a kind of post, when it actually names a kind of *line within* a post.

This note keeps them separate.

---

## A vocabulary note (read first)

Before the structure: the words.

- **A sighting** — also called a **sightings post** — is the signed `kind=sighting` artifact. It has its own Message-ID, signature, and `Date:`. SPEC §7 Sightings defines it.
- An **entry** (or **sighting line**) is one `(why, post-ref)` line within a sighting. SPEC §7.3 Canonical sighting body format defines the line grammar.
- A **self-sighting** is an entry whose why is `mine` — a first-person claim of authorship of the referenced post. **It is line-level, not post-level.**

A sighting may contain self-sightings (`mine` entries), sightings of others' posts (`known`, `positive`, `neutral`, `negative`), or both. The SPEC §7.6 Complete sighting example shows all five whys in one post.

There is no protocol object called "a self-sighting post." When colloquial usage says "publish your self-sighting," it means "publish a sighting whose entries are all (or mostly) self-sightings" — typically the founding gesture. Below, this note uses the precise terms.

---

## The two things

### 1. A self-sighting (a line-level claim)

A self-sighting is one entry in a sighting:

```
mine  did:key:z6Mk.../2026-04-22-hello-swamp-a3f2
```

That single line is the unit. It says: "I, the signer of the surrounding sighting, claim authorship of this post."

Self-sightings are not artifacts. They are properties of entries inside a sighting. The artifact is the sighting; the self-sighting is what makes a particular entry first-person.

### 2. A sighting (the artifact) and the stream of them

A sighting is a single signed post:

- `Content-Type: application/swamp; kind=sighting; v=0.6.0`
- Body lists `(why, post-ref)` entries
- Has its own `Message-ID`, signature, and `Date:`
- Lives in IPFS like any other Swamp post — addressable by CID
- Immutable once signed

A publisher accumulates a *stream* of sightings over time. Each one is independent; there is no chain stitching them together. The founding gesture (SPEC §7.4 First-person sightings) is one such sighting whose entries are all self-sightings; subsequent sightings may be all-`mine`, all-`known`, all-`positive`, or any mix.

Readers find sightings the same way they find any other Swamp post — through gossip, through their local pond, by walking References, or by following a CID a friend shared. There is no canonical "latest" pointer; your picture of an author's recent activity is the union of whatever sightings you've collected. Eventually consistent, which matches the gossip register.

---

## How they fit together

A typical setup:

- **The artifacts.** Every two months or so, the publisher signs a new sighting listing the posts they want findable. Each one is a fresh post with its own Message-ID and CID; together they accumulate as the publisher's authoritative output.
- **Discovery.** Readers learn about the publisher's sightings the way they learn about anything else in Swamp: gossip, walking References from a post they liked, asking peers, or being subscribed to that DID locally. Aggregators that crawl IPFS for a DID's posts can be built as tools on top, but they are not part of the protocol.

No `Supersedes:` between sightings. None needed.

---

## The "more like this" gesture

When a reader finds a post they like and wants more from the same author, the gesture in an IPFS-only world is overlapping rather than singular:

- **Check the local pond first.** The reader's agent has been collecting posts via gossip. If you've been swimming a while, you probably already have other posts from this author cached.
- **Walk References.** The post may have `In-Reply-To:`, `Sighting-Of:`, or other refs. Walking the graph finds *related* posts, not the whole stream — but often that's actually what you want.
- **Ask peers.** Gossip a query: "anyone got recent posts signed by DID X?" Peers respond with CIDs they've seen.
- **Subscribe to the DID locally.** Tag the author as "interesting" in your agent. Future gossip mentioning that DID gets prioritized.
- **Find a recent profile or sighting post by the same DID.** Profiles (SPEC §9 Profiles) and sightings are where authors curate their own References.

Swamp doesn't have an "RSS gesture." It has a *pond*. You don't pull a stream; you watch what surfaces, ask around, and let your local cache thicken over time.

---

## Publishing rhythm during bootstrap

While Swamp is bootstrapping, **a brand-new reader who wants the publisher's full back catalog in one pull is the common case, not the edge case.** Most people who land on a sighting will be encountering it for the first time.

This shapes the recommended rhythm:

> **Republish a full-catalog sighting — every post you want findable, each marked `mine` — every month or two.**

Concretely:

- Each new sighting includes everything you want a new reader to be able to find. Not just "the posts since last time"; the full catalog. Every entry is a self-sighting (`mine`).
- Regular readers' agents see the same posts again, recognize them by `<DID>/<CID>`, and dedupe. They are already designed for this (SPEC §7.3 Canonical sighting body format explicitly allows duplicate post-refs within a sighting; the same logic carries across sightings). The repetition costs them nothing.
- New readers' agents pick up everything in one pull. They don't need to walk back through a year of incremental sightings to assemble a complete picture.

The cost is asymmetric in the new reader's favor — a few extra signed bytes for established readers, a complete picture for newcomers. That's the right trade for now.

Cadence is human-paced, not automated: monthly or every two months is a reasonable default for a person publishing at a typical writing rate. An agent publishing on a person's behalf may publish more often.

The social-media announcement layer (SPEC §13 Finding new surfacers and `TLDR.md`'s bootstrap pattern) tapers off independently. You announce a recent sighting on Mastodon, Bluesky, or wherever your friends already read you, until your circle has picked you up; then you stop pinging social and just keep publishing. The republishing rhythm is a separate practice from the announcement rhythm.

---

## Steady state, eventually

When Swamp is no longer bootstrapping — when most readers in your circle already follow you and the new-reader case is rare — the rhythm relaxes. At that point, *incremental* sightings (only the entries since last time) are sensible: regular readers care about new entries, and new readers can either request a consolidated catalog explicitly or walk the sighting stream backwards.

But that day is not today. For now, full-catalog every month or two is the right shape.

A "consolidated" sighting at any point is just a long sighting; no special status, no special header, no special handling. Publishers with very large catalogs (hundreds or thousands of posts) may eventually want pagination patterns, but those are out of scope here.

---

## What `Supersedes:` is and isn't for

`Supersedes:` (SPEC §6 Threading, supersession, retraction) is for posts where **only the latest matters** and earlier versions should drop out of consideration:

- `Form: now` posts (SPEC §4.5.1 `Form: now`) — "I'm at the cafe" is replaced by "I'm at home"
- Profiles (SPEC §9 Profiles) — your current bio replaces last year's bio
- RSVPs — your latest "yes/no/maybe" replaces earlier ones

Sightings are **not** in this category. Each one is a moment-in-time statement that stays valid as part of the record. The most recent one is not "the truth and the others are obsolete"; the most recent one is just the most recent one. Earlier sightings remain valid claims about what the publisher had said about which posts at that earlier moment.

If a publisher genuinely wants to *retract* a self-sighting (say, they discover they listed a post that wasn't theirs after all), the right move is a new sighting that omits the contested entry, plus a separate retraction post if they want to be explicit. Not a `Supersedes:`-chained replacement of the prior sighting.

---

## Common misreadings to avoid

A few specific failure modes worth flagging, mostly from this project's own history:

- **"The self-sighting" as a post-level noun.** The phrase is shorthand for "a sighting whose entries are all (or mostly) self-sightings." It is not a separate kind of artifact; the artifact is always a sighting. When you find yourself writing or reading "the self-sighting" as if it names a singular document, the words have collapsed a structural relationship.
- **A `Supersedes:` chain stitching successive sightings together.** Wrong shape; the prior is not retracted by the new one.
- **A canonical filename like `self-sighting.txt` baked into tooling as if it is the artifact.** It's a convenience pointer; what's served there is a sighting, not a "self-sighting" — even if every entry happens to be `mine`. The canonical address is the CID.
- **Worrying that you have to re-sight your entire history forever.** You don't. During bootstrap, full-catalog republishing every month or two is generous and useful; in the long run, you can taper to incremental sightings.

---

## Summary

A self-sighting is one `mine` line in a sighting. A sighting is the signed artifact, addressed by its CID and identified by its Message-ID. A publisher accumulates a stream of sightings over time. Conflating them creates the confusion this note exists to dispel.

While Swamp is bootstrapping, republish a full-catalog sighting — every post you want findable, each marked `mine` — every month or two. Regular readers dedupe; new readers get the whole picture in one pull. No `Supersedes:` between sightings — that header is for posts where only the latest matters, and sightings are not such posts.
