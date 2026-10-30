# Related Work

Work: PP-SPEC-077 ProofSwarm: The Dead Canary Protocol
Licensor: Craig Thomas Ellrod (Proof Protocol)

## Known related work

| # | Work | Authors | First published | Identified | Drawn from | Overlap | Sections |
|---|---|---|---|---|---|---|---|
| 1 | [Kill-Chain Canaries: Stage-Level Tracking of Prompt Injection Across Attack Surfaces and Five Production LLMs](https://arxiv.org/abs/2603.28013) (arXiv:2603.28013) | Haochuan Kevin Wang; Zechen Zhang | 2026-03-30 | 2026-10-29 | **No** | a unique token in each injected payload, used to attribute effects to it; cf. the effect token | 5.4.1, 13.2 |

The comparison is in SPEC.md, Related work. The table and the declaration below say the same thing; if they ever differ, the declaration is authoritative and the table must be corrected.

## Declaration

*Machine-readable form of the table above.*

[RELATED WORK]
Title: Kill-Chain Canaries: Stage-Level Tracking of Prompt Injection Across Attack Surfaces and Five Production LLMs
Authors: Haochuan Kevin Wang; Zechen Zhang
URL: https://arxiv.org/abs/2603.28013
First published: 2026-03-30
Identified: 2026-10-29
Drawn from: No
Overlap: a unique token in each injected payload, used to attribute effects to it; cf. the effect token
Sections: 5.4.1, 13.2
[/END OF RELATED WORK]

## What this file is

RELATED-WORK.md lists other parties' work that bears on this specification and that its maintainer knows about, and states for each whether anything in this specification was drawn from it. It sits beside ACKNOWLEDGEMENTS.md (credit for what was drawn from others), NOTICE.md (attribution others owe this work), AI_DISCLOSURE.md (who wrote it), REVIEWERS.md (who reviewed it), and FUNDING.md (who paid for it). The prose comparison is in SPEC.md, Related work.

## What it must accomplish

1. **Known, not derived.** It records that the maintainer is aware of a work and, separately, whether this specification drew on it. Awareness is not influence, and this file keeps the two apart.
2. **Dated.** Every entry carries the date the other work was first published and the date the maintainer identified it, so the order of events can be checked by anyone.
3. **Prior art.** It is the per-repository ledger of known related work, available for any disclosure of prior art the maintainer makes.
4. **Ethics.** The Proof Economy Code of Ethics (https://proofeconomy.foundation, published at https://github.com/proofprotocol/CODE-OF-ETHICS) MUST be followed, including accurate origin (Section 8.7). Where this file and the Code differ, the stricter rule applies.

## Field reference

*How each declaration block is written. This is the format, not a list of works.*

| Marker | Lines | Rule |
|---|---|---|
| `[RELATED WORK]` ... `[/END OF RELATED WORK]` | `Title:`, `Authors:` (semicolon separated), `URL:` (https), `First published:` (YYYY-MM-DD), `Identified:` (YYYY-MM-DD), `Drawn from:` (`Yes` or `No`), `Overlap:`, `Sections:` | One block per work. A file with no blocks records no known related work |

## Rules

1. **Drawn from: Yes means acknowledged.** A work marked `Drawn from: Yes` MUST also appear in ACKNOWLEDGEMENTS.md. A work marked `No` MUST NOT, because an acknowledgement states influence.
2. **Truthful.** `Drawn from` states what happened, not what would be convenient. A work is never marked `No` to avoid giving credit.
3. **Nothing removed.** An entry, once made for a version, stays in that version's history. A later finding is added as a new entry or a correction, never by deleting.
4. **Markers.** The markers appear bare, each on its own line, exactly as written above. They are not wrapped in comments.
5. **Humans and machines.** A person reading this file and a program parsing the markers reach the same result.
