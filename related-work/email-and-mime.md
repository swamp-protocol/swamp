# Related work: email and MIME (RFC 822, RFC 5322, RFC 2045/2046)

*Swamp's post envelope is email-header-shaped. This note maps which specifications it borrows from and which it deliberately departs from.*

---

## What these are

**RFC 822** (David Crocker, 1982) is the original internet-mail message format: a block of `Name: value` headers, a blank line, a text body. It was the durable contribution of ARPANET mail and remains the cited historical reference. Many practitioners who came up through the 1980s and 1990s still speak of "822-style" messages, and the term is well understood in that form.

**RFC 5322** (Pete Resnick, 2008) is the current normative internet-mail format. It supersedes RFC 2822, which superseded RFC 822. For a modern implementer the relevant citation is RFC 5322; for historical accuracy and community legibility, RFC 822 is the grandparent.

**RFC 2045 / 2046** are the MIME specifications (Freed, Borenstein, 1996). They add structure on top of 5322 for non-ASCII bodies, multipart messages, attachments, and a registry of content types. A `MIME-Version: 1.0` header at the top of a message announces: "I am a MIME-structured message; parse me accordingly."

Together, 822 / 5322 and MIME are the formal foundation of every email system on the internet.

## How Swamp relates

**Borrowed: the header format.** Swamp posts use the 5322 header grammar — `Name: value` pairs, case-insensitive names, folding via continuation lines with leading whitespace, a blank line separating headers from body. This is deliberate: it is the most-implemented and most-legible structured-text format in computing history. Millions of humans can read a 5322-style header block on sight; every language has a parser.

**Borrowed: specific header semantics.** `From:`, `Subject:`, `Date:`, `Message-ID:`, `In-Reply-To:`, `References:`, `Content-Type:`, `Content-Language:` — all standard 5322 / MIME headers, used in Swamp with substantially the same semantics. `Supersedes:` borrows its name from Usenet / NNTP.

**Borrowed: the "Content-Language matters" move.** MIME's decision to make content language a first-class header is right, and Swamp inherits it verbatim (SPEC §4.4 Content-Language).

**Borrowed: the address-is-not-identity distinction.** Email has always had this — the `From:` line is a social claim, not a cryptographic proof — and the subsequent history of SPF, DKIM, DMARC is an attempt to bolt proof onto a format that was never designed for it. Swamp builds the proof in from day one (signing over the canonical byte-range), while keeping the `From:` header's friendliness to human readers.

**Departed: MIME itself.** Swamp posts deliberately omit `MIME-Version: 1.0` and never use `multipart/*`. The Content-Type is always `application/swamp; ...`, which signals to MIME-compliant mail readers that the payload is opaque and to Swamp readers which parser to use. This is the most important technical choice distinguishing Swamp from "just sign some email" — the medium is not email, and the signal to mail tooling to stop parsing is explicit (SPEC §4.2 Not email).

**Departed: transport.** RFC 5322 messages travel over SMTP; Swamp posts live on IPFS (SPEC §2 Substrate). The envelope shape is shared; the transport is not.

**Departed: recipients.** 5322 has `To:`, `Cc:`, `Bcc:`. Swamp has none of these — every post is public by construction. A Swamp equivalent of addressing lives in layered-post convention (SPEC §12 Disclosure tiers and layered posts), not in headers.

**Departed: signing model.** S/MIME and PGP-signed email both add signatures as attachments or armor around a 5322 message. Swamp makes signing mandatory and part of the canonical post structure, not an extension.

## References

- [RFC 822](https://www.rfc-editor.org/info/rfc822) — "Standard for the Format of ARPA Internet Text Messages" (1982)
- [RFC 5322](https://www.rfc-editor.org/info/rfc5322) — "Internet Message Format" (2008)
- [RFC 2045](https://www.rfc-editor.org/info/rfc2045), [RFC 2046](https://www.rfc-editor.org/info/rfc2046) — MIME (1996)

---

*Related-work note accompanying the Swamp v0.6.0 specification.*
