# TL;DR — how to start posting to Swamp

*The fast version. Copy, modify, publish. For the why, see [`MANIFESTO.md`](MANIFESTO.md). For the rules, see [`SPEC.md`](SPEC.md). For the hand-holding version, see [`HUMANS.md`](HUMANS.md). For agent-assisted setup, see [`IMPLEMENTATION.md`](IMPLEMENTATION.md).*

---

## What you need

1. **A DID** — a keypair. `did:key` is the simplest method; your DID *is* the public key. No registrar, no server.
2. **An IPFS node, or a pinning service** — where your signed posts will live. Run a node yourself (Kubo on a laptop, Mac Mini, or VPS), or use a pinning service (Pinata, Lighthouse, Filebase, others — the landscape evolves). Most personal use fits inside free tiers.
3. **A way to sign bytes with your private key** — a small script or your agent.

Your agent can set all three up. See [`IMPLEMENTATION.md`](IMPLEMENTATION.md).

---

## A post — copy and modify

Save as a text file. Replace placeholders. Sign it with your key.

```
Swamp-Version: 0.7.0
From: Your Name
DID: did:key:z6Mk...your-public-key-here...
Message-ID: 2026-04-22-hello-swamp-a3f2
Date: 2026-04-22T15:00-0700
Subject: Hello from Swamp
Content-Type: application/swamp; kind=post; v=0.7.0

Hello. I'm here. If you can read this, IPFS works.

-----BEGIN SIGNATURE-----
(base64 signature bytes)
-----END SIGNATURE-----
```

Conventions:

- **Message-ID**: date prefix, topical slug, short random tail. Readable and sortable.
- **Date**: ISO 8601 with timezone offset.
- **Signature**: covers bytes from the first character of `From:` through the blank line before the signature block. UTF-8, LF line endings, no trailing whitespace. (SPEC §4.6 Signature.)
- **Markdown and images**: add `Body-Format: text/markdown` to write CommonMark. Embed an image by publishing its bytes beside the post (a file named by its CID) and writing `![alt text](<the-CID>)` in the body. (SPEC §4.9.)

---

## Your founding sighting

A sighting is a signed list of `(why, post-ref)` entries — for each post-ref, the reason it's in the sighting. Your **founding sighting** lists your own posts, each with `mine` as the why — making them **self-sightings** (line-level claims of authorship). It's how friends find you in Swamp.

It can be thin. The first one often is — one Hello-world post, signed and listed. As you accumulate more posts, you'll publish fuller sightings (monthly or every two months works well). Each new sighting is its own signed artifact; you do not edit the old one. "Founding" just means *first* — it's where the stream begins.

```
Swamp-Version: 0.7.0
From: Your Name
DID: did:key:z6Mk...your-public-key-here...
Message-ID: 2026-04-22-founding-sighting-b91c
Date: 2026-04-22T15:30-0700
Subject: My posts so far
Content-Type: application/swamp; kind=sighting; v=0.7.0

A few things I've written.

mine  did:key:z6Mk.../bafybeia1b2c3...x1
mine  did:key:z6Mk.../bafybeid4e5f6...x2

-----BEGIN SIGNATURE-----
(base64 signature bytes)
-----END SIGNATURE-----
```

Each body line: `<why><space><DID>/<CID>`. For your own posts the why is `mine`; that line is a self-sighting. A sighting may also mix in `known`, `positive`, `neutral`, or `negative` entries — see SPEC §7 Sightings. The CIDs are opaque on the wire; reader agents resolve them to the posts' Message-ID slugs (e.g. `2026-04-22-hello-swamp-a3f2`) at display time.

---

## Where to publish

`ipfs add post.txt` produces a CID — a permanent, byte-exact address. The CID is how friends' agents find and verify your post. Pin the post somewhere that isn't only your laptop: a pinning service (Pinata, Lighthouse, Filebase, others — the landscape evolves), a friend's node, or your own node on a Mac Mini or VPS. The more places it's pinned, the more reliably it stays reachable.

For your **founding sighting** specifically, you want it pinned on IPFS at a CID friends can be pointed at — that's the file other agents will subscribe to.

---

## Bootstrapping via social media

Social-media posts are short; a sighting with a dozen entries is not. So the pattern is:

1. Publish your sighting on IPFS and note the CID.
2. On Mastodon, Bluesky, X, LinkedIn — wherever your friends already read you — post a clickable link to your sighting through an IPFS gateway URL: `https://ipfs.io/ipfs/<CID>`, `https://dweb.link/ipfs/<CID>`, or any other public gateway you prefer. Sample text:

   > Join me on Swamp, an uncentralized unplatform with microblogging, blogging, link rolls, and more. My latest sighting: https://ipfs.io/ipfs/bafybeiabc...xyz
   >
   > That file lists things I've published to Swamp, signed with my DID. Add it to your reader if you have one.

3. When you publish new posts, write a new sighting that includes them and pin it. Each new sighting is its own signed artifact with its own CID; the previous sighting stays valid (no `Supersedes:` — see SPEC §7.4 First-person sightings). Share the new CID's gateway URL occasionally on social media.

That's the bridge from "where your friends already are" to "where you're posting now." No platform needed between the two — just a link.

---

## That's the whole move

A signed post, a founding sighting (a sighting whose entries are all `mine`), pinned on IPFS, with a one-line announcement on existing social media linking through a gateway. Everything else — threading, profiles, the richer sighting vocabulary, extensions — is convention and tooling you can grow into later. Start with this.
