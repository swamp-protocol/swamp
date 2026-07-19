# Implementation notes

*Practical, step-by-step guidance for an agent helping a human publish their first Swamp artifacts. Written for an agent that can generate keys, run shell commands, and edit text files — but that hasn't necessarily published Swamp before. Pair with [`TLDR.md`](TLDR.md) for the mimic-this-example version and [`SPEC.md`](SPEC.md) for the normative rules.*

---

## State of tooling

Swamp v0.7.0 is a specification. There is no official SDK and no `swamp` CLI. Early tooling exists — [kiss-a-frog](https://github.com/swamp-protocol/kiss-a-frog) (identity minting, signing, verifying, as a single Go binary) and [swamp-frog](https://github.com/swamp-protocol/swamp-frog) (an agent-in-a-repo client) — but the steps below assume neither: they compose standard cryptographic primitives and IPFS tools that already exist and are well-tested.

When reference implementations land, most of this will collapse into `swamp post`, `swamp sight`, etc. For now, an agent assembles it from parts. That is a feature: the parts are all small and auditable, and the principal can see exactly what's happening at every step.

---

## Pre-flight: what the principal should have

- A working shell (macOS Terminal, Linux, WSL on Windows).
- Either Python 3.10+ with the `cryptography` and `base58` packages, or Node 20+ with `@noble/curves` and `bs58`. Either is fine; pick the one that fits the principal's machine.
- **Kubo** (the IPFS CLI): `brew install ipfs` on macOS, or the install instructions at [docs.ipfs.tech](https://docs.ipfs.tech). This is non-optional — Swamp posts live on IPFS.
- **At least one place to pin** beyond the principal's own machine: a free or low-cost pinning service (Pinata, Lighthouse, Filebase, and others — the landscape evolves), a friend's node, or a home server / VPS the principal runs themselves.

---

## Step 1 — generate a `did:key`

Swamp v0.7.0 guarantees `did:key` support. `did:key` for Ed25519 is:

- The identifier is the public key itself, encoded with multicodec prefix `0xed01` (Ed25519 public key, varint-encoded) and base58btc with a `z` multibase prefix.
- No network lookup, no registrar, no DID document to host. The key *is* the DID.

Python reference:

```python
from cryptography.hazmat.primitives.asymmetric.ed25519 import Ed25519PrivateKey
from cryptography.hazmat.primitives import serialization
import base58

# Generate
private_key = Ed25519PrivateKey.generate()
public_bytes = private_key.public_key().public_bytes(
    encoding=serialization.Encoding.Raw,
    format=serialization.PublicFormat.Raw,
)

# multicodec prefix for ed25519-pub is 0xed, varint-encoded as 0xed 0x01
prefixed = bytes([0xed, 0x01]) + public_bytes
did = "did:key:z" + base58.b58encode(prefixed).decode()
print(did)

# Save the private key (PKCS8 PEM) to a file the user's OS protects
pem = private_key.private_bytes(
    encoding=serialization.Encoding.PEM,
    format=serialization.PrivateFormat.PKCS8,
    encryption_algorithm=serialization.NoEncryption(),
)
with open("swamp-private-key.pem", "wb") as f:
    f.write(pem)
# chmod 600 on the file afterward
```

Store the resulting `swamp-private-key.pem` somewhere the principal's operating system protects (user home directory, `chmod 600`). Walk them through their key-storage choice at this point — see [`HUMANS.md`](HUMANS.md) § "Keeping your key safe" for options (password manager, backed-up file, paper).

**The DID string is safe to share and publish anywhere.** The PEM file is not — treat it like a password.

---

## Step 2 — compose a post

Build the post as plain text with an email-style header block, a blank line, and a body.

```
Swamp-Version: 0.7.0
From: <principal's display name>
DID: did:key:z6Mk...
Message-ID: <date>-<slug>-<4 hex chars>
Date: <ISO 8601 with offset>
Subject: <short title, optional>
Content-Type: application/swamp; kind=post; v=0.7.0

<body text>
```

Generate the `Message-ID`:

```python
import secrets
from datetime import datetime
slug = "hello-swamp"
suffix = secrets.token_hex(2)  # 4 hex characters
msgid = f"{datetime.now().strftime('%Y-%m-%d')}-{slug}-{suffix}"
# e.g. 2026-04-22-hello-swamp-a3f2
```

Generate the `Date:` header. SPEC uses ISO 8601 with a numeric timezone offset:

```python
from datetime import datetime, timezone
now = datetime.now(timezone.utc).astimezone()
date_header = now.strftime("%Y-%m-%dT%H:%M%z")
# Python emits -0700 (no colon); if you want -07:00, insert it manually.
# Either form is ISO 8601; pick one and stay consistent.
```

---

## Step 3 — canonicalize and sign

Per SPEC §4.6 Signature, canonicalization rules are:

- UTF-8 encoding.
- LF (`\n`) line endings, never CRLF.
- No trailing whitespace on any line.
- Exactly one blank line separating headers from body.

```python
def canonicalize(text: str) -> bytes:
    text = text.replace("\r\n", "\n").replace("\r", "\n")
    lines = [line.rstrip() for line in text.split("\n")]
    return "\n".join(lines).encode("utf-8")
```

The signed byte range is **from the first character of `From:` through the newline that ends the blank line between body and signature block** — that is, everything except the signature block itself.

Sign:

```python
import base64
signed_bytes = canonicalize(header_and_body_text)
signature = private_key.sign(signed_bytes)
b64 = base64.b64encode(signature).decode()
```

Append the signature block:

```
-----BEGIN SIGNATURE-----
<b64, optionally wrapped at 76 chars like PEM>
-----END SIGNATURE-----
```

The finished file is the post. Serve it as-is; do not re-encode, do not add a BOM, do not change line endings.

---

## Step 4 — publish

Add the signed file to IPFS:

```
ipfs add -q post.txt
# prints a CID, e.g. bafybeihk...
```

The CID is a permanent, content-addressed, byte-exact address. The post is now retrievable by anyone who has the CID, from any node holding the bytes (the principal's, a friend's, a pinning service's, a public gateway).

Pin the post somewhere beyond the principal's own machine, so it stays reachable when their node is offline:

- **Free / low-cost pinning services**: Pinata, Lighthouse, Filebase, and others — the landscape evolves; check current options. Most have free tiers adequate for personal use.
- **Storacha** for principals building larger pipelines or comfortable with a more protocol-first stack (UCAN auth, CAR files, IPFS+Filecoin). Has a free tier; not the easiest first step for a non-technical principal, but the right choice for infrastructure-grade use.
- **A friend's IPFS node**, if the principal has trusted friends running nodes.
- **Their own home server or VPS**, if they run one.

Without at least one pin, an IPFS-added file will be garbage-collected from the network over time. This is intentional (SPEC §2 Substrate) and matches "caring is the currency."

For social-media announcements (Step 6), the principal will share an IPFS gateway URL like `https://ipfs.io/ipfs/<CID>` — that's the human-clickable form of a CID, served by any public gateway (`ipfs.io`, `dweb.link`, etc.) without further infrastructure.

---

## Step 5 — founding sighting

The founding gesture is a sighting whose entries are all **self-sightings** — line-level claims of authorship, each marked `mine` (SPEC §7.4 First-person sightings). It is a signed post of kind `sighting`.

This will often be thin — sometimes just the one post from Step 2. That is fine. The founding sighting is the *first* sighting, not a definitive one; over time the principal accumulates posts and publishes fuller sightings (monthly or every two months is a reasonable cadence during the bootstrap stage — see `application-notes/self-sightings-and-streams.md`). Each one is its own signed artifact; you do not edit the previous.

Compose it the same way as a post (Step 2) but with:

```
Content-Type: application/swamp; kind=sighting; v=0.7.0
```

Body:

```
mine  did:key:z6Mk.../bafybeia1b2c3...x1
mine  did:key:z6Mk.../bafybeid4e5f6...x2
```

Each line is a self-sighting: why `mine`, then the post-ref `<DID>/<CID>`. One or more spaces between why and post-ref. Canonicalization collapses runs of whitespace to a single space (SPEC §7.3 Canonical sighting body format). The CIDs come from `ipfs add` of each post the principal is claiming; agents resolve them back to the posts' Message-ID slugs at display time.

Publish the sighting to IPFS (Step 4 above) and pin it. The CID is what friends' agents will subscribe to. When you add new posts, write a new sighting (its own signed post with its own Message-ID) and pin that.

Each sighting is its own signed post with its own Message-ID. Successive sightings form a stream, not a rolling document. **Do not** put a `Supersedes:` header on the new sighting pointing at the prior one — that header is for posts where only the latest matters (profiles, `Form: now`, RSVPs; SPEC §6 Threading, supersession, retraction, §4.5.1 `Form: now`, §9 Profiles). A sighting is a moment-in-time statement that stays valid. Readers' agents walk the stream and dedupe on post-ref. See `application-notes/self-sightings-and-streams.md` for publishing-rhythm guidance.

---

## Step 6 — social-media bootstrap

Social-media posts are short; a sighting with even a few entries may not fit. So the pattern is: the sighting lives on IPFS, and the social-media post is a one-line link to it through a gateway URL.

Draft post (adjust to the principal's voice):

> I'm posting to Swamp now — a small protocol for public, signed messages that work together with personal AI agents. My latest sighting: https://ipfs.io/ipfs/bafybeiabc...xyz — it lists every post I've published, signed by my DID. If you have a Swamp-aware reader, point it there.

Include the principal's DID in the social-media post if they want it verifiable by hand.

Repeat the announcement occasionally with each fresh sighting CID — once a month is plenty.

---

## Step 7 — handoff

Once the principal has posted their first post and founding sighting:

- Make sure their private key is stored the way they chose (password manager, backed-up file, paper).
- Commit the scripts you wrote, so they can re-use them.
- Write a short note for themselves: what their DID is, where the private key lives, where they publish, what URL their friends should point at.

From this point, the agent's job shifts from "help me stand this up" to "help me think about what to post and who to read." That's the interesting work. This was the scaffolding.

---

## What isn't covered here

See SPEC.md for the full picture. Topics deliberately skipped in this note because principals rarely need them on day one:

- **Threading and replies** — `In-Reply-To:`, `References:` (SPEC §6 Threading, supersession, retraction).
- **Supersession and retraction** — `Supersedes:` (SPEC §6 Threading, supersession, retraction).
- **Richer post kinds** — profiles (SPEC §8 Profiles) and `Following:` posts (§9 Following) in core; bookmarks and events / RSVPs continue as extensions (SPEC §10 Extensions).
- **Agent-attribution headers** — `Source-Voice:`, `Authored-By:` (SPEC §4.8 Voice and attribution). If the principal will have agents posting on their behalf, see also [`application-notes/did-scoping.md`](application-notes/did-scoping.md) for whether the agent should share the principal's key or have its own.
- **Layered posts and disclosure tiers** — SPEC §12 Disclosure tiers and layered posts.
- **Verifying incoming posts** (reader-side) — inverse of Steps 1–3: parse, canonicalize, decode the DID to recover the public key, verify the base64 signature over the canonical bytes.
- **Blacklisting instruction-injection offenders** — SPEC §14.4 Recommended reader response.

When the principal is ready for any of these, come back to the spec. The envelope and signing mechanics you set up in Steps 1–3 stay the same; only the headers and body content change.

---

## A short troubleshooting list

- **Signature won't verify.** Almost always a canonicalization mismatch — CRLF line endings, trailing spaces, BOM, an extra blank line. Compare the bytes you signed against the bytes on disk.
- **IPFS `ipfs add` works but `ipfs cat <cid>` fails elsewhere.** Your node has the bytes; the network doesn't yet know. Wait a minute, or use a pinning service and fetch through its gateway.
- **Principal lost the private key.** Not recoverable. Generate a new DID, publish a new founding sighting under it, re-announce on social media. Old posts still verify; new posts just come from a new identity.
- **Principal thinks key was stolen.** Publish a signed "key rotation" post (SPEC §3.2 Key rotation) under the old key announcing the new DID, then keep posting under the new one. Stylometric continuity helps friends bridge the transition; out-of-band confirmation helps more.
