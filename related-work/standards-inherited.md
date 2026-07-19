# Related work: small inherited standards

*Brief acknowledgments of the small, stable standards Swamp leans on without re-specifying. These do not warrant their own full notes but deserve explicit citation.*

---

## Semantic Versioning

Swamp's `Swamp-Version:` header follows [Semantic Versioning 2.0.0](https://semver.org). MAJOR for incompatible envelope changes, MINOR for backward-compatible additions, PATCH for clarifications that do not change bytes-on-the-wire. The `RELEASES.md` document in this repository extends this with a policy separating protocol-version bumps from document-revision commits.

## BCP 47 — language tags

The `Content-Language:` header (SPEC §4.4 Content-Language) uses [BCP 47](https://www.rfc-editor.org/info/bcp47) language tags. BCP 47 is the IETF's compound standard combining ISO 639 (language identifiers like `en`, `fr`, `zh`), ISO 3166 (region subtags like `US`, `MX`, `BR`), and ISO 15924 (script subtags like `Hans`, `Hant`). Examples: `en`, `en-US`, `es-MX`, `zh-Hans`, `pt-BR`. BCP 47 is the same tag format used by HTTP's `Accept-Language`, HTML's `lang` attribute, and email's `Content-Language:` — using it in Swamp means existing tooling already works.

**Underlying components:**

- [ISO 639](https://www.iso.org/iso-639-language-code.html) — language codes
- [ISO 3166](https://www.iso.org/iso-3166-country-codes.html) — country codes
- [ISO 15924](https://unicode.org/iso15924/) — script codes

## ISO 8601 — timestamps

All Swamp timestamps (`Date:` in the post envelope, `Fetched-At:` in bookmarks, `Start:` / `End:` in events) use [ISO 8601](https://www.iso.org/iso-8601-date-and-time-format.html) — the internationally recognized format for dates and times, including timezone offsets. Example: `2026-04-22T14:40-0700`. ISO 8601 is the same format RFC 3339 profiles for internet use; both are equivalent for Swamp's purposes.

## UTF-8

Swamp is UTF-8 from end to end. Canonicalization rules in SPEC §4.6 Signature and §7.3 Canonical sighting body format require UTF-8 byte encoding and LF line endings. No other encoding is permitted. UTF-8 is the overwhelmingly dominant text encoding on the modern internet and the only one a Swamp implementation needs to handle.

## Base64

Signature blocks in the post body use standard [Base64](https://www.rfc-editor.org/info/rfc4648) encoding. No Base64URL variant, no custom alphabet — plain RFC 4648 Base64.

## References consolidated

- [semver.org](https://semver.org)
- [BCP 47](https://www.rfc-editor.org/info/bcp47)
- [ISO 8601](https://www.iso.org/iso-8601-date-and-time-format.html) / [RFC 3339](https://www.rfc-editor.org/info/rfc3339)
- [RFC 4648](https://www.rfc-editor.org/info/rfc4648) — Base64

---

*Related-work note accompanying the Swamp v0.7.0 specification.*
