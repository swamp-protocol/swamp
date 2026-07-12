# Related work: RSS and Atom

*RSS and Atom are the durable prior art for "the author's stream, syndicated" on the open web. Swamp lands somewhere different — discovery happens through gossip, sightings, and IPFS rather than through polling a URL — and the contrast clarifies both.*

---

## What these are

**RSS** (Really Simple Syndication, or RDF Site Summary depending on which branch of the schism you ask) is a family of XML formats for publishing a list of recent posts from a site. Multiple incompatible versions exist; the most common in practice is RSS 2.0 (Harvard-hosted, by Dave Winer and others). Every blog platform, podcast host, and news site has published RSS for decades.

**Atom** (RFC 4287, 2005) is the IETF-standardized successor, designed after RSS 2.0's semantic ambiguities became clear in production. Atom has cleaner handling of authorship, dates, content encoding, and relationship links. It lost the adoption race to RSS 2.0 for surface reasons (inertia, naming) but is technically better.

Both formats serve the same purpose: a reader tool polls a URL periodically, fetches the current feed document, and compares against what it already has to find new entries.

## How Swamp relates

**Borrowed: pull, not push.** RSS / Atom consumers pull on their own cadence; publishers do not notify subscribers. Swamp's sighting-graph discovery (SPEC §13 Finding new surfacers) inherits the pull posture. This is a durable design: pull scales, push requires subscription tracking that looks suspiciously like a platform.

**Borrowed: keep the protocol simple enough that anyone can implement a reader over a weekend.** The durability of RSS — it still works, twenty years later, after every attempt to replace it — comes from being small enough that no single vendor needs to bless it. Swamp aspires to similar smallness.

**Borrowed: no subscription manifest format.** Swamp deliberately does not define an OPML equivalent. OPML exists for RSS / Atom because reader apps want to import/export subscription lists; Swamp readers can build equivalent tools on top of which DIDs they follow, but the protocol does not commit to a list format.

**Divergence: no per-author "stream URL."** RSS and Atom assume each author publishes a single document at a stable URL that readers poll. Swamp does not. A Swamp post lives in IPFS, addressed by its CID; a publisher's "stream" is whatever sightings they have signed over time, found through gossip, walking References, or asking peers. There is no canonical "latest" URL that summarizes an author's recent activity — sighting posts (SPEC §7 Sightings) carry that affordance, but they are independent signed artifacts, not a single document being updated in place.

**Divergence: discovery pattern.** RSS readers find new entries by re-fetching a known URL on a schedule. Swamp readers find new posts through gossip and through their existing reading graph; an aggregator that crawls IPFS for a DID's posts and offers a feed view can be built as a tool on top, but it is not part of the protocol. The "RSS gesture" — pull-this-URL-and-list-what's-new — does not have a Swamp-native equivalent.

**Divergence: signing.** RSS and Atom are plaintext XML, unsigned. Signed-feed extensions exist but were never adopted widely. Swamp posts are signed at the byte level (SPEC §4.6 Signature); authenticity is a property of the post, not of the place it was fetched from.

**Divergence: content-addressed durability.** RSS and Atom URLs decay; the feed document at that URL is whatever the server decides to serve today, with no cryptographic link back to historical snapshots. Swamp posts live in IPFS, addressed by CID — byte-exact and durable as long as anyone pins them. The `ipfs:` locator in `Swamp-Version:` (SPEC §4.1 Versioning) shows the same lesson applied to spec versions.

**Lesson inherited from decades of operational RSS pain: pointer durability decays in both directions.** A URL from last week is probably live, one from five years ago may have moved, been abandoned, or been sold to a spam repurposer. The `Contact:` durability caveats in SPEC §4.3 Contact record this lesson; it applies to any non-content-addressed pointer Swamp readers walk.

## References

- [RSS 2.0 specification (Harvard Cyberlaw)](https://cyber.harvard.edu/rss/rss.html)
- [Atom Syndication Format (RFC 4287)](https://www.rfc-editor.org/info/rfc4287)
- [Atom Publishing Protocol (RFC 5023)](https://www.rfc-editor.org/info/rfc5023) — for historical interest; Swamp deliberately does not imitate this part

---

*Related-work note accompanying the Swamp v0.6.0 specification.*
