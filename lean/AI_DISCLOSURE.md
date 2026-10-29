# AI Disclosure: lean/

*How the Lean formalization of PP-SPEC-077 adjudication was made, and by whom. Required by PP-SPEC-077 Section 21.15.*

## Summary

The decision to formalize 077 in Lean, and the question it answers, are Craig Ellrod's. The Lean code and proofs were written by Claude and checked by the Lean kernel.

## Ratio

| Dimension | Human | AI |
|---|---|---|
| Conception and every normative decision | 70% | 30% |
| Design details and naming | 10% | 90% |
| Words, code, and schemas as written | 0% | 100% |
| Review, direction, acceptance, decision to publish | 100% | 0% |

Method: self-estimated. MAY be re-measured with a tool such as ProofJack.com (PP-SPEC-088).

## This version (2026-10-29)

**Human (Craig Ellrod):**
- The question whether Lean threatens Proof of Efficacy, and the direction to use Lean on Proof Protocol's own adjudication rather than only to describe vendors
- Approval to build it and to install the Lean toolchain
- Review and acceptance (pending)

**AI (Claude Opus 5.5):**
- Choice of what to model (Sections 5.6.4, 5.6.6, 11.1, 11.2, 12, 14.3, 15.6.5) and which guarantees to prove
- All Lean code, the seven theorems, the nine conformance vectors, FINDINGS.md, README.md and the CI check
- The four precedence findings F1 to F4 and the proposed 5.6.6.2 text

**Proposed by the AI, pending the author's explicit acceptance:**
- The precedence order Undelivered, Blind, Void, 11.1, Sealed, used by the model where the specification is silent
- The proposed 5.6.6.2 Outcome precedence text in FINDINGS.md

**Checked by machine:** every theorem and vector compiled with Lean 4.19.0 (`lake build`), depending only on Lean's standard axioms `propext` and `Quot.sound`. No `sorry`. A kernel check confirms each proof is valid for the model as written; it does not confirm that the model matches the specification's intent. That is the author's review.
