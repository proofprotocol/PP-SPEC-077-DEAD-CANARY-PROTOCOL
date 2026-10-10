# Changelog

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
