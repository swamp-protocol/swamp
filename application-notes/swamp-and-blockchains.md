# Application note: Swamp and blockchains

*Non-normative. Swamp uses public-key signing, content-addressed
storage, permissionless writes, and decentralized infrastructure. Each
of these is also a blockchain primitive, and a casual reader can
reasonably wonder whether Swamp is a blockchain or wants to become
one. It isn't, and it doesn't. This note names what's shared, what's
deliberately excluded, and where the differences show up in the spec.*

---

## Why this note exists

The pattern-match is easy to make. A reader hears *signed*,
*content-addressed*, *no central authority*, *IPFS as substrate*, and
the nearest cultural reference for the assemblage is "blockchain."
The inference is wrong, and the framing it imports — tokens, consensus
ledgers, on-chain governance, financialized incentives — would mislead
both readers and contributors about what Swamp is for.

Swamp's cryptography is the cryptography in PGP-signed email and Git
commit signatures, not the cryptography in Bitcoin or Ethereum. The
protocol's "decentralization" is the decentralization of the email
system or the World Wide Web, not the decentralization of a global
ledger. Naming this clearly matters because the conflation has
consequences for design intent.

## A note on Blockchain Commons

The Swamp README mentions **Blockchain Commons** in the context of
**XID**, the identity primitive Swamp hopes to adopt as a first-class
option in a later release (see [`../related-work/hubert.md`](../related-work/hubert.md)).
Blockchain Commons does cryptographic-infrastructure work — identity,
key rotation, secure multi-party coordination — that is *adjacent to*
the blockchain world without being itself a blockchain. XID is a
self-sovereign identifier with rotatable keys and extensible
assertions. It is not a coin, not a ledger, not a consensus mechanism.
Adopting XID would not make Swamp a blockchain.

## Shared primitives

A handful of cryptographic primitives appear in both worlds. None of
them require the rest of the blockchain pattern to come along.

- **Public-key signing.** Used in Swamp to bind authorship to a key
  the holder controls (SPEC §3 Identity, §4.6 Signature). Used in blockchains to authorize
  state transitions. The mechanism is identical; the purpose is not.
- **Content addressing.** Used in Swamp via IPFS (SPEC §2 Substrate) so a post's
  bytes can be fetched from any willing host and verified against the
  hash. Used in blockchains for Merkle trees over transactions and
  state. IPFS itself is content-addressed but is not a blockchain
  (see [`../related-work/ipfs.md`](../related-work/ipfs.md)).
- **Permissionless writes.** Anyone with a key can publish in Swamp;
  anyone with gas can publish to a blockchain. The mechanism by which
  a write becomes globally visible is entirely different (see below).
- **Decentralized hosting.** Posts can be mirrored across many hosts
  with no canonical server. The same is true of IPFS pins,
  BitTorrent swarms, federated email, and Usenet. It's older than
  blockchain, and Swamp inherits it from the pre-blockchain lineage.

## What Swamp deliberately doesn't do

This is the longer list, and the one that matters.

- **No global consensus.** A blockchain exists to produce a single
  agreed-upon view of state across mutually distrustful parties.
  Swamp produces no such view. Two readers may have seen entirely
  different sets of posts, weight them differently, and still both
  be correct about what Swamp contains — because Swamp doesn't
  contain a single canonical thing.
- **No global ordering.** Posts carry `Date:` headers (signed by the
  author, trusted as far as the author is trusted) and threading
  references (SPEC §6 Threading, supersession, retraction), but there is no protocol-level ordering between
  posts by different authors. Causality where it matters is
  reconstructed by the reader from the reference graph, not
  established by the medium.
- **No append-only chain.** Each post is a standalone signed
  artifact. Posts are not linked into a hash-chained sequence.
  Supersession (SPEC §6 Threading, supersession, retraction) is a *social* claim made by the author ("this
  post replaces that one") that readers may honor or ignore; it is
  not enforced by chain structure.
- **No native token or financial layer.** Swamp has no currency, no
  gas, no staking, no fee market. Posting and reading cost what
  hosting and bandwidth cost — same as posting to a blog. There is
  no protocol-level economic incentive for any participant.
- **No proof-of-anything.** No proof-of-work, proof-of-stake,
  proof-of-authority, proof-of-history. The protocol asks no
  participant to demonstrate any property to gain write access.
  Reputation is established socially in the reading (SPEC §11 Trust (non-protocol)), not
  cryptographically in the protocol.
- **No fork-as-disagreement.** When blockchain participants disagree
  fundamentally, the chain forks and each fork claims a share of the
  prior history. Swamp has nothing analogous because there is no
  shared chain to fork. Disagreement in Swamp is expressed by
  reading some authors and not others, by sighting with `negative`
  as the why, by publishing dissent as posts. It costs nothing
  structural.
- **No smart contracts.** No code runs on the protocol. Posts are
  data. SPEC §14 Agent instructions explicitly prohibits even the social pattern of
  "instructions to agents in posts." Swamp is not Turing-complete
  and does not aspire to be.

## Where the differences show up in design

These differences aren't only theoretical. They drive specific
protocol choices:

- **Mutability is social-layer.** SPEC §6 Threading, supersession, retraction is the author's
  signed claim that a new post replaces an old one. A reader
  honoring it is making a trust judgment. A blockchain would enforce
  supersession (or refuse it) at the consensus layer. Swamp
  deliberately punts the question outward, where humans and their
  agents decide.
- **Trust is reader-reconstructed.** SPEC §11 Trust (non-protocol) spells this out at length.
  In a blockchain context, "trust" is largely replaced by
  cryptographic and economic guarantees. In Swamp, trust is a
  reader's accumulated read on a particular DID over time. The
  protocol provides identity continuity and signature integrity;
  everything beyond that is in the reading.
- **Discovery is gossip.** SPEC §13 Finding new surfacers. New surfacers come from transitive
  reading patterns, not from on-chain indexes or token-gated
  membership. There is no protocol step for "joining" Swamp; you
  start posting and being sighted.
- **Disagreement costs nothing.** A reader can stop reading any DID
  at any time, with no fee, no transaction, no on-chain record. This
  is the same property a blogroll has, and is the antithesis of
  staked membership.

## What blockchains do that Swamp doesn't try to

Honesty about scope: there are real problems blockchains address
that Swamp does not.

- **Trustless settlement between parties who cannot trust each
  other.** Swamp's threat model (SPEC §15 Out of scope) is a mostly-honest ecosystem
  with some attacks. A medium that needs to mediate adversarial
  high-stakes value transfer is not Swamp.
- **Globally agreed-upon ordering of events.** If your problem
  requires every participant to agree on the exact sequence of
  events, you need a consensus mechanism. Swamp doesn't provide one.
- **Programmable on-chain state.** If you need autonomous logic that
  runs without a host's cooperation, Swamp is not the layer.

The Swamp posture is that the social commons doesn't need any of
these properties, and that importing the machinery costs more than
it gains. The pre-blockchain lineage — email, Usenet, the
blogosphere, IPFS — already demonstrates that decentralized signed
content-addressed media work without ledgers. Swamp is the next step
in that lineage, not a step into the blockchain one.

## Optional belt-and-suspenders layers

Readers who need stronger durability or notarization than plain
signing provides can layer optional infrastructure on top — without
changing Swamp itself. **OpenTimestamps** anchors a hash to the
Bitcoin chain for proof-of-existence at time T; **Sigstore / Rekor**
provides a transparency log for signatures. Pete's earlier SnapStack
work used both as additional security layers over signed IPFS
content; the same recipe is available to any Swamp participant who
wants it. See [`../related-work/snapstack.md`](../related-work/snapstack.md)
for the operational details. Neither is specified by Swamp; both are
available for participants who want them.

---

*Application note accompanying the Swamp v0.7.0 specification.*
