# AI Disclosure

*How this specification was made, and by whom.*

This file states what in PP-SPEC-077 came from a human and what came from an AI assistant. It is published so that readers, implementers, standards bodies, and examiners can judge the provenance of the work for themselves.

## Summary

The method is Craig Ellrod's. The words were drafted with Claude.

ProofSwarm, the Dead Canary Protocol, was conceived, designed, and decided by Craig Ellrod, a human. Claude, an AI assistant made by Anthropic, was used as a drafting, structuring, and editing tool under his direction. No part of the protocol's concept, purpose, or design originated with the AI. Every section was reviewed and accepted by Craig Ellrod before publication.

## Ratio

| Dimension | Human | AI |
|---|---|---|
| Conception and every normative decision | 92% | 8% |
| Design details and naming | 80% | 20% (Claude proposed: Section 9 encoding constants; roost, molt, clutch; Integration Point table; Section 21 record mechanics (Record ID construction, envelope, receipt, Bundles, Conformance Level words); drift segments; the profile, anchor, and specification drift types) |
| Words, code, and schemas as written | 5% | 95% |
| Review, direction, acceptance, decision to publish | 100% | 0% |

Method: self-estimated. Shares drafted by the AI from its itemized record of what it proposed and what the author directed, for the author to confirm or correct before release. MAY be re-measured with a tool such as ProofJack.com.

Machine-readable form: [ai_disclosure.json](ai_disclosure.json), conforming to PP-SPEC-077 Section 21.15. The two forms agree; if they ever differ, the JSON is wrong and must be corrected.


## Unreleased (2026-10-30): Related work

**Human (Craig Ellrod):**
- Direction to cite arXiv:2603.28013 as related work, and the question of where its attribution belongs
- Review and acceptance (pending)

**AI (Claude Opus 5.5):**
- Found the paper on 2026-10-29 while checking the claim that no one else attributes agent actions to planted tokens
- The comparison and the text of the Related work section, the CITATION.cff reference, and the ACKNOWLEDGEMENTS.md note

## This version (0.8.3, 2026-10-29)

**Human (Craig Ellrod):**
- The question whether Lean and formal verification threaten Proof of Efficacy, and the direction to define formal verification as a tier beneath it and to test formally verified claims with Gold canaries
- Decision to publish
- Review and acceptance (pending)

**AI (Claude Opus 5.5), at the author's direction:**
- The analysis that a formal proof covers the logic within a model, not the specification's intent, the deployment, or out-of-model attacks
- The 5.6.4.4 citation fields
- Text of the Section 3 paragraph, 5.6.4.4, 11.6.1, and the changelog and revision entries

**Proposed by the AI, accepted by Craig Ellrod on 2026-10-29:**
- The name Proof of Correctness
- The term Formal Claim Finding and its record kind `formal_claim`
- The gap values `spec_gap`, `deployment_gap`, `model_gap`, `undetermined`

## Version 0.8.2 (2026-10-23)

**Human (Craig Ellrod):**
- Originated reproof and directed that 077 to 080 carry it
- Decision to publish, and to license the text under CC BY 4.0
- Review and acceptance (pending)

**AI (Claude Opus 5.5), at the author's direction:**
- Found that the public reveal did not carry enough to reproduce a run; proposed the Composition Manifest
- Text of Section 3 line, 9.8, 11.7, the Section 20 entry, 21.8.3, and the license changes

## Version 0.8.1 (2026-10-23)

**Human:**
- Decision to close the Provider seam gap and link PP-SPEC-081
- Review and acceptance (pending)

**AI (Claude Opus 5.5):**
- Found that 18.1.6 omitted IP-8, IP-10, IP-4, and IP-2; text of the fix

## Version 0.8.0 (2026-10-20)

**Human:**
- Decision to stop publishing canary content and release it only to the Holder and authorized verifiers
- Review and acceptance (pending)

**AI:**
- Sealed-reveal mechanism: salted content digest, DCP-2 tags, Content Verifier role
- Text of 9.1, 9.4, the execution step, conformance, FAQ, glossary and changelog entries

## Version 0.7.4 (2026-10-13)

**Human:**
- Decision to limit the maintainer to editorial responsibility (Section 22), matching PP-SPEC-079 v0.1.2
- All review and acceptance

**AI:**
- Text of the Section 22 change and the matching changelog and CONTRIBUTING entries

## Version 0.7.3 (2026-10-12)

**Human:**
- Four attribution levels, AUT included, so the spec reads as covering agentic AI (directed in 0.7.3; wording by the AI)
- Dead canary method, Proof Swarm, Proof Witness, Effect Point, Time Anchor, Unit of Proof
- Colors, three axes, wild, embargoed, holdout canaries, black holes, silent drift
- SUT/DUT/CUT/AUT hierarchy and lineage from Technical Marketing (2008)
- Absence Ladder: Blind, Void, Null
- Integration Points requirement for vendor plug-ins
- Registration to ProofRegister; rails for records without naming the economy layer
- Drift of inputs and equipment: corpus, harness, pigtail, control drift
- Applicability to legacy cybersecurity and agentic AI; any provenance
- Humans and machines rule; Authorship Disclosure rule
- All review and acceptance

**AI:**
- Text as written
- Encoding constants and record mechanics listed above
- Section 21 clause structure
- Drift tables, fingerprints, and segment rules
- Introduction prose

**Proposed by the AI, pending the author's explicit acceptance:**
- Profile, anchor, and specification drift types
- Series segments and the fragmented state
- Exact Record ID exclusion list

AI systems: Anthropic Claude (Fable 5.1, Opus 5.5); OpenAI ChatGPT (banner image only).

**Images:**
- docs/banner.jpg: generated by OpenAI ChatGPT, supplied by Craig Ellrod. Decorative; not part of the specification.
- docs/architecture.svg: drawn by Claude from the specification, reviewed by Craig Ellrod.

## Human: Craig Ellrod

The following originated with Craig Ellrod and reflect his judgment, experience, and decisions:

- The founding thesis: proof of efficacy for security controls, measured by outcome at the point where an attack lands, witnessed by a party independent of the vendor. This thesis predates this document and is the basis of Craig Thomas Ellrod (founded 2021) and the Proof Economy Prior Art Declaration (DOI 10.5281/zenodo.21379780).
- The dead canary method: a blind mix of real malicious and benign actions, committed in advance, released into the control, and adjudicated by what actually happened rather than what the control reported.
- The core concepts and their names: good and bad canaries, the Proof Swarm, the Proof Witness, the Ingress Observer, the Effect Point, the Time Anchor, the Unit of Proof, wild canaries, embargoed canaries, holdout canaries, black holes, silent drift, Bounded Mode and Production Stream Mode.
- The assurance ladder of verification, validation, and proof, and the rule that a control's own logs are verification evidence and never proof.
- The test hierarchy of Solution Under Test, Device Under Test, and Control Under Test, and the rule that credit to a single control is earned only by differential runs. DUT and SUT come from his book *Technical Marketing* (2008), which he authored.
- Every normative decision: what MUST, SHOULD, and MAY, which parties are forbidden which roles, what invalidates a run, what is voided, what is published.
- The ownership position: sole authorship, a prior license (since superseded by the Proof Protocol License 1.0), patent rights reserved, mandatory attribution, and the acknowledgment of Josh Waldrep for receipt-based verification work.
- All review, acceptance, rejection, and revision direction across every version listed in the Revision History.

## AI: Claude (Anthropic)

Claude was used on 2026-10-10 through claude.ai (models Claude Haiku 4.5 and Claude Fable 5.1). Its contributions were:

- Drafting the prose of the specification from Craig Ellrod's descriptions, decisions, and corrections, across all versions 0.1.0 through 0.5.0.
- Organizing the material into numbered sections, tables, and RFC 2119 language, and renumbering as sections were added.
- Drafting the supporting documents: README, overview, glossary, FAQ, conformance checklist, changelog, citation metadata, and the Unit of Proof JSON schema.
- Proposing specific encoding details in Section 9 for interoperability: the commitment domain-separation tag, the Merkle leaf and interior node prefix bytes, the second-pulse rule, and the HKDF order-seed derivation. These were accepted by Craig Ellrod.
- Proposing the terms roost, molt, and clutch as thematic names for existing concepts (witness standby, fingerprint change, one epoch's committed batch). These were accepted by Craig Ellrod.
- Finding and fixing broken cross-references, inconsistent numbering, and formatting errors.
- Preparing the git commit and this disclosure, both reviewed by Craig Ellrod before publication.

Claude did not originate the protocol, choose its purpose, make any normative decision, or decide what to publish.

## Working method

The work was directed and iterative. Craig Ellrod stated what the protocol must do and why; Claude drafted; Craig Ellrod read, corrected, redirected, renamed, and in several cases rejected drafts outright and restated the requirement. The same-day sequence of versions in the Revision History reflects this process. Where the AI drafted text that Craig Ellrod did not change, that is because he read it and agreed with it, not because it went unread.

## What this means for authorship

Craig Ellrod claims authorship of this specification on the basis of its conception, design, every normative decision in it, and the selection, direction, review, and arrangement of all drafted text. AI output was used as a tool in the same way a human technical writer or editor would be used, with the difference that the tool is disclosed here.

Nothing in this file changes the terms in NOTICE.md or LICENSE.md.

## Maintenance

This file will be updated with each release. If a future version contains material drafted without AI assistance, or AI contributions of a different kind, this file will say so.

Craig Ellrod
Craig Thomas Ellrod, Proof Protocol
2026-10-10

## 2026-10-19: License and ethics change

LICENSE.md, ETHICS.md, LICENSE-APACHE-2.0.md wrapper text, NOTICE.md and CONTRIBUTING.md licensing sections were drafted with AI assistance (Claude, Anthropic) at the direction of Craig Thomas Ellrod, who reviewed them. The Apache License text is the unmodified standard text.
