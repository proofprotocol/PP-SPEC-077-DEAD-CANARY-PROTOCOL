# Changelog

## 0.6.1 (2026-10-10)
- Terminology: Registry, a PP-SPEC-004 (ProofRegister API) conformant ledger; public instance proofregister.com
- 9.6: every published artifact goes to a Registry; `proofregister_uri` required in Units of Proof and result series
- Schema: `proofregister_uri` added and required
- README: where results live

## 0.6.0 (2026-10-10)
- Section 5.6: three axes, Color, Path, Outcome, each set once at its own time
- Colors: White, Gray, Red, Black, Gold; wild canaries stay outside the axes as their own evidence class
- Gold reference canaries test the Vendor's written claims; Gold Missed is a Claim Finding (11.6)
- Claim Accuracy Rate added to Section 12
- Void, Undelivered, Sealed defined as outcomes; cadence defined as a Path field, not a color
- 5.4.1 effect tokens; 13.2 matching by token, Effect Point, and window; replay findings
- Security Considerations: canary replay, test as cover
- 9.1 commitment binds color and path
- Schema: color, path, effect_token, claim; top-level effect_point deprecated

## 0.5.1 (2026-10-10)
- Terminology: added Agent Under Test (AUT), an actor inside the SUT, not a control
- Section 2.1: lineage now covers all four terms (SUT, DUT, CUT, AUT) as derived from Technical Marketing (2008)
- Section 2.2: AUT added beside the DUT in the test hierarchy; new 2.2.5 states AUT is not an attribution level and points to PP-SPEC-078 (No Bros Jail Mode Protocol: The Jailed Canary Protocol)
- Updated glossary, FAQ, README, CITATION

## 0.5.0 (2026-10-10)
- Added Section 16, Operating Modes: Bounded Mode and Production Stream Mode
- Added Section 17, Technology Profiles for nine domains plus profile structure and implementation guidance
- Section 9: fixed domain-separation tag in commitments, Merkle leaf and interior node prefixes, second-pulse rule and HKDF derivation for order seed
- Terminology: roost, molt, clutch
- Renumbered Execution, Security Considerations, Reserved, Interpretation to 18 through 21
- Updated conformance, glossary, FAQ, README, CITATION, schema

## 0.4.0 (2026-10-10)
- Control Under Test (CUT) restored as a single control inside the DUT
- Added Section 2.2, Test Hierarchy: SUT contains DUTs, DUT contains CUTs
- CUT attribution only by differential runs; DUT logs are annotation only
- Commitments now include target level and identifier
- Rates reported per level; CUT Fingerprints added to Section 15.2
- Schema adds `attribution_level`, `sut`, `cut`, `cut_fingerprint`

## 0.3.1 (2026-10-10)
- Control Under Test (CUT) renamed Device Under Test (DUT) throughout, including schema fields `dut` and `dut_fingerprint`
- Added Solution Under Test (SUT)
- Added Section 2.1, Terminology Lineage, citing Technical Marketing (2008)

## 0.3.0 (2026-10-10)
- Added Section 15, Continuous Mode and Drift: CUT Fingerprint, stale results, trickle and triggered runs, silent drift, undeclared change, witness calibration, black hole drift, result series
- Renumbered Execution, Security Considerations, Reserved, and Interpretation to 16 through 19
- Updated conformance, glossary, overview, FAQ, README, CITATION, and schema

## 0.2.2 (2026-10-10)
- Spec ID set to PP-SPEC-077 in the Proof Protocol series
- Sole author: Craig Ellrod
- Patent rights reserved by Craig Ellrod and Nebulonium, Inc.
- Acknowledgment: Josh Waldrep, for his receipt-based verification work

## 0.2.1 (2026-10-10)
- Renamed to Prooflock: The Dead Canary Protocol

## 0.2.0 (2026-10-10)
- Renamed to Prooflock: The Dead Canary Protocol (PP-SPEC-077)
- Swarm renamed Flock; probes renamed good and bad canaries; witness named Proof Witness
- Added mutation and novelty scoring (Section 6)
- Added embargoed canaries for undisclosed vulnerabilities (Section 7)
- Added wild canaries (Section 13)
- Added Witness Coverage Map (Section 14)

## 0.1.0 (2026-10-10)
- Initial draft as Witnessed Efficacy Probe (PP-WEP-0001)
