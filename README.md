# type_eq

## What does this library do?

`type_eq` provides a simple mechanism for constructing a _type proof_ -- i.e.
a binding which knows that two types are the same, even if they are opaque.
Here's a short example:

```ocaml
module A : sig
  (* These types are opaque outside of the [A] module. *)
  type a
  type b

  (* This type is not the same as [a] or [b]. *)
  type c

  val a_b_proof : (a, b) Type_eq.t
  (** [a_b_proof] proves that [a] and [b] are the same type -- otherwise a type
      error will be thrown during its construction! *)

  val a_c_proof : (a, c) Type_eq.t
  (** [a_c_proof] proves that [a] and [c] are the same type.

      Unfortunately, [a] and [c] are _not_ the same type, so this cannot be constructed! *)
end = struct
  (* These types are indeed the same! *)
  type a = string
  type b = string
  type c = int

  let a_b_proof = Type_eq.Eq
  let a_c_proof = Type_eq.Eq
  (* This fails with a type error:

     Error: Signature mismatch:
        ...
        Values do not match:
          val a_c_proof : ('a, 'a) Type_eq.t
        is not included in
          val a_c_proof : (b, c) Type_eq.t
        The type (b, b) Type_eq.t is not compatible with the type
          (b, c) Type_eq.t
        Type b is not compatible with type c
  *)
end
```

## Why is this library useful?

Sometimes you'll be working with types which are opaque -- as in the example
above. This utility can be used to determine if two opaque types are indeed
equal, which can allow you to cast between them, among other operations.

See the `.mli` file for a fully-documented interface.

Note that a stripped-down version of this utility is included as `Type.eq` in
OCaml 5+: https://github.com/ocaml/ocaml/blob/c2d00ef67b4af1e6ba90e77e4106770bbdd88a01/stdlib/type.ml#L18
