open OUnit2
open Cornellguessr

(**[approx] checks if two floats are within tolerance *)
let approx a b tolerance = abs_float (a -. b) < tolerance

let test_data_init _ =
  let photo = "../public/photos/IMG_6138.HEIC" in
  let data = Data.init [ photo ] in
  let loc = (Data.locations data).(0) in
  assert (approx loc.coord.lat 42.4464 1e-4);
  assert (approx loc.coord.lon (-76.4859) 1e-4);
  assert (loc.photo = photo)

let test_data_pick _ =
  let photo = "../public/photos/IMG_6138.HEIC" in
  let data = Data.init [ photo ] in
  let rng = Random.State.make_self_init () in
  let loc = Data.pick data rng in
  assert (approx loc.coord.lat 42.4464 1e-4);
  assert (approx loc.coord.lon (-76.4859) 1e-4);
  assert (loc.photo = photo)

let tests =
  "test suite"
  >::: [
         ("a trivial test" >:: fun _ -> assert_equal 0 0);
         "test initializing data.t" >:: test_data_init;
         "test picking a photo from data.t" >:: test_data_init;
       ]

let _ = run_test_tt_main tests
