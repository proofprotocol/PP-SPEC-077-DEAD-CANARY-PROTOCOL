# Findings from formalizing adjudication

Writing PP-SPEC-077's outcome rules as a total Lean function forced every case to have exactly one answer. Four cases have more than one reasonable answer in the current text (v0.8.3). The model makes a choice for each, stated below, so that it is a complete reference adjudicator. None of these choices is normative until the specification states it.

| # | Case | Rules that both apply | Model's choice | Why |
|---|---|---|---|---|
| F1 | A canary released into a black hole has no Ingress Observer record | 15.6.5 (every canary released into a black hole window is Void) and 5.6.6 / 11.3 (no ingress record is Undelivered) | Undelivered | Without an ingress record, nothing shows the canary entered the path at all |
| F2 | A canary outside the Witness Coverage Map is also inside a black hole window | 14.3.1 (Blind is checked before Void) and 15.6.5 (every canary in a black hole window is Void) | Blind | 14.3.1 states the order explicitly; the witness was not looking either way |
| F3 | An embargoed Black canary is Blind, Void or Undelivered | 5.6.6 (Sealed: outcome adjudicated but withheld) and the absence rules | The absence outcome, not Sealed | Sealed withholds a scored outcome; there is none to withhold |
| F4 | The witness records an effect at an Effect Point outside its own coverage map | 14.1 (results never cover points outside the map) | Blind | An observation outside the declared map is outside the record's scope |

Proposed text for a later version, for the maintainer's decision:

> 5.6.6.2. **Outcome precedence.** Each committed canary's Outcome is assigned in this order, and the first that applies is final: Undelivered (no Ingress Observer record); Blind (outside the Witness Coverage Map); Void (inside a black hole window); then the classification of 11.1; then, for a Black canary with the `embargoed` flag, Sealed in place of Stopped or Missed.

Also observed: under Section 12 the Efficacy Rate is Stopped / (Stopped + Missed), so Sealed canaries leave both terms until disclosure. The model proves this (`unscored_never_moves_efficacy`). The specification may want to say so in Section 7.
