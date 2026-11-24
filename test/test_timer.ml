open OUnit2
open Cornellguessr

let test_decr_timer _ =
  let timer = Timer.create_timer 10.0 in
  assert_equal (Timer.get_remaining_time(Timer.decr_time timer 1.0)) 599.0

let test_create_timer _ =
  let timer = Timer.create_timer 10.0 in
  assert_equal (Timer.get_remaining_time timer) 600.0

let test_timer_up _ =
  let timer = Timer.create_timer 10.0 in
  let new_timer = Timer.decr_time timer 600.0 in
  assert_bool "time up failed" (Timer.time_up new_timer)

let test_time_conversion _ =
  let timer = Timer.create_timer 10.0 in
  assert_equal (Timer.seconds_to_minutes(Timer.get_remaining_time timer)) 10.0
let tests =
  "timer test suite"
  >::: [
    "test create timer" >:: test_create_timer;
    "test decr timer" >:: test_decr_timer;
    "test timer up" >:: test_timer_up;
    "test time conversion" >:: test_time_conversion;
  ]

let () = run_test_tt_main tests