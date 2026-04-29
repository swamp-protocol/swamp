# Related work: IPFS

*IPFS is the substrate Swamp posts live on. SPEC §2 Substrate names IPFS directly and lists the two properties Swamp relies on.*

---

## What IPFS is

**IPFS** (the InterPlanetary File System) is a public, content-addressed distributed file system. An object added to IPFS yields a **CID** (content identifier) — a hash of the bytes that serves as a location-independent address. Fetching an object means: given a CID, ask the network for those bytes; any node that has them can serve them, and the fetcher verifies the bytes match the CID before trusting them.

Core properties relevant to Swamp:

- **Content addressing.** The address is derived from the content. Tamper-detection is built in: if the bytes change, the CID changes.
- **World-readable and world-writable given the address.** Any actor can `ipfs add` an object; any actor can `ipfs get` one if they know the CID.
- **No default persistence.** An object lives on the network only as long as at least one node pins it. Unpinned objects are eventually garbage-collected by the nodes holding them.
- **Canonical directory structure.** CIDs can address directories, not just single files, with child CIDs for each entry.

## How Swamp relates

**Borrowed: the substrate.** Swamp posts are added to IPFS, addressed by CID, and fetched from any node holding the bytes. The `ipfs:<cid>` scheme in `Swamp-Version:` (SPEC §4.1.1 Value grammar) is first-class.

**Borrowed: "caring is the currency."** IPFS's pinning model — content persists if and only if someone pins it — maps directly onto Swamp's social logic. A post you care about, you pin. A post nobody cares about, ages out. This is a feature; institutions disappear quietly when the people who cared about them stop caring, and that is the correct default for a pre-institutional medium.

**Borrowed: content addressing for durable citation.** The `ipfs:<cid>` locator form is Swamp's answer to link rot. A widely-cited post, or spec version, remains resolvable as long as any node on the network pins it.

**Departed: IPNS for identity or authorship.** IPNS (InterPlanetary Name System) provides mutable pointers on top of IPFS — a stable name that can be updated to point at new CIDs. Swamp deliberately does not use IPNS for identity or post identity. Post identity is the `(DID, Message-ID)` tuple carried inside the signed post, not a mutable pointer to it. SnapStack's extensive hands-on experience with IPNS (see `snapstack.md`) informed this choice: IPNS is operationally painful, requires active republishing, and depends on DNSLink or ENS backing to be reliable — all of which defeat the decentralization story.

(The `ipns:` locator defined in SPEC §4.1.1 Value grammar is a separate, narrower use: it names a *spec* version — "whatever the maintainers are calling v0.3 today" — where the operational costs of republishing are borne by a small group of stewards rather than by every author, and a reader can always fall back to the `ipfs:` locator for a byte-exact pin. The caution above applies to identity and per-post addressing, not to that one spec-pointer case.)

**Gateways are convenience, not substrate.** Readers routinely reach IPFS content through public gateways (`ipfs.io`, `dweb.link`, Cloudflare's gateway). A gateway URL is a clickable pointer for humans clicking links from social media, but the canonical home of a Swamp post is its CID on IPFS, and gateway URLs are pointers at that.

**Headers point outside IPFS.** Swamp post bodies live in IPFS, but several headers reference resources on the open web by design: `Contact:` (`bsky:`, `fediverse:`, `email:`, `web:`, others), `Bookmark-Of:` (an external HTTP URL — that's what a bookmark is), profile `Homepage:` and `Avatar:`, event `URL:`. That commitment applies to where artifacts live, not to what they may point at.

## References

- [ipfs.tech](https://ipfs.tech) — the IPFS project
- [docs.ipfs.tech](https://docs.ipfs.tech) — technical documentation
- `related-work/snapstack.md` — hands-on notes on IPNS in practice (relevant to Swamp's decision to avoid it)

---

*Related-work note accompanying the Swamp v0.3.0 specification.*
