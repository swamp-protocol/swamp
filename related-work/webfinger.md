# Related work: WebFinger (RFC 7033)

*WebFinger is finger's HTTPS-era revival, and the discovery layer ActivityPub leans on for `acct:user@host` resolution. Swamp does not require it, but the routing pattern it formalizes is the same shape Swamp's `Contact:` header gestures at.*

---

## What WebFinger is

**WebFinger** is standardized in **RFC 7033** (Jones, Salgueiro, Smarr, 2013). A client looks up information about an account by issuing an HTTPS GET to `https://host/.well-known/webfinger?resource=acct:user@host`, and the server responds with a **JRD** (JSON Resource Descriptor) — a JSON document listing the subject, optional aliases, and a set of `links` pointing at the user's resources (avatar, profile page, ActivityPub inbox, OpenID provider, and so on).

Core design choices:

- **HTTPS-based.** No bespoke transport; everything rides on the existing web.
- **`.well-known/webfinger` location.** A fixed, discoverable path on the host — no service discovery layer above it.
- **`acct:` URI scheme.** A canonical way to write `user@host` as a URI, defined in RFC 7565.
- **JRD response format.** Structured JSON listing typed links, not free-form text.
- **Discovery, not publishing.** The response points *at* a person's resources; it does not contain the resources.

In practice, WebFinger is best known as the resolution layer for **Mastodon and the wider Fediverse**: when a Mastodon user types `@alice@example.com`, the client issues a WebFinger query against `example.com`, parses the JRD, and follows the ActivityPub link to find Alice's actor document.

## How Swamp relates

**Parallel: pointing at resources, not containing them.** A WebFinger JRD is a router: here are the URLs for this person's stuff. Swamp's `Contact:` header (SPEC §4.3 Contact) plays the same routing role — the post enumerates where else its author can be reached, without inlining those resources.

**Parallel: `acct:user@host` as a portable handle.** WebFinger normalizes the user-at-host shape that finger introduced and that Mastodon, Matrix, and others use. Swamp's `Contact: fediverse:@user@instance.example.com` borrows the same handle shape (and depends on WebFinger underneath when a reader resolves it).

**Divergence: host-trust vs. signature-trust.** A WebFinger response is trusted because it came from the host named in the query — TLS proves the host, the host vouches for the user. Swamp does not depend on host-trust at any layer; signatures are over the post bytes themselves (SPEC §4.6 Signature), and any host can serve any post.

**Divergence: discovery vs. content-addressed substrate.** WebFinger answers "where do I find this account's resources on the web?" Swamp posts live in IPFS, addressed by CID — the question of "where" is largely answered by the substrate itself, and WebFinger-style lookups are not part of how Swamp posts are found. WebFinger remains a sensible way to advertise a `Contact:`-shaped routing card outside Swamp; the two layers do not need to be tightly bound.

## References

- [RFC 7033](https://www.rfc-editor.org/info/rfc7033) — "WebFinger" (Jones, Salgueiro, Smarr, 2013)
- [RFC 7565](https://www.rfc-editor.org/info/rfc7565) — "The 'acct' URI Scheme" (Saint-Andre, 2015)
- [RFC 5785](https://www.rfc-editor.org/info/rfc5785) — "Defining Well-Known Uniform Resource Identifiers (URIs)"

---

*Related-work note accompanying the Swamp v0.6.0 specification.*
