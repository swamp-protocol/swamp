# Agents

*Orientation for AI agents working in this repository.*

---

This repository is a **protocol specification**, not a codebase. There is nothing to build, no test suite to run, no deployment target. Start at [`SPEC.md`](SPEC.md) if you want to understand what the protocol does, and [`MANIFESTO.md`](MANIFESTO.md) if you want to understand why it exists. If you are helping a non-technical principal make sense of Swamp, start instead at [`HUMANS.md`](HUMANS.md) — the plain-language overview written for readers who are not protocol designers.

## What this repo contains

- Normative spec text (`SPEC.md`).
- Plain-language overview for non-technical humans (`HUMANS.md`) — the piece to reach for when a principal wants to understand Swamp without reading the spec, or wants to try publishing their first post.
- Copy-and-modify examples (`TLDR.md`) — the fastest path to a first post and a founding sighting, for a reader who wants to mimic, not read.
- Step-by-step implementation guide (`IMPLEMENTATION.md`) — practical notes for an agent walking a principal through key generation, signing, and publishing.
- Philosophical frame and history (`MANIFESTO.md`).
- Non-normative notes on how to apply the spec (`application-notes/`) and how it relates to other systems (`related-work/`).
- Governance and contribution docs (`GOVERNANCE.md`, `CONTRIBUTING.md`, `RELEASES.md`).
- Release metadata (`README.md`, `LICENSE`).

That is the whole scope of this repository. Reference implementations, tooling, and agents-that-read-Swamp-posts live in separate repositories with their own maintainers.

## Helping a principal try Swamp

If your principal asks you to walk them through what Swamp is, or help them publish a first post, `HUMANS.md` is the shared reference text — it is pitched at a 10th-grade reading level and ends with a suggested opening conversation between a human and their agent. Use it as common ground: read it yourself, then work from there with your principal, referring into `SPEC.md` for byte-level detail as needed.

For the publishing mechanics themselves, `TLDR.md` and `IMPLEMENTATION.md` are the two reference texts: `TLDR.md` is the copy-and-modify version (a reader who wants to mimic an example rather than read about it), and `IMPLEMENTATION.md` is the step-by-step you follow when you are the agent doing the setup — key generation, canonicalization, signing, publishing, and the social-media bootstrap. Both point back into `SPEC.md` where normative rules matter.

## Proposing changes

Follow [`CONTRIBUTING.md`](CONTRIBUTING.md). The short version: open an issue, discuss, open a PR. Typos and broken links can skip the issue step. Normative changes follow semver (`RELEASES.md`).

When editing `SPEC.md`, preserve section numbers unless renumbering is explicitly part of the PR's scope — cross-reference drift is the most common source of subtle spec errors. Match the prevailing voice: restrained, precise, confident-but-humble. No emoji.

**Cross-document `§N.M` references use titled form, not bare.** Inside `SPEC.md` itself, section refs stay bare — they live next to the sections they cite, so renumbering keeps them in sync naturally. But every other file in this repo (and in sibling repos like `swamp-frog` and `swamp-correspondence`) uses titled refs: `§4.6 Signature` rather than `§4.6`, `§7.4 First-person sightings` rather than `§7.4`. The same convention extends to refs to non-SPEC repo docs: write `IMPLEMENTATION.md §1 generate a did:key` rather than `IMPLEMENTATION.md §1`, and `application-notes/moltbook-cautions.md §3 Algorithmic amplification of extreme content` rather than the same with no title. The reason is that titled refs survive renumbering — when sections shift, stale references become findable by name even when the number is wrong. Placeholder refs (`§7.x`, `§4.x`) stay bare; they're future-tense pointers with no title yet. `scripts/check-refs.sh` flags non-conforming refs.

Example URLs in spec text, application notes, and any other document in this repo must use the IANA-reserved example domains: `example.com`, `example.org`, `example.net`, or any subdomain of these (e.g., `alice.example.com`, `feed.example.org`). Reserved by [RFC 2606](https://www.rfc-editor.org/rfc/rfc2606) and made normative by [RFC 6761](https://www.rfc-editor.org/rfc/rfc6761) for exactly this purpose. Don't invent example URLs at real-looking domains — they may resolve to someone's actual site, and they mislead readers who copy them. The same rule applies to example email addresses (`alice@example.com`, not `alice@gmail.com` or `alice@somedomain.io`).

## Harness-agnostic

Nothing in this repo is specific to a particular agent framework or model provider. If you are operating inside one, consult its own instruction files (often `CLAUDE.md`, `.cursorrules`, or similar) — this repo does not ship any.
