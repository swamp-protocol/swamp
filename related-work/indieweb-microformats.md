# Related work: IndieWeb and microformats2

*The IndieWeb's vocabulary of post kinds and its embrace of the open web's existing primitives shape several of Swamp's structural choices.*

---

## What these are

**The IndieWeb** is a community and set of practices oriented toward the principle that you should own your own content on your own domain. Its core tools are **microformats2** (h-entry, h-card, h-event, and others) — simple class-based annotations that add semantic structure to HTML — and **Webmention**, a federated notification protocol. The IndieWeb values human-readable publishing, portable identity via a personal domain, and composition from small parts.

**h-entry** is the microformat for a blog post or note. **h-card** is for contact information. **h-event** is for events. Alongside these, *post kinds* like `bookmark-of`, `like-of`, `reply-to`, `repost-of`, and `rsvp` describe the relationship a post has to something else on the web.

## How Swamp relates

**Borrowed: the post-kinds vocabulary.** Swamp's `kind=profile` (core) and the bookmarks and events extensions' `kind=bookmark`, `kind=event`, and `kind=rsvp` are direct reflections of IndieWeb practice. The **`Bookmark-Of:`** header is named in obvious homage to h-entry's `bookmark-of`. The RSVP response set (`yes | no | maybe | interested`) is the IndieWeb set verbatim.

**Borrowed: the "post, don't application" posture.** IndieWeb encourages thinking of your output as posts on your site, which might also notify other sites, which might also render elsewhere — not as content inside an application. Swamp takes this further: a post is a signed, freestanding artifact that travels on its own and can be rendered by anything that can parse an envelope and a body.

**Borrowed: the "title as author record" pattern.** IndieWeb bookmarks commonly embed the bookmarked page's title as observed by the author — a small act of archival that guards against link rot and drive-by retitling. Swamp's optional `Title:` on bookmark posts (bookmarks extension) serves the same purpose.

**Borrowed: implicit acceptance of link rot.** Swamp and IndieWeb both take the position that the open web rots, and neither pretends otherwise. A bookmark is a vouch at a moment in time. If the link dies, the vouch survives.

**Divergence: identity.** IndieWeb identity is your domain — relmeauth, IndieAuth, `rel="me"` links. Swamp identity is a DID (SPEC §3 Identity). A Swamp participant can still link to their IndieWeb site via `Contact: web:`; the identity layers can sit side by side without conflict.

**Divergence: transport.** IndieWeb publishing lives on HTTPS at a personal URL. Swamp publishing lives at a content-addressed CID. An author can do both; the artifacts are not the same bytes.

**Divergence: Webmention.** IndieWeb posts notify each other via Webmention, a POST to the mentioned site's endpoint. Swamp has no direct equivalent — the closest analogue is a sighting referencing a post (one author noticing another), which is publicly attributable rather than a point-to-point notification.

## Interop potential

A Swamp bookmark of an IndieWeb post is natural; the two models agree about what a bookmark is and differ only about where it is published. An IndieWeb site could render its owner's recent Swamp posts alongside native h-entry posts — they share enough semantic structure to cross-render without special tooling.

An IndieWeb-style "display my posts on my own domain" pattern composes naturally with Swamp: an IndieWeb site can render its owner's signed Swamp posts alongside native h-entry posts, with the canonical bytes living in IPFS underneath. The site is a view onto the publisher's posts, not the authoritative location.

## References

- [indieweb.org](https://indieweb.org) — the IndieWeb community wiki
- [microformats.org](https://microformats.org) — microformats2 specifications
- [h-entry](http://microformats.org/wiki/h-entry), [h-card](http://microformats.org/wiki/h-card), [h-event](http://microformats.org/wiki/h-event)
- [Webmention](https://www.w3.org/TR/webmention/) — W3C Recommendation

---

*Related-work note accompanying the Swamp v0.6.0 specification.*
