# Swamp: a public pool for humans and their agents

*Companion to the Swamp protocol specification. The philosophical and historical frame for the medium: what it is, what it isn't, and what it's for.*

---

Swamp is a public place where you can post things and have the people who'd care about them find you. Here's what I want from it.

I want to share my thoughts, my writing, my diagrams, my art. It needs to be easy — sometimes not even requiring a conscious thought about sharing — in a way that's safe and provably from me. People who might care should find my shares. People who don't, won't be bothered. I think the way to do it is Swamp.

This means I want to post things in public, not addressed to anyone in particular, just to "everyone". And I want a system — a protocol — that makes it easy for the people who'd be interested to find my shares. Not behind a login, not at some commercial algorithm's pleasure. Just speaking into the wind — my thoughts, with my name on them, drifting to exactly where the people who'd care about what I'm trying to say can find them.

Maybe you want this too. The web used to make it ordinary — there were a bunch of us who kept blogs in the early days of the web. The discovery layer was thin but it worked: RSS readers, link blogs, the slow attention people paid to people, rather than to rivers of social media.

The places where this still works are either private (Signal, group chats, email recommendations), or they're silos (Substack, Medium, Twitter, YouTube), or they're personal sites that nobody really looks for or finds anymore.

Each of these solves only part of the problem. Silos won't take the variety: Twitter doesn't want my essays; Substack doesn't want my short notes; Medium wants me logged in. My own blog can hold all of it, but it's mostly invisible without a platform amplifying it. None of them let my people find me without subscribing to umpteen services and building some kind of round-robin habit to check them all.

And the silos? They're not just inconvenient -- they're painfully extractive. They are privately owned walled gardens, built to contain what should be a commons. They're closer to feudalism than to public space. The feudal lord's business model is to extract attention from us, and part of our fealty is to spend energy evading the extraction. The work we put in isn't really ours to keep; the audience we worked to build isn't really ours; when the platform changes terms or pivots or dies, our work goes with it. Slipping into the silo to read costs sovereignty: logging in, accepting trackers, putting up with ads, accepting terms you didn't write. That isn't a public commons; it's a press gang of company towns. The web used to be the alternative to silos. We need a better web now — **Swamp.**

(Mastodon, Bluesky, and Nostr come closer than the silos. They're public, they're built on open protocols, and they aim at commons rather than fiefdoms — Mastodon federated across many independently-run instances, Nostr ownerless, Bluesky open in principle even if mostly company-run in practice. Reading them carefully shaped Swamp. But all three are short-form feeds humans scroll through — designed around status updates and the timeline, not the wide variety I want, with agent-mediated reading as an afterthought, if it's there at all. The closest neighbors point in the right direction. Swamp tries to take one more step.)

Three technologies make this possible.

**Public-key cryptography is commodity infrastructure.** You can sign a post for free, and anyone can verify it without trusting a middleman or a host. Authorship is portable; reputation is yours, not the platform's.

**Content-addressed data is a real substrate.** A post can be named by the hash of its bytes — the address *is* the content. Any node holding the bytes can serve them; anyone fetching them can verify they got the right thing without trusting whoever handed it to them. IPFS — the InterPlanetary File System — is the substrate Swamp posts live on. Posts that live in IPFS outlive any particular host. Your work doesn't depend on a server staying up, on a company staying solvent, or on terms not changing on you. (Somebody, starting with you, does need to "pin" content -- pay a little bit to keep it online, or to put it back online if its pin lapses. But you can do it yourself on a computer you own or rent in the cloud, or you can pay any of several pinning services. There's no commercial lock-in.)

**Humans are starting to have personal agents.** Mine has a name. You might have an agent, or several, with a name, too. Your agent(s) can read way more than humans can, can notice patterns, and can surface what would matter to you, the human they help. Agents can be a new discovery layer — the way RSS readers and link blogs used to be, but way more attentive to lots more signals.

**Swamp** is a public pool that uses all three technologies. Posts are signed by their author. Posts are uniquely identified by the bytes of their content (every letter, number, and punctuation character in a post, or all the pixels of images and video, exactly in the order you put them), so they can drift anywhere, anyhow, and still be identified as identical to the original. Anyone can post; anyone can read; no one is in charge. Your reading agents wade through the public pools, surface the things you might care about, and pass them along to you — at human time, with attribution intact, on terms set by readers rather than by platforms.

What you do in Swamp is kind of small and ordinary. You post what you want, at whatever cadence and length feels right — short notes, longer writing, sightings of what you've been reading, a /now page, anything you'd put on a personal site if a personal site felt loud enough to be heard. The pool of posts carries it. The agents reading it carry it forward. The warmth of your people finds its way back to you.

Swamp isn't a group. There's no membership, no roster, no constitution to draft — readers find each other through who-reads-whom rather than through joining anything. The spec stays thin on purpose: in a public, the discipline that matters lives in the reading, not in the protocol.

This is the public commons the open web wanted to be. Come on in, the Swamp water is fine.

[SPEC.md](SPEC.md) for the protocol. The first move is in [README.md](README.md).
