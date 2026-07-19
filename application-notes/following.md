# Application note: Following: posts and the commentary pattern

*Non-normative application note accompanying the Swamp v0.7.0 specification. SPEC §9 defines the normative shape of `Following:` posts: structured-only line-oriented body, parallel to sightings, no prose mixed in. This note walks through what that shape looks like in practice and how authors who want to comment on their follows do so cleanly via sibling `kind=post` posts.*

---

## What a `Following:` post is

A signed snapshot of the feeds an author is following at the time of publication. Each line of the body names one feed:

```
<DID> <whitespace> <Feed-URL>
```

That's the whole grammar. No prose, no markup, no per-entry annotations. Authors who want to say something *about* their follows publish a separate post that points at the `Following:` post — keeping the data clean and the commentary expressive.

This separation matches Swamp's existing pattern for sightings (§7): the sighting body is line-oriented data; commentary lives in a post that references the sighting. `Following:` follows the same discipline.

## Worked example

A `Following:` post:

```
Swamp-Version: 0.7.0
From: Alice
DID: did:key:z6Mk...
Message-ID: 2026-05-05-following-spring
Date: 2026-05-05T10:00-0700
Subject: who I'm reading right now
Feed: https://alice.example.com/swamp/latest
Content-Type: application/swamp; kind=following; v=0.7.0

# craft
did:key:z6Bo... https://bob.example.org/swamp/latest
did:key:z6Ca... https://carol.example.net/swamp/latest

# breadth
did:key:z6Da... https://dana.example.com/swamp/latest
did:key:z6Er... https://erin.example.com/swamp/latest

# argument
did:key:z6Fr... https://fred.example.org/swamp/latest

-----BEGIN SIGNATURE-----
(base64 signature bytes)
-----END SIGNATURE-----
```

Comment lines (starting with `#`) and blank lines are preserved but ignored by parsers. The author uses them to group entries for human readers; tooling treats the entries as a set.

A sibling commentary post written the same day:

```
Swamp-Version: 0.7.0
From: Alice
DID: did:key:z6Mk...
Message-ID: 2026-05-05-following-commentary
Date: 2026-05-05T10:04-0700
Subject: notes on my current follows
Feed: https://alice.example.com/swamp/latest
Form: article
References: did:key:z6Mk.../bafybei...the-following-cid
Content-Type: application/swamp; kind=post; v=0.7.0

I just published my spring follow list. A few words on the choices.

Bob and Carol are the people I read for craft. Bob writes long-form
essays once a week and edits himself harder than most. Carol's a quick
reader; her sightings often surface things I'd miss.

Dana and Erin are recent adds in the breadth bucket. Dana has the
widest range I've seen on Swamp; we'll see if Erin sticks.

Fred and I disagree about most things. That's the point.

-----BEGIN SIGNATURE-----
(base64 signature bytes)
-----END SIGNATURE-----
```

The `References:` header in the commentary post points at the `Following:` post, making the link explicit for tools that walk reference graphs.

## Why no prose in the Following: body

Three reasons:

1. **Unambiguous parsing.** Mixing structure (entries) with prose (commentary) in one body forces a parser to disambiguate "is this line an entry or prose?" Any convention for that disambiguation has edge cases — a sentence like "I started using did:key in 2024" looks like an entry under a "lines starting with `did:`" rule. Splitting bodies eliminates the ambiguity entirely.

2. **Parallel to sightings.** Sighting bodies are structured (each line `<why> <DID>/<CID>`); their commentary lives in posts that reference the sighting. `Following:` posts use the same discipline. One pattern across the spec for "list-shaped artifact + optional commentary."

3. **Forward-compatibility.** If a future release wants per-entry annotations (tags, whys, display names), the body grammar needs to be extensible without breaking parsers. Starting from "structured only" leaves room to add structure cleanly. Starting from "structure mixed with prose" makes future-version body grammar a much harder problem.

## Tooling recommendations

For implementations rendering or walking `Following:` posts:

- **Display entries with whatever name surfaces.** Swamp doesn't carry display names in `Following:` entries by design. A reader's tool can look up each DID's most recent profile (§9) or recent posts to find a `From:` value, and render entries as "Bob (`did:key:z6Bo...`)". When no name is available, render the bare DID (truncated for display: `did:key:z6Bo...`). Don't fabricate; surface what's there.

- **Show the Feed-URL alongside the DID** when rendering for humans, so a reader can see whether the URL's host is one they recognize.

- **Verify Feed-URLs lazily.** Don't try to verify every entry's Feed-URL when displaying a `Following:` post; that's `N` HTTP fetches for what's typically a passive read. Verify on follow (when the user explicitly subscribes) or on poll (when fetching the entry's actual feed).

- **Pair Following: posts with their commentary when present.** A reader's tool can walk recent posts by the same DID with `References:` pointing at the `Following:` post and show them together. Authors who always pair the two reward this; authors who don't get a clean default render.

- **Track the snapshot stream.** Each `Following:` post is independent (no `Supersedes:`). Tools building a follow-graph dedupe on Message-ID and treat the latest as authoritative; older snapshots show change over time.

## When to publish a Following: post

Whenever the author wants. There is no protocol cadence. Some patterns:

- **Seasonal review.** "Here's who I'm reading this spring." Republish quarterly or so.
- **On meaningful change.** Publish a fresh `Following:` post when the active list shifts noticeably, not on every micro-add.
- **Explicit one-shot for an event.** "Here's who I'm following who's at AIW 2027." Authors can publish multiple `Following:` posts with different framings (in different `Subject:` lines); the latest by Date is the live default view, but historical ones inform context.

The protocol doesn't enforce snapshot frequency; the social layer does. Spamming snapshots dilutes the signal; quiet authors should publish on cadence with what they actually do.

## What `Following:` doesn't do

- **It doesn't subscribe the author to anyone's feed.** Subscription is reader-side polling of the `Feed:` URL or walking the gossip graph; the protocol is not informed when someone "follows" someone else. Publishing a `Following:` post is a public claim of interest, not a network operation.
- **It doesn't endorse content.** "I'm reading this stream" is shallower than "I think this post is good." Endorsement of specific posts belongs in sightings (§7), with the appropriate why.
- **It doesn't replace `Contact:`.** `Contact:` (§4.3) names the author's own off-Swamp reachability. `Following:` names *other* authors' Swamp feeds. Different jobs.

## Forward compatibility

v0.7.0 ships `Following:` with a structured-only body and no per-entry metadata. If practice surfaces a real need for per-entry annotations (tags, whys, display names), a later release can extend the body grammar additively — for example, with an optional third column whose semantics are reserved.

The deliberate stance for v0.7.0 is *don't pre-impose structure*. Authors with rich opinions about specific entries publish commentary posts that reference the `Following:` post. The shape of the artifact follows the shape of the thought.
