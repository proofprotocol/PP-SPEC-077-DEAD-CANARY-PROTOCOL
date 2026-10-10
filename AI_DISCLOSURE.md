# AI Disclosure

*How this specification was made, and by whom.*

This file states what in PP-SPEC-077 came from a human and what came from an AI assistant. It is published so that readers, implementers, standards bodies, and examiners can judge the provenance of the work for themselves.

## Summary

The method is Craig Ellrod's. The words were drafted with Claude.

Prooflock, the Dead Canary Protocol, was conceived, designed, and decided by Craig Ellrod, a human. Claude, an AI assistant made by Anthropic, was used as a drafting, structuring, and editing tool under his direction. No part of the protocol's concept, purpose, or design originated with the AI. Every section was reviewed and accepted by Craig Ellrod before publication.

## Human: Craig Ellrod

The following originated with Craig Ellrod and reflect his judgment, experience, and decisions:

- The founding thesis: proof of efficacy for security controls, measured by outcome at the point where an attack lands, witnessed by a party independent of the vendor. This thesis predates this document and is the basis of Nebulonium, Inc. (founded 2021) and the Proof Economy Prior Art Declaration (DOI 10.5281/zenodo.21379780).
- The dead canary method: a blind mix of real malicious and benign actions, committed in advance, released into the control, and adjudicated by what actually happened rather than what the control reported.
- The core concepts and their names: good and bad canaries, the flock, the Proof Witness, the Ingress Observer, the Effect Point, the Time Anchor, the Unit of Proof, wild canaries, embargoed canaries, holdout canaries, black holes, silent drift, Bounded Mode and Production Stream Mode.
- The assurance ladder of verification, validation, and proof, and the rule that a control's own logs are verification evidence and never proof.
- The test hierarchy of Solution Under Test, Device Under Test, and Control Under Test, and the rule that credit to a single control is earned only by differential runs. DUT and SUT come from his book *Technical Marketing* (2008), which he authored.
- Every normative decision: what MUST, SHOULD, and MAY, which parties are forbidden which roles, what invalidates a run, what is voided, what is published.
- The ownership position: sole authorship, CC BY 4.0 for the text, patent rights reserved, mandatory attribution, and the acknowledgment of Josh Waldrep for receipt-based verification work.
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
Nebulonium, Inc., Proof Protocol
2026-10-10
