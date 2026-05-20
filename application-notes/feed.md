# Application note: Feed: header and the signed CID claim

*Non-normative application note accompanying the Swamp v0.4.0 specification. SPEC §4.10 Feed defines the normative contract for the `Feed:` header and the signed claim returned at its URL. This note walks through what the contract looks like in practice, common edge cases, and recommendations for authors and tooling.*

---

## Why `Feed:` exists

A reader encountering one of an author's posts on a non-Swamp surface — Bluesky, Mastodon, X, email — has one CID and a DID, and no protocol-level way to ask "what else does this DID post?" Without a discovery affordance, that reader hits a wall.

`Feed:` answers the question with one round-trip: the URL in the post's `Feed:` header, when GETted with `Accept: application/swamp`, returns a tiny signed envelope claiming the CID of the author's most recent self-sighting. From there, the sighting's `References:` chain (§6) walks back through history. The chain is durable; only the claim itself is mutable, and it sits at exactly one bounded point.

## What's at the URL: a worked example

A first-time publisher has just posted their founding self-sighting at `bafybei...self001`. Their `Feed:` URL serves:

```
Swamp-Version: 0.4.0
From: Alice
DID: did:key:z6Mk...
Date: 2026-05-05T08:00-0700
Latest: bafybei...self001
Message-ID: 2026-05-05-08-00-feed-claim-001
Content-Type: application/swamp; kind=feed-claim; v=0.4.0

-----BEGIN SIGNATURE-----
(base64 signature bytes)
-----END SIGNATURE-----
```

A few weeks later, after several more self-sightings, the URL serves:

```
Swamp-Version: 0.4.0
From: Alice
DID: did:key:z6Mk...
Date: 2026-05-22T14:00-0700
Latest: bafybei...self042
Prev: bafybei...self041
Message-ID: 2026-05-22-14-00-feed-claim
Content-Type: application/swamp; kind=feed-claim; v=0.4.0

-----BEGIN SIGNATURE-----
(base64 signature bytes)
-----END SIGNATURE-----
```

The body is empty; `Latest:` and `Prev:` carry the substance. The signature covers the canonical envelope (§4.6) just like any post.

## Two-step site pattern

A polite Swamp host serves both `/swamp/latest` (the Feed: URL) and `/swamp/<CID>` (per-post permalinks), with content negotiation on each:

| URL | `Accept:` | Response |
|---|---|---|
| `/swamp/latest` | `application/swamp` | The signed feed-claim envelope above. |
| `/swamp/latest` | `text/html` (browser) | A landing page introducing the author, with the latest self-sighting summary and a link to the canonical CID. |
| `/swamp/<CID>` | `application/swamp` | The raw self-sighting bytes from IPFS (or a local mirror). |
| `/swamp/<CID>` | `text/html` (browser) | An HTML render of the self-sighting. The HTML SHOULD include `<link rel="canonical" href="ipfs://<CID>">` so Swamp-aware tooling sees the IPFS reference. |

This makes the same URL space useful to both populations: humans land on a readable page; Swamp clients get the bytes they need. Authors who can't host content negotiation can serve only `application/swamp`-shaped responses; the spec doesn't require the HTML companion.

## Steady-state polling

Once Bill (the reader) has Alice's `Feed:` URL, he polls it forever, not just at first contact. Every poll is one round-trip; cache discipline matters.

**Server-side:** support `ETag` and `If-Modified-Since` on the Feed: URL. When the latest self-sighting hasn't changed, return `304 Not Modified` with no body. Authors with static-host setups get this from the host (S3, GitHub Pages, Cloudflare Pages all support it); authors running their own server should configure it.

**Client-side:** send conditional GETs. Cache the response for some duration even on 200 responses; the spec doesn't mandate a value, but an hour for active authors and a day for quiet ones is a reasonable default. Aggressive polling is wasteful on a medium where the underlying state changes daily at most.

**The `Prev:` field's role.** Bill's client polls Alice's Feed: every hour. Some week Bill goes offline for three days. When he comes back online, Alice has published five new self-sightings. The new feed-claim has `Latest: bafybei...self047` and `Prev: bafybei...self046`. Bill's client knows it last saw `bafybei...self042`. Without `Prev:`, the client knows it missed *something* but has to fetch `self047` and walk its `References:` chain to find out how far back. With `Prev:`, the client can compute "I missed `self043`, `self044`, `self045`, `self046`" by walking from `Prev:` back; the new sighting's `References:` chain confirms reach-back.

`Prev:` is optional but strongly recommended.

## DID and Feed-URL: who attests to what

Two parties make claims:

- **The post author**, signing the post that carries the `Feed:` header. Their signature attests: "this is my post, and at the time I published it, I named *this URL* as my feed pointer." The post is signed; the URL is a hint.
- **The Feed: URL response**, signed by whoever runs the URL. Its signature attests: "I am the holder of *this DID*, and my latest self-sighting is at *this CID*." The signature is over the response, not over anything else.

A reader following a Feed: URL discovered through a third party (a `Following:` post — §11) checks both attestations. If the URL serves a feed-claim from the same DID the third party named, all three claims (third party's pointer, author's prior claim, current Feed-claim) align — the reader has a verified pointer.

If the URL serves a feed-claim from a *different* DID, the third party's pointer is wrong (stale, typo'd, or the URL was repointed) but no fraud has occurred — both signed claims are individually valid; only their relationship is broken. The reader falls back to other discovery (gossip, sightings) and ideally surfaces the disagreement to whatever tool brought them here.

If the URL serves a feed-claim with an invalid signature, reject hard. Either the URL has been hijacked or something is misconfigured; in neither case is the claim trustworthy.

## Authors with no website

A Swamp author doesn't need to host a site. The `Feed:` URL can be:

- **A static file on any HTTP host.** GitHub Pages, S3, Cloudflare R2, Vercel, Netlify — anywhere that serves a file at a stable URL. The author updates the file when they publish a new self-sighting; the file is the signed envelope shown above.
- **A small dynamic endpoint.** A handful of lines of any web stack: read the latest self-sighting CID from a local store, sign a fresh envelope, return it. Done.
- **A mirrored gateway.** A community-run service that hosts Feed: URLs for authors who don't want to operate even a static file. The author signs the envelope; the gateway just serves it.

The signature does the work; the URL is just where the bytes live.

## Tooling recommendations

For implementations of Swamp readers, agents, or aggregators:

- **Cache the Feed: URL** along with the DID it pointed at when last verified. If the URL repoints to a different DID later, surface the change rather than silently following.
- **Honor `Prev:`** when present. It's free polling-efficiency.
- **Don't over-poll.** A Feed: URL polled every minute is rarely useful and often rude. Default to once an hour; let users tighten if they want.
- **Verify before display.** Don't render a `Latest:` CID's contents without first verifying the Feed-claim's signature against the stated DID. A stale or invalid claim should be visibly flagged, not silently displayed.
- **Surface mismatches.** When a `Following:` entry's DID and the Feed-URL's actual served DID disagree, tell the user. The disagreement is information, not an error to swallow.

## Forward-compatibility notes

v0.4.0 specifies URL-only `Feed:` locators. A later release may add DNS TXT (`Feed: _swamp.alice.example.com`, resolved via DNS) for cases where website uptime is a problem. The header name stays `Feed:`; the value's syntax extends.

The `prev` chain in feed-claims could be extended with multi-step hop hints in a future release, but the current `References:` chain on each self-sighting already provides arbitrary walk-back. `Prev:` exists specifically to avoid one fetch in the common case; deeper hints earn their keep only if missed-poll-recovery becomes a hot path.
