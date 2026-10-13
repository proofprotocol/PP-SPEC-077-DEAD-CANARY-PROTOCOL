# FAQ

**Is this breach and attack simulation (BAS) or red teaming?**
No. BAS and red teams are usually run by or for the party being evaluated, and they report what the tooling saw. ProofSwarm is a proof protocol: independent operators, sealed answer keys, an out-of-band witness at the outcome point, and mandatory publication of every run.

**Why do I need good canaries?**
Two reasons. They prove the path was working, so a dead bad canary counts as a block and not an outage. And they expose controls that "win" by blocking everything. Efficacy is never published without the false block rate.

**The control raised an alert. Why is that a miss?**
Because the attack still landed. ProofSwarm measures outcome. Detection without prevention is recorded as an annotation, never as Stopped.

**Can the Provider tune its product to pass?**
Not without actually stopping attacks. Canaries are mutated every run, holdout variants are never published, good and bad canaries look alike, and the order comes from a public beacon after the answer key is sealed.

**Does ProofSwarm prove a control will stop 0days?**
No test can prove that. ProofSwarm measures resistance to novelty through mutations and holdouts, and it supports embargoed canaries for undisclosed vulnerabilities, committed before disclosure and revealed after.

**What is a wild canary?**
An effect the standby Proof Witness sees that matches nothing in the committed Proof Swarm. Since every test canary is known in advance, anything else is real: an attack, a fault, or a false alarm. Wild canaries are reported separately and are never counted as Units of Proof.

**Who should run the Proof Witness?**
Never the Provider. Ideally the customer or a neutral third party, not the test operator. Independence is the whole point. The Proof Witness exists to say what happened without asking anyone who has a stake in the answer.

**What makes the Proof Witness independent?**
Five things, and all of them are required:
- **Independent operator.** The party that sells, builds, or runs the Device Under Test (DUT) never operates the witness, never configures it, and never touches its records.
- **Independent position.** It watches the Effect Point, where the attack would actually land. It does not rely on the control's path, the control's view, or the control's opinion.
- **Independent channel.** It runs out of band: its own network path, its own credentials, its own storage, its own telemetry pipeline. The control cannot see it, slow it, edit it, or silence it.
- **Independent of the answer key.** It is blind to which canaries are good or bad until its own records are sealed. It cannot shade its observations toward the expected result, because it does not know the expected result.
- **Independent of time.** Its records are anchored to an external public beacon that no party to the run controls. Nobody can backdate, reorder, or swap them.

**Why does independence matter more than the test itself?**
Because a test the Provider controls is just a more elaborate self-attestation. A Provider log, a Provider dashboard, or a Provider-run test is the control vouching for itself. That is verification. Proof starts where the party with something to gain stops having a hand in the evidence.

**Can the test operator also run the Proof Witness?**
It is allowed, but it is the weakest conforming setup. The operator built the Proof Swarm and holds the labels. The strongest setup separates the three jobs: the Issuer builds and seals the Proof Swarm, the Proof Witness observes, and the Time Anchor keeps time, each run by a different party. Under a PP-SPEC-079 Engagement in Independent Test Lab Mode it is not allowed: 079 4.2.3 (v0.1.2) requires a Proof Witness independent of the Lab and its affiliates.

**What if the Provider pays for the test?**
Payment must be disclosed in the run record, along with every other financial interest in the outcome. Paying for a test buys a test, not a result. The Provider still never touches canaries, labels, the witness, or the anchor.

**Can the control detect or evade the Proof Witness?**
It should not be able to. The witness sits outside the control's path and authority. If the control can see, reach, or influence the witness, the witness is not independent and the run does not conform.

**Why is the Proof Witness blind to labels?**
An observer who knows what is supposed to happen tends to see it. Blinding removes that bias. The witness records only what it observes, commits those records, and only then learns which canaries were good or bad.

**Who checks the Proof Witness?**
Anyone. Its records are committed and anchored before the reveal, and the reveal is public. Any third party can recompute the commitments, check the timestamps against the public beacon, and confirm that the witness record and the answer key line up. Independence does not depend on trusting the witness operator's word.

**How is this different from a control log showing the control fired?**
A log is the control vouching for itself. That is verification, a legitimate baseline. ProofSwarm produces proof: a sealed, witnessed, anchored record of what actually happened, built from independent evidence. Evidence is not proof; proof contains evidence.

**What is the difference between CUT, DUT, and SUT?**
The SUT is the whole solution the canaries enter. A DUT is one security device or product inside it. A CUT is one control inside that device: a rule, a policy, a detection. Results are attributed at whichever level the proof supports.

**What is an AUT?**
An Agent Under Test is an agent inside the SUT whose own conduct is being tested. A DUT stops attacks; an AUT may commit them. It is the fourth attribution level. In DCP the agent is the path an attack travels, so a canary that gets through an agent counts against the guardrail (the DUT or CUT), not the agent. What the agent does on its own (taking bait, misbehaving unprovoked, or declining bait) is attributed to the AUT under PP-SPEC-078 (No Bros Jail Mode Protocol: The Jailed Canary Protocol).

**The product's logs say rule 412 blocked the attack. Doesn't that prove the rule works?**
No. That is the device vouching for itself. Credit goes to a single control only when matched runs show the attack lands with that control off and dies with it on.

**What happens when the Provider updates the product?**
The proof goes stale. Every result is bound to an independently captured fingerprint of the deployed control. When the fingerprint changes, a new run is triggered and old results are marked stale until the control is proven again.

**What is silent drift?**
Results moving while the fingerprint stays the same. Something changed that nobody declared, and Continuous Mode records it as a finding.

**What if the network drops or a node dies mid-run?**
That is a black hole. Canaries caught in it are voided, not scored, because an outage is not a block. Black holes are detected with liveness checks that do not go through the control, and the black hole rate is published with every result.

**Can a Provider blame outages to erase bad results?**
No. If the control caused the outage, it is scored as a false block. Attribution rests on independent liveness evidence, not Provider statements, and voided canaries can never be replaced or relabeled.

**What is a Unit of Proof?**
The witnessed, committed, anchored outcome of one bad canary in a valid run: Stopped or Missed.

**What are the two operating modes?**
ProofSwarm runs in Bounded Mode for scheduled tests and in Production Stream Mode for live traffic. Bounded Mode declares a start and end time, commits a fixed Proof Swarm before release, and produces one result report with sealed records. Production Stream Mode releases canaries continuously into production in rolling epochs, publishes results as a time series, and keeps proof current as the control changes.

**When should I use Bounded Mode?**
Bounded Mode is for pre-deployment validation, Provider evaluation, staged rollouts, security incident response testing, and any proof you want to publish as a point-in-time report. It runs the full sequence: commitment, blinding, release, observation, sealing, adjudication, publication.

**When should I use Production Stream Mode?**
Production Stream Mode is for continuous verification of live controls, real-time detection of silent drift or undeclared updates, compliance monitoring, and ongoing proof that a control stays effective. Results accumulate as a series bound to Fingerprint versions. Old results are marked stale if the fingerprint changes, and new findings appear as silent drift or undeclared changes are detected.

**What does Production Stream Mode need?**
An out-of-band Proof Witness on a production Effect Point isolated from the DUT; continuous Time Anchor service; black hole detection independent of the DUT; declared tolerance thresholds for pass rate, void rate, and silent drift; and published fingerprints and result series updated no less than weekly.

**Can I implement this?**
Yes, with attribution to Craig Ellrod, Nebulonium, Inc., and Proof Protocol. See [NOTICE.md](../NOTICE.md). Patent rights are reserved by Craig Ellrod and Nebulonium, Inc. No patent license is granted.
