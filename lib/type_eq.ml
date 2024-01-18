type (_, _) t = Eq : ('a, 'a) t

let coerce (type a b) (eq : (a, b) t) (a : a) : b =
  match (eq, a) with
  | Eq, b -> b

let commute (type a b) (eq : (a, b) t) : (b, a) t =
  match eq with
  | Eq as eq -> eq

let transit (type a b c) (eq_a : (a, b) t) (eq_b : (b, c) t) : (a, c) t =
  match (eq_a, eq_b) with
  | Eq, Eq -> Eq

let val_equal (type a b) ?(equal = ( = )) (Eq : (a, b) t) (a : a) (b : b) = equal a (b : a)

module Lift (M : sig
  type 'a t
end) =
struct
  let lift (type a b) (eq : (a, b) t) : (a M.t, b M.t) t =
    match eq with
    | Eq -> Eq
end
