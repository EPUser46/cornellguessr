open OUnit2
open Cornellguessr
open Js_of_ocaml

let test_create_map _ =
  let test_doc = Dom_html.document in
  let map_div = Dom_html.createDiv test_doc in
  map_div##.id := Js.string "test-map";
  Dom.appendChild test_doc##.body map_div;
  let (coords: Data.coord) = {lat = 50.0; lon = -50.0} in
  let _map = Map.create_map "test-map" coords (Some 10) in
  assert_bool "Map not initialized" (Js.to_bool (map_div##.classList##contains(Js.string "leaflet-container")))
  

let tests =
  "map test suite"
  >::: [
    "test create map" >:: test_create_map;
  ]

let () = run_test_tt_main tests