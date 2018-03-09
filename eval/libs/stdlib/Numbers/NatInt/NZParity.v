From Hammer Require Import Hammer.









Require Import Bool NZAxioms NZMulOrder.



Module Type NZParity (Import A : NZAxiomsSig').
Parameter Inline even odd : t -> bool.
Definition Even n := exists m, n == 2*m.
Definition Odd n := exists m, n == 2*m+1.
Axiom even_spec : forall n, even n = true <-> Even n.
Axiom odd_spec : forall n, odd n = true <-> Odd n.
End NZParity.

Module Type NZParityProp
(Import A : NZOrdAxiomsSig')
(Import B : NZParity A)
(Import C : NZMulOrderProp A).



Instance Even_wd : Proper (eq==>iff) Even.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.Even_wd". Restart.  unfold Even. solve_proper. Qed.

Instance Odd_wd : Proper (eq==>iff) Odd.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.Odd_wd". Restart.  unfold Odd. solve_proper. Qed.

Instance even_wd : Proper (eq==>Logic.eq) even.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.even_wd". Restart. 
intros x x' EQ. rewrite eq_iff_eq_true, 2 even_spec. now f_equiv.
Qed.

Instance odd_wd : Proper (eq==>Logic.eq) odd.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.odd_wd". Restart. 
intros x x' EQ. rewrite eq_iff_eq_true, 2 odd_spec. now f_equiv.
Qed.



Lemma Even_or_Odd : forall x, Even x \/ Odd x.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.Even_or_Odd". Restart. 
nzinduct x.
left. exists 0. now nzsimpl.
intros x.
split; intros [(y,H)|(y,H)].
right. exists y. rewrite H. now nzsimpl.
left. exists (S y). rewrite H. now nzsimpl'.
right.
assert (LT : exists z, z<y).
destruct (lt_ge_cases 0 y) as [LT|GT]; [now exists 0 | exists x].
rewrite <- le_succ_l, H. nzsimpl'.
rewrite <- (add_0_r y) at 3. now apply add_le_mono_l.
destruct LT as (z,LT).
destruct (lt_exists_pred z y LT) as (y' & Hy' & _).
exists y'. rewrite <- succ_inj_wd, H, Hy'. now nzsimpl'.
left. exists y. rewrite <- succ_inj_wd. rewrite H. now nzsimpl.
Qed.

Lemma double_below : forall n m, n<=m -> 2*n < 2*m+1.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.double_below". Restart. 
intros. nzsimpl'. apply lt_succ_r. now apply add_le_mono.
Qed.

Lemma double_above : forall n m, n<m -> 2*n+1 < 2*m.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.double_above". Restart. 
intros. nzsimpl'.
rewrite <- le_succ_l, <- add_succ_l, <- add_succ_r.
apply add_le_mono; now apply le_succ_l.
Qed.

Lemma Even_Odd_False : forall x, Even x -> Odd x -> False.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.Even_Odd_False". Restart. 
intros x (y,E) (z,O). rewrite O in E; clear O.
destruct (le_gt_cases y z) as [LE|GT].
generalize (double_below _ _ LE); order.
generalize (double_above _ _ GT); order.
Qed.

Lemma orb_even_odd : forall n, orb (even n) (odd n) = true.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.orb_even_odd". Restart. 
intros.
destruct (Even_or_Odd n) as [H|H].
rewrite <- even_spec in H. now rewrite H.
rewrite <- odd_spec in H. now rewrite H, orb_true_r.
Qed.

Lemma negb_odd : forall n, negb (odd n) = even n.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.negb_odd". Restart. 
intros.
generalize (Even_or_Odd n) (Even_Odd_False n).
rewrite <- even_spec, <- odd_spec.
destruct (odd n), (even n) ; simpl; intuition.
Qed.

Lemma negb_even : forall n, negb (even n) = odd n.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.negb_even". Restart. 
intros. rewrite <- negb_odd. apply negb_involutive.
Qed.



Lemma even_0 : even 0 = true.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.even_0". Restart. 
rewrite even_spec. exists 0. now nzsimpl.
Qed.

Lemma odd_0 : odd 0 = false.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.odd_0". Restart. 
now rewrite <- negb_even, even_0.
Qed.

Lemma odd_1 : odd 1 = true.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.odd_1". Restart. 
rewrite odd_spec. exists 0. now nzsimpl'.
Qed.

Lemma even_1 : even 1 = false.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.even_1". Restart. 
now rewrite <- negb_odd, odd_1.
Qed.

Lemma even_2 : even 2 = true.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.even_2". Restart. 
rewrite even_spec. exists 1. now nzsimpl'.
Qed.

Lemma odd_2 : odd 2 = false.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.odd_2". Restart. 
now rewrite <- negb_even, even_2.
Qed.



Lemma Odd_succ : forall n, Odd (S n) <-> Even n.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.Odd_succ". Restart. 
split; intros (m,H).
exists m. apply succ_inj. now rewrite add_1_r in H.
exists m. rewrite add_1_r. now f_equiv.
Qed.

Lemma odd_succ : forall n, odd (S n) = even n.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.odd_succ". Restart. 
intros. apply eq_iff_eq_true. rewrite even_spec, odd_spec.
apply Odd_succ.
Qed.

Lemma even_succ : forall n, even (S n) = odd n.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.even_succ". Restart. 
intros. now rewrite <- negb_odd, odd_succ, negb_even.
Qed.

Lemma Even_succ : forall n, Even (S n) <-> Odd n.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.Even_succ". Restart. 
intros. now rewrite <- even_spec, even_succ, odd_spec.
Qed.



Lemma Even_succ_succ : forall n, Even (S (S n)) <-> Even n.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.Even_succ_succ". Restart. 
intros. now rewrite Even_succ, Odd_succ.
Qed.

Lemma Odd_succ_succ : forall n, Odd (S (S n)) <-> Odd n.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.Odd_succ_succ". Restart. 
intros. now rewrite Odd_succ, Even_succ.
Qed.

Lemma even_succ_succ : forall n, even (S (S n)) = even n.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.even_succ_succ". Restart. 
intros. now rewrite even_succ, odd_succ.
Qed.

Lemma odd_succ_succ : forall n, odd (S (S n)) = odd n.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.odd_succ_succ". Restart. 
intros. now rewrite odd_succ, even_succ.
Qed.



Lemma even_add : forall n m, even (n+m) = Bool.eqb (even n) (even m).
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.even_add". Restart. 
intros.
case_eq (even n); case_eq (even m);
rewrite <- ?negb_true_iff, ?negb_even, ?odd_spec, ?even_spec;
intros (m',Hm) (n',Hn).
exists (n'+m'). now rewrite mul_add_distr_l, Hn, Hm.
exists (n'+m'). now rewrite mul_add_distr_l, Hn, Hm, add_assoc.
exists (n'+m'). now rewrite mul_add_distr_l, Hn, Hm, add_shuffle0.
exists (n'+m'+1). rewrite Hm,Hn. nzsimpl'. now rewrite add_shuffle1.
Qed.

Lemma odd_add : forall n m, odd (n+m) = xorb (odd n) (odd m).
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.odd_add". Restart. 
intros. rewrite <- !negb_even. rewrite even_add.
now destruct (even n), (even m).
Qed.



Lemma even_mul : forall n m, even (mul n m) = even n || even m.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.even_mul". Restart. 
intros.
case_eq (even n); simpl; rewrite ?even_spec.
intros (n',Hn). exists (n'*m). now rewrite Hn, mul_assoc.
case_eq (even m); simpl; rewrite ?even_spec.
intros (m',Hm). exists (n*m'). now rewrite Hm, !mul_assoc, (mul_comm 2).

rewrite <- !negb_true_iff, !negb_even, !odd_spec.
intros (m',Hm) (n',Hn). exists (n'*2*m' +n'+m').
rewrite Hn,Hm, !mul_add_distr_l, !mul_add_distr_r, !mul_1_l, !mul_1_r.
now rewrite add_shuffle1, add_assoc, !mul_assoc.
Qed.

Lemma odd_mul : forall n m, odd (mul n m) = odd n && odd m.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.odd_mul". Restart. 
intros. rewrite <- !negb_even. rewrite even_mul.
now destruct (even n), (even m).
Qed.



Lemma even_add_even : forall n m, Even m -> even (n+m) = even n.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.even_add_even". Restart. 
intros n m Hm. apply even_spec in Hm.
rewrite even_add, Hm. now destruct (even n).
Qed.

Lemma odd_add_even : forall n m, Even m -> odd (n+m) = odd n.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.odd_add_even". Restart. 
intros n m Hm. apply even_spec in Hm.
rewrite odd_add, <- (negb_even m), Hm. now destruct (odd n).
Qed.

Lemma even_add_mul_even : forall n m p, Even m -> even (n+m*p) = even n.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.even_add_mul_even". Restart. 
intros n m p Hm. apply even_spec in Hm.
apply even_add_even. apply even_spec. now rewrite even_mul, Hm.
Qed.

Lemma odd_add_mul_even : forall n m p, Even m -> odd (n+m*p) = odd n.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.odd_add_mul_even". Restart. 
intros n m p Hm. apply even_spec in Hm.
apply odd_add_even. apply even_spec. now rewrite even_mul, Hm.
Qed.

Lemma even_add_mul_2 : forall n m, even (n+2*m) = even n.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.even_add_mul_2". Restart. 
intros. apply even_add_mul_even. apply even_spec, even_2.
Qed.

Lemma odd_add_mul_2 : forall n m, odd (n+2*m) = odd n.
Proof. hammer_hook "NZParity" "NZParity.NZParityProp.odd_add_mul_2". Restart. 
intros. apply odd_add_mul_even. apply even_spec, even_2.
Qed.

End NZParityProp.
