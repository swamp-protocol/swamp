# Application note: Markdown bodies and embedded media

*Superseded 2026-07 by SPEC §4.9, which lands markdown bodies and image embedding in core (v0.7.0) in a lighter shape than proposed here — bare-CID embeds with no `kind=media` envelope. This note is preserved as design history; its `kind=media` design remains available to a future extension if standalone, individually attributed media artifacts earn their keep in practice. Version strings below are frozen at the v0.6 era this note was written in.*

*Forward-looking application note. The current Swamp spec defines text bodies (SPEC §4 Post format) and a small set of post kinds (SPEC §7 Sightings, §8 Profiles, §9 Following) but does not define a body-format declaration or any image / video / audio support. This note describes a proposed shape for a later release — markdown as a recognized body format, images and other media as first-class signed `kind=media` posts, embedded into prose via markdown links to a `swamp:` URI — and identifies the small set of additions the current spec already carries to keep that later release additive rather than breaking. Examples below use `Swamp-Version: 0.X.0` as a placeholder for whichever release lands these features.*

---

## Why this note exists

Two adjacent questions arrive together as soon as a Swamp implementation starts handling anything richer than plain prose:

1. **How does an author declare that their post body is markdown** (or any non-plain format), so renderers can interpret `**bold**`, `[links](...)`, and `![images](...)` rather than displaying raw characters?
2. **How does a post include an image, audio clip, or short video**, given that Swamp posts are email-header-shaped text envelopes and the spec is explicit (SPEC §4.2 Not email) about not being multipart MIME?

The two are coupled. Once markdown is a recognized body format, the natural way to embed an image is `![alt](url)` — but the *url* needs to point at something Swamp-shaped, not just an arbitrary HTTP resource, if the image is to participate in the medium's reactability and integrity guarantees.

This note resolves both, lays out the proposed shape, and identifies the minimum hooks the current spec already carries so a later release is additive rather than breaking.

---

## Current baseline

The current spec deliberately keeps bodies simple:

- Bodies are UTF-8 text (SPEC §4.6 Signature).
- SPEC §4.2 Not email forbids `MIME-Version:` and any `multipart/*` Content-Type. Posts are not email and are not MIME containers.
- Bookmark bodies (bookmarks extension) explicitly note "no markdown semantics imposed." A body containing `**bold**` is just text containing those characters; rendering is a reader-side choice with no spec backing.
- `Content-Type:` carries `application/swamp; kind={post|sighting|profile|following}; v=0.6.0`. There is no kind for media.

This is fine for the current scope. It is not enough for the moment an author wants to share a photograph of a frog with a caption.

---

## Proposed shape

### Body format declaration

A new optional header **`Body-Format:`** declares the syntactic format of the post body. Defined values:

| Value | Meaning |
|---|---|
| `text/plain` | Plain text. Renderers display verbatim. |
| `text/markdown` | CommonMark-flavored markdown. Renderers may interpret structural syntax. |

Default when `Body-Format:` is absent is `text/plain`. Authors writing markdown declare `Body-Format: text/markdown` explicitly; renderers gate markdown interpretation on the explicit declaration.

The vocabulary is extensible. Future values may add other text-shaped formats (`text/asciidoc`, `text/x-org`). **`text/html` is not defined and not recommended** — it expands the active-content surface (script, embedded objects, link tracking) far beyond what plain text or markdown imply, and Swamp's threat model assumes readers may render bodies without a sandbox.

`Body-Format:` is a body concern, parallel to `Content-Language:` (SPEC §4.4 Content-Language). It is intentionally not a parameter on `Content-Type:`, which carries the envelope kind. Mixing envelope-kind and body-format on one header would couple two orthogonal facts; keeping them separate reads cleanly and follows the spec's existing pattern of one fact per header.

### Media as a first-class post kind

A **`kind=media`** post is a signed envelope describing one media object. The bytes of the object live in IPFS (SPEC §2 Substrate), addressed by CID; the post envelope names the CID and metadata.

Distinguished by `Content-Type: application/swamp; kind=media; v=0.X.0` (the `v=` matches whichever spec release lands `kind=media`).

**Headers added on `kind=media` posts:**

- **`Media-Type:`** (required, exactly one) — the IANA media type of the binary object. Initial values: `image/jpeg`, `image/png`, `image/gif`, `image/webp`, `video/mp4`, `video/webm`, `audio/mpeg`, `audio/ogg`, `audio/mp4`. **`image/svg+xml` is excluded** for the same active-content reason as `text/html`. Other types are permitted but readers may choose not to render them.
- **`Media-CID:`** (required, exactly one) — content address of the binary object. The CID is what readers fetch from IPFS to obtain the actual bytes.
- **`Media-Bytes:`** (optional) — declared byte length of the binary, as advisory metadata for readers planning fetches.
- **`Alt:`** (optional but encouraged for image and video) — accessibility description, in the language of the post body. For images and video, this is the description a screen reader or a text-only reader would use in place of the visual.

The post body is optional caption / commentary, in whatever `Body-Format:` the author declares.

The signature covers the headers, including `Media-CID:`. Integrity of the binary is therefore guaranteed via the CID even though the bytes themselves are not in the post — fetching the CID and comparing against the signed declaration verifies the link.

### Embedding via markdown and the `swamp:` URI scheme

A prose post with `Body-Format: text/markdown` may embed media using standard markdown image syntax:

```
![A frog on a lily pad](swamp:did:key:z6Mk.../bafybeih7pkoy3zfcafrlsvpe7v3jt2qrgcyhrh7dxljmqdqrfmrdpzwfa)
```

The link target is a **`swamp:` URI** — a scheme defined for naming Swamp post-refs in any context that takes a URI. Grammar:

```
swamp:<DID>/<CID>
```

`<DID>` and `<CID>` are the same tokens used elsewhere as post-refs (SPEC §5 Identifying posts, §7.3 Canonical sighting body format). The `swamp:` prefix lets URI parsers, markdown renderers, and tools recognize the form without ambiguity, and lets the same shape appear in markdown links, `Bookmark-Of:` values pointing at Swamp posts, future inline citations, and any other URI-bearing context.

A renderer encountering `![alt](swamp:...)` resolves the URI, fetches the `kind=media` post, follows `Media-CID:` to retrieve the binary, and displays inline. A non-rendering or text-only reader sees the markdown source verbatim — `![alt](swamp:...)` is still legible — and can follow the link manually.

Plain markdown link syntax (`[text](swamp:...)`) works the same way for non-media references: a textual link to another post in any kind.

### Linking via References

Embedding by markdown link is convenient at the body layer, but the *fact* that this post points at another post should also be visible at the envelope layer, where agents not parsing the body can see it. The proposed shape broadens the existing **`References:`** header (SPEC §6 Threading, supersession, retraction) to carry any post-ref this post points at, not only thread ancestors.

A prose post embedding an image lists the media post in `References:`:

```
References: did:key:z6Mk.../bafybeih7pkoy3zfcafrlsvpe7v3jt2qrgcyhrh7dxljmqdqrfmrdpzwfa
```

(The `<CID>` in the post-ref is the CID of the *media post* — the signed envelope. The bytes-CID of the image itself appears separately as `Media-CID:` inside the media post; see the example below.)

Readers reconstructing threads walk `References:` and follow only refs whose target is `kind=post` (or other thread-eligible kinds, future work). Renderers locating embedded media walk `References:` and follow `kind=media` refs. Sighting agents walk `References:` and may sight or skip individually.

This avoids inventing a new `Includes:` or `Embeds:` header. The trade is that `References:` now carries mixed semantics; the disambiguator is the *kind* of the referenced post, fetched on demand. In practice this is cheap — agents already need to fetch referenced posts to do anything useful with them.

---

## Hooks already in the current spec

Three small additions already in the current spec keep a later release cleanly additive rather than breaking:

### 1. The `swamp:` URI scheme

`swamp:<DID>/<CID>` is defined as a URI scheme in the current spec, even though the current spec has no markdown rendering and no media. The scheme generalizes post-refs and lets current implementations recognize the form wherever it appears — most usefully in `Bookmark-Of:` values pointing at Swamp posts, which the bookmarks extension treats as external HTTP URLs only.

### 2. `Body-Format:` header

`Body-Format:` is an optional header in the current spec with a stub vocabulary: `text/plain` defined, omission means `text/plain`. Current renderers can ignore it; later readers extend the vocabulary to include `text/markdown` and gate rendering on the explicit value.

This is purely a forward-compatibility hook. Current implementations that don't care about body format pay no cost; later implementations gain a stable header to key off rather than retrofitting one.

### 3. `References:` semantic softening

SPEC §6 Threading, supersession, retraction describes `References:` as "post-refs this post points at, primarily used for thread ancestors" rather than strictly "chain of ancestors for thread reconstruction." Readers reconstructing threads walk only kind-compatible refs; readers with other purposes (rendering, sighting) walk the same header for their own purposes.

This is a documentation choice, not a wire-format change. Current posts using `References:` for thread chains continue to work identically. Later posts using `References:` for media links also work, because the spec language permits it.

---

## Examples

### A markdown prose post embedding an image

```
Swamp-Version: 0.X.0
From: Alice
DID: did:key:z6Mk...
Message-ID: 2026-05-01-08-15-frog-bog-d9e1
Date: 2026-05-01T08:15-0700
Subject: A frog at the swamp
Content-Type: application/swamp; kind=post; v=0.X.0
Body-Format: text/markdown
References: did:key:z6Mk.../bafybeih7pkoy3zfcafrlsvpe7v3jt2qrgcyhrh7dxljmqdqrfmrdpzwfa

Saw this guy on the path this morning.

![A small green frog mostly underwater on a lily pad](swamp:did:key:z6Mk.../bafybeih7pkoy3zfcafrlsvpe7v3jt2qrgcyhrh7dxljmqdqrfmrdpzwfa)

Stood absolutely still for a full minute. I think he thought I couldn't see him.

-----BEGIN SIGNATURE-----
(signature bytes)
-----END SIGNATURE-----
```

### The `kind=media` post the prose post points at

```
Swamp-Version: 0.X.0
From: Alice
DID: did:key:z6Mk...
Message-ID: 2026-05-01-08-12-frog-photo-a3f2
Date: 2026-05-01T08:12-0700
Subject: Frog on lily pad
Content-Type: application/swamp; kind=media; v=0.X.0
Media-Type: image/jpeg
Media-CID: bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi
Media-Bytes: 142857
Alt: A small green frog mostly underwater on a lily pad, eyes just above the surface.

Olympus TG-7, 2026-05-01, Lake Hodges. Cropped, no other edits.

-----BEGIN SIGNATURE-----
(signature bytes)
-----END SIGNATURE-----
```

A reader rendering the prose post:

1. Parses the body as markdown (per `Body-Format: text/markdown`).
2. Encounters the `![...](swamp:...)` image link.
3. Resolves the `swamp:` URI to a post-ref.
4. Fetches the `kind=media` post by CID via IPFS.
5. Verifies the media post's signature.
6. Reads `Media-CID:` and fetches the binary.
7. Renders the image inline with the markdown's `alt` text as the accessibility label (which should match `Alt:` on the media post — diverging is allowed but suspicious).

A reader that doesn't do markdown — or doesn't fetch media — sees the raw markdown source, which is still legible prose with a labeled link.

---

## Why these choices over alternatives

### Why `kind=media` rather than inline base64 or multipart

Inline base64 in the body would put binary content inside the email-header-shaped text file, defeating the legibility ethos and bloating posts that mostly aren't binary. Multipart MIME is explicitly excluded by SPEC §4.2 Not email. Naming the binary by CID and signing the CID in a sibling envelope keeps every post a small readable text file, and lets the binary travel and be cached by IPFS like any other Swamp object.

### Why a separate `kind=media` post rather than media headers on `kind=post`

Two reasons. First, **reactability:** a media post is a first-class artifact in the sighting graph. Others can sight your image with `positive` independently of sighting your prose around it — the same argument that makes bookmarks distinct from prose posts (see the bookmarks extension's rationale). Second, **reuse:** the same media post can be referenced from many prose posts. If media headers lived on prose posts, the same image would be re-uploaded and re-signed for every reuse.

### Why broadening `References:` rather than new `Includes:` / `Embeds:`

Header proliferation has cost. Email's `References:` is already imprecise in real-world use, and the spec's borrowing of it (SPEC §6 Threading, supersession, retraction) is loose enough to extend without rewriting. The disambiguator — *kind of the referenced post* — is something readers already need to evaluate after a fetch. A new header would be tidier on paper and not noticeably better in practice.

The cost is real: thread-reconstruction agents that previously could trust every `References:` value to be a thread ancestor must now check the kind. This is acceptable because (a) the broadening lands in the same release as `kind=media`, so the new shape is a coherent step rather than a retrofit, and (b) thread reconstruction is already best-effort given how email `References:` chains work in the wild.

### Why `Body-Format:` rather than a `Content-Type:` parameter

`Content-Type:` already carries the envelope kind (`application/swamp; kind=...; v=...`). Adding a `body=markdown` parameter would mix two orthogonal facts on one header: what kind of envelope this is (post, sighting, media, ...) and what syntax the body uses (plain, markdown, ...). Separate headers keep separate concerns separate, and the spec's existing pattern (`Content-Language:` on its own header rather than as a `Content-Type:` parameter) is already this shape.

---

## Out of scope for this note

- **Image transforms** (thumbnails, alternate resolutions, format conversions). Out of scope. A media post is one binary; a thumbnail is a separate media post if the author cares to sign one.
- **Streaming media** (HLS, DASH, fragmented MP4 with manifests). Out of scope. Swamp's threat and storage model is whole-object content addressing; manifest-driven streaming wants a different storage model.
- **DRM, paywalls, access-controlled media.** Out of scope by SPEC §15 Out of scope.
- **Caption tracks for video** (WebVTT, SRT). Possibly a future application note. The natural shape is a sibling `kind=media` post with `Media-Type: text/vtt` referenced from the video post via `References:`.
- **Multi-image gallery posts.** Same shape as multi-link bookmarks (the bookmarks extension's one-link rule): a sighting groups N media posts with a prose preamble, rather than a single envelope carrying multiple media payloads.

---

## Summary of forward-compatibility hooks

| Hook | Purpose | Cost in the current spec |
|---|---|---|
| `swamp:` URI scheme | Forward-compatible naming for post-refs in any URI context | Documentation only; no parser change |
| `Body-Format:` header (stub) | Reserve the header name; `text/plain` only | Optional header; renderers ignore |
| `References:` softened language | Permit non-ancestor refs without breaking current use | Documentation only; existing behavior unchanged |

Each is small, none is a wire-format change, and together they make the later release's media support purely additive.
