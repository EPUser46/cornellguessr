(lang dune 3.24)

(name cornellguessr)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name <author@example.com>")

(maintainers "Maintainer Name <maintainer@example.com>")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name cornellguessr)
 (allow_empty)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends
  ocaml
  leaflet
  yojson
  js_of_ocaml
  js_of_ocaml-ppx
  js_of_ocaml-lwt
  lwt
  lwt_ppx
  (ounit2 :with-test))
 (tags
  ("add topics" "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
