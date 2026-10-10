# Glossary

*Informative. Normative definitions are in [SPEC.md](../SPEC.md), Section 2.*

| Term | Meaning |
|---|---|
| **Bad Canary** | A canary carrying a real adversary technique (MITRE ATT&CK or ATLAS) that produces a defined malicious effect if not stopped. |
| **Good Canary** | A canary performing a legitimate action that produces a defined benign effect if not stopped. |
| **Boundary Good Canary** | A good canary built to look like a bad one. Measures false blocks where they actually happen. |
| **Flock** | The full, blind-mixed set of good and bad canaries for one run. |
| **Agent Under Test (AUT)** | An agent inside the SUT whose own conduct is under test. An actor, not a control. Tested under PP-SPEC-078 (No Bros Jail Mode Protocol: The Jailed Canary Protocol). Derived from *Technical Marketing* (2008) DUT/SUT. |
| **Control Under Test (CUT)** | One control inside a DUT: a single rule, policy, signature, detection, or guardrail function. |
| **Device Under Test (DUT)** | A security product, configuration, or agent guardrail containing one or more CUTs. Term from *Technical Marketing* (2008). |
| **Solution Under Test (SUT)** | The full deployment the flock enters: one or more DUTs plus the protected environment and its Effect Points. Term from *Technical Marketing* (2008). |
| **Differential Attribution** | Proving a single CUT stopped an attack by matched runs with the CUT active and with it disabled. A DUT log naming the control is not enough. |
| **CUT Fingerprint** | Independent hash of one control's definition and parameters. |
| **Vendor** | Whoever builds, sells, or operates the DUT. |
| **Issuer** | Builds the flock, holds the labels, publishes commitments. Never the Vendor. |
| **Effect Point** | Where a canary's effect lands: target host, data store, identity system, egress sink, agent tool output. |
| **Proof Witness** | The standby, independent, out-of-band observer at the Effect Point. Records which canaries lived and died. |
| **Ingress Observer** | Passive observer at the release point. Proves delivery. |
| **Time Anchor** | External public time and randomness source, such as the NIST Randomness Beacon. |
| **Commitment** | Hash of a canary, its label, expected effect, flags, and a nonce, published before release. |
| **Reveal** | Publication of commitment preimages after the run, so anyone can check nothing changed. |
| **Stopped** | Bad canary died. |
| **Missed** | Bad canary lived, regardless of any alert. |
| **Passed** | Good canary lived. |
| **False Block** | Good canary died. |
| **Unit of Proof (UoP)** | The adjudicated outcome of one bad canary in a valid run. |
| **Mutation** | A fresh variant of a technique, generated per run. |
| **Holdout Canary** | A private, never-published variant. |
| **Embargoed Canary** | A canary exploiting an undisclosed vulnerability. Committed now, revealed after coordinated disclosure. |
| **Wild Canary** | An effect the Proof Witness sees that matches no committed canary. A real-world event. |
| **DUT Fingerprint** | Independent hash of the exact deployed state of the control: version, config, policy, rules, and for AI controls, model, prompt, and tool permissions. |
| **Stale** | A result whose DUT Fingerprint no longer matches the deployed control. |
| **Trickle** | Continuous low-volume canary release between full runs. |
| **Control / Environment / Threat / Witness Drift** | Change in the control, the environment, the threat landscape, or the witness over time. |
| **Silent Drift** | Measured behavior changes while the fingerprint stays the same. Something changed that nobody declared. |
| **Black Hole** | Part of the system disappears for any period, from network, node, or system failure unrelated to any canary or attack. |
| **Void (black hole)** | A canary released into a black hole. Never scored, never backfilled. |
| **Black Hole Rate** | Share of canaries and time lost to black holes. Published with every result. |
| **Witness Coverage Map** | The declared Effect Points and effect types the Proof Witness watches. Everything else is a blind spot. |
| **Bounded Mode** | A scheduled test run with declared start and end times, a fixed committed flock, sealed evidence, and a publishable point-in-time report. |
| **Production Stream Mode** | Continuous canary release into live traffic with rolling epoch-based commitments, no declared end, and ongoing result series tracking drift and changes. |
| **Roost** | The Proof Witness's standby state between and after runs. |
| **Molt** | A DUT or CUT Fingerprint change. Prior results go stale. |
| **Clutch** | One epoch's committed batch of canaries in Production Stream Mode. |
| **Color** | What kind of canary it is: White, Gray, Red, Black, Gold. Sealed before release. Wild canaries have no color; they were never committed. |
| **Path** | Where the canary goes and how it is sent: ingress, effect token, route, effect point, target, cadence, clutch. Sealed before release. |
| **Outcome** | What happened: Stopped, Missed, Passed, False block, Void, Undelivered, Sealed. Assigned once, after the fact. |
| **Effect Token** | Unique per-canary identifier visible at the Effect Point. Matches an observation to its canary after reveal. No token means wild. |
| **Gold Canary** | A bad canary testing a technique the vendor claims in writing to stop. Gold Missed is a Claim Finding. |
| **Claim Accuracy Rate** | Gold Stopped over all Gold. The vendor's own claims graded against outcome. |
| **Verification** | Self-attestation. Baseline tier. |
| **Validation** | One step above verification. |
| **Proof** | Independent evidence of outcome under adversarial conditions. |
