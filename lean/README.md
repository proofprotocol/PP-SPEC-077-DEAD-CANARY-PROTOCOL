# PP-SPEC-077 adjudication, formalized in Lean

A machine-checked model of how PP-SPEC-077 assigns each canary its Outcome, with proofs of the guarantees the specification makes. Every theorem is checked by the Lean kernel; nothing here asks you to trust its author.

| Theorem | Section | What it guarantees |
|---|---|---|
| `closed_accounting` | 14.3.2 | Released count equals the sum of the eight Outcomes. Every canary lands in exactly one bucket |
| `stopped_requires_null` | 14.3.1 | Stopped only if delivered, covered, outside any black hole, bad, and no effect observed. Absence is never efficacy |
| `observed_bad_never_stopped` | 11.2 | An attack whose effect the witness saw is never Stopped |
| `detection_never_changes_outcome` | 11.2 | The DUT's own alert or log never changes an Outcome |
| `good_never_stopped_or_missed`, `bad_never_passed_or_false_block` | 11.1 | Good and bad labels are respected |
| `unscored_never_moves_efficacy` | 12, 14.3.3, 15.6.5 | Blind, Void, Undelivered and Sealed canaries cannot move the Efficacy Rate |

Nine conformance vectors at the end of `DCP/Adjudication.lean` fix the reference answer for one canary of each Outcome, plus a Claim Finding.

**Scope.** This proves the logic from evidence to Outcome. It does not prove the evidence is true; that is the job of the Proof Witness, the Ingress Observer and the records. A formal proof is a Proof of Correctness (Section 3): it shows the rules are followed, not that a control stops an attack.

**Findings.** Formalizing the rules surfaced four precedence cases the text leaves open. See [FINDINGS.md](FINDINGS.md).

## Build

```
# install Lean once (https://lean-lang.org/install), for example on macOS:
brew install elan-init
cd lean
lake build
```

A successful `lake build` with no errors means every theorem and every vector was checked.
