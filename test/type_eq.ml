let () =
  let open Alcotest in
  run "type_eq"
    [
      ( "Basic functionality",
        let module Subject : sig
          (* These three types are opaque, but because we provide proofs that the types are equal,
             they can be coerced into the same type. *)
          type a
          type b
          type c

          val a_b_proof : (a, b) Type_eq.t
          (** [a_b_proof] proves that [a] and [b] are the same type. *)

          val b_c_proof : (b, c) Type_eq.t
          (** [b_c_proof] proves that [b] and [c] are the same type. *)

          val a_of_string : string -> a
          val b_of_string : string -> b
          val c_of_string : string -> c
          val string_of_a : a -> string
          val string_of_b : b -> string
          val string_of_c : c -> string
        end = struct
          type a = string
          type b = string
          type c = string

          let a_b_proof = Type_eq.Eq
          let b_c_proof = Type_eq.Eq
          let a_of_string x = x
          let b_of_string x = x
          let c_of_string x = x
          let string_of_a x = x
          let string_of_b x = x
          let string_of_c x = x
        end in
        [
          ( test_case "Proof can be used to coerce one type to another" `Quick
          @@ fun () ->
            let open Subject in
            let a : a = a_of_string "foo" in
            let b : b = Type_eq.coerce a_b_proof a in

            check string "equal" (string_of_a a) (string_of_b b) );
          (*
           *
           *)
          ( test_case "Proofs follow the commutative property" `Quick
          @@ fun () ->
            let open Subject in
            let b_a_proof = Type_eq.commute a_b_proof in
            let b : b = b_of_string "bar" in
            let a : a = Type_eq.coerce b_a_proof b in
            check string "equal" (string_of_a a) (string_of_b b) );
          (*
           *
           *)
          ( test_case "Proofs follow the transitive property" `Quick @@ fun () ->
            let open Subject in
            let a_c_proof : (a, c) Type_eq.t =
              Type_eq.transit a_b_proof b_c_proof
            in
            let a : a = a_of_string "foo" in
            let c : c = Type_eq.coerce a_c_proof a in
            check string "equal" (string_of_a a) (string_of_c c) );
          (*
           *
           *)
          ( test_case "Proofs can be used to check equality" `Quick @@ fun () ->
            let open Subject in
            let a : a = a_of_string "foo" in
            let b : b = b_of_string "foo" in
            let c : c = c_of_string "bar" in

            check bool "equal" true (Type_eq.val_equal a_b_proof a b);
            check bool "equal" false (Type_eq.val_equal b_c_proof b c) );
          (*
           *
           *)
          ( test_case "Proofs can be lifted into types with one parameter" `Quick
          @@ fun () ->
            let open Subject in
            let a : a option = Some (a_of_string "foo") in
            let b : b option = Some (b_of_string "foo") in
            let c : c option = None in

            let open Type_eq.Lift (struct
              type 'a t = 'a option
            end) in
            check bool "equal" true (Type_eq.val_equal (lift a_b_proof) a b);
            check bool "equal" false (Type_eq.val_equal (lift b_c_proof) b c) );
        ] );
    ]
