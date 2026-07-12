# Related work: the blogosphere, blogrolls, and link blogs

*The early-2000s blogosphere is the closest cultural ancestor to Swamp. Sightings descend from link blogs; the `known` why descends from the blogroll; the manifesto's "slow attention people paid to people" is exactly what that medium was.*

*This note is tight on structural ancestry (which spec moves came from where). For the broader cultural and intellectual lineage — including the early wikisphere and the "social software" movement — see [`../application-notes/social-software-lineage.md`](../application-notes/social-software-lineage.md).*

---

## What these were

The **blogosphere**, roughly 1999–2010, was a loose set of personally-owned weblogs that read each other. Three artifacts of that medium matter for Swamp:

**The blogroll.** A sidebar list of blogs the author read regularly. Not endorsements, not a friend graph in the social-media sense — a public statement of "these are the people on my radar." A reader scanning your blogroll learned who you read; a reader cross-referencing several blogrolls learned the shape of a small public.

**The link blog (or linklog).** A blog whose primary post type was a short pointer to something the author had seen elsewhere — a few words of framing, then a link. Kottke, Boing Boing, Daring Fireball's Linked List, Waxy.org, MetaFilter (collectively-authored), and many others ran in this register. Often paired with a longer-form blog by the same author; sometimes the link blog *was* the whole site.

**"Via:" attribution.** When you posted a link, you noted who you got it from. "Via Kottke" was a manual citation, freely given, that let readers walk the chain backward. The convention was social: you credited the surfacer, and if their reading proved consistently good, you started reading them too.

The discovery layer that made this work was **RSS readers** (Bloglines, NetNewsWire, eventually Google Reader) plus the slow attention of humans who actually read each other's stuff. When Google Reader closed in 2013, the technical layer was already collapsing; the audience had migrated to algorithmic silos by then.

## How Swamp relates

**Borrowed: sightings as signed link blogs.** The sighting (SPEC §7 Sightings) is the link blog's structural descendant. The author lists posts they have seen, each with a why naming the reason for inclusion, signed. Where a 2005 link blogger typed "via Kottke" in prose, a 2026 Swamp sighting carries the post-ref and the why in a parseable line. Same gesture, different envelope.

**Borrowed: `known` as blogroll.** The `known` why (SPEC §7.2 Why values) is the blogroll: a shallow "this person is on my radar" claim, distinct from endorsement. Listing someone's DID with `known` is the closest Swamp gets to the sidebar's "people I read" register.

**Borrowed: the slow-attention posture.** The blogosphere worked because reading was deliberate — twelve blogs once a day, not a feed of thousands once a minute. Swamp's design choices around non-viral travel (sightings rather than amplification, no like-counts, no trending) inherit this posture. The manifesto's "things travel slowly" is the blogosphere's reading rhythm reconstituted, with agents now able to read the larger pool on the human's behalf.

**Borrowed: own your address.** The blogosphere assumed everyone had their own domain. Your blog *was* your address; people pointed at it; you posted there. Swamp moves the address from a host-bound URL to a CID-and-DID pair the publisher controls — a sharper version of the same impulse. The founding gesture (SPEC §7.4 First-person sightings, a sighting whose entries are all self-sightings) is the modern analogue of "post a list of your bookmarks on your sidebar."

**Lesson inherited: the surfacer matters more than the algorithm.** What kept the blogosphere from descending into noise was that you read specific people whose taste you trusted, and they did the filtering. No central ranker. Swamp's reader-built trust (SPEC §11 Trust (non-protocol)) and sighting-graph discovery (§13 Finding new surfacers) take this as the entire model rather than a small piece of it.

## Divergences

**Authorship guarantees.** A 2005 blog post was unsigned; the URL was the only attestation, and when the blog moved or the domain expired, history dispersed. Swamp posts are signed at the byte level (SPEC §4.6 Signature) and content-addressable (§2 Substrate). A Swamp post is recoverable and verifiable independent of where it was first served.

**Reading capacity.** The blogosphere ran on human attention; an active reader followed maybe a hundred feeds, and that was already a job. Swamp expects the agent to do most of the reading and surface what would matter. The slow attention is preserved at the human layer; the wide reading happens underneath.

**Why the blogosphere shrank.** A few causes converged: silos absorbed the audience (Twitter and Facebook were faster, more social, and free); RSS reader infrastructure consolidated and then collapsed (Google Reader, 2013); search and discovery decayed as Google's algorithm changed shape; and personal sites were unsigned, so when a blog moved or died, its history dispersed. Swamp addresses the last of these directly (signing + content addressing) and tries to avoid the first three by not being a silo, not requiring a central reader, and not relying on search.

## References

- Rebecca Blood, *The Weblog Handbook* (Perseus, 2002) — the foundational practitioner text for the form.
- Rebecca Blood, "Weblogs: A History and Perspective" (2000) — contemporary with the form; the link-blog vs. journal-blog distinction.
- Anil Dash, "The Web We Lost" (2012) — what the blogosphere did that the silos don't.
- Andy Baio, "Never Trust a Corporation to Do a Library's Job" (2015) — link rot, archival fragility, and why personal sites mattered.
- Marco Arment, "Lockdown" (2013) — Google Reader's closure as inflection point.
- [kottke.org](https://kottke.org/) — Jason Kottke's link blog, running since 1998; the canonical example still in the register.

---

*Related-work note accompanying the Swamp v0.6.0 specification.*
