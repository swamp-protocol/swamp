# Related work: finger (RFC 1288)

*Finger is the early-1990s antecedent for "ask a server about a person." Swamp does not borrow its mechanics, but the discovery shape it introduced runs through everything that followed.*

---

## What finger is

**Finger** is a user-information protocol standardized in **RFC 1288** (Zimmerman, 1991), descended from earlier RFC 742 (1977) and RFC 1196 (1990) revisions. A client opens a TCP connection to port 79 on a host, sends a query like `user@host` followed by CRLF, and receives a free-text response describing whoever the server decides to disclose: full name, login status, last-seen time, the contents of a `.plan` and `.project` file from the user's home directory.

Core design choices:

- **Single-user discovery.** A query names one person on one host; the server formats a response intended for human reading.
- **Plaintext over TCP/79.** No transport security, no authentication, no signing.
- **Free-form response.** The server returns whatever text it likes; clients do not parse structurally.
- **`.plan` and `.project` files.** A user could publish a small status note simply by editing a file in their home directory — a precursor to "post on your own machine and let others fetch it."

Finger was widely deployed on Unix systems through the 1990s, then largely retired as the open internet grew unsafe for the model. It survives in a handful of long-running personal servers and as a frequently cited piece of internet folk history.

## How Swamp relates

**Antecedent: ask a server about a person.** The shape of finger — a reader naming a person and a host, fetching back something authored — is the earliest version of what `Contact:` headers describe today. Swamp does not implement finger, but it inherits the cultural memory that user-by-user discovery is a useful pattern that does not require a platform to mediate.

**Antecedent: the `.plan` file as personal publishing.** The `.plan` file was a one-author, one-stream artifact under the author's direct control, served as-is to anyone who asked. Swamp posts are in the same lineage — a participant publishes their own bytes, signed, to a content-addressed substrate — several substrates later.

**Divergence: no signing, no integrity.** Finger's response is whatever the server says, with no cryptographic link back to the named user. Swamp posts are signed at the byte level; authenticity does not depend on the host (SPEC §3 Identity, §6 Threading, supersession, retraction).

**Divergence: no durability.** A finger response is generated on demand and discarded after delivery; there is no archive, no content addressing, no way to reference what the server said yesterday. Swamp posts are durable byte artifacts on a content-addressed substrate (SPEC §2 Substrate).

**Divergence: discovery layer, not publishing layer.** Finger answers "who is this user, right now" — a snapshot. Swamp posts are the publishing artifact itself; sightings (SPEC §13 Finding new surfacers) are the discovery layer on top.

## References

- [RFC 1288](https://www.rfc-editor.org/info/rfc1288) — "The Finger User Information Protocol" (Zimmerman, 1991)
- [RFC 742](https://www.rfc-editor.org/info/rfc742) — earlier NAME/FINGER specification (Harrenstien, 1977)

---

*Related-work note accompanying the Swamp v0.3.0 specification.*
