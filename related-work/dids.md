# Related work: Decentralized Identifiers (DIDs)

*Swamp identities are DIDs, per SPEC §3 Identity. This note covers which DID methods matter for Swamp and why.*

---

## What DIDs are

**Decentralized Identifiers (DIDs)** are a W3C Recommendation (2022) for a URI scheme whose identifiers are controlled by the subject rather than by a registrar. A DID is of the form `did:<method>:<method-specific-id>` — for example `did:key:z6MkrJVnaZkeFzdQOGnummMHrmgzGdsB...`. Each method defines its own resolution rules, key-management conventions, and governance model.

A DID Document is the resolved form — a JSON-LD structure containing verification methods (public keys), service endpoints, and authorizations. Given a DID, the resolver returns the current DID Document; given a DID Document, a reader knows which keys can sign on behalf of that identity.

## Methods relevant to Swamp

**`did:key`.** A DID whose identifier is the multibase-encoded public key itself. Resolution is deterministic — no network lookup required — because the key *is* the DID. This is the simplest possible method and the one Swamp uses as its guaranteed baseline. Roughly fifty lines of code to implement resolution; no infrastructure dependencies.

**`did:web`.** A DID backed by an HTTPS endpoint. `did:web:example.com` resolves by fetching `https://example.com/.well-known/did.json`. Richer than `did:key` (supports key rotation without changing the DID) but depends on DNS and HTTPS — a centralization most Swamp participants will consider acceptable for authorship but not for posts that need maximal durability.

**`did:plc`.** The Personal Ledger Consortium method used by the AT Protocol. Requires a lookup against the PLC directory service. Not in scope for Swamp's v0.7.0 baseline but compatible with Swamp's `DID:` header — a reader that can resolve `did:plc:` entries can participate.

## How Swamp relates

**Borrowed: the DID as identity primitive.** Swamp posts declare identity in the `DID:` header and prove it via signature verification against the DID's current public key. This is exactly the use case DIDs were designed for.

**Borrowed: method-agnosticism.** The spec does not commit to a single method. Any DID method is permitted in `DID:`; readers that cannot resolve a given method treat those posts the same way they would treat an unreachable transport — verifiable by anyone who can resolve, opaque to those who cannot.

**Baseline: `did:key`.** Swamp v0.7.0 names `did:key` as the guaranteed-supported baseline. A new participant can generate a DID locally, with no registrar and no network dependencies, and begin posting.

**Tension: richer methods.** Some DID methods (and the closely-related Blockchain Commons XID work — see `related-work/hubert.md`) offer much richer identity semantics: key rotation without identity change, delegation, permissions, stable identifiers across key lifecycle. Swamp's current approach — an ad hoc key-rotation announcement post signed by the old key — is the minimum-viable pattern. Future versions will likely adopt richer machinery; SPEC §17 Open questions flags this as an open question.

## References

- [W3C DID Core Recommendation](https://www.w3.org/TR/did-core/)
- [did:key method spec](https://w3c-ccg.github.io/did-method-key/)
- [did:web method spec](https://w3c-ccg.github.io/did-method-web/)
- `related-work/hubert.md` — covers Blockchain Commons XID as a richer alternative

---

*Related-work note accompanying the Swamp v0.7.0 specification.*
