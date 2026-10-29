/-
  PP-SPEC-077 ProofSwarm: The Dead Canary Protocol
  Formal model of canary adjudication, checked by the Lean kernel.

  Copyright (c) 2026 Craig Thomas Ellrod. Part of Proof Protocol.
  Licensed under the Proof Protocol License 1.1 (see ../LICENSE.md).
  Authorship disclosure: ../AI_DISCLOSURE.md.

  Sections modeled: 5.6.4 (Color), 5.6.6 (Outcome), 11.1 and 11.2 (adjudication),
  12 (Efficacy Rate), 14.3 (Absence Ladder, closed accounting), 15.6.5 (voiding).

  What this file proves is the logic of adjudication: given the evidence for a canary,
  which single Outcome it receives, and what that rules out. It does not prove that the
  evidence is true. That is fidelity at capture, the job of the Proof Witness, the
  Ingress Observer and the records (Sections 10, 14, 21).
-/
namespace DCP

/-- 5.6.4: the committed kind of a canary. -/
inductive Color where
  | white | gray | red | black | gold
  deriving DecidableEq, Repr

/-- Red, Black and Gold carry real techniques (bad); White and Gray are legitimate (good). -/
def Color.isBad : Color → Bool
  | .red | .black | .gold => true
  | .white | .gray => false

def Color.isBlack : Color → Bool
  | .black => true
  | _ => false

/-- 5.6.6: every committed canary receives exactly one of these. -/
inductive Outcome where
  | stopped | missed | passed | falseBlock | void | undelivered | sealed | blind
  deriving DecidableEq, Repr

/-- The evidence the records hold for one committed canary after reveal. -/
structure Evidence where
  color     : Color
  /-- An Ingress Observer record exists (10.3). -/
  delivered : Bool
  /-- The committed Effect Point and effect type are inside the Witness Coverage Map (14.1). -/
  covered   : Bool
  /-- A black hole window covers the release, the landing, or the witness (15.6). -/
  blackHole : Bool
  /-- The Proof Witness recorded the canary's effect. -/
  observed  : Bool
  /-- The DUT raised an alert or wrote a log about it. An annotation only (11.2). -/
  detected  : Bool
  /-- The canary carries the `embargoed` flag (Section 7). -/
  embargoed : Bool
  deriving DecidableEq, Repr

/-- The reference adjudicator. Precedence: Undelivered, Blind, Void, then 11.1, then Sealed.
    The order Undelivered before Blind before Void is this model's reading where the
    specification leaves it implicit; see FINDINGS.md. -/
def adjudicate (e : Evidence) : Outcome :=
  if !e.delivered then .undelivered
  else if !e.covered then .blind
  else if e.blackHole then .void
  else
    let scored : Outcome :=
      if e.color.isBad then (if e.observed then .missed else .stopped)
      else (if e.observed then .passed else .falseBlock)
    if e.color.isBlack && e.embargoed then .sealed else scored

/-! ## Counting: 14.3.2 closed accounting -/

structure Tally where
  stopped     : Nat := 0
  missed      : Nat := 0
  passed      : Nat := 0
  falseBlock  : Nat := 0
  void        : Nat := 0
  undelivered : Nat := 0
  sealed      : Nat := 0
  blind       : Nat := 0
  deriving DecidableEq, Repr

def Tally.total (t : Tally) : Nat :=
  t.stopped + t.missed + t.passed + t.falseBlock + t.void + t.undelivered + t.sealed + t.blind

def Tally.add (t : Tally) : Outcome → Tally
  | .stopped     => { t with stopped := t.stopped + 1 }
  | .missed      => { t with missed := t.missed + 1 }
  | .passed      => { t with passed := t.passed + 1 }
  | .falseBlock  => { t with falseBlock := t.falseBlock + 1 }
  | .void        => { t with void := t.void + 1 }
  | .undelivered => { t with undelivered := t.undelivered + 1 }
  | .sealed      => { t with sealed := t.sealed + 1 }
  | .blind       => { t with blind := t.blind + 1 }

def tally (l : List Outcome) : Tally := l.foldr (fun o t => t.add o) {}

theorem Tally.total_add (t : Tally) (o : Outcome) : (t.add o).total = t.total + 1 := by
  cases o <;> simp [Tally.add, Tally.total] <;> omega

theorem tally_cons (o : Outcome) (l : List Outcome) : tally (o :: l) = (tally l).add o := rfl

theorem tally_total (l : List Outcome) : (tally l).total = l.length := by
  induction l with
  | nil => rfl
  | cons o l ih => rw [tally_cons, Tally.total_add, ih]; rfl

/-- **Closed accounting (14.3.2).** For any run, the released count equals the sum of
    Stopped, Missed, Passed, False block, Void, Undelivered, Sealed and Blind. Every canary
    lands in exactly one bucket and none is lost or counted twice. -/
theorem closed_accounting (released : List Evidence) :
    (tally (released.map adjudicate)).total = released.length := by
  rw [tally_total, List.length_map]

/-! ## What a Stopped result requires -/

/-- **Absence is not efficacy (14.3.1).** A canary is Stopped only if it was delivered,
    its Effect Point was covered by the witness, no black hole touched it, it is a bad
    canary, and the witness saw no effect. Not watching, losing the path, or failing to
    deliver can never be scored as the control stopping an attack. -/
theorem stopped_requires_null (e : Evidence) (h : adjudicate e = .stopped) :
    e.delivered = true ∧ e.covered = true ∧ e.blackHole = false ∧
    e.observed = false ∧ e.color.isBad = true := by
  cases e with
  | mk c d cov bh obs det emb =>
    cases c <;> cases d <;> cases cov <;> cases bh <;> cases obs <;> cases emb <;>
      simp_all [adjudicate, Color.isBad, Color.isBlack]

/-- **An attack that landed is Missed (11.2).** A delivered, covered, non-black-holed bad
    canary whose effect the witness observed is Missed or, if embargoed Black, Sealed.
    It is never Stopped, whatever the DUT reported. -/
theorem observed_bad_never_stopped (e : Evidence) (h : e.observed = true) :
    adjudicate e ≠ .stopped := by
  intro hs
  have := (stopped_requires_null e hs).2.2.2.1
  rw [h] at this
  cases this

/-- **Alerts do not change outcomes (11.2).** Setting or clearing the DUT's own detection
    flag never changes the Outcome. Detection without prevention is not Stopped. -/
theorem detection_never_changes_outcome (e : Evidence) (b : Bool) :
    adjudicate { e with detected := b } = adjudicate e := by
  cases e; rfl

/-- **Labels are respected (11.1).** A good canary is never Stopped or Missed, and a bad
    canary is never Passed or False block. -/
theorem good_never_stopped_or_missed (e : Evidence) (h : e.color.isBad = false) :
    adjudicate e ≠ .stopped ∧ adjudicate e ≠ .missed := by
  cases e with
  | mk c d cov bh obs det emb =>
    cases c <;> cases d <;> cases cov <;> cases bh <;> cases obs <;> cases emb <;>
      simp_all [adjudicate, Color.isBad, Color.isBlack]

theorem bad_never_passed_or_false_block (e : Evidence) (h : e.color.isBad = true) :
    adjudicate e ≠ .passed ∧ adjudicate e ≠ .falseBlock := by
  cases e with
  | mk c d cov bh obs det emb =>
    cases c <;> cases d <;> cases cov <;> cases bh <;> cases obs <;> cases emb <;>
      simp_all [adjudicate, Color.isBad, Color.isBlack]

/-! ## Rates: Section 12 -/

/-- Efficacy Rate as (numerator, denominator): Stopped / (Stopped + Missed). -/
def efficacy (t : Tally) : Nat × Nat := (t.stopped, t.stopped + t.missed)

/-- **Unscored outcomes cannot move the Efficacy Rate (12, 14.3.3, 15.6.5).** Adding a
    Blind, Void, Undelivered or Sealed canary to any tally leaves both the numerator and the
    denominator of the Efficacy Rate unchanged. -/
theorem unscored_never_moves_efficacy (t : Tally) (o : Outcome)
    (h : o = .blind ∨ o = .void ∨ o = .undelivered ∨ o = .sealed) :
    efficacy (t.add o) = efficacy t := by
  cases o <;> simp_all [Tally.add, efficacy]

/-- A Claim Finding (11.6) is exactly a Gold canary adjudicated Missed. -/
def claimFinding (e : Evidence) : Bool :=
  match e.color, adjudicate e with
  | .gold, .missed => true
  | _, _ => false

/-! ## Conformance vectors (checked by evaluation) -/

example : adjudicate ⟨.red,   true,  true,  false, false, true,  false⟩ = .stopped     := by decide
example : adjudicate ⟨.red,   true,  true,  false, true,  true,  false⟩ = .missed      := by decide
example : adjudicate ⟨.white, true,  true,  false, true,  false, false⟩ = .passed      := by decide
example : adjudicate ⟨.gray,  true,  true,  false, false, false, false⟩ = .falseBlock  := by decide
example : adjudicate ⟨.gold,  true,  true,  true,  false, false, false⟩ = .void        := by decide
example : adjudicate ⟨.black, false, true,  false, false, false, true ⟩ = .undelivered := by decide
example : adjudicate ⟨.black, true,  true,  false, true,  false, true ⟩ = .sealed      := by decide
example : adjudicate ⟨.red,   true,  false, false, false, false, false⟩ = .blind       := by decide
example : claimFinding ⟨.gold, true, true, false, true, true, false⟩ = true              := by decide

end DCP
