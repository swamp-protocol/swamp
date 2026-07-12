# Governance

*How core Swamp — this specification — is stewarded. Deliberately short. Extensions are not governed here, or anywhere: each extension is governed by whoever publishes it (SPEC §10), and there is no overall governance of the extension space, by design.*

---

## Stewards

**Peter Kaminski** — founding steward, 2026-04.

Stewards are responsible for hosting the spec, guiding Swamp's evolution, merging pull requests to the specification, resolving disagreements where rough consensus does not form on its own, and selecting release codenames.

## Seeking additional stewards

**We are actively seeking additional stewards to join Peter in guiding Swamp's evolution.** Stewards should have substantial experience with the anthropology of human communication, decentralized protocols, agent-mediated systems, or all three, and a demonstrated track record of collaborative stewardship of open specifications.

A public call for additional stewards will be issued as a Swamp post in due course. This governance document will be updated as new stewards join.

## How stewards decide

Stewards decide by **rough consensus**, in the working sense borrowed from the IETF tradition: not unanimity, not majority vote, but a determination that the objections have been heard and addressed and that the remaining position is the one the group can live with. Where rough consensus doesn't form, stewards may defer a decision, scope it smaller, or decline to land a change.

Stewards are expected to document their reasoning in the relevant issue or pull request so contributors and future stewards can understand why a decision landed where it did.

## When rough consensus fractures

If stewards and contributors genuinely cannot reconcile a disagreement, **forks are legitimate**. Swamp's own specification treats forks as legible (see SPEC §4.1.2 Forks): a fork identifies itself by pointing at its own canonical location, which makes the divergence visible to readers rather than masking it. Disagreements that can't be resolved within a single spec can be resolved by two specs with a shared lineage.

This is not a threat — it's the designed safety valve. Forking is not failure; it is what the protocol makes possible when stewardship breaks down on a specific question.

## Disagreements between implementations

Stewards do not referee implementations. There is no certification, no compliance mark, and no authority that can order software off the pond — the must-carry invariant (SPEC §10.1) means even posts from software others believe is out of spec still travel intact. What stewards maintain is the instruments the parties argue *with*: the spec text and, as it matures, a public conformance corpus. The routing for "we think you're out of spec" conversations — including the cases where the fixture or the spec itself turns out to be the bug, and the cases where the right answer is an extension or a legible fork — lives in `CONTRIBUTING.md`, "When implementations disagree."

## Changes to governance

Changes to this document follow the same process as changes to any other spec document (see `CONTRIBUTING.md`): issue, discussion, pull request, steward approval. Governance changes specifically should be preceded by public discussion — governance that shifts silently loses the legibility that makes it worth having.

## Scope of stewardship

Stewards steward **the specification** — the bytes on the wire, the envelope, the semantics, the accompanying application and related-work notes, the governance of this document. Stewards do NOT control:

- What people post in Swamp. The medium is public and signed; authors are responsible for their own posts.
- What readers trust. Trust is per-reader (see SPEC §11 Trust (non-protocol)).
- How forks evolve. Once a fork declares its own `Swamp-Version:` locator, it is its own spec.
- Implementations of Swamp tooling. Reference implementations may live in separate repositories, each with their own maintainers.
- Extensions. An extension is governed by whoever publishes it (SPEC §10). Competing extensions are welcome; adoption arbitrates.

## Where Swamp is discussed

Discussions about Swamp will happen in many mediums — issues and pull requests, email, other networks — and that's as it should be. But **the canonical place to talk about Swamp is on Swamp.** When a conversation matters, bring it home: post it, sight it, let it become part of the record. GitHub issues and pull requests remain the mechanics for landing spec changes (see `CONTRIBUTING.md`); the discourse of record lives on the medium itself.

## Why this is short

Specs with five-thousand-word governance documents tend to die of process. Swamp's governance is intentionally light: name stewards, describe the decision rule, point at the release scheme, document that forks are legitimate. The same minimalism applies to the specification itself — the spec stays thin on purpose, and new normative material has to earn its place against the cost of constraining a young medium. When something in this document proves insufficient in practice, we'll extend it — not before.
