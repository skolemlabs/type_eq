(lang dune 3.1)

(name type_eq)

(version 0.0.1)

(generate_opam_files true)

(source
 (github skolemlabs/type_eq))

(authors "Zach Baylin <zbaylin@gmail.com>")

(maintainers
 "Zach Baylin <zbaylin@gmail.com>"
 "Trent Small <sixstring982@gmail.com>")

(license MIT)

(package
 (name type_eq)
 (synopsis "Type equality proofs for OCaml 4")
 (depends
  (ocaml
   (>= 4.03))
  dune
  (alcotest :with-test)))
