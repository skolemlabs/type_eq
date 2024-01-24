(** Represents equality between two types ['a], ['b]. The constraint means that, if you have an
    instance of [Eq], ['a] and ['b] are the same type *)
type ('a, 'b) t = Eq : ('a, 'a) t

val coerce : ('a, 'b) t -> 'a -> 'b
(** [coerce eq a] applies equality proof [eq] on a value of type ['a] to coerce it to ['b] *)

val commute : ('a, 'b) t -> ('b, 'a) t
(** [commute eq] uses the commutative property of equality to produce a proof of equality from ['b]
    to ['a] from a proof from ['a] to ['b] *)

val transit : ('a, 'b) t -> ('b, 'c) t -> ('a, 'c) t
(** [transit eq_a eq_b] uses the transitive property of equality to produce a proof of equality from
    ['a] to ['c] from proofs from ['a] to ['b] and ['b] to ['c] *)

val val_equal : ?equal:('a -> 'a -> bool) -> ('a, 'b) t -> 'a -> 'b -> bool
(** [val_equal ?equal eq a b] returns [equal a b] after casting [a] to ['b].

    [?equal] is [( = )] by default *)

module Lift (M : sig
  type 'a t
end) : sig
  val lift : ('a, 'b) t -> ('a M.t, 'b M.t) t
  (** [lift eq] produces a proof that ['a M.t] and ['b M.t] are equivalent if ['a] and ['b] are
      equivalent *)
end
