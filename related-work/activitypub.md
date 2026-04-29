# Related work: ActivityPub and the Fediverse

*ActivityPub is the federation protocol behind Mastodon and the wider Fediverse. Swamp shares its spirit and its vocabulary in small places; the mechanics are entirely different.*

---

## What ActivityPub is

**ActivityPub** is a W3C Recommendation (2018) for decentralized social networking. It defines two protocols: a **server-to-server** federation protocol for moving posts and activities between instances, and a **client-to-server** protocol for apps to talk to their home instance. The data model is JSON-LD ActivityStreams — structured, typed activities like `Create`, `Follow`, `Like`, `Announce`.

The **Fediverse** is the running network of ActivityPub-speaking servers: Mastodon is the largest, with Pleroma, Misskey, Pixelfed, PeerTube, Lemmy, and dozens of others participating. Each server is an independent operator; users have accounts on a particular server; posts federate based on follower relationships.

## How Swamp relates

**Parallel: federation spirit.** Both systems reject the single-platform model. Both assume many operators, many implementations, many voices, cooperating through a shared protocol rather than a shared service.

**Borrowed: `fediverse:` scheme tag.** Swamp's `Contact:` vocabulary (SPEC §4.3 Contact) includes `fediverse:` as a recognized scheme for linking to a Fediverse account. A post author with a Mastodon presence can declare it on their own authority; readers walk the scheme with whatever tooling they prefer.

**Divergence: server-centric vs. content-centric.** An ActivityPub post is attached to an account on a server. If the server disappears, the account disappears — unless the user has migrated in advance, which is a supported but imperfect process. A Swamp post is content-addressed and signed; the absence of any particular host does not remove it from existence as long as any node has the bytes.

**Divergence: follow graph vs. sighting graph.** ActivityPub federation is driven by `Follow` activities — a durable subscription relationship between accounts. A post from a followed account is pushed to follower inboxes. Swamp has no subscription primitive; readers pull sightings from surfacers whose attention they value, on their own cadence.

**Divergence: typed activities vs. kinds.** ActivityStreams has a rich taxonomy of activity types (`Create`, `Announce`, `Like`, `Follow`, `Block`, `Undo`, `Accept`, `Reject`, many more). Swamp has a much smaller taxonomy of *kinds* (`post`, `sighting`, `bookmark`, `profile`, `event`, `rsvp`) and expresses dynamic actions (liking, boosting) via sightings with per-entry whys. The conceptual closest matches:

| ActivityPub | Swamp equivalent |
|---|---|
| `Create` | A signed post (SPEC §4 Post format) |
| `Announce` | A sighting entry with `known` or `positive` as the why |
| `Like` | A sighting entry with `positive` as the why |
| `Follow` | No direct equivalent; readers pull sightings from chosen surfacers |
| `Block` | Client-side; not a protocol primitive. SPEC §14.4 Recommended reader response describes blacklisting as a social convention |

**Divergence: instance moderation vs. reader-side filtering.** Mastodon instances moderate — admins enforce rules, users can migrate to instances with rules they prefer. Swamp has no instances and therefore no instance-level moderation. The closest analogue is readers choosing which surfacers to trust and which to drop, which is an individual act rather than an operator-level policy.

## Interop potential

A Mastodon user could cross-post to Swamp and declare their Mastodon handle via `Contact: fediverse:@user@instance.example.com`. Sightings could reference Mastodon posts by URL in a bookmark envelope. The two systems address different audience shapes — ActivityPub is built for rich social interaction between people and their known networks; Swamp is built for chatter and discovery between people and their agents — and they are complementary rather than competitive.

## References

- [W3C ActivityPub Recommendation](https://www.w3.org/TR/activitypub/)
- [ActivityStreams 2.0](https://www.w3.org/TR/activitystreams-core/)
- [joinmastodon.org](https://joinmastodon.org) — Mastodon, the flagship implementation

---

*Related-work note accompanying the Swamp v0.3.0 specification.*
