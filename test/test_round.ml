open OUnit2
open Cornellguessr

(**[approx] checks if two floats are within tolerance *)
let approx a b tolerance = abs_float (a -. b) < tolerance

let test_guess _ =
  let json = "../public/metadata.json" in
  let data = Data.init json in
  let rng = Random.State.make_self_init () in
  let round = Round.create rng data in
  let location = Round.location round in
  let result =
    Round.guess round
      { lon = location.Data.coord.lon; lat = location.Data.coord.lat }
  in
  assert (approx result.distance 0.0 1e-4);
  assert (result.points = 0)

let test_update_round _ =
  let json = "../public/metadata.json" in
  let data = Data.init json in
  let rng = Random.State.make_self_init () in
  let round = Round.create rng data in
  let new_round = Round.update_round round 60.0 in
  assert (approx (Timer.seconds_to_minutes (Round.time_left new_round)) 2.0 1e-4)

let test_haversine_m _ =
  let a = { Data.lat = 42.4464; lon = -76.4859 } in
  let b1 = { Data.lat = 42.4474; lon = -76.4859 } in
  let b2 = { Data.lat = 42.4464; lon = -76.4849 } in
  assert (approx (Round.haversine_m a b1) 111.195 1e-2);
  assert (approx (Round.haversine_m a b2) 82.05 0.1)

let tests =
  "test suite"
  >::: [
         ("a trivial test" >:: fun _ -> assert_equal 0 0);
         "test that guess works" >:: test_guess;
         "test that update_round works" >:: test_update_round;
         "test that haversine distance works" >:: test_haversine_m;
       ]

let _ = run_test_tt_main tests
