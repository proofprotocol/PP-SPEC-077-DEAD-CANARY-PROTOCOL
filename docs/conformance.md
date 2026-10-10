# Conformance Checklist

*Informative summary of the MUST requirements in [SPEC.md](../SPEC.md). A run that fails any item is non-conforming.*

## Roles and independence (SPEC 4)

- [ ] Issuer is not the Vendor
- [ ] Vendor does not generate canaries, hold labels, run the Proof Witness, or run the Time Anchor
- [ ] Proof Witness operated by a party other than the Vendor
- [ ] DUT cannot observe, delay, modify, or suppress Proof Witness records
- [ ] All parties with a financial interest disclosed in the run record

## Test hierarchy (SPEC 2.2)

- [ ] Every bad canary commits its target level (SUT, DUT, or CUT) and target identifier
- [ ] CUT attribution established only by differential runs, never by DUT logs alone
- [ ] Unattributable outcomes assigned to the next coarser level
- [ ] Rates reported per level, never finer than the evidence
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
- [ ] Gold canaries cite a dated Vendor claim included in the run record
- [ ] Gold Missed published as a Claim Finding
- [ ] Claim Accuracy Rate published when any Gold canary is in the flock

## Flock (SPEC 8)

- [ ] Flock contains both good and bad canaries
- [ ] Ratio and order randomized from a Time Anchor pulse issued after commitment
- [ ] Ratio and order not disclosed before the run concludes

## Commitment and reveal (SPEC 9)

- [ ] Per-canary commitments computed with SHA-256 or stronger and a fresh nonce of at least 128 bits
- [ ] Commitments use the `DCP-1:canary` domain tag; Merkle leaves prefixed 0x43, interior nodes 0x45
- [ ] Merkle root published and bound to a Time Anchor pulse before first release
- [ ] Order seed derived from the second pulse after `T_commit` via HKDF-SHA256 with info `DCP-1:order`
- [ ] All non-embargoed preimages revealed after the run
- [ ] Reveal reproduces the committed root
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

- [ ] DUT Fingerprint recorded every run, captured or verified independently of the Vendor
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
- [ ] Flock size and composition fixed and committed
- [ ] Full commitment, blinding, release, observation, sealing, adjudication sequence completed
- [ ] One result report produced with per-run fingerprints, rates, and findings
- [ ] All evidence sealed and published before accepting results

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
- [ ] Every component publishes a Component Fingerprint captured independently of its vendor
- [ ] Interface Manifest (party, product, version, fingerprint, interests per seam) published to the Registry before release
- [ ] No component other than the Issuer can hold or infer labels before reveal
- [ ] Separation: Issuer and Proof Witness differ; Proof Witness is not the DUT Vendor; Time Anchor occupies no other seam; DUT Vendor occupies none of IP-1, 3, 5, 6, 7, 9
- [ ] IP-8 Adjudicator reproduces reference output on the conformance vectors
- [ ] DUT is unmodified and cannot detect any seam
