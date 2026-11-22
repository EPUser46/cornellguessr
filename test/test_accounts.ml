open OUnit2
open Cornellguessr

(* Create entry as a record. *)
let e name score : Accounts.entry = { name; score }

(* Build board. *)
let board_of es = List.fold_left Accounts.add Accounts.empty es
let names es = List.map (fun (x : Accounts.entry) -> x.name) es
let all b = Accounts.top max_int b
let show ns = "[" ^ String.concat "; " ns ^ "]"

(* Compare boards by their names. *)
let check_names label expected entries =
  label >:: fun _ -> assert_equal expected (names entries) ~printer:show

let add_tests =
  [
    check_names "adding entries out of order results in a sorted board"
      [ "best"; "mid"; "worst" ]
      (all (board_of [ e "worst" 30; e "best" 10; e "mid" 20 ]));
    check_names
      "tie gives precendence to first occurrence and doesn't break ordering"
      [ "first"; "second"; "worse" ]
      (all (board_of [ e "first" 10; e "worse" 50; e "second" 10 ]));
  ]

let top_tests =
  [
    check_names "top of an empty board" [] (Accounts.top 5 Accounts.empty);
    check_names "top n returns only the best n" [ "a"; "b" ]
      (Accounts.top 2 (board_of [ e "c" 3; e "a" 1; e "d" 4; e "b" 2 ]));
    check_names "top n where n > List.length board returns all entries"
      [ "a"; "b" ]
      (Accounts.top 10 (board_of [ e "b" 2; e "a" 1 ]));
    check_names "top 0 is empty" [] (Accounts.top 0 (board_of [ e "a" 1 ]));
  ]

let is_error = function
  | Error _ -> true
  | Ok _ -> false

let json_tests =
  [
    ( "save then load gives the same board" >:: fun _ ->
      let b = board_of [ e "worst" 30; e "best" 10; e "mid" 20 ] in
      match Accounts.of_json (Accounts.to_json b) with
      | Ok b' -> assert_equal (all b) (all b')
      | Error msg -> assert_failure msg );
    ( "out-of-order save loads sorted" >:: fun _ ->
      match
        Accounts.of_json
          {|[{"name":"worst","score":9},{"name":"best","score":1}]|}
      with
      | Ok b -> assert_equal [ "best"; "worst" ] (names (all b)) ~printer:show
      | Error msg -> assert_failure msg );
    ( "non-JSON input gives an error" >:: fun _ ->
      assert_bool "garbage" (is_error (Accounts.of_json "garbage")) );
    ( "entry with a missing score is an error" >:: fun _ ->
      assert_bool "missing score"
        (is_error (Accounts.of_json {|[{"name":"a"}]|})) );
  ]

let suite =
  "Accounts"
  >::: [ "add" >::: add_tests; "top" >::: top_tests; "JSON" >::: json_tests ]

let () = run_test_tt_main suite
