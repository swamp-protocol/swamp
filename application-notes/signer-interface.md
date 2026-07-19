# Application note: `window.swamp` — the browser signer interface

*Non-normative application note accompanying the Swamp v0.7.0 specification. This note specifies an interface, not core protocol: any browser signer may provide it, any browser client may consume it, and neither needs to know which one it's talking to. It lives here rather than in core because it is platform-specific practice — CLI tools never touch it — and rather than in any one implementation's repository because it is two-sided: signers (Lilypad, rivals) implement one side, clients (Airboat, Skimmer, rivals) the other. Originated as Lilypad's interface proposal, 2026-07-18.*

---

## Motivation

Swamp's custody rule for web clients is settled: **keys never enter the page**. A page that holds a signing key is one XSS away from identity theft. But a page that can't sign can't publish. The resolution, proven by Nostr's NIP-07, is a signer extension: the page prepares bytes, an extension the user trusts holds the key, and a user gesture bridges the two. This note specifies that bridge for Swamp so clients and signers pair freely.

## The interface

A signer provides a frozen object at `window.swamp` in every `http(s)` page, from `document_start`:

```ts
window.swamp: {
  getDid(): Promise<string>;      // active identity's did:key
  sign(text: string): Promise<string>;  // full signed envelope text
  signer?: { name: string, version: string };  // optional identification
}
```

### `getDid()`

Resolves to the user's active identity as a `did:key` string (e.g. `did:key:z6Mk...`). This is public information, but it is identifying — signers MUST gate it behind the same per-origin consent as `sign` (see below).

### `sign(text)`

`text` is a complete **unsigned** envelope: header block, blank line, body — everything except the signature block (SPEC §4). The signer:

1. Rejects (`bad-request`) if the text already contains a signature block, has no `DID:` header, or its `DID:` header does not match the active identity. The DID check is a courtesy to client developers: a signature under a mismatched DID header would never verify, so it fails fast and loud instead of producing garbage.
2. Obtains an explicit per-request user approval that displays the requesting origin, the signing identity, and the exact text to be signed.
3. Canonicalizes per SPEC §4.6 (LF endings, no trailing whitespace, one blank line between headers and body, terminating `"\n\n"`), signs the canonical UTF-8 bytes with Ed25519, and resolves to the **full signed envelope**: canonical signed range + signature block — a complete artifact any Swamp verifier accepts.

**Why the full envelope, not the bare signature?** Byte-exactness. Canonicalization is the interoperability cliff: if the client glued a returned signature onto its *own* serialization of the envelope, any divergence (a trailing space, a CRLF, a doubled blank line) would produce a file whose signature doesn't verify. Returning the whole envelope makes the signer's canonicalization authoritative and leaves the client exactly one correct move:

> **Clients MUST publish the returned text verbatim.** Don't reflow it, don't trim it, don't re-serialize it through a parser. Bytes in, signed bytes out, signed bytes published.

### Errors

Rejections are `Error` objects with a `code` property:

| code | meaning |
|---|---|
| `denied` | user declined this signature (or dismissed the prompt) |
| `origin-denied` | user has not allowed (or has blocked) this site |
| `no-key` | signer has no active identity configured |
| `bad-request` | malformed call: empty text, existing signature block, missing or mismatched `DID:` header |
| `unavailable` | signer extension unreachable (disabled, updating) |
| `internal` | signer-side failure |

Clients should treat `denied` as a normal user choice (not an error state to retry), and `origin-denied`/`no-key` as onboarding states worth explaining to the user.

## Signer requirements

- **Preview-what-you-sign.** Every `sign` call gets a per-request user approval showing the exact envelope text, the requesting origin, and the signing DID. No blanket "always allow signing for this site" — Swamp envelopes are short and human-legible, and reading them is the security model.
- **Deny-by-default origins.** A site's first call prompts the user for permission to talk to the signer at all; until allowed, calls reject with `origin-denied` (after the user declines) without leaking whether a key exists. Origin consent MAY be remembered; signature approval MUST NOT be.
- **Keys stay home.** No interface method exposes private key material, and no signer behavior may be extended to do so. Export is a signer-UI affordance, never a page-facing one. (Custody and minting rules for the keys themselves are core: SPEC §3.3.)
- **First provider wins.** If `window.swamp` already exists, a signer must stand down rather than clobber it. Users with two signers installed choose by disabling one.

## Client guidance

- Feature-detect: `if (window.swamp) { ... }`. The property is defined at `document_start`, so it's present by the time client code runs; its absence means no signer is installed (fall back to a local signing flow — for example, an outbox drained by a CLI signer; see [`stores.md`](stores.md)).
- Call `getDid()` once at session/config time and build envelope `DID:` headers from it. Don't cache it across sessions without re-checking — the user may have switched identities.
- Expect latency and denial: `sign()` resolves on human timescales (a confirm window) or not at all. Keep the draft; a denial is not data loss.
- Verify after signing if you like — the returned envelope is a complete artifact any Swamp verifier accepts.

## Compatibility notes

- The bare-signature alternative (`sign() -> base64 sig`) was considered and rejected; see "why the full envelope" above.
- This interface deliberately has no `verify()` — verification needs no secrets, so clients do it themselves (a wasm verifier, a JS port, or server-side CLI verification).
- Future methods (multiple-identity selection, `kind`-aware display hints, batch signing for sighting flows) should arrive as new optional methods, never as changed semantics for `getDid`/`sign`.
