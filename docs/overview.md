# Overview: Prooflock in Plain English

*Informative. The normative text is [SPEC.md](../SPEC.md).*

## The problem

Security Providers claim their products work with their own evidence: their logs, their dashboards, their test reports. That is self-attestation. It is a fine baseline, but it is not proof. A log entry saying "the control fired" does not tell you whether the attack actually failed.

## The idea

Coal miners carried canaries. If the air turned bad, the canary died first, and nobody could fake a dead bird.

Prooflock sends a Proof Swarm of canaries into the environment a security control protects:

- **Bad canaries** carry real attacks. If the control works, they die.
- **Good canaries** do legitimate work. If the control works, they live.

The Proof Swarm is mixed blind, so the control cannot cheat by spotting the test. A **Proof Witness** waits where each canary's effect would land and simply records who lived and who died. It does not know which canaries were good or bad until after it has locked in its records.

## Solution, device, control

Proof is attributed at three levels. The **Solution Under Test (SUT)** is the whole deployment. Inside it, each **Device Under Test (DUT)** is a security product or guardrail. Inside each device, each **Control Under Test (CUT)** is a single rule, policy, or detection. A device log claiming which rule fired does not count: a single control earns credit only when matched runs show the attack lands with that control off and dies with it on.

## The four outcomes

| Canary | Lived | Died |
|---|---|---|
| Bad | **Missed.** The attack worked. | **Stopped.** The control did its job. |
| Good | **Passed.** Business as usual. | **False block.** The control broke legitimate work. |

A control that blocks everything stops every bad canary, but it also kills every good one. Prooflock always reports both sides.

## Why nobody can cheat

- **The Provider is out of the loop.** It does not build canaries, hold the answer key, or run the witness.
- **The answer key is sealed first.** Every canary and its label are hashed and anchored to a public time beacon before release. After the run, the hashes are opened. If anything changed, the run is void.
- **The order is chosen by the beacon,** after the commitment, so nobody can arrange the Proof Swarm to look good.
- **The witness is out of band.** The control cannot see, delay, or edit its records.
- **Every run gets published,** including the bad ones.

## What about new attacks and 0days?

No test can prove resistance to an attack that does not exist yet. Prooflock measures the closest honest thing:

- **Mutations.** Every run uses fresh variants of each technique. Signature-matching controls fall apart on variants they have never seen.
- **Holdouts.** A private pool of variants that is never published.
- **Embargoed canaries.** Real 0days can be committed now and revealed after coordinated disclosure. The record proves the control was tested before the world knew.

## Wild canaries

Every test canary is committed in advance. So if the standby Proof Witness ever sees an effect that matches no committed canary, it did not come from the test. That is a **wild canary**: a real attack, or a real fault. The test harness doubles as a detection layer, and its accuracy on the committed Proof Swarm tells you how much to trust it.

## Proof that stays current

A test proves a control on one day. Controls change constantly: rule pushes, policy edits, model updates. Prooflock's Continuous Mode keeps proof current:

- Every result is tied to a **fingerprint** of the exact deployed control. Change the control and the old proof goes **stale** until it is proven again.
- A **trickle** of canaries runs all the time, with full runs on a schedule and whenever anything changes.
- **Silent drift** is caught: if results move while the fingerprint stays the same, something changed that nobody declared.
- The Proof Witness is checked against the committed canaries every run, so drift in the witness shows up too.

## Black holes

Sometimes part of the system just disappears: a network drop, a dead node, a crashed service. A canary that vanishes into an outage did not die at the hands of the control. Prooflock detects these **black holes** independently of the control, voids every canary caught in one, and publishes how much was lost. If the control itself caused the outage, it does not get to call it a black hole: that is a false block.

## Units of Proof

Each bad canary in a valid run produces one **Unit of Proof**: a signed, anchored, independently witnessed outcome. Units of Proof are the building block for comparing controls, pricing risk, and building a market for proof instead of claims.
