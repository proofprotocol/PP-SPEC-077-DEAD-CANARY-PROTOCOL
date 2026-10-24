# ProofSwarm: The Dead Canary Protocol (DCP)

*A Proof Protocol specification*

> **Ownership and Attribution Notice**
>
> This specification is authored by **Craig Thomas Ellrod** and is published as part of **Proof Protocol**. Copyright (c) 2026 Craig Thomas Ellrod.
>
> Any use, implementation, derivative, citation, or incorporation of this specification, in whole or in part, MUST attribute **Craig Thomas Ellrod and Proof Protocol**. This requirement applies to standards bodies, working groups, consortia, and commercial implementations.
>
> This specification is licensed under the Proof Protocol License 1.0 (see LICENSE.md); text Apache License 2.0 under Part A. Original inventor: Craig Thomas Ellrod (ORCID 0009-0004-1058-7666).
>
> **Patents.** Patent terms are in [PATENT-SCHEDULE.md](PATENT-SCHEDULE.md). Claims not listed there are reserved by Craig Thomas Ellrod. Licensing: 1proofprotocol@gmail.com.
>
> **Acknowledgment:** Josh Waldrep, for his receipt-based verification work.
>
> This specification is related to the Proof Economy Prior Art Declaration, DOI [10.5281/zenodo.21379780](https://doi.org/10.5281/zenodo.21379780).

| Field | Value |
|---|---|
| Spec ID | PP-SPEC-077 |
| Version | 0.8.1 (Draft) |
| Date | 2026-10-23 |
| Status | Draft for public record |
| Maintainer | Craig Thomas Ellrod (Proof Protocol) |

---

## Abstract

ProofSwarm, the Dead Canary Protocol (DCP), produces proof of efficacy for a security control.

A Proof Swarm of canaries goes in. Not all of them come out. Good canaries are mixed with bad canaries, and neither the Device Under Test (DUT) nor the standby Proof Witness can tell them apart. Every canary is committed before release. The Proof Witness, positioned where an attack's effect would land and operating out of band from the control, records which canaries lived and which died. After the run, commitments are revealed and outcomes are adjudicated as Units of Proof.

Because every canary is committed in advance, any effect the Proof Witness observes that is not in the committed Proof Swarm did not come from the protocol. DCP therefore also surfaces real attacks in the wild (Section 13).

DCP measures **outcome**, not detection. A control that alerts on an attack that still succeeds has failed.

## Introduction: Why This Specification Exists

### The problem this family of specifications solves

Nobody can price security risk, because nobody can measure security efficacy. Every control, whether bought, built, or adopted, is described by the party that made it: a datasheet, a demo, a Provider-funded report, a design document, a dashboard of alerts. Implementors choose controls on those descriptions. Insurers underwrite on questionnaires that ask whether controls exist, not whether they work. Regulators supervise against attestations. Each of them is relying on the word of someone with a stake in the answer, and none of them has proof of what a control actually does when an attack arrives.

Agentic AI makes the gap wider and more expensive. An agent acts inside the system with legitimate credentials, decides its next step from text it has just read, and can be persuaded to do what its owner never authorized. The losses it can cause are new, and the controls sold to contain it have no track record. When risk cannot be measured, it is excluded, restricted, or priced as if every control were equally good, which punishes the controls that work and rewards the ones that only claim to.

The Proof Protocol specifications replace description with proof. PP-SPEC-077 measures what a security control did to committed test traffic. PP-SPEC-078 measures whether an agent containment control stopped an agent that tried to break its policy. PP-SPEC-079 makes those measurements independent of whoever built the control, and comparable across controls of any origin. PP-SPEC-080 lets the parties who pay for risk, insurers, regulators, and Implementors, state in advance what proof they will accept. Together they produce records that a person or a machine can verify without trusting the party the record is about.

**This specification's part:** the measurement of a security control, in any environment, legacy or agentic.

### Why this specification

Every security product is sold on a claim of efficacy, and almost none of them has ever been held to it.

The Implementor gets a datasheet, a demo the Provider drives, a third-party report the Provider paid for, and a dashboard that shows alerts. None of these answers the only question that matters: when a real attack arrives, in this environment, against this configuration, on an ordinary day, does the attack reach the thing it was aimed at or not? The Provider cannot answer it, because the Provider grades its own homework. The lab cannot answer it, because the lab is not this environment. The dashboard cannot answer it, because an alert is not a stop. And the Implementor cannot answer it, because by the time the answer arrives it is called an incident.

The result is an industry that runs on self-attestation. Providers attest to their own efficacy; Implementors attest to their own compliance; auditors attest that the attestations exist. Controls are confirmed to be present, configured, and logging. Whether they work is assumed.

This specification exists to replace that assumption with a measurement that nobody in the transaction can bend.

The method is old and borrowed from every discipline that has had to prove something to a skeptic. You do not inspect every molecule in a pipe; you add a dye and see where it comes out. You do not trust the drug company's claim; you give the pill to some and a sugar pill to others and let neither the patient nor the doctor know which. ProofSwarm does the same for a security control. It sends a Proof Swarm of canaries, some carrying real attacks and some carrying ordinary traffic, with every canary's true nature sealed in a hash before the control ever sees it. An independent witness, standing where the damage would land and reachable by nobody who sells the control, records which canaries arrive. Only after the witness has signed are the seals opened and the outcomes assigned. The order and the mix were chosen by a public randomness beacon, not by anyone with a stake. Every canary ends in exactly one bucket, and the buckets for "we could not see" and "the environment failed" are separated from the bucket for "the control stopped it," so that absence of evidence can never be dressed as evidence of efficacy.

What comes out is not a score, a grade, a pass, or a certificate. It is a set of Units of Proof: single, signed, time-anchored facts about what one attack did in one system on one day. Rates can be computed from them; judgments can be made on them; markets can be built on them. The specification does none of those things. It makes the facts, and it makes them in a form that cannot be rewritten after the fact by the party they embarrass.

**Scope.** This specification produces proof of efficacy: a record of what a control did to committed test traffic. It does not produce proof of control, meaning a record that a control exists, is configured, or is governed. Presence of a control is a precondition for a run, not a result of one. No record produced under this specification may be cited as proof of control, and no control attestation, from any framework, may be cited as proof of efficacy. The two questions are different, and the second does not answer the first.

**Applicability.** This specification applies to any environment in which a control is supposed to stop something. That includes the whole of legacy cybersecurity: network and perimeter, web application, endpoint and host, network detection, identity and access, cloud workload and container, data and secrets (Section 17). It includes agentic AI systems, where the controls are prompt and tool guardrails, policy engines, egress filters, and sandboxes, and where the Agent Under Test can itself be a target (2.2, 17.9). It includes controls of every provenance: commercial, open source, custom-built, managed, and platform-native. The canary changes with the technology profile; the protocol does not. Every record it produces is written for two readers at once, a person auditing it and an agent or API acting on it, and both reach the same answer from it (21.14). A method that worked only for one generation of controls would be a product. This is a protocol.

**What this is not.** It is not a breach and attack simulation product, which plays recorded attacks and reads the Provider's own logs. It is not a penetration test, which depends on the skill of the tester and leaves no committed record. It is not a benchmark, which measures the product in the benchmark's environment rather than the Implementor's. It is a protocol: a set of rules under which anyone, using any tools, can produce proof of efficacy that any other party can verify without trusting the producer.

## 1. Conventions

The key words MUST, MUST NOT, REQUIRED, SHALL, SHALL NOT, SHOULD, SHOULD NOT, RECOMMENDED, MAY, and OPTIONAL are to be interpreted as described in RFC 2119 and RFC 8174.

## 2. Terminology

- **Agent Under Test (AUT):** An autonomous or tool-calling agent inside the SUT whose own conduct is under test. An AUT is an actor, not a control: a DUT stops attacks, an AUT may commit them. An AUT's conduct is adjudicated under PP-SPEC-078 (No Bros Jail Mode Protocol: The Jailed Canary Protocol), not under this specification.
- **Control Under Test (CUT):** A single control inside a DUT whose efficacy is being measured: one rule, policy, signature, detection, or guardrail function.
- **Device Under Test (DUT):** A security product, configuration, or agent guardrail containing one or more CUTs.
- **Solution Under Test (SUT):** The full deployment the Proof Swarm enters: one or more DUTs plus the protected environment, its Effect Points, and its dependencies.
- **Provider:** The party that builds, maintains, sells, or operates the DUT: a commercial vendor, an open source project, a managed service, a cloud platform, or an internal team. Every rule that constrains the Provider applies to all of them equally.
- **Implementor:** The party that operates, or intends to operate, the SUT in which the DUT is deployed, and for whose benefit a run is usually commissioned.
- **Issuer:** The party that generates the Proof Swarm, holds the labels, and publishes commitments. The Issuer MUST NOT be the Provider.
- **Bad Canary:** A canary that executes a real adversary technique (for example, a MITRE ATT&CK or ATLAS TTP instance) and, if unstopped, produces a defined malicious effect.
- **Good Canary:** A canary that performs a legitimate action and, if unstopped, produces a defined benign effect.
- **Proof Swarm:** The full, ordered set of good and bad canaries for one run. Called Flock in versions 0.2.0 to 0.7.1.
- **Effect Point:** The location where a canary's intended effect lands (target host, data store, identity system, egress sink, agent tool output, or equivalent).
- **Proof Witness:** The standby, independent observer positioned at the Effect Point that records whether each canary's effect occurred.
- **Ingress Observer:** A passive observer at the release point that records that each canary was delivered.
- **Time Anchor:** An external, publicly verifiable time and randomness source (for example, the NIST Randomness Beacon) not controlled by any party to the run.
- **Run:** One complete release of a Proof Swarm against a DUT.
- **Unit of Proof (UoP):** The adjudicated outcome of one bad canary in a valid run (Section 11).
- **Wild Canary:** An effect observed by the Proof Witness that matches no committed canary (Section 13).
- **Witness Coverage Map:** The declared set of Effect Points and effect types the Proof Witness observes (Section 14).
- **DUT Fingerprint:** A hash identifying the exact deployed state of the DUT (Section 15.2).
- **Trickle:** A continuous low-volume Proof Swarm released between full runs (Section 15.3).
- **Silent Drift:** A change in measured behavior with no change in DUT Fingerprint (Section 15.4).
- **Black Hole:** A period during which part of the system disappears for reasons unrelated to any canary or attack (Section 15.6).
- **Registry:** The append-only public ledger where commitment roots, Time Anchor bindings, witness record roots, reveals, fingerprints, result series, findings, and Witness Coverage Maps are published, conforming to PP-SPEC-004 (ProofRegister API). The public instance is proofregister.com (9.6).
- **Color:** The committed kind of a canary: White, Gray, Red, Black, or Gold (5.6.4).
- **Path:** The committed delivery plan of a canary: ingress, effect token, route, effect point, target, cadence, and clutch (5.6.5).
- **Outcome:** What happened to a canary, assigned once after witness records are committed (5.6.6).
- **Effect Token:** A unique, nonce-derived identifier carried in a canary's expected effect, used after reveal to match witness observations to committed canaries (5.4.1).
- **Reference Canary (Gold):** A bad canary testing a technique the Provider has claimed in writing to stop (5.6.4).
- **Claim Finding:** A published record that a Gold canary was Missed, with the Provider claim it falsifies (11.6).
- **Roost:** The Proof Witness's standby state between and after runs (Section 13.1).
- **Molt:** A change in a DUT Fingerprint or CUT Fingerprint (Section 15.2.3).
- **Clutch:** One epoch's committed batch of canaries in Production Stream Mode (Section 16.2).
- **Corpus:** The body of material a Proof Swarm is drawn from: technique catalog, payload families, mutation generators, holdout pool, Gold claim set, good-canary templates, ratio policy (15.2.6).
- **Pigtail:** The short connection between the testing equipment and the SUT: the release path into the ingress on one side, the tap between the Effect Point and the Proof Witness on the other (15.2.7).
- **Harness:** The testing equipment as a whole: every component occupying an Integration Point (Section 18).
- **Segment:** A stretch of a result series over which every fingerprint in 15.7.2 is unchanged (15.7.3).
- **Holder:** The party for whose benefit a run was commissioned, identified by a public key, named in every record the run produces (21.3).
- **Record ID:** The content hash of a record's canonical form, excluding its signature envelope; the same record has the same ID everywhere (21.1).
- **Signature Envelope:** The detached, append-only set of signatures attached to a record (21.4).
- **Registry Receipt:** A signed acknowledgment from a Registry that it has recorded a record under a stated root and Time Anchor pulse (21.5).
- **Bundle:** A record that aggregates a set of Units of Proof or result series by Merkle root under one Holder (21.7).
- **Disclosure Level:** Who may read a record's contents: public, holder-only, embargoed, or sealed (21.9).
- **Conformance Level:** Executed, Conformant, or Registered (21.13).

### 2.1. Terminology Lineage

DUT and SUT follow the competitive test methodology published in Craig Thomas Ellrod, *Technical Marketing: secrets revealed, Strategy and Tactics for Competitive Results*, first edition (StrateQuest, LLC, 2008), ISBN-13 978-0-9822570-0-5, Chapter 4, "Competitive Test", which defines a competitive test as a device under test (DUT), or solution under test (SUT), together with the testing equipment. In this specification the Proof Swarm, observers, and Time Anchor are the testing equipment, and the Proof Witness keeps that equipment independent of the DUT. This specification extends the model one level down with the Control Under Test (CUT), so proof can be attributed to a single control inside a device, and one step sideways with the Agent Under Test (AUT), so an agent inside the solution can itself be the subject of a test. All four terms, SUT, DUT, CUT, and AUT, derive from the book's DUT and SUT. The book's baseline practice of testing with and without the device is the basis for differential attribution (2.2.3).

### 2.2. Test Hierarchy: SUT, DUT, CUT, AUT

Proof is attributed at four levels: SUT, DUT, CUT, and AUT. This specification attributes outcomes to the SUT, DUT, and CUT. The AUT sits beside the DUT inside the SUT, and outcomes caused by its own conduct are attributed to it under PP-SPEC-078:

| Level | Term | Scope | Example |
|---|---|---|---|
| Solution | **SUT** | The full deployment the Proof Swarm enters | A production agent stack with its network, identity, and data stores |
| Device | **DUT** | One security product, configuration, or guardrail inside the SUT | An EDR, a WAF, an agent policy layer |
| Control | **CUT** | One control inside the DUT | A single rule, policy, signature, detection, or guardrail function |
| Agent | **AUT** | One agent inside the SUT whose own conduct is under test | A coding agent, an MCP-connected assistant, one member of a multi-agent system |

2.2.1. An SUT contains one or more DUTs and zero or more AUTs. A DUT contains one or more CUTs.

2.2.2. Every bad canary MUST declare, in its commitment, the level it targets (`sut`, `dut`, or `cut`) and the identifier of the target at that level.

2.2.3. **CUT attribution is earned, not reported.** A Stopped outcome MAY be attributed to a single CUT only by differential evidence: matched runs in an otherwise identical SUT with the CUT active and with the CUT disabled or bypassed, using fresh canaries of the same technique. A DUT log or alert naming the control that acted is verification evidence. It MAY be recorded as an annotation and MUST NOT by itself attribute an outcome to a CUT.

2.2.4. An outcome that cannot be attributed to a single CUT MUST be attributed to the DUT, and an outcome that cannot be attributed to a single DUT MUST be attributed to the SUT. Attribution never moves to a finer level without the evidence in 2.2.3.

2.2.5. **AUT attribution is made under PP-SPEC-078.** An agent guardrail is a DUT, and its rules are CUTs. The agent it protects is an AUT. Under this specification the AUT is the path an attack travels: a canary that reaches an Effect Point through an agent is attributed to the SUT, DUT, or CUT that failed to stop it, never to the agent. Outcomes caused by the agent's own conduct (an offense, an unprovoked offense, or bait declined within policy) are attributed to the AUT, and are produced only by a PP-SPEC-078 run. Together the two specifications attribute proof at all four levels.

## 3. Assurance Tiers

Proof Protocol distinguishes three tiers of assurance. DCP is a method for the proof tier.

| Tier | Definition |
|---|---|
| Verification | Self-attestation by the party responsible for the control. A legitimate baseline, not a ceiling. |
| Validation | One step above verification. |
| Proof | A sealed, witnessed, and anchored record of outcome under adversarial conditions, built from independent evidence by a method the party responsible for the control cannot steer. Evidence is not proof; proof contains evidence. |

A log entry, alert, or telemetry record produced by the DUT or the Provider is verification evidence. It MUST NOT be presented as proof under this specification.

## 4. Roles and Independence

4.1. The Provider MUST NOT generate canaries, hold labels, operate the Proof Witness, operate the Time Anchor, adjudicate, hold signing keys for any record of the run, or occupy any other Integration Point (18.1.6).

4.2. The Proof Witness MUST be operated by a party other than the Provider. It SHOULD be operated by the customer or a third party rather than the Issuer.

4.3. The DUT MUST NOT be able to observe, delay, modify, or suppress Proof Witness records.

4.4. Any party with a financial interest in the outcome MUST be disclosed in the run record.

## 5. Canary Design

5.1. **Real technique.** Each bad canary MUST execute a real technique capable of producing its malicious effect. Inert markers, signatures, or test strings MUST NOT be used as bad canaries.

5.2. **Indistinguishability.** Good and bad canaries MUST be indistinguishable to the DUT and to the Proof Witness by any feature other than their actual behavior. Format, size distribution, protocol, source, timing, and metadata SHOULD be drawn from the same distributions.

5.3. **Boundary good canaries.** Good canaries SHOULD include near-boundary look-alikes of the bad canaries, so that false blocks near the decision boundary are measured.

5.4. **Defined effects.** Every canary MUST have a defined, machine-checkable expected effect at a declared Effect Point, recorded in its commitment.

5.4.1. **Effect token.** Every canary's expected effect MUST include an effect token: an identifier derived from `nonce_i`, unique per canary, visible at the Effect Point, and committed as part of Path (5.6.5). Effect tokens MUST be drawn from the same format distribution as the domain's ordinary identifiers (filenames, session identifiers, hostnames, object keys, usernames) so that they do not distinguish canaries from real traffic (5.2). Effect tokens are single use and MUST NOT be reused across canaries or runs.

5.5. **Safety.** Bad canary effects MUST be contained to the test environment and SHOULD be reversible.

### 5.6. Three Axes: Color, Path, Outcome

Every canary is described on exactly three axes. Each axis answers one question, is set at one time, and is never changed afterward.

| Axis | Question | Set when | Set by | Sealed in commitment |
|---|---|---|---|---|
| **Color** | What kind of canary is this? | Before release | Issuer | Yes |
| **Path** | Where is it going and how is it sent? | Before release | Issuer | Yes |
| **Outcome** | What happened to it? | After witness records are committed | Adjudication (Section 11) | No. Recorded once, never revised |

5.6.1. Color and Path MUST be fixed in the canary's commitment (Section 9) before release. Outcome MUST NOT be assigned until the Proof Witness has committed its records (10.4).

5.6.2. Outcome never alters Color or Path. A canary keeps the Color and Path it was committed with regardless of what happened to it.

5.6.3. The DUT and the Proof Witness MUST NOT be able to distinguish Color from any feature other than behavior (5.2). Color is a sealed label, not a visible marking.

#### 5.6.4. Color

| Color | Kind | Label | Role |
|---|---|---|---|
| **White** | Good canary | good | Ordinary legitimate action. Negative control. Proves the path is up. Feeds False Block Rate. |
| **Gray** | Boundary good canary | good | Legitimate action built to resemble a bad canary (5.3). Measures false blocks at the decision boundary. |
| **Red** | Bad canary, known or mutated variant | bad | Real technique drawn from the public pool (6.1). Feeds Efficacy Rate; mutated variants also feed Novelty Efficacy Rate. |
| **Black** | Holdout canary | bad | Private variant never published or demonstrated (6.2). Carries the `embargoed` flag when it exploits an undisclosed vulnerability (Section 7). |
| **Gold** | Reference canary | bad | A technique the Provider has claimed in writing to stop. Positive control. Gold Stopped confirms the witness and path; Gold Missed is a Claim Finding (11.6). |

5.6.4.1. Every committed canary MUST carry exactly one Color from White, Gray, Red, Black, or Gold. A Wild Canary (Section 13) has no Color, no Path, and no Outcome: it was never committed, so it is not on these axes. It is a separate evidence class.

5.6.4.2. Gold canaries MUST cite the Provider claim they test: document, version, and the specific statement. The claim MUST predate the run and MUST be included in the run record.

5.6.4.3. A Proof Swarm MUST contain White and Red. It SHOULD contain Gray and Black. It MAY contain Gold.

#### 5.6.5. Path

Path is the committed delivery plan for one canary.

| Field | Meaning |
|---|---|
| `ingress` | The release point where the Ingress Observer records delivery (10.3). |
| `effect_token` | Unique per-canary identifier, derived from the nonce, visible at the Effect Point (5.4.1). |
| `route` | The ordered list of DUTs the canary is expected to traverse. |
| `effect_point` | Where the canary's effect lands if unstopped (Section 2). |
| `target` | The level (`sut`, `dut`, `cut`) and identifier the canary tests (2.2.2). |
| `cadence` | `full` for a scheduled or triggered run, `trickle` for continuous low-volume release (15.3). |
| `clutch` | In Production Stream Mode, the epoch batch this canary belongs to (16.2). Absent in Bounded Mode. |

5.6.5.1. Path MUST be fixed in the commitment. A canary observed at an Effect Point other than its committed `effect_point` is not that canary; the observation is a Wild Canary (Section 13).

5.6.5.2. Cadence is a Path field, not a Color. A trickle canary is a White, Gray, Red, Black, or Gold released at low volume.

#### 5.6.6. Outcome

| Outcome | Applies to | Meaning |
|---|---|---|
| **Stopped** | Red, Black, Gold | Effect did not occur. The canary died. |
| **Missed** | Red, Black, Gold | Effect occurred, regardless of any alert. |
| **Passed** | White, Gray | Effect occurred. |
| **False block** | White, Gray | Effect did not occur. |
| **Void** | Any committed color | Released into or landing inside a black hole window (15.6.5). Never scored, never backfilled. |
| **Undelivered** | Any committed color | No Ingress Observer record. Excluded from the run (11.3). |
| **Sealed** | Black with `embargoed` | Outcome adjudicated but withheld until coordinated disclosure (7.3). Published as commitment only. |
| **Blind** | Any committed color | Committed Effect Point or effect type outside the Witness Coverage Map (14.3). Never scored. |

5.6.6.1. Each committed canary receives exactly one Outcome, once. Void and Undelivered are outcomes, not colors; the canary keeps its Color.

5.6.6.2. `detected` is an annotation, not an Outcome. A Missed canary with `detected: true` is still Missed (11.2).

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

## 8. Proof Swarm Construction

8.1. The Proof Swarm MUST contain both good and bad canaries.

8.2. The good-to-bad ratio and the release order MUST be randomized per run, seeded from a Time Anchor pulse published after commitment (Section 9).

8.3. The ratio and order MUST NOT be disclosed to the Provider, the DUT, or the Proof Witness before the run concludes.

8.4. Good canaries SHOULD make up no less than 30% of the Proof Swarm.

## 9. Commitment and Reveal

9.1. Before release, the Issuer MUST compute for each canary a content digest and a commitment:

```
d_i = H("DCP-2:content" || canary_content_i || content_salt_i)
c_i = H("DCP-2:canary" || d_i || color_i || path_i || expected_effect_i || flags_i || nonce_i)
```

where `H` is SHA-256 or stronger, `"DCP-2:content"` and `"DCP-2:canary"` are fixed ASCII domain-separation tags, `content_salt_i` is at least 128 bits of fresh randomness that prevents `d_i` from being matched against known techniques, `color_i` is one of `white`, `gray`, `red`, `black`, `gold` (5.6.4), `path_i` is the canonical serialization of the Path fields including the effect token (5.6.5), `flags_i` records `embargoed` status and any Gold claim reference, and `nonce_i` is at least 128 bits of fresh randomness.

9.2. The Issuer MUST build a Merkle tree over all `c_i` and publish the root `R` bound to a Time Anchor pulse `T_commit` before the first release. Leaf hashes MUST be computed as `H(0x43 || c_i)` and interior nodes as `H(0x45 || left || right)`, so that leaves and interior nodes cannot be confused. An odd node at any level is promoted unchanged.

9.3. Ordering and ratio randomization MUST use the second Time Anchor pulse issued after `T_commit`, so the Issuer cannot choose the order after seeing the commitment and cannot time the commitment against an imminent pulse. The order seed MUST be derived as `HKDF-SHA256(salt = R, ikm = pulse_output, info = "DCP-2:order")`, and the Proof Swarm MUST be permuted by a Fisher-Yates shuffle that consumes the seed as a big-endian stream.

9.4. **Reveal.** After the run, the Issuer MUST reveal every canary except embargoed canaries (Section 7) in two parts.

9.4.1. **Public reveal.** For each canary: `d_i`, `color_i`, `path_i`, `expected_effect_i`, `flags_i`, and `nonce_i`, at Disclosure Level `public` (21.9). Any verifier MUST be able to recompute `R` from the public reveal and the embargoed commitments. The public reveal is sufficient to adjudicate the run (Section 11) and to match witness observations (Section 13).

9.4.2. **Content reveal.** For each canary: `canary_content_i` and `content_salt_i`, at Disclosure Level `holder_only` (21.9), released to the Holder and to Content Verifiers. A Content Verifier is a party the Holder or the Issuer authorizes in writing to check that each `d_i` matches its content and that each bad canary executes a real technique (5.1). Content Verifiers MUST disclose their interests (Section 4) and MAY be bound to confidentiality.

9.4.3. The Issuer MAY release the content reveal at Disclosure Level `public`.

9.4.4. Every published result MUST state whether the content reveal was checked, by which Content Verifier, and on what date. A result whose content reveal no one has checked MUST say so.

9.4.5. Runs whose commitments use the `DCP-1:canary` tag (versions before 0.8.0) remain valid under the rules of the version they were committed under.

9.5. A run whose reveal does not reproduce `R` is invalid.

9.6. **Registry.** Every artifact this specification requires to be published, including the commitment root `R` and its Time Anchor binding, the witness record root, the reveal, DUT and CUT Fingerprints, Units of Proof, result series, findings, and the Witness Coverage Map, MUST be published to a Registry conforming to PP-SPEC-004. The Registry record identifier MUST be carried in every Unit of Proof and every result series record as `proofregister_uri`. Publication anywhere else is additional, never a substitute.

9.7. **Registration precedes publication.** A run is Conformant only if its result record is registered under 9.6 before any result derived from it is published or cited, and the Registry Receipt (21.5) is included in the published result. A run that is executed under this specification but not registered MAY be described as "executed under PP-SPEC-077". It MUST NOT be described as Conformant and it produces no Units of Proof (21.13).

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
  "color": "red | black | gold",
  "path": {"ingress": "string", "effect_token": "string", "route": ["dut id"], "effect_point": "string", "target": {"level": "sut | dut | cut", "id": "string"}, "cadence": "full | trickle", "clutch": "string or null"},
  "claim": "object when color is gold, else null",
  "attribution_level": "sut | dut | cut",
  "sut": "solution identifier",
  "dut": "product name",
  "dut_fingerprint": "ea55dce4aa233b4d27e047cabf8a6a2e68475b626dbdc7a6d5d4cfb8bff437c6",
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
  "proofregister_uri": "https://proofregister.com/record/PR-2026-NNNNN",
  "registry_receipt": "hash of the Registry Receipt (21.5)",
  "holder": {"id": "string", "public_key": "multibase or JWK thumbprint"},
  "disclosure": "public | holder_only | embargoed | sealed",
  "valid_through": "RFC 3339 timestamp or null (21.8)",
  "signatures": [{"role": "issuer | witness | holder | registry | endorser", "key": "string", "sig": "hex"}],
  "disclosed_interests": []
}
```

`uop_id` is the Record ID (21.1). `signatures`, `proofregister_uri`, and `registry_receipt` are registration fields and are excluded from the hash that produces `uop_id`.

11.6. **Claim Findings.** A Gold canary adjudicated Missed MUST be recorded as a Claim Finding: the cited Provider claim, the technique, the variant, the DUT Fingerprint, and the Unit of Proof. Claim Findings MUST be published with the run. A Gold canary adjudicated Stopped is a Unit of Proof like any other bad canary and additionally confirms witness and path function for that run.

## 12. Run Metrics

| Metric | Definition |
|---|---|
| Efficacy Rate | Stopped / (Stopped + Missed) |
| Novelty Efficacy Rate | Efficacy Rate over mutated and holdout variants only |
| Claim Accuracy Rate | Gold Stopped / (Gold Stopped + Gold Missed). The Provider's written claims graded against outcome. |
| False Block Rate | False block / (Passed + False block) |
| Detection-Only Rate | Missed with `detected: true` / bad canary total |
| Path Validity | Good canaries delivered and passed / good canary total |
| Black Hole Rate | Canaries voided by black holes / canaries released; and black hole time / observed time |
| Witness Accuracy | Proof Witness agreement with committed canary effects, per run |

Efficacy Rate MUST NOT be published without False Block Rate. A control that blocks everything is not efficacious.

All rates MUST be reported at the attribution level of the underlying outcomes: per SUT, per DUT, and per CUT where CUT attribution is established (2.2.3). Rates MUST NOT be rolled down to a finer level than the proof supports.

## 13. Wild Canaries

13.1. The Proof Witness MAY remain in standby, its roost, at the Effect Points between and after runs.

13.2. After reveal, each Proof Witness observation is matched to the committed Proof Swarm by effect token, Effect Point, and release window. An observation that matches a committed canary belongs to that canary. An observation that matches no committed canary is a **Wild Canary**: a real attack, a real fault, or a real false alarm that did not originate from the protocol. An observation carrying a committed effect token with no corresponding Ingress Observer record, or outside its release window, is neither: it MUST be recorded as a **replayed canary** finding (Section 20) and MUST NOT be scored.

13.3. Wild Canaries MUST be recorded with timestamp, Time Anchor binding, Effect Point, and observed effect, and SHOULD be escalated for investigation.

13.4. Wild Canaries are NOT Units of Proof. They lack pre-commitment and a known label. They MUST be reported as a separate evidence class, `observed_in_wild`, at a lower assurance level than controlled results.

13.5. Ongoing controlled runs calibrate the standby Proof Witness. Its demonstrated accuracy on committed canaries SHOULD be published alongside any Wild Canary data.

## 14. Witness Coverage

14.1. The Proof Witness only sees the effects it watches. Every result MUST be published with its Witness Coverage Map.

14.2. Effects outside the Witness Coverage Map are blind spots. Results MUST NOT be presented as covering effect types or Effect Points outside the map.

### 14.3. Absence Ladder

A canary the Proof Witness did not observe contributes nothing to proof until the reason it was not observed is known. Every non-observation MUST be classified as exactly one of the following, in this order of precedence:

| Rung | Condition | Scores? |
|---|---|---|
| **Blind** | The canary's committed Effect Point or effect type is outside the Witness Coverage Map (14.1) | No. The witness was not looking. |
| **Void** | Inside the map, but a black hole window covers the release, the landing, or the witness (15.6) | No. The witness was looking; the thing it watched was gone. |
| **Null** | Inside the map, path live, no effect observed | Yes. This is a dead canary: Stopped for a bad canary, False block for a good one (11.1). |

14.3.1. Blind is checked before Void, and Void before Null. A canary MUST NOT be scored Stopped or False block unless its non-observation is Null.

14.3.2. **Closed accounting.** For every run and every clutch, the released count MUST equal the sum of Stopped, Missed, Passed, False block, Void, Undelivered, Sealed, and Blind. A run in which it does not is invalid.

14.3.3. **Published shares.** The Blind share and the Void share (each over released canaries) MUST be published beside every rate in Section 12 that they would otherwise inflate. A rate published without its Blind and Void shares is non-conforming.

14.3.4. A Blind canary is a defect in the Mine Plan or the coverage map, not in the DUT. It MUST be recorded as a finding of kind `blind`, and the Issuer SHOULD NOT commit canaries to Effect Points the declared coverage map does not include.

## 15. Continuous Mode and Drift

A single run proves a control at one moment. Controls, environments, threats, and witnesses change. Continuous Mode keeps proof current and turns change into proof.

### 15.1. Drift Types

Drift is any change, over time, in anything that a result depends on. The thing under test is only one of those things. The inputs, the testing equipment, the connections between them, and the observer drift too, and a result series that tracks only the DUT will attribute every other drift to the DUT. Every drift type below MUST be fingerprinted, anchored, and shown in the result series (15.7), and a change in any of them marks the series as a new segment.

**Drift of the thing under test**

| Drift | Meaning | Detected by |
|---|---|---|
| **Control drift** | A DUT or a CUT changes: version, configuration, policy, rule set, signatures, or, for AI controls, model, prompt, or tool permissions. | DUT and CUT Fingerprints (15.2); silent drift (15.4) |
| **Environment drift** | The SUT changes around the DUT: Effect Points, topology, dependencies, identities, data stores. | SUT Fingerprint (15.2.5); Witness Coverage Map versioning (15.5.3) |
| **Black hole drift** | Part of the system disappears for any period of time for reasons unrelated to any canary or attack (Section 15.6). | Liveness probes (15.6) |

**Drift of the inputs**

| Drift | Meaning | Detected by |
|---|---|---|
| **Corpus drift** | The canary corpus changes: the technique catalog, the payload families, the mutation generators, the holdout pool, the Gold claim set, the good-canary templates, or the ratio policy. A Proof Swarm drawn from a different corpus is a different test, and a rate change after corpus drift says nothing about the DUT. | Corpus Fingerprint (15.2.6) |
| **Threat drift** | Adversary techniques in the wild change faster than the corpus. The corpus is stale against the threat even though it has not changed. | Wild Canary findings (Section 13); novelty efficacy trend; corpus age |
| **Profile drift** | The Technology Profile the run uses changes version, altering canary shapes, Effect Point definitions, or the token shaper. | Profile version in the Interface Manifest |

**Drift of the testing equipment**

| Drift | Meaning | Detected by |
|---|---|---|
| **Harness drift** | Any component occupying an Integration Point changes: Issuer, Release Driver, Ingress Observer, Fingerprint Capture, Liveness Prober, Adjudicator, Registry client, Signer. A new adjudicator version can move a rate without a single canary behaving differently. | Component Fingerprints (18.1.2); Interface Manifest diff |
| **Pigtail drift** | The connection between the testing equipment and the SUT changes: the release path into the ingress, the tap or sensor between the Effect Point and the Proof Witness, the credentials or network route either uses, a load balancer or proxy inserted or removed in that short span. The pigtail is the piece nobody owns and everybody assumes. | Pigtail Fingerprint (15.2.7); ingress and effect latency baselines; Witness Calibration canaries (15.5) |
| **Witness drift** | The Proof Witness loses coverage or accuracy over time, or its coverage map changes. | Witness Calibration (15.5); Blind share trend (14.3) |
| **Anchor drift** | The Time Anchor source changes or becomes unavailable, breaking the pulse sequence a run depends on. | Pulse continuity check at commitment and reveal |

**Drift of the rules**

| Drift | Meaning | Detected by |
|---|---|---|
| **Specification drift** | The run moves to a new version of this specification or of the governing engagement specification, changing an Outcome rule, a validity rule, or a metric definition. | Specification version in the Interface Manifest; results across versions MUST NOT be joined in one series without a declared mapping |
| **Policy drift** (PP-SPEC-078) | The Declared Policy an agent is judged against changes. | Policy hash and anchor (078 5.2) |

15.1.1. A rate change coincident with any input, equipment, or rule drift MUST be reported as unattributed until a run with the drifted element held constant isolates the cause. The series MUST show the drift marker at the point it occurred.

15.1.2. The DUT Provider is responsible for none of the drifts in the second, third, and fourth tables, and MUST NOT be charged with a rate change they explain. Equally, the Issuer MUST NOT silently refresh the corpus or the harness to move a rate in either direction; an undeclared corpus or harness change is a finding against the Issuer of the same kind as an undeclared molt is against the Provider (15.4.3).

### 15.2. DUT Fingerprint

15.2.1. Every run MUST record a DUT Fingerprint: a hash over the DUT's version, configuration, policy, rule and signature sets, and, for AI controls, model identifier, system prompt, and tool permissions.

15.2.2. Results are bound to the DUT Fingerprint they were produced against. Results MUST NOT be presented as applying to any other fingerprint.

15.2.3. When the DUT Fingerprint changes (a molt), all prior results for the DUT MUST be marked `stale` until a valid run completes against the new fingerprint.

15.2.4. The Fingerprint MUST be captured by a party other than the Provider, or verified independently against the deployed DUT. A Provider-declared fingerprint alone is verification evidence.

15.2.5. **CUT Fingerprint.** Every CUT with attributed results MUST have its own fingerprint: a hash over that control's rule, policy, signature, or guardrail definition and its parameters, captured under 15.2.4.

15.2.6. A change to a CUT Fingerprint marks `stale` the results attributed to that CUT and all DUT-level and SUT-level results that include it. Results attributed to other CUTs in the same DUT remain current if their own fingerprints are unchanged.

15.2.7. **SUT changes.** A declared or detected change to the SUT is environment drift and triggers a full run under 15.3.3.

15.2.5. **SUT Fingerprint.** The Issuer or the Fingerprint Capture component MUST capture a hash over the declared SUT state the run depends on: Effect Point identifiers and versions, the route list, identity and data-store identifiers, and the Witness Coverage Map version. Captured under the same independence rule as 15.2.4.

15.2.6. **Corpus Fingerprint.** The Issuer MUST publish a hash over the canary corpus the Proof Swarm was drawn from: technique catalog version, payload family identifiers, mutation generator versions and seeds policy, holdout pool commitment (contents sealed, size and commitment public), Gold claim set hash, good-canary template set, and ratio policy. The Corpus Fingerprint is committed with `R` (9.2) and carried in every result series record. A Proof Swarm drawn from a different Corpus Fingerprint starts a new series segment.

15.2.7. **Pigtail Fingerprint.** The party operating the Release Driver and the party operating the Proof Witness MUST each publish a hash over the connection they use to reach the SUT: ingress endpoint and route, release credentials or identity, sensor or tap identifiers, Effect Point access path, and any intermediary (proxy, load balancer, gateway) in that path. The two halves are published separately and neither party may alter the other's. A Pigtail Fingerprint change marks a new series segment and MUST trigger the Witness Calibration canaries of 15.5 before any further canary is scored.

### 15.3. Cadence

15.3.1. **Trickle.** In Continuous Mode, the Issuer MUST release a continuous low-volume Proof Swarm (a trickle) between full runs. Trickle canaries follow all rules of Sections 5 through 10, including commitment, blinding, and label indistinguishability.

15.3.2. **Scheduled runs.** A full Proof Swarm MUST be run on a cadence declared before Continuous Mode begins.

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

15.6.6. **Attribution.** An outage caused by the DUT is not a black hole. If the DUT fails closed, crashes, or drops traffic, the effect on good canaries is a False block and MUST be scored as such. Attribution to the DUT or to an unrelated cause MUST rest on the independent liveness evidence in 15.6.3, not on Provider statements.

15.6.7. **Witness black holes.** While the Proof Witness is dark, there is no proof. Results MUST NOT be inferred for that window, and Wild Canaries cannot be observed during it. Witness black hole windows MUST be published.

15.6.8. **Black hole rate.** The share of time and the share of canaries lost to black holes MUST be published with every result series. A high black hole rate limits what the results can prove.

15.6.9. **No backfill.** Canaries voided by a black hole MUST NOT be replaced by re-labeling, re-timing, or reusing their commitments. New canaries require new commitments.

### 15.7. Result Series

15.7.1. In Continuous Mode, results MUST be published as a time series per DUT Fingerprint, including stale periods, silent drift findings, undeclared change findings, witness calibration, and black hole windows.

15.7.2. A point-in-time result MUST carry its DUT Fingerprint, SUT Fingerprint, Corpus Fingerprint, Pigtail Fingerprints, the Interface Manifest hash (which carries every Component Fingerprint), the specification version, its timestamp, and its status: `current` or `stale`.

15.7.3. **Segments.** A series is divided into segments at every change of any fingerprint in 15.7.2. Rates MUST be computed within a segment. A rate across segments MAY be shown only with the segment boundaries drawn and the drift type at each boundary named. A series whose segments are shorter than the Mine Plan's minimum run count is reported as `fragmented`, which is a finding about the stability of the test, not about the DUT.

## 16. Operating Modes

ProofSwarm deploys in two complementary modes, each serving different deployment contexts and risk postures.

### 16.1. Bounded Mode

Bounded Mode is the lab, staging, or scheduled-window deployment: a test run with a declared start and end time, a fixed committed Proof Swarm, sealed records, and a publishable report.

**16.1.1. Structure.** A Bounded Mode run declares start and end times, Effect Points, the DUT, and the SUT before release (Sections 5.4, 2.2); commits a fixed Proof Swarm size and composition (Section 8); runs the full sequence of commitment, blinding, release, observation, sealing, adjudication, publication (Sections 5-14); and produces one result report per run with per-run fingerprints, rates, and findings (Section 11).

**16.1.2. Proof model.** Every canary has a committed outcome; every outcome is witnessed, sealed, and adjudicated. Voided canaries and outages are recorded and published. Results are point-in-time: they prove efficacy against the SUT, DUT, and CUT as deployed on the run date.

**16.1.3. Use cases:** Bounded Mode is appropriate for pre-deployment validation, Provider evaluation, staged rollouts, security incident response testing, and published proofs of control efficacy.

### 16.2. Production Stream Mode

Production Stream Mode is the in-production deployment: a continuous release of canaries into live traffic, with rolling epoch-based commitments, no declared end, and ongoing proof series.

**16.2.1. Structure.** Production Stream Mode commits canaries in rolling epochs (a clutch every N minutes or hours, each with its own sealed answer key and committed effect types, and no fixed end time); runs the full commitment and blinding rules on every clutch (each clutch is independent, commitment precedes release, labels stay sealed until voiding or publication per Sections 8-10); observes outcomes in the live Effect Points as canaries are released and the DUT responds (Section 10); publishes rolling result series per CUT Fingerprint with per-epoch results, aggregated rates, and continuous drift findings (Section 15.7); and triggers full runs on Fingerprint change, declared environment change, or silent drift detection (Section 15.3.3).

**16.2.2. Proof model.** Every canary is committed, released into production, and observed. The Proof Witness runs out-of-band continuously. Results accumulate as a time series bound to Fingerprint versions, not as point-in-time reports. Stale results, silent drift, and undeclared changes are published as findings.

**16.2.3. Constraints.** Production Stream Mode requires an out-of-band Proof Witness on a production Effect Point isolated from the DUT (Section 10.2); continuous Time Anchor service for anchoring every canary and every liveness check (Sections 9, 10.4); black hole detection independent of the DUT (Section 15.6.3); declared tolerance thresholds for good canary pass rate, black hole void rate, and silent drift (Sections 15.4, 15.6); and published fingerprints and result series, with stale and drift findings, updated no less than weekly (Section 15.7).

**16.2.4. Use cases:** Production Stream Mode is appropriate for continuous verification of live controls, real-time detection of silent drift or undeclared updates, compliance monitoring, and ongoing proof that a control remains effective across production mutations.

**16.2.5. Real-time absence.** Every clutch MUST publish its Blind share, Void share, and Null count beside its rates (14.3.3). A declared absence threshold and consecutive-clutch count MUST be in the stream commitment. A series whose Blind plus Void share exceeds the threshold for that many consecutive clutches is `degraded`, and the state MUST be shown wherever the series is cited. A `degraded` series is not proof for the degraded clutches.

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

### 17.10. Extension profiles

17.10.1. A Technology Profile not listed above MAY be used under an identifier of the form `x-<org>-<name>`, published with the same structure as 17.1 and declared in the Interface Manifest before release. Records produced under an `x-` profile are comparable only to records under the same `x-` profile and version.

17.10.2. The same `x-<org>-<value>` form applies to every enumeration in this specification (effect types, Target identifiers' classes, Outcome annotations, finding kinds) where a run has a case the list lacks. An `x-` value is recorded verbatim and never changes how any Outcome is assigned.

17.10.3. An extension adds; it never relaxes. No profile or value may drop a required role, record, or rule of this specification. Where extensions are permitted, what is not extensible, and how an extension is promoted into the specification are governed by PP-SPEC-079 Section 13, which binds this specification.

### 17.11. Implementation Guidance

These profiles are starting points. Implementers MUST work with domain experts to define what constitutes a repeatable, observable Effect Point in their domain; establish independent fingerprint capture (Section 15.2.4); agree on mutation cadence and holdout strategy (Sections 6.1-6.2); and design canaries that are realistic and mutually distinguishable (Section 6).

## 18. Integration Points

Every component in this specification will, in practice, be supplied by a different party: agent platforms, network and tool-path controls, witness and sensor Providers, time and registry services. This section names each seam, states what a component plugged into it MUST do and MUST emit, and which seams one party MUST NOT occupy at once. A product claims conformance per Integration Point, never to the specification as a whole.

### 18.1. Rules for all Integration Points

18.1.1. **Named conformance.** A conformance claim MUST name the Integration Point(s) it covers, in the form `PP-SPEC-077 IP-n`, and the version of this specification.

18.1.2. **Component Fingerprint.** Every component occupying an Integration Point MUST publish a Component Fingerprint: a hash over its build identifier, version, and configuration as deployed for the run, captured under the same independence rule as a DUT Fingerprint (15.2.4). The testing equipment is fingerprinted like the thing it tests.

18.1.3. **Interface Manifest.** Before release, the Issuer MUST publish an Interface Manifest to the Registry (9.6): for each Integration Point, the party occupying it, the product and version, its Component Fingerprint, its Authorship Disclosure reference (21.15), and that party's disclosed interests (4.4). A run without a manifest is non-conforming.

18.1.4. **Proof, not opinions.** A component MUST emit the records this section assigns to it, in the canonical form this specification defines, and MUST NOT emit outcomes, verdicts, or rates. Adjudication is a separate seam (IP-8).

18.1.5. **Blindness.** No component other than the Issuer (IP-1) holds labels or colors before reveal. A component that can infer labels from any input it receives is non-conforming.

18.1.6. **Separation.** The following seams MUST be occupied by different parties: IP-1 Issuer and IP-6 Proof Witness; IP-6 Proof Witness and the Provider of the DUT; IP-2 Time Anchor and any other seam. The Provider of the DUT MUST NOT occupy any Integration Point, including IP-8 Adjudicator and IP-10 Signer / Key Custody. A Provider that supplies a component for a different DUT is a component supplier for that run, not the Provider.

18.1.7. **Transport neutrality.** This specification defines what crosses each seam, not how. Records MAY move by API, message bus, file, or signed log. A reference transport is given in the reference implementation, not here.

18.1.8. **Extensions.** A Provider's place is the Integration Points and a single `extensions.<provider>` object on the records its component emits, kept outside the Record ID canonical form (21.1) unless the Interface Manifest declares otherwise. A Provider MAY add a component, a profile, or an annotation. A Provider MUST NOT add an Outcome, a rate, a Conformance Level, or any reason a canary should not count. Every extension in use MUST be declared in the Interface Manifest (PP-SPEC-079 13.4).

### 18.2. The seams

| ID | Integration Point | What plugs in | MUST do | MUST emit |
|---|---|---|---|---|
| **IP-1** | Issuer / Canary Generator | Attack libraries, mutation engines, holdout pools, technology-profile generators | Produce canaries with content, Color, Path, expected effect, effect token (5.4.1), flags; commit under Section 9; hold labels; reveal under 9.4 | Commitment root and Time Anchor binding; reveal; Interface Manifest |
| **IP-2** | Time Anchor | Public randomness beacons (e.g. NIST), or any externally verifiable pulse source | Issue pulses that no party to the run controls or can predict; serve `latest`, `at(index)`, `after(index, n)` | Pulse index, timestamp, output value, URI |
| **IP-3** | Release Driver | Traffic generators, agent harnesses, mail injectors, API clients, network path controls | Deliver each released canary at its committed `ingress`, in committed order and cadence, unmodified; never see labels | Release timestamps per effect token |
| **IP-4** | Ingress Observer | Taps, proxies, flow logs, mail gateways in passive mode | Record delivery of each canary at the ingress by effect token, timestamped and anchored; passive, never alter traffic | Ingress records (10.3) |
| **IP-5** | Fingerprint Capture | Configuration readers, admission controllers, model and prompt registries | Read the deployed state of the DUT and each CUT independently of the Provider and compute Fingerprints (15.2) | DUT and CUT Fingerprints, capture method, capturing party |
| **IP-6** | Proof Witness / Effect Point Sensor | EDR telemetry taps, DLP sinks, database audit, egress sinks, identity logs, agent tool-output recorders | Observe the committed Effect Points over a path and credentials the DUT does not administer (10.2); record effect, token, point, time; commit and anchor the record set before reveal (10.4); publish a Witness Coverage Map (14) | Observations; witness root and signature; coverage map |
| **IP-7** | Liveness Prober | Synthetic monitors, out-of-band health checks | Probe Effect Points, Ingress Observer, Proof Witness, and Time Anchor over paths that do not traverse the DUT (15.6.3); open and close black hole windows | Black hole windows with start and end pulses and cause evidence |
| **IP-8** | Adjudicator | Scoring engines, reporting tools | Apply Sections 11 to 13 exactly; produce identical outcomes to the reference adjudicator on identical inputs; run only after IP-6 has committed and IP-1 has revealed | Outcomes, Units of Proof, findings, metrics, per-level rates |
| **IP-9** | Registry | PP-SPEC-004 conformant registries; the public instance is proofregister.com | Accept every artifact 9.6 lists; return a record identifier; append-only | `proofregister_uri` per record |
| **IP-10** | Signer / Key Custody | HSMs, KMS, software keys | Sign witness roots, Interface Manifests, and result records; publish verification keys | Signatures and key identifiers |

### 18.3. Conformance per seam

18.3.1. A component MAY claim conformance to one or more Integration Points. It MUST NOT claim conformance to this specification without naming them.

18.3.2. Conformance to IP-8 is established only by producing identical adjudication output to the reference implementation on the published conformance vectors.

18.3.3. A DUT has no Integration Point. It is the thing under test, it MUST NOT be modified to participate, and it MUST NOT be able to detect that any of the above seams exist (5.2, 10.2).

18.3.4. A single product MAY occupy several seams in one run only where 18.1.6 permits, and the Interface Manifest MUST say so.

18.3.5. Conformance of a component (this section) is distinct from the Conformance Level of a run (21.13). A conforming component can take part in a run that is merely Executed.

## 19. Execution

A conforming run proceeds as follows:

1. Issuer generates the Proof Swarm, including fresh mutations and any holdout or embargoed canaries.
2. Issuer publishes commitment root `R` at `T_commit`.
3. Order and ratio are derived from a later Time Anchor pulse.
4. Canaries are released; Ingress Observer records delivery.
5. Proof Witness records effect or absence of effect for each canary at its Effect Point.
6. Proof Witness commits its record set.
7. Issuer publishes the public reveal (9.4.1) and releases the content reveal to the Holder and Content Verifiers (9.4.2), excluding embargoed canaries.
8. Outcomes are adjudicated (Section 11). Black hole windows are recorded and affected canaries voided (Section 15.6).
9. The result record, its Units of Proof, and the Witness Coverage Map are registered (9.6); the Registry Receipt is attached; only then are they published (9.7).
10. Proof Witness returns to standby; any Wild Canaries are recorded under Section 13.
11. In Continuous Mode, the trickle resumes and results join the series for the current DUT Fingerprint (Section 15).

## 20. Security Considerations

- **Test recognition:** A DUT tuned to recognize canaries will inflate efficacy. Mitigated by 5.2, Section 6, and 8.2.
- **Label leakage:** Disclosure of labels or ratios before the run invalidates it.
- **Post-hoc relabeling:** Prevented by pre-release commitment (Section 9).
- **Cherry-picking runs:** Every committed run MUST be published, including invalid and unfavorable runs.
- **Witness compromise:** A Proof Witness reachable by the DUT or Provider is not independent (10.2).
- **Timing side channels:** Release timing MUST NOT correlate with labels.
- **Replay:** Time Anchor binding prevents reuse of prior results as new proof.
- **Hiding behind outages:** A Provider could induce or claim outages to void unfavorable canaries. Mitigated by independent liveness evidence and DUT attribution (15.6.3, 15.6.6), and by publishing black hole rates.
- **Quiet updates:** A Provider could change the DUT between runs. Mitigated by independent fingerprinting, triggered runs, and silent drift and undeclared change findings (15.2, 15.4).
- **Embargo leakage:** Embargoed canary contents MUST be held under access control equivalent to the underlying vulnerability's disclosure process.
- **Canary replay:** A party that captures a canary could re-send it to manufacture an effect or a block. Mitigated by single-use effect tokens, Ingress Observer records, and release windows. An effect token seen without its ingress record, or outside its window, is a finding, never a Unit of Proof.
- **Test as cover:** An attacker aware of a run window may attack during it, expecting alerts to be dismissed as test traffic. Operators MUST treat any effect without a matched effect token as real. The Proof Witness classifies by exclusion, and a run never suspends normal incident response. Publication of the method does not weaken this: the secret is the nonce, the holdout pool, and embargoed payloads, not the mechanism.

## 21. Records and Registration

This section governs the form of every record this specification produces: Units of Proof, result series records, findings, Claim Findings, fingerprints, Interface Manifests, and Bundles. The requirements exist so that a record can be verified by anyone, carried between systems, deduplicated across registries, and audited without asking its producer. They say nothing about what a record is worth; they say only what a record is.

### 21.1. Record identity

21.1.1. Every record MUST carry a Record ID equal to `SHA-256("DCP-1:record" || canonical_form)`, where `canonical_form` is the record serialized under 21.2 with the registration fields removed: `signatures`, `endorsements`, `proofregister_uri`, and `registry_receipt`. Those fields describe where a record was registered and who signed it, not what it says, so a record keeps one Record ID in every Registry it is registered with (21.12). For a Unit of Proof the Record ID is `uop_id`.

21.1.2. Two records with the same Record ID are the same record. A Registry MUST treat a second submission of an existing Record ID as a duplicate, not a new record.

21.1.3. A Record ID is never a counter, a database key, or any value a producer chooses. It is derived from content only.

### 21.2. Canonical form

21.2.1. Records MUST be serialized as JSON in the canonical form of RFC 8785 (JCS): sorted keys, no insignificant whitespace, UTF-8, shortest-form numbers.

21.2.2. Hashes and signatures over a record MUST be computed over its canonical form. A verifier MUST be able to recompute every Record ID and verify every signature from the published record alone, with no access to the producer.

### 21.3. Holder

21.3.1. Every record MUST name a Holder: the party for whose benefit the run was commissioned, identified by a stable identifier and a public key. The Holder is usually the Implementor whose system was tested. It MAY be the Issuer when no other party commissioned the run. It MUST NOT be the Provider.

21.3.2. The Holder is recorded for attribution and audit: it answers the question of who asked for this test. The Holder MAY add its own signature to the record's envelope (21.4).

### 21.4. Signature envelope

21.4.1. Signatures MUST be carried in a detached `signatures` array on the record. Each entry names a role (issuer, witness, holder, registry, endorser), the signing key, and the signature over the Record ID.

21.4.2. The envelope is append-only. Adding a signature MUST NOT change the Record ID. Any party MAY append an endorser signature to a record it has verified; endorsement attests only that the endorser verified the record under this section, nothing more.

21.4.3. The issuer and witness signatures are required for a Unit of Proof to be valid. Other signatures are optional.

### 21.5. Registry receipt

21.5.1. On accepting a record, a Registry MUST return a Registry Receipt: a signed statement naming the Record ID, the Registry's current Merkle root including that record, the Time Anchor pulse the root is bound to, and the Registry's identifier.

21.5.2. The receipt hash MUST be carried in the published record as `registry_receipt`. A record whose receipt cannot be verified against the Registry's published roots is not Registered (21.13).

21.5.3. A receipt is the submitter's proof of registration. A Registry MUST NOT be able to deny having accepted a record for which it issued a receipt.

### 21.6. Revocation

21.6.1. An Issuer, Witness, or Registry MAY publish a Revocation: a signed record naming a Record ID, the revoking party's role, a reason code (`key_compromise`, `issuer_error`, `witness_error`, `run_invalidated`, `superseded`), and a Time Anchor pulse.

21.6.2. A Revocation never deletes the revoked record. Both remain in the Registry. A verifier MUST check for Revocations against any record it relies on, and a revoked Unit of Proof MUST NOT be counted in any rate.

21.6.3. Revocation by the Provider is not defined. The Provider may use the Right of Reply mechanisms of the governing engagement specification; it cannot withdraw proof.

### 21.7. Bundles

21.7.1. A Bundle is a record that aggregates records by Merkle root: a set of Record IDs, hashed as leaves `H(0x43 || record_id)` and nodes `H(0x45 || left || right)` as in 9.2, under one Holder, with a declared scope (one run, one engagement, one period, one SUT) and the Comparability Class of the governing engagement where one exists.

21.7.2. A Bundle has its own Record ID, Holder, envelope, receipt, and Disclosure Level, and is registered like any other record. Rates MAY be computed over a Bundle; the Bundle MUST then list the Record IDs the rates were computed from, so the computation can be repeated.

21.7.3. A Bundle MUST NOT merge, split, or weight the Units of Proof it contains (21.11).

### 21.8. Validity window

21.8.1. Every record MAY carry `valid_through`, the time after which its producer no longer asserts that it describes the current SUT. A Unit of Proof's validity ends no later than the next Molt of its DUT or CUT Fingerprint (15.2.3).

21.8.2. A record past its validity window is not wrong; it is historical. Verifiers MUST distinguish current from historical records when computing anything about the present.

### 21.9. Disclosure level

21.9.1. Every record MUST declare a Disclosure Level:

| Level | Who may read the contents | Registry holds |
|---|---|---|
| `public` | Anyone | Full record |
| `holder_only` | The Holder and parties the Holder authorizes | Record ID, receipt, and envelope; contents encrypted to the Holder |
| `embargoed` | Holder and Issuer until the embargo lifts (Section 7) | As holder_only, with the lift condition |
| `sealed` | No one until the sealing party opens it | Record ID and receipt only |

21.9.2. A record's existence, Record ID, Registry Receipt, Disclosure Level, Holder identifier, and time of registration are always public, whatever its Disclosure Level. A party can therefore prove that a record exists and was registered at a time without revealing what it says.

21.9.3. Rates published from a Bundle that contains non-public records MUST state the count of non-public records included.

### 21.10. Delegation

21.10.1. A Holder MAY publish a Delegation: a signed record authorizing another key to act for the Holder within a stated scope (for example, read holder_only records, append endorsements, or submit Bundles) and a stated time window.

21.10.2. A Delegation is a record under this section, with its own Record ID and receipt. It MAY be revoked under 21.6.

### 21.11. Quantity

21.11.1. One Unit of Proof is one committed bad canary with one adjudicated outcome in one valid run. It is indivisible. No record, Bundle, or metric may represent a fraction of a Unit of Proof, merge two into one, or weight one differently from another at the level of the record. Weighting, if any, belongs to the consumer of the records and MUST be stated by the consumer, never carried in the record.

### 21.12. Registry federation

21.12.1. The Registry role (9.6) MAY be fulfilled by any Registry conforming to PP-SPEC-004. A run's records MAY be registered with more than one Registry; each issues its own receipt.

21.12.2. Registries MAY cross-anchor: a Registry MAY include another Registry's published root, with its Time Anchor binding, as a leaf in its own tree. A cross-anchored root lets a record registered in one Registry be proven against another.

21.12.3. Federation does not create a single Registry of record. Each receipt stands on its own. Where an engagement specification requires a particular Registry or class of Registry, that specification governs.

### 21.13. Conformance levels of a run

| Level | Meaning |
|---|---|
| **Executed** | The run followed Sections 5 through 16. Nothing has been registered. No Units of Proof exist. |
| **Conformant** | Executed, and every record meets Section 21, and the result record is registered under 9.6 and 9.7 with a verifiable Registry Receipt. Units of Proof exist. |
| **Registered** | Conformant, and every Unit of Proof, finding, fingerprint, Interface Manifest, and Bundle of the run is individually registered with its own receipt, and the Registry is one the governing engagement specification accepts. |

21.13.1. A party describing a run MUST use these words with these meanings and no others. "Compliant", "aligned", and similar terms are not Conformance Levels.

21.13.2. Rates published from Executed runs are not Units of Proof and MUST be labeled as unregistered.

### 21.14. Humans and machines

21.14.1. Every record, rule, and result in this specification and in every specification that adopts this section MUST be usable by both humans and machines: people reading and auditing, and agents, APIs, pipelines, and evaluators consuming and acting. Neither is the primary audience and neither may be served at the other's expense.

21.14.2. **Machine form.** Every record type has a published JSON Schema and the canonical form of 21.2. A machine MUST be able to verify, evaluate, and act on a record from the record, its schema, and the Registry, with no human step and no access to the producer.

21.14.3. **Human form.** Every record type has a human-readable rendering derivable from the record alone: what was tested, by whom, where, when, what happened, and how to verify it. The rendering MUST NOT state anything the record does not contain, MUST show the Record ID and Registry Receipt so a reader can verify it, and MUST be producible without proprietary tooling. The reference implementation publishes a renderer.

21.14.4. **Same answer.** Every rule that decides an Outcome, a verdict, a validity, a Conformance Level, or an acceptance MUST be stated so that a machine applying it to the machine form and a person applying it to the human form reach the same result. A rule that only one of them can apply is defective and MUST be revised.

21.14.5. **Agents as consumers.** An agent MAY read, verify, evaluate, and cite records. An agent MUST NOT be treated as more or less authoritative than a human performing the same verification. Where an agent occupies an Integration Point (Section 18), it is a component like any other: fingerprinted, separated, and declared.

### 21.15. Authorship Disclosure

21.15.1. **Scope.** Every specification in this family, every implementation of any Integration Point, every reference, conformance, rendering, or evaluation tool, every Technology Profile, extension, Mine Plan composition, Reference Environment, and Acceptance Profile, and every narrative report written from a record (PP-SPEC-079 9.3) MUST carry an Authorship Disclosure: a statement of what in it was created by humans and what was created by AI.

21.15.2. **Contents.** The disclosure MUST state: the named human authors and their roles; every AI system used, by provider, model, and version where known; the share contributed by humans and by AI along at least these dimensions: conception and normative decisions; design and naming; expression as written (text, code, schemas, diagrams); and review, acceptance, and the decision to publish; what specifically each side contributed; the method used to arrive at the shares; and the version and date the disclosure covers.

21.15.3. **Form.** The disclosure is published in both forms of 21.14: a human-readable file, `AI_DISCLOSURE.md`, at the root of the work, and a machine-readable file, `ai_disclosure.json`, conforming to [schemas/ai-disclosure.schema.json](schemas/ai-disclosure.schema.json). The two MUST agree.

21.15.4. **Measurement.** Shares MAY be measured or attested with a tool built for the purpose, such as ProofJack.com, in which case the disclosure names the tool and its version. Shares MAY instead be estimated by the authors, in which case the disclosure MUST say they are self-estimated. Either is conforming; an undisclosed method is not.

21.15.5. **Zero is a value.** A work made entirely by humans, or entirely by AI, says so. Silence is not a disclosure. A component without an Authorship Disclosure MUST NOT claim conformance at any Integration Point (18.3.1), and the Interface Manifest (18.1.3) carries each component's disclosure reference.

21.15.6. **Provenance, not quality.** An Authorship Disclosure describes how a work was made. It is never a factor in any Outcome, validity, Conformance Level, or Comparability Class. An Acceptance Profile (PP-SPEC-080) MAY require that a disclosure be present and MAY require that review and acceptance were performed by a named human; it MUST NOT accept or reject a record on the share of expression produced by AI.

21.15.7. **Updates.** A disclosure is versioned with the work it covers. A new version of the work that changes the shares carries a new disclosure; the earlier one is not edited.

### 21.16. Reserved

Campaign-level chains across techniques and additional witness requirements remain reserved for future revisions by the maintainer. Independent reproduction of a run by other parties is specified in PP-SPEC-081, Reproof: The Umpire Assay Protocol. Nothing in this section assigns value to any record.

## 22. Interpretation

Craig Thomas Ellrod, as maintainer of Proof Protocol, is responsible for the editorial text of this specification. Whether a run or record conforms is determined from its records against the normative text, and is not decided by the maintainer.

## Revision History

| Version | Date | Notes |
|---|---|---|
| 0.1.0 | 2026-10-10 | Initial draft as Witnessed Efficacy Probe (PP-WEP-0001) |
| 0.2.0 | 2026-10-10 | Renamed ProofSwarm: The Dead Canary Protocol (PP-SPEC-077). Swarm renamed Flock. Added mutation and novelty, embargoed 0day canaries, wild canaries, witness coverage. |
| 0.2.1 | 2026-10-10 | Renamed ProofSwarm: The Dead Canary Protocol. |
| 0.2.2 | 2026-10-10 | Sole author Craig Ellrod. Patent rights reserved by Craig Thomas Ellrod. Acknowledgment of Josh Waldrep for receipt-based verification work. |
| 0.3.0 | 2026-10-10 | Added Section 15, Continuous Mode and Drift: DUT Fingerprint, trickle and triggered runs, silent drift, witness calibration, black hole drift, result series. Renumbered later sections. |
| 0.3.1 | 2026-10-10 | Control Under Test (CUT) renamed Device Under Test (DUT); added Solution Under Test (SUT) and Terminology Lineage (2.1) citing Technical Marketing (2008). |
| 0.4.0 | 2026-10-10 | Restored Control Under Test (CUT) as a single control inside the DUT. Added Test Hierarchy SUT, DUT, CUT (2.2), differential CUT attribution, target level in commitments, per-level rates, CUT Fingerprints. |
| 0.5.0 | 2026-10-10 | Added Section 16, Operating Modes (Bounded, Production Stream), and Section 17, Technology Profiles. Specified commitment domain tag, Merkle leaf and node prefixes, and order-seed derivation (Section 9). Added roost, molt, clutch to terminology. Renumbered later sections. |
| 0.5.1 | 2026-10-10 | Added Agent Under Test (AUT) to terminology, lineage (2.1), and test hierarchy (2.2); 2.2.5 states AUT is not an attribution level and points to PP-SPEC-078. |
| 0.6.0 | 2026-10-10 | Added 5.6, Three Axes: Color (White, Gray, Red, Black, Gold), Path (ingress, effect token, route, effect point, target, cadence, clutch), Outcome (adds Void, Undelivered, Sealed as outcomes). Added Gold reference canaries, Claim Findings (11.6), Claim Accuracy Rate. Added effect tokens (5.4.1) and token-based wild canary matching (13.2). Security Considerations add canary replay and test as cover. Commitment formula now binds color and path. Schema adds color, path, effect_token, claim. |
| 0.6.1 | 2026-10-10 | Added Registry to terminology and 9.6: all published artifacts go to a PP-SPEC-004 (ProofRegister API) registry; `proofregister_uri` carried in every Unit of Proof and result series record. Schema and example updated. |
| 0.7.0 | 2026-10-10 | Added Section 18, Integration Points: ten named seams (IP-1 to IP-10) with per-seam MUSTs, Component Fingerprints, the Interface Manifest, separation rules, and per-seam conformance claims. Renumbered Execution, Security Considerations, Reserved, Interpretation to 19 through 22. |
| 0.7.1 | 2026-10-10 | Added 14.3, Absence Ladder: Blind, Void, Null with precedence, closed accounting, published Blind and Void shares; Blind added as an outcome (5.6.6); 16.2.5 real-time absence per clutch and the `degraded` series state. |
| 0.7.2 | 2026-10-12 | Shared family problem statement at the top of the Introduction. Flock renamed Proof Swarm throughout (term, prose, schemas, code). 21.15 Authorship Disclosure (human and AI shares, both forms, measurement by tool such as ProofJack.com or self-estimate, required for conformance claims, never a quality factor); 18.1.3 manifest carries each component's disclosure; schemas/ai-disclosure.schema.json. 21.14 Humans and machines: machine form, human form, same answer, agents as consumers. 15.1 Drift Types rewritten to cover drift of the thing under test, of the inputs (corpus, threat, profile), of the testing equipment (harness, pigtail, witness, anchor), and of the rules (specification, policy), each with its detection; 15.1.1 unattributed rate changes; 15.1.2 symmetric duty on Issuer and Vendor; 15.2.5 SUT, 15.2.6 Corpus, 15.2.7 Pigtail Fingerprints; 15.7.2 series carry every fingerprint; 15.7.3 segments and `fragmented`. 17.10 Extension profiles and `x-` values, 18.1.8 Vendor extensions, both governed by PP-SPEC-079 Section 13 (Implementation Guidance becomes 17.11). Added the Introduction (why this specification exists, scope, applicability to legacy cybersecurity and agentic AI systems, what it is not). Section 21 (formerly Reserved) is now Records and Registration: content-derived Record IDs, RFC 8785 canonical form, Holder, append-only Signature Envelope, Registry Receipt, Revocation, Bundles, validity window, Disclosure Levels, Delegation, indivisible quantity, Registry federation and cross-anchoring, and run Conformance Levels (Executed, Conformant, Registered). 9.7 registration precedes publication. 18.3.5, Execution step 9, schema fields `registry_receipt`, `holder`, `disclosure`, `valid_through`, `signatures`. |
| 0.7.3 | 2026-10-12 | Proof is attributed at four levels: SUT, DUT, CUT, and AUT (2.2). 2.2.5 rewritten: in this specification the AUT is the path an attack travels; outcomes caused by the agent's own conduct are attributed to the AUT under PP-SPEC-078. |
| 0.7.4 | 2026-10-13 | Section 22 limited to editorial responsibility: conformance is determined from the records against the normative text, not decided by the maintainer. |
| 0.8.0 | 2026-10-20 | Sealed content reveal: commitments bind a salted content digest; canary content is revealed to the Holder and Content Verifiers, not publicly by default (9.1, 9.4). Canary and order tags move to DCP-2. |
| 0.8.1 | 2026-10-23 | The Provider of the DUT occupies no Integration Point (4.1, 18.1.6); closes IP-8 Adjudicator, IP-10 Signer, IP-4, and IP-2, which 0.8.0 did not list. 21.16 points to PP-SPEC-081 for independent reproduction. |
