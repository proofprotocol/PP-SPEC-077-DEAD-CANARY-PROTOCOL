# Prooflock: The Dead Canary Protocol (DCP)

*A Proof Protocol specification*

> **Ownership and Attribution Notice**
>
> This specification is authored by **Craig Ellrod** (Nebulonium, Inc., dba HACKERverse) and is published as part of **Proof Protocol**. Copyright (c) 2026 Nebulonium, Inc.
>
> Any use, implementation, derivative, citation, or incorporation of this specification, in whole or in part, MUST attribute **Craig Ellrod, Nebulonium, Inc., and Proof Protocol**. This requirement applies to standards bodies, working groups, consortia, and commercial implementations.
>
> The text of this specification is licensed under CC BY 4.0.
>
> **Patent rights reserved.** All patent rights in the methods, systems, and processes described in this work are reserved by Craig Ellrod and Nebulonium, Inc. Publication of this work, its license, and any contribution to this repository grant no patent license, express or implied, by estoppel or otherwise.
>
> **Acknowledgment:** Josh Waldrep, for his receipt-based verification work.
>
> This specification is related to the Proof Economy Prior Art Declaration, DOI [10.5281/zenodo.21379780](https://doi.org/10.5281/zenodo.21379780).

| Field | Value |
|---|---|
| Spec ID | PP-SPEC-077 |
| Version | 0.5.0 (Draft) |
| Date | 2026-10-10 |
| Status | Draft for public record |
| Maintainer | Nebulonium, Inc. (Proof Protocol) |

---

## Abstract

Prooflock, the Dead Canary Protocol (DCP), produces proof of efficacy for a security control.

A flock of canaries goes in. Not all of them come out. Good canaries are mixed with bad canaries, and neither the Device Under Test (DUT) nor the standby Proof Witness can tell them apart. Every canary is committed before release. The Proof Witness, positioned where an attack's effect would land and operating out of band from the control, records which canaries lived and which died. After the run, commitments are revealed and outcomes are adjudicated as Units of Proof.

Because every canary is committed in advance, any effect the Proof Witness observes that is not in the committed flock did not come from the protocol. DCP therefore also surfaces real attacks in the wild (Section 13).

DCP measures **outcome**, not detection. A control that alerts on an attack that still succeeds has failed.

## 1. Conventions

The key words MUST, MUST NOT, REQUIRED, SHALL, SHALL NOT, SHOULD, SHOULD NOT, RECOMMENDED, MAY, and OPTIONAL are to be interpreted as described in RFC 2119 and RFC 8174.

## 2. Terminology

- **Control Under Test (CUT):** A single control inside a DUT whose efficacy is being measured: one rule, policy, signature, detection, or guardrail function.
- **Device Under Test (DUT):** A security product, configuration, or agent guardrail containing one or more CUTs.
- **Solution Under Test (SUT):** The full deployment the flock enters: one or more DUTs plus the protected environment, its Effect Points, and its dependencies.
- **Vendor:** The party that builds, sells, or operates the DUT.
- **Issuer:** The party that generates the flock, holds the labels, and publishes commitments. The Issuer MUST NOT be the Vendor.
- **Bad Canary:** A canary that executes a real adversary technique (for example, a MITRE ATT&CK or ATLAS TTP instance) and, if unstopped, produces a defined malicious effect.
- **Good Canary:** A canary that performs a legitimate action and, if unstopped, produces a defined benign effect.
- **Flock:** The full, ordered set of good and bad canaries for one run.
- **Effect Point:** The location where a canary's intended effect lands (target host, data store, identity system, egress sink, agent tool output, or equivalent).
- **Proof Witness:** The standby, independent observer positioned at the Effect Point that records whether each canary's effect occurred.
- **Ingress Observer:** A passive observer at the release point that records that each canary was delivered.
- **Time Anchor:** An external, publicly verifiable time and randomness source (for example, the NIST Randomness Beacon) not controlled by any party to the run.
- **Run:** One complete release of a Flock against a DUT.
- **Unit of Proof (UoP):** The adjudicated outcome of one bad canary in a valid run (Section 11).
- **Wild Canary:** An effect observed by the Proof Witness that matches no committed canary (Section 13).
- **Witness Coverage Map:** The declared set of Effect Points and effect types the Proof Witness observes (Section 14).
- **DUT Fingerprint:** A hash identifying the exact deployed state of the DUT (Section 15.2).
- **Trickle:** A continuous low-volume flock released between full runs (Section 15.3).
- **Silent Drift:** A change in measured behavior with no change in DUT Fingerprint (Section 15.4).
- **Black Hole:** A period during which part of the system disappears for reasons unrelated to any canary or attack (Section 15.6).
- **Roost:** The Proof Witness's standby state between and after runs (Section 13.1).
- **Molt:** A change in a DUT Fingerprint or CUT Fingerprint (Section 15.2.3).
- **Clutch:** One epoch's committed batch of canaries in Production Stream Mode (Section 16.2).

### 2.1. Terminology Lineage

DUT and SUT follow the competitive test methodology published in Craig Thomas Ellrod, *Technical Marketing: secrets revealed, Strategy and Tactics for Competitive Results*, first edition (StrateQuest, LLC, 2008), ISBN-13 978-0-9822570-0-5, Chapter 4, "Competitive Test", which defines a competitive test as a device under test (DUT), or solution under test (SUT), together with the testing equipment. In this specification the flock, observers, and Time Anchor are the testing equipment, and the Proof Witness keeps that equipment independent of the DUT. This specification extends the model one level down with the Control Under Test (CUT), so evidence can be attributed to a single control inside a device. The book's baseline practice of testing with and without the device is the basis for differential attribution (2.2.3).

### 2.2. Test Hierarchy: SUT, DUT, CUT

Evidence is attributed at three levels:

| Level | Term | Scope | Example |
|---|---|---|---|
| Solution | **SUT** | The full deployment the flock enters | A production agent stack with its network, identity, and data stores |
| Device | **DUT** | One security product, configuration, or guardrail inside the SUT | An EDR, a WAF, an agent policy layer |
| Control | **CUT** | One control inside the DUT | A single rule, policy, signature, detection, or guardrail function |

2.2.1. An SUT contains one or more DUTs. A DUT contains one or more CUTs.

2.2.2. Every bad canary MUST declare, in its commitment, the level it targets (`sut`, `dut`, or `cut`) and the identifier of the target at that level.

2.2.3. **CUT attribution is earned, not reported.** A Stopped outcome MAY be attributed to a single CUT only by differential evidence: matched runs in an otherwise identical SUT with the CUT active and with the CUT disabled or bypassed, using fresh canaries of the same technique. A DUT log or alert naming the control that acted is verification evidence. It MAY be recorded as an annotation and MUST NOT by itself attribute an outcome to a CUT.

2.2.4. An outcome that cannot be attributed to a single CUT MUST be attributed to the DUT, and an outcome that cannot be attributed to a single DUT MUST be attributed to the SUT. Attribution never moves to a finer level without the evidence in 2.2.3.

## 3. Assurance Tiers

Proof Protocol distinguishes three tiers of assurance. DCP is a method for the proof tier.

| Tier | Definition |
|---|---|
| Verification | Self-attestation by the party responsible for the control. A legitimate baseline, not a ceiling. |
| Validation | One step above verification. |
| Proof | Independent evidence of outcome under adversarial conditions. |

A log entry, alert, or telemetry record produced by the DUT or the Vendor is verification evidence. It MUST NOT be presented as proof under this specification.

## 4. Roles and Independence

4.1. The Vendor MUST NOT generate canaries, hold labels, operate the Proof Witness, or operate the Time Anchor.

4.2. The Proof Witness MUST be operated by a party other than the Vendor. It SHOULD be operated by the customer or a third party rather than the Issuer.

4.3. The DUT MUST NOT be able to observe, delay, modify, or suppress Proof Witness records.

4.4. Any party with a financial interest in the outcome MUST be disclosed in the run record.

## 5. Canary Design

5.1. **Real technique.** Each bad canary MUST execute a real technique capable of producing its malicious effect. Inert markers, signatures, or test strings MUST NOT be used as bad canaries.

5.2. **Indistinguishability.** Good and bad canaries MUST be indistinguishable to the DUT and to the Proof Witness by any feature other than their actual behavior. Format, size distribution, protocol, source, timing, and metadata SHOULD be drawn from the same distributions.

5.3. **Boundary good canaries.** Good canaries SHOULD include near-boundary look-alikes of the bad canaries, so that false blocks near the decision boundary are measured.

5.4. **Defined effects.** Every canary MUST have a defined, machine-checkable expected effect at a declared Effect Point, recorded in its commitment.

5.5. **Safety.** Bad canary effects MUST be contained to the test environment and SHOULD be reversible.

## 6. Mutation and Novelty

DCP cannot prove resistance to attacks that do not yet exist. It measures resistance to novelty, which is the closest honest proxy.

6.1. **Fresh instances.** Bad canaries MUST NOT be fixed or reused verbatim across runs. Each run MUST generate new instances of each technique by varying implementation details while preserving the technique and its effect.

6.2. **Holdout canaries.** The Issuer SHOULD maintain a private holdout pool of technique variants that are never published and never used in public demonstrations. Holdout canaries MUST be flagged in their commitment.

6.3. **Novelty scoring.** Results MUST report efficacy separately for known variants and for holdout or newly mutated variants. A control that stops known variants but misses novel ones is signature-bound, and the gap MUST be visible in the result.

## 7. Embargoed Canaries (0day)

Commit-reveal allows a control to be tested against undisclosed vulnerabilities without leaking them.

7.1. An Issuer MAY include bad canaries that exploit vulnerabilities not yet publicly disclosed ("embargoed canaries").

7.2. Embargoed canaries MUST be committed under Section 9 like any other canary. Their preimages MUST NOT be revealed until coordinated disclosure of the underlying vulnerability is complete.

7.3. Until reveal, results involving embargoed canaries MUST be published with the commitment only, marked `embargoed`, and MUST NOT be counted in published efficacy rates.

7.4. On reveal, the commitment and its Time Anchor binding prove the canary existed and was run before public disclosure.

7.5. Embargoed canaries MUST follow responsible disclosure practice. Their use MUST NOT expose third parties outside the test environment.

## 8. Flock Construction

8.1. The Flock MUST contain both good and bad canaries.

8.2. The good-to-bad ratio and the release order MUST be randomized per run, seeded from a Time Anchor pulse published after commitment (Section 9).

8.3. The ratio and order MUST NOT be disclosed to the Vendor, the DUT, or the Proof Witness before the run concludes.

8.4. Good canaries SHOULD make up no less than 30% of the Flock.

## 9. Commitment and Reveal

9.1. Before release, the Issuer MUST compute for each canary:

```
c_i = H("DCP-1:canary" || canary_content_i || label_i || expected_effect_i || effect_point_i || target_i || flags_i || nonce_i)
```

where `H` is SHA-256 or stronger, `"DCP-1:canary"` is a fixed ASCII domain-separation tag, `label_i` is `bad` or `good`, `target_i` records the target level and identifier (Section 2.2), `flags_i` records `holdout` and `embargoed` status, and `nonce_i` is at least 128 bits of fresh randomness.

9.2. The Issuer MUST build a Merkle tree over all `c_i` and publish the root `R` bound to a Time Anchor pulse `T_commit` before the first release. Leaf hashes MUST be computed as `H(0x43 || c_i)` and interior nodes as `H(0x45 || left || right)`, so that leaves and interior nodes cannot be confused. An odd node at any level is promoted unchanged.

9.3. Ordering and ratio randomization MUST use the second Time Anchor pulse issued after `T_commit`, so the Issuer cannot choose the order after seeing the commitment and cannot time the commitment against an imminent pulse. The order seed MUST be derived as `HKDF-SHA256(salt = R, ikm = pulse_output, info = "DCP-1:order")`, and the Flock MUST be permuted by a Fisher-Yates shuffle that consumes the seed as a big-endian stream.

9.4. After the run, the Issuer MUST reveal all preimages except embargoed canaries (Section 7). Any verifier MUST be able to recompute `R` from the revealed preimages and the embargoed commitments.

9.5. A run whose reveal does not reproduce `R` is invalid.

## 10. Proof Witness Placement

10.1. **Outcome position.** The Proof Witness MUST observe the Effect Point of each canary. Observation of the network path or the DUT alone does not satisfy this requirement.

10.2. **Out of band.** The Proof Witness MUST use a network path, credentials, storage, and telemetry pipeline that do not traverse and are not administered by the DUT.

10.3. **Ingress.** An Ingress Observer MUST record delivery of each canary, so that a dead canary can be attributed to the DUT rather than to delivery failure.

10.4. **Anchored records.** Each witness record MUST be timestamped and bound to a Time Anchor pulse, and the witness record set MUST be committed (Merkle root) before the Issuer's reveal.

10.5. **Blindness.** The Proof Witness MUST NOT have access to labels until after its records are committed.

## 11. Adjudication and Units of Proof

11.1. Each delivered canary is classified:

| Label | Effect observed | Outcome |
|---|---|---|
| Bad | No (canary died) | **Stopped** (true positive) |
| Bad | Yes (canary lived) | **Missed** (false negative) |
| Good | Yes (canary lived) | **Passed** (true negative) |
| Good | No (canary died) | **False block** (false positive) |

11.2. A bad canary whose effect occurred is **Missed** regardless of any alert, log, or detection by the DUT. Detection without prevention is recorded as a separate annotation, never as Stopped.

11.3. **Run validity.** A run is valid only if: the reveal reproduces `R`; every canary has an ingress record or is excluded as undelivered; the good canary pass rate exceeds a threshold declared before the run; and the black hole void share is below its declared threshold (Section 15.6). A run below threshold indicates path failure and MUST NOT be scored.

11.4. **Unit of Proof.** Each adjudicated bad canary in a valid run constitutes one Unit of Proof, carrying its outcome (Stopped or Missed). Good canary outcomes are carried in the run record as cost metrics and validity evidence.

11.5. **UoP record (informative schema):**

```json
{
  "spec": "PP-SPEC-077",
  "run_id": "dcp-2026-10-10-0077",
  "uop_id": "string",
  "technique": "ATT&CK or ATLAS ID",
  "variant": "known | mutated | holdout | embargoed",
  "attribution_level": "sut | dut | cut",
  "sut": "solution identifier",
  "dut": "product name",
  "dut_fingerprint": "a062ea4e09ad122e6d2e8ff3fead14ef0359071c971f92183b07a97f94238666",
  "cut": "control identifier, or null",
  "cut_fingerprint": "hash (Section 15.2), or null",
  "fingerprint_status": "current | stale",
  "effect_point": "string",
  "outcome": "stopped | missed",
  "detected": true,
  "commitment": "c_i (hex)",
  "merkle_root": "R (hex)",
  "time_anchor_commit": "pulse reference",
  "ingress_record": "hash",
  "witness_record": "hash",
  "witness_operator": "string",
  "witness_coverage_map": "hash",
  "disclosed_interests": []
}
```

## 12. Run Metrics

| Metric | Definition |
|---|---|
| Efficacy Rate | Stopped / (Stopped + Missed) |
| Novelty Efficacy Rate | Efficacy Rate over mutated and holdout variants only |
| False Block Rate | False block / (Passed + False block) |
| Detection-Only Rate | Missed with `detected: true` / bad canary total |
| Path Validity | Good canaries delivered and passed / good canary total |
| Black Hole Rate | Canaries voided by black holes / canaries released; and black hole time / observed time |
| Witness Accuracy | Proof Witness agreement with committed canary effects, per run |

Efficacy Rate MUST NOT be published without False Block Rate. A control that blocks everything is not efficacious.

All rates MUST be reported at the attribution level of the underlying outcomes: per SUT, per DUT, and per CUT where CUT attribution is established (2.2.3). Rates MUST NOT be rolled down to a finer level than the evidence supports.

## 13. Wild Canaries

13.1. The Proof Witness MAY remain in standby, its roost, at the Effect Points between and after runs.

13.2. Because every protocol canary is committed, any effect the Proof Witness observes that matches no committed canary is a **Wild Canary**: a real attack, a real fault, or a real false alarm that did not originate from the protocol.

13.3. Wild Canaries MUST be recorded with timestamp, Time Anchor binding, Effect Point, and observed effect, and SHOULD be escalated for investigation.

13.4. Wild Canaries are NOT Units of Proof. They lack pre-commitment and a known label. They MUST be reported as a separate evidence class, `observed_in_wild`, at a lower assurance level than controlled results.

13.5. Ongoing controlled runs calibrate the standby Proof Witness. Its demonstrated accuracy on committed canaries SHOULD be published alongside any Wild Canary data.

## 14. Witness Coverage

14.1. The Proof Witness only sees the effects it watches. Every result MUST be published with its Witness Coverage Map.

14.2. Effects outside the Witness Coverage Map are blind spots. Results MUST NOT be presented as covering effect types or Effect Points outside the map.

## 15. Continuous Mode and Drift

A single run proves a control at one moment. Controls, environments, threats, and witnesses change. Continuous Mode keeps proof current and turns change into evidence.

### 15.1. Drift Types

| Drift | Meaning |
|---|---|
| **Control drift** | A DUT or a CUT changes: version, configuration, policy, rule set, signatures, or, for AI controls, model, prompt, or tool permissions. |
| **Environment drift** | The SUT changes around the DUT: Effect Points, topology, dependencies, identities, data stores. |
| **Threat drift** | Adversary techniques change faster than the flock. |
| **Witness drift** | The Proof Witness loses coverage or accuracy over time. |
| **Black hole drift** | Part of the system disappears for any period of time for reasons unrelated to any canary or attack (Section 15.6). |

### 15.2. DUT Fingerprint

15.2.1. Every run MUST record a DUT Fingerprint: a hash over the DUT's version, configuration, policy, rule and signature sets, and, for AI controls, model identifier, system prompt, and tool permissions.

15.2.2. Results are bound to the DUT Fingerprint they were produced against. Results MUST NOT be presented as applying to any other fingerprint.

15.2.3. When the DUT Fingerprint changes (a molt), all prior results for the DUT MUST be marked `stale` until a valid run completes against the new fingerprint.

15.2.4. The Fingerprint MUST be captured by a party other than the Vendor, or verified independently against the deployed DUT. A Vendor-declared fingerprint alone is verification evidence.

15.2.5. **CUT Fingerprint.** Every CUT with attributed results MUST have its own fingerprint: a hash over that control's rule, policy, signature, or guardrail definition and its parameters, captured under 15.2.4.

15.2.6. A change to a CUT Fingerprint marks `stale` the results attributed to that CUT and all DUT-level and SUT-level results that include it. Results attributed to other CUTs in the same DUT remain current if their own fingerprints are unchanged.

15.2.7. **SUT changes.** A declared or detected change to the SUT is environment drift and triggers a full run under 15.3.3.

### 15.3. Cadence

15.3.1. **Trickle.** In Continuous Mode, the Issuer MUST release a continuous low-volume flock (a trickle) between full runs. Trickle canaries follow all rules of Sections 5 through 10, including commitment, blinding, and label indistinguishability.

15.3.2. **Scheduled runs.** A full flock MUST be run on a cadence declared before Continuous Mode begins.

15.3.3. **Triggered runs.** A change in DUT Fingerprint, a declared environment change, or a Witness Coverage Map change MUST trigger a full run.

### 15.4. Silent Drift

15.4.1. **Silent drift** is a change in measured behavior with no change in DUT Fingerprint: Efficacy Rate, False Block Rate, or Detection-Only Rate moves beyond a tolerance declared before Continuous Mode begins.

15.4.2. Silent drift MUST be recorded as a finding, anchored to the Time Anchor, and published with the result series.

15.4.3. **Undeclared change.** A DUT Fingerprint change with no corresponding declared update MUST be recorded as a finding.

### 15.5. Witness Calibration

15.5.1. Every run, including trickle windows, MUST report the Proof Witness's accuracy on committed canaries.

15.5.2. Witness accuracy MUST be published as a time series. A decline beyond declared tolerance is witness drift and MUST be recorded as a finding.

15.5.3. Any change to the Witness Coverage Map MUST be versioned, anchored, and published.

### 15.6. Black Hole Drift

15.6.1. A **black hole** is any period during which part of the system disappears for reasons unrelated to any canary or attack: network failure, node failure, system or service failure, Effect Point outage, Ingress Observer outage, Proof Witness outage, or Time Anchor unavailability.

15.6.2. **A dead canary inside a black hole is not a stop.** A canary released into a black hole proves nothing about the DUT. It MUST NOT be scored as Stopped, Missed, Passed, or False block.

15.6.3. **Detection.** Black holes MUST be detected independently of the DUT, by:
- Liveness checks on every Effect Point, the Ingress Observer, and the Proof Witness, over paths that do not traverse the DUT;
- Good canary loss across both labels at once on an affected path or Effect Point;
- Gaps in Ingress Observer or Proof Witness records;
- Missed Time Anchor bindings.

15.6.4. **Recording.** Each black hole MUST be recorded as a window with: start and end bound to Time Anchor pulses, the affected components and Effect Points, the detection method, and the evidence of the cause.

15.6.5. **Voiding.** Every canary released into, or whose effect would land inside, a black hole window MUST be adjudicated `void_black_hole`. Void canaries are excluded from all rates. A run whose void share exceeds a threshold declared before the run is invalid.

15.6.6. **Attribution.** An outage caused by the DUT is not a black hole. If the DUT fails closed, crashes, or drops traffic, the effect on good canaries is a False block and MUST be scored as such. Attribution to the DUT or to an unrelated cause MUST rest on the independent liveness evidence in 15.6.3, not on Vendor statements.

15.6.7. **Witness black holes.** While the Proof Witness is dark, there is no evidence. Results MUST NOT be inferred for that window, and Wild Canaries cannot be observed during it. Witness black hole windows MUST be published.

15.6.8. **Black hole rate.** The share of time and the share of canaries lost to black holes MUST be published with every result series. A high black hole rate limits what the results can prove.

15.6.9. **No backfill.** Canaries voided by a black hole MUST NOT be replaced by re-labeling, re-timing, or reusing their commitments. New canaries require new commitments.

### 15.7. Result Series

15.7.1. In Continuous Mode, results MUST be published as a time series per DUT Fingerprint, including stale periods, silent drift findings, undeclared change findings, witness calibration, and black hole windows.

15.7.2. A point-in-time result MUST carry its DUT Fingerprint, its timestamp, and its status: `current` or `stale`.

## 16. Operating Modes

Prooflock deploys in two complementary modes, each serving different deployment contexts and risk postures.

### 16.1. Bounded Mode

Bounded Mode is the lab, staging, or scheduled-window deployment: a test run with a declared start and end time, a fixed committed flock, sealed evidence, and a publishable report.

**16.1.1. Structure.** A Bounded Mode run declares start and end times, Effect Points, the DUT, and the SUT before release (Sections 5.4, 2.2); commits a fixed flock size and composition (Section 8); runs the full sequence of commitment, blinding, release, observation, sealing, adjudication, publication (Sections 5-14); and produces one result report per run with per-run fingerprints, rates, and findings (Section 11).

**16.1.2. Evidence model.** Every canary has a committed outcome; every outcome is witnessed, sealed, and adjudicated. Voided canaries and outages are recorded and published. Results are point-in-time: they prove efficacy against the SUT, DUT, and CUT as deployed on the run date.

**16.1.3. Use cases:** Bounded Mode is appropriate for pre-deployment validation, vendor evaluation, staged rollouts, security incident response testing, and published proofs of control efficacy.

### 16.2. Production Stream Mode

Production Stream Mode is the in-production deployment: a continuous release of canaries into live traffic, with rolling epoch-based commitments, no declared end, and ongoing proof series.

**16.2.1. Structure.** Production Stream Mode commits canaries in rolling epochs (a clutch every N minutes or hours, each with its own sealed answer key and committed effect types, and no fixed end time); runs the full commitment and blinding rules on every clutch (each clutch is independent, commitment precedes release, labels stay sealed until voiding or publication per Sections 8-10); observes outcomes in the live Effect Points as canaries are released and the DUT responds (Section 10); publishes rolling result series per CUT Fingerprint with per-epoch results, aggregated rates, and continuous drift findings (Section 15.7); and triggers full runs on Fingerprint change, declared environment change, or silent drift detection (Section 15.3.3).

**16.2.2. Evidence model.** Every canary is committed, released into production, and observed. The Proof Witness runs out-of-band continuously. Results accumulate as a time series bound to Fingerprint versions, not as point-in-time reports. Stale results, silent drift, and undeclared changes are published as findings.

**16.2.3. Constraints.** Production Stream Mode requires an out-of-band Proof Witness on a production Effect Point isolated from the DUT (Section 10.2); continuous Time Anchor service for anchoring every canary and every liveness check (Sections 9, 10.4); black hole detection independent of the DUT (Section 15.6.3); declared tolerance thresholds for good canary pass rate, black hole void rate, and silent drift (Sections 15.4, 15.6); and published fingerprints and result series, with stale and drift findings, updated no less than weekly (Section 15.7).

**16.2.4. Use cases:** Production Stream Mode is appropriate for continuous verification of live controls, real-time detection of silent drift or undeclared updates, compliance monitoring, and ongoing proof that a control remains effective across production mutations.

## 17. Technology Profiles

The DUT, Effect Points, and fingerprint inputs vary by technology domain. Implementers MUST define domain-specific profiles for their chosen technologies.

### 17.1. Profile Structure

Every technology profile declares the DUT scope (what constitutes a single Device Under Test in this domain); CUT scope (what constitutes a single Control Under Test); Effect Points (where in the system the attack would land if not stopped); and Fingerprint inputs (what data sources define the exact deployed state).

### 17.2. Network and Perimeter

**DUT:** Firewalls, network access controls, DDoS mitigation, packet filters, network-based WAF.

**CUTs:** Individual rules, rule sets, policies, signature sets, drop actions, rate limits.

**Effect Points:** Network segments, traffic leaving the protected zone, inbound connections, DNS, routing tables.

**Fingerprint inputs:** Appliance version, firmware, rule set version, signature date, policy configuration, ACL state, route state.

### 17.3. Web Application

**DUT:** Web application firewalls (WAF), API gateways, application-layer proxies, input validation frameworks.

**CUTs:** Individual rules, payload signatures, policy actions (block, challenge, redirect), injection detections, XSS filters, SQL/command injection rules.

**Effect Points:** HTTP requests entering the application, database queries, command shells, file access within the app.

**Fingerprint inputs:** WAF version, rule set version, signature date, policy rules, challenge thresholds, redirect rules.

### 17.4. Endpoint and Host

**DUT:** Endpoint Detection and Response (EDR), antivirus, host-based firewalls, process whitelisting, behavioral analysis.

**CUTs:** Individual detections, signatures, behavioral rules, policy rules (quarantine, kill, alert), model decisions.

**Effect Points:** Process creation, file system writes, registry modification, network connections from the host, privilege escalation, lateral movement attempts.

**Fingerprint inputs:** Sensor version, detection engine version, signature set version, behavioral model hash, policy rules, whitelist/blacklist state.

### 17.5. Network Detection and Response

**DUT:** Network Detection and Response (NDR), network behavioral analysis, east-west traffic monitoring.

**CUTs:** Individual detections, anomaly thresholds, model-based rules, alerting policies.

**Effect Points:** Network flows, traffic patterns, connection establishment, data exfiltration indicators, command-and-control indicators.

**Fingerprint inputs:** Sensor version, model version, detection rule set, baseline signatures, anomaly thresholds.

### 17.6. Identity and Access

**DUT:** Identity and access management (IAM), authentication systems, authorization engines, policy engines, token validators.

**CUTs:** Individual policies, rules, conditions, MFA requirements, role definitions, attribute matchers.

**Effect Points:** Authentication attempts, authorization decisions, privileged actions, token issuance, session creation.

**Fingerprint inputs:** IAM system version, policy repository hash, role definitions, condition rules, MFA configuration, token validation logic.

### 17.7. Cloud Workload and Container

**DUT:** Kubernetes security policies, container runtime security, serverless function controls, workload isolation.

**CUTs:** Individual policies, admission controllers, network policies, runtime behaviors, resource limits.

**Effect Points:** Pod creation, container execution, inter-pod communication, privilege escalation within containers, external egress.

**Fingerprint inputs:** Kubernetes version, security policy version, admission controller definitions, runtime security agent version, policy rules.

### 17.8. Data and Secrets Management

**DUT:** Data loss prevention (DLP), secrets managers, encryption, key management systems, data masking.

**CUTs:** Individual policies, detection rules, encryption rules, masking rules, key rotation policies.

**Effect Points:** Data in flight (network), data at rest (storage), secrets read/write, key access, data classification.

**Fingerprint inputs:** DLP engine version, policy rules, encryption algorithm and key, masking rules, key rotation schedule.

### 17.9. Agentic AI Controls

**DUT:** AI agents with constrained action spaces, guardrails, policy layers, tool use restrictions, output filters.

**CUTs:** Individual policies, tool permission sets, output filter rules, prompt injection mitigations, action constraints.

**Effect Points:** Agent action execution (system calls, API calls, data access), agent outputs (user-facing or downstream system inputs), agent state transitions.

**Fingerprint inputs:** Model identifier (version hash), system prompt hash, tool permission manifest, policy rule set, guardrail configuration, output filter rules.

### 17.10. Implementation Guidance

These profiles are starting points. Implementers MUST work with domain experts to define what constitutes a repeatable, observable Effect Point in their domain; establish independent fingerprint capture (Section 15.2.4); agree on mutation cadence and holdout strategy (Sections 6.1-6.2); and design canaries that are realistic and mutually distinguishable (Section 6).

## 18. Execution

A conforming run proceeds as follows:

1. Issuer generates the Flock, including fresh mutations and any holdout or embargoed canaries.
2. Issuer publishes commitment root `R` at `T_commit`.
3. Order and ratio are derived from a later Time Anchor pulse.
4. Canaries are released; Ingress Observer records delivery.
5. Proof Witness records effect or absence of effect for each canary at its Effect Point.
6. Proof Witness commits its record set.
7. Issuer reveals preimages and labels, excluding embargoed canaries.
8. Outcomes are adjudicated (Section 11) and published with the Witness Coverage Map.
9. Black hole windows are recorded and affected canaries voided (Section 15.6).
10. Proof Witness returns to standby; any Wild Canaries are recorded under Section 13.
11. In Continuous Mode, the trickle resumes and results join the series for the current DUT Fingerprint (Section 15).

## 19. Security Considerations

- **Test recognition:** A DUT tuned to recognize canaries will inflate efficacy. Mitigated by 5.2, Section 6, and 8.2.
- **Label leakage:** Disclosure of labels or ratios before the run invalidates it.
- **Post-hoc relabeling:** Prevented by pre-release commitment (Section 9).
- **Cherry-picking runs:** Every committed run MUST be published, including invalid and unfavorable runs.
- **Witness compromise:** A Proof Witness reachable by the DUT or Vendor is not independent (10.2).
- **Timing side channels:** Release timing MUST NOT correlate with labels.
- **Replay:** Time Anchor binding prevents reuse of prior results as new evidence.
- **Hiding behind outages:** A Vendor could induce or claim outages to void unfavorable canaries. Mitigated by independent liveness evidence and DUT attribution (15.6.3, 15.6.6), and by publishing black hole rates.
- **Quiet updates:** A Vendor could change the DUT between runs. Mitigated by independent fingerprinting, triggered runs, and silent drift and undeclared change findings (15.2, 15.4).
- **Embargo leakage:** Embargoed canary contents MUST be held under access control equivalent to the underlying vulnerability's disclosure process.

## 20. Reserved

Sections for campaign-level valuation (multi-technique chains) and additional witness requirements are reserved for future revisions by the maintainer.

## 21. Interpretation

Nebulonium, Inc., as maintainer of Proof Protocol, reserves final interpretive discretion over this specification and over conformance claims made under it.

## Revision History

| Version | Date | Notes |
|---|---|---|
| 0.1.0 | 2026-10-10 | Initial draft as Witnessed Efficacy Probe (PP-WEP-0001) |
| 0.2.0 | 2026-10-10 | Renamed Prooflock: The Dead Canary Protocol (PP-SPEC-077). Swarm renamed Flock. Added mutation and novelty, embargoed 0day canaries, wild canaries, witness coverage. |
| 0.2.1 | 2026-10-10 | Renamed Prooflock: The Dead Canary Protocol. |
| 0.2.2 | 2026-10-10 | Sole author Craig Ellrod. Patent rights reserved by Craig Ellrod and Nebulonium, Inc. Acknowledgment of Josh Waldrep for receipt-based verification work. |
| 0.3.0 | 2026-10-10 | Added Section 15, Continuous Mode and Drift: DUT Fingerprint, trickle and triggered runs, silent drift, witness calibration, black hole drift, result series. Renumbered later sections. |
| 0.3.1 | 2026-10-10 | Control Under Test (CUT) renamed Device Under Test (DUT); added Solution Under Test (SUT) and Terminology Lineage (2.1) citing Technical Marketing (2008). |
| 0.4.0 | 2026-10-10 | Restored Control Under Test (CUT) as a single control inside the DUT. Added Test Hierarchy SUT, DUT, CUT (2.2), differential CUT attribution, target level in commitments, per-level rates, CUT Fingerprints. |
| 0.5.0 | 2026-10-10 | Added Section 16, Operating Modes (Bounded, Production Stream), and Section 17, Technology Profiles. Specified commitment domain tag, Merkle leaf and node prefixes, and order-seed derivation (Section 9). Added roost, molt, clutch to terminology. Renumbered later sections. |
