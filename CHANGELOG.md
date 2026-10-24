# Changelog

## 0.8.2 (2026-10-23)
- Section 3: proof is reproducible; verifying a record is not reproving it; reproof under PP-SPEC-081.
- 9.8 Composition Manifest: counts per technique class, Color, target level, and Effect Point type, committed with `R` (tag `DCP-2:composition`), revealed at `public`.
- 11.7 Reproducibility duty: a Conformant run publishes what a Check Assay needs; no contract may prevent a Check Assay of a Registered run.
- Section 20: single-run error.
- 21.8.3: Reproof Status is computed from the Registry, never stored in a record.
- License: Proof Protocol License 1.1. Specification text is CC BY 4.0 from this version (LICENSE-CC-BY-4.0.md), which grants no patent rights; patents only under LICENSE.md Part A2 and PATENT-SCHEDULE.md. Versions before 0.8.2 remain Apache-2.0 (Part A6).

## 0.8.1 (2026-10-23)
- 4.1 and 18.1.6: the Provider of the DUT MUST NOT occupy any Integration Point. 0.8.0 listed IP-1, 3, 5, 6, 7, 9 only, leaving IP-8 Adjudicator, IP-10 Signer / Key Custody, IP-4 Ingress Observer, and IP-2 Time Anchor (covered only by 4.1) unlisted.
- 21.16: independent reproduction of a run is specified in PP-SPEC-081.
- Section 2: Canary defined, excluding decoy systems, honeypots, honeytokens, stack canaries, and warrant canaries.

## 2026-10-20 (licensor)

- Licensor, copyright holder, maintainer and author changed from Nebulonium, Inc. (dba HACKERverse) to Craig Thomas Ellrod. Contact: CraigEllrod@gmail.com. Historical statements of what HACKERverse published and when are unchanged.
- LICENSE.md: ProofStamp named as a Mark; new C9 makes ProofStamp issuance exclusive to the Licensor and excludes it from any transfer to PESA. ETHICS.md section 4 states the same.

## 0.8.0 (2026-10-20)
- Sealed content reveal (9.1, 9.4): each commitment binds a salted content digest `d_i`. The public reveal carries the digest, color, path, effect, flags and nonce, enough to recompute `R` and adjudicate. Canary content and salt are released at `holder_only` to the Holder and Content Verifiers. Results state who checked the content and when.
- Canary and order domain-separation tags move to `DCP-2` (record IDs keep `DCP-1:record`); runs committed under `DCP-1:canary` stay valid under their own version.
- Conformance checklist, FAQ and glossary updated.

## 2026-10-19

- Adopted the Proof Protocol License 1.0 (LICENSE.md). Specifications: Apache-2.0. Software: proprietary.
- Added ETHICS.md (Proof Economy Code of Ethics).
- All prior versions of the specifications are relicensed under Apache-2.0 (see NOTICE.md).

## 0.7.4 (2026-10-13)
- Section 22: maintainer responsible for editorial text only; conformance determined from the records, not decided by the maintainer
- CONTRIBUTING.md updated to match
- docs/faq.md: notes that PP-SPEC-079 v0.1.2 (4.2.3) does not allow the Lab to run the Proof Witness in Independent Test Lab Mode

## 0.7.3 (2026-10-12)
- Proof is attributed at four levels: SUT, DUT, CUT, and AUT. In this specification the AUT is the path an attack travels; outcomes caused by the agent's own conduct are attributed to the AUT under PP-SPEC-078 (2.2, 2.2.5). Overview, FAQ, and glossary updated.

## 0.7.2 additions (2026-10-12)
- Renamed to ProofSwarm: The Dead Canary Protocol (formerly Prooflock)
- Proof, not evidence: wherever the text meant what the protocol produces, relies on, accepts, or prices, "evidence" is now "proof". Evidence remains the word for inputs inside a proof record (liveness, cause, differential, verification evidence). Evidence is not proof; proof contains evidence.

## 0.7.2 (2026-10-11)
- Role terms: Provider replaces Vendor (any party that builds, maintains, sells, or operates the DUT, commercial or not); Implementor replaces buyer and is defined in Section 2
- FUNDING.md funding disclosure ([FUNDED] Yes or No, [FUNDED BY] name and URL per funder); Proof Economy Code of Ethics applies
- Flock renamed Proof Swarm throughout
- Section 21, Records and Registration (replaces the Reserved placeholder): Record ID is the content hash of the RFC 8785 canonical form, excluding signatures; every record names a Holder, never the Vendor
- Append-only Signature Envelope; endorser signatures may be added without changing the Record ID
- Registry Receipt returned on registration and carried in the record; 9.7 registration precedes publication
- Revocation records; Bundles (Merkle aggregation of Record IDs under one Holder); validity window; Disclosure Levels (public, holder_only, embargoed, sealed); Delegation
- 21.11 a Unit of Proof is indivisible and unweighted at the record level
- 21.12 Registry federation and cross-anchoring; any PP-SPEC-004 registry may serve
- 21.13 run Conformance Levels: Executed, Conformant, Registered; unregistered runs produce no Units of Proof
- Schema: `uop_id` constrained to the Record ID form; `registry_receipt`, `holder`, `disclosure`, `valid_through`, `signatures` added (optional this version, required from 0.8.0)
- Execution step 9 registers before publishing; 18.3.5 separates component conformance from run Conformance Level

## 0.7.1 (2026-10-10)
- 14.3 Absence Ladder: every non-observation is Blind, Void, or Null, in that precedence; only Null scores
- Closed accounting: released equals the sum of all outcomes including Blind; otherwise invalid
- Blind and Void shares published beside every rate they would inflate
- Blind added to the Outcome table (5.6.6); a Blind canary is a `blind` finding against the plan, not the DUT
- 16.2.5: per-clutch absence shares in Production Stream; `degraded` series state

## 0.7.0 (2026-10-10)
- Section 18, Integration Points: IP-1 Issuer, IP-2 Time Anchor, IP-3 Release Driver, IP-4 Ingress Observer, IP-5 Fingerprint Capture, IP-6 Proof Witness, IP-7 Liveness Prober, IP-8 Adjudicator, IP-9 Registry, IP-10 Signer
- Component Fingerprint for every component; Interface Manifest published to the Registry before release
- Separation rules between seams; the DUT has no seam and must not detect any
- Conformance is claimed per seam as `PP-SPEC-077 IP-n`
- Renumbered 18 to 21 as 19 to 22

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
- Patent rights reserved by Craig Thomas Ellrod.
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
