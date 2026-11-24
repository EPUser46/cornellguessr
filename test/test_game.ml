open OUnit2
open Cornellguessr

(*start game with initial game state*)
let json = "../public/metadata.json"
let data = Data.init json 

let new_game () = Game.init (Random.State.make [|28|]) data
let somewhere : Data.coord = {lat = 38.785; lon = -70.236}

let time_left state = Round.time_left (Game.current_round state)

(* place a pin at [somewhere] and submit *)
let guess state = Game.submit (Game.place_pin state somewhere)

(* points of the current round's result; fails the test if there is None.*)
let points state = 
  match Game.result state with
  | Some r -> r.Round.points
  | None -> assert_failure "expected a result, received None."

(* play [n] full rounds (guess, then go next), starting with initial game state*)
let play_rounds n = 
  let rec go state i = 
    if i = 1 then guess state else go (Game.next_round (guess state)) (i-1)
  in
  go (new_game()) n

(* ----- initial state tests ----- *)
let init_tests =
  [ ("starts at round 1" >:: fun _ -> 
      assert_equal 1 (Game.round_number (new_game())) ~printer:string_of_int);
    ("starts with 0 points" >:: fun _ -> 
      assert_equal 0 (Game.total_points (new_game())) ~printer:string_of_int);
    ("no result at the start" >:: fun _ -> assert_equal None (Game.result (new_game())));
    ("not over at the start of game" >:: fun _ -> 
      assert_bool "is_over" (not (Game.is_over (new_game ()))));
    ("no finished rounds" >:: fun _ -> 
      assert_equal [] (Game.finished_rounds (new_game())));
    ("timer starts positive" >:: fun _ -> assert_bool "time_left" (time_left (new_game()) > 0.));
    ("same seed, same first location" >:: fun _ ->
      assert_equal 
        (Round.location (Game.current_round (new_game ())))
        (Round.location (Game.current_round (new_game ()))) );
    
  ]

(* ----- place pin & submit ----- *)

let submit_tests =
  [
    ("submit without a pin does nothing" >:: fun _ -> 
      assert_equal None (Game.result (Game.submit (new_game()))) );

    ("pin and submit gives a result" >:: fun _ -> 
      assert_bool "has result" (Game.result (guess (new_game())) <> None) );

    ("points and distance are non-negative" >:: fun _ -> 
      match Game.result (guess (new_game())) with
      | Some r ->
        assert_bool "non-neg. distance" (r.Round.distance >= 0. );
        assert_bool "non-neg. points" (r.points >= 0)
      | None -> assert_failure "expected a result :(");

    ("submitting twice keeps the first result" >:: fun _ -> 
      let st = guess (new_game()) in
      assert_equal (Game.result st) (Game.result (Game.submit st)));
    
    ("moving pin after submission does not change result " >:: fun _ ->
      let st = guess (new_game()) in
      let st' = Game.submit (Game.place_pin st {Data.lat = 0.; lon =0.}) in
      assert_equal (Game.result st) (Game.result st'));
    
    ("total points include current if submitted" >:: fun _ ->
      let st = guess (new_game()) in
      assert_equal (points st) (Game.total_points st) ~printer:string_of_int);
  ]

let suite = 
  "game tests" >:::
  [ "init tests" >::: init_tests; "submit tests" >::: submit_tests]

let () = run_test_tt_main suite
