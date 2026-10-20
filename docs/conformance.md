# Conformance Checklist

*Informative summary of the MUST requirements in [SPEC.md](../SPEC.md). A run that fails any item is non-conforming.*

## Roles and independence (SPEC 4)

- [ ] Issuer is not the Provider
- [ ] Provider does not generate canaries, hold labels, run the Proof Witness, or run the Time Anchor
- [ ] Proof Witness operated by a party other than the Provider
- [ ] DUT cannot observe, delay, modify, or suppress Proof Witness records
- [ ] All parties with a financial interest disclosed in the run record

## Test hierarchy (SPEC 2.2)

- [ ] Every bad canary commits its target level (SUT, DUT, or CUT) and target identifier
- [ ] CUT attribution established only by differential runs, never by DUT logs alone
- [ ] Unattributable outcomes assigned to the next coarser level
- [ ] Rates reported per level, never finer than the proof
- [ ] CUT Fingerprints captured independently for every CUT with attributed results

## Canaries (SPEC 5, 6, 7)

- [ ] Bad canaries execute real techniques, not inert markers or test strings
- [ ] Good and bad canaries indistinguishable to the DUT and the Proof Witness except by behavior
- [ ] Every canary has a defined, machine-checkable expected effect at a declared Effect Point
- [ ] Bad canary effects contained to the test environment
- [ ] No bad canary reused verbatim across runs
- [ ] Holdout and embargoed canaries flagged in their commitments
- [ ] Embargoed canaries excluded from published rates until reveal
- [ ] Every committed canary carries exactly one Color and a complete Path in its commitment
- [ ] Every canary carries a single-use effect token shaped like the domain's ordinary identifiers
- [ ] Outcome assigned only after Proof Witness records are committed, exactly once, never revised
- [ ] Observations matched to canaries by effect token, Effect Point, and release window; unmatched observations recorded as wild
- [ ] Effect tokens without ingress records recorded as replay findings, never scored
- [ ] Gold canaries cite a dated Provider claim included in the run record
- [ ] Gold Missed published as a Claim Finding
- [ ] Claim Accuracy Rate published when any Gold canary is in the Proof Swarm

## Proof Swarm (SPEC 8)

- [ ] Proof Swarm contains both good and bad canaries
- [ ] Ratio and order randomized from a Time Anchor pulse issued after commitment
- [ ] Ratio and order not disclosed before the run concludes

## Commitment and reveal (SPEC 9)

- [ ] Per-canary commitments computed with SHA-256 or stronger and a fresh nonce of at least 128 bits
- [ ] Content digests use the `DCP-2:content` tag with a fresh content salt of at least 128 bits; commitments use the `DCP-2:canary` tag; Merkle leaves prefixed 0x43, interior nodes 0x45
- [ ] Merkle root published and bound to a Time Anchor pulse before first release
- [ ] Order seed derived from the second pulse after `T_commit` via HKDF-SHA256 with info `DCP-2:order`
- [ ] Public reveal (9.4.1) published for every non-embargoed canary
- [ ] Content reveal (9.4.2) released to the Holder and any Content Verifier at `holder_only`
- [ ] Published result states whether, by whom, and when the content reveal was checked (9.4.4)
- [ ] Public reveal reproduces the committed root
- [ ] Commitment root, witness root, reveal, fingerprints, results, findings, and coverage map published to a PP-SPEC-004 registry; `proofregister_uri` in every Unit of Proof

## Proof Witness (SPEC 10)

- [ ] Observes the Effect Point, not just the path or the DUT
- [ ] Out of band from the DUT: separate path, credentials, storage, telemetry
- [ ] Ingress Observer records delivery of each canary
- [ ] Witness records timestamped, anchored, and committed before the Issuer's reveal
- [ ] Proof Witness has no access to labels until its records are committed

## Adjudication and publication (SPEC 11, 12, 14, 20)

- [ ] Bad canaries whose effect occurred scored Missed regardless of alerts
- [ ] Good canary pass threshold declared before the run
- [ ] Runs below threshold not scored
- [ ] Efficacy Rate published together with False Block Rate
- [ ] Novelty Efficacy Rate reported separately
- [ ] Witness Coverage Map published with every result
- [ ] Every non-observation classified Blind, Void, or Null in that order; nothing scored Stopped or False block unless Null
- [ ] Released count equals the sum of all outcomes including Blind; Blind and Void shares published beside every rate
- [ ] Production Stream clutches publish absence shares; `degraded` state shown wherever a series is cited
- [ ] Every committed run published, including invalid and unfavorable runs

## Continuous Mode and drift (SPEC 15)

- [ ] DUT Fingerprint recorded every run, captured or verified independently of the Provider
- [ ] Results bound to their fingerprint; prior results marked stale on fingerprint change
- [ ] Trickle canaries follow all commitment and blinding rules
- [ ] Full runs on a declared cadence and on every fingerprint, environment, or coverage change
- [ ] Silent drift and undeclared changes recorded as findings
- [ ] Witness accuracy reported every run and published as a series
- [ ] Black holes detected independently of the DUT and recorded as anchored windows
- [ ] Canaries in black hole windows voided, never scored and never backfilled
- [ ] DUT-caused outages scored as False block, not black holes
- [ ] Black hole rate published with every result series

## Wild canaries (SPEC 13)

- [ ] Wild canaries reported only as `observed_in_wild`, never as Units of Proof

## Operating Modes (SPEC 16)

### Bounded Mode
- [ ] Start and end times declared before release
- [ ] Effect Points, DUT, and SUT declared before release
- [ ] Proof Swarm size and composition fixed and committed
- [ ] Full commitment, blinding, release, observation, sealing, adjudication sequence completed
- [ ] One result report produced with per-run fingerprints, rates, and findings
- [ ] All records sealed and published before accepting results

### Production Stream Mode
- [ ] Canaries committed in rolling epochs with sealed answer keys
- [ ] No fixed end time declared; continuous release authorized
- [ ] Proof Witness operates out-of-band continuously
- [ ] Time Anchor available continuously to anchor every canary and liveness check
- [ ] Black hole detection independent of the DUT at all times
- [ ] Tolerance thresholds declared for pass rate, void rate, and silent drift
- [ ] Fingerprints and result series published no less than weekly
- [ ] Results published as time series per Fingerprint version
- [ ] Stale periods, silent drift findings, and black hole windows included in series

## Integration Points (SPEC 18)

- [ ] Every conformance claim names its Integration Point(s) as `PP-SPEC-077 IP-n` and the spec version
- [ ] Every component publishes a Component Fingerprint captured independently of its Provider
- [ ] Interface Manifest (party, product, version, fingerprint, interests per seam) published to the Registry before release
- [ ] No component other than the Issuer can hold or infer labels before reveal
- [ ] Separation: Issuer and Proof Witness differ; Proof Witness is not the DUT Provider; Time Anchor occupies no other seam; DUT Provider occupies none of IP-1, 3, 5, 6, 7, 9
- [ ] IP-8 Adjudicator reproduces reference output on the conformance vectors
- [ ] DUT is unmodified and cannot detect any seam

## Records and registration (SPEC 9.6, 9.7, 21)

- [ ] Every record's ID is the SHA-256 of its RFC 8785 canonical form with the signature envelope removed, under the `DCP-1:record` tag
- [ ] Every record names a Holder with a public key; the Holder is never the Provider
- [ ] Issuer and witness signatures present in the envelope; envelope is append-only and does not alter the Record ID
- [ ] Result record registered before anything derived from it is published; Registry Receipt carried in the record
- [ ] Revocations checked before any record is counted; revoked Units of Proof excluded from every rate
- [ ] Bundles list the Record IDs their rates were computed from; no merging, splitting, or weighting of Units of Proof
- [ ] Every record declares a Disclosure Level; non-public counts stated beside any published rate
- [ ] Run described only as Executed, Conformant, or Registered, with the Section 21.13 meanings; unregistered rates labeled as such

## Authorship Disclosure (SPEC 21.15)

- [ ] Every component in the Interface Manifest carries a reference to its ai_disclosure.json
- [ ] AI_DISCLOSURE.md and ai_disclosure.json present for the work, agreeing, with human and AI shares on all four dimensions, the AI systems named, and the method stated (self-estimated, or measured or attested with a named tool such as ProofJack.com)
- [ ] No conformance claim at any seam by a component without a disclosure
