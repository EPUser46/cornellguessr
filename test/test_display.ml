
open Cornellguessr

let metadata_path = "/static/metadata_test.json"

(* testpin is placed. *)
let bakerlab : Data.coord = { lat = 42.450528; lon = -76.481892 }

let leaderboard =
  List.fold_left Accounts.add Accounts.empty
    [
      { Accounts.name = "Clarice"; score = 22 };
      { name = "Julie"; score = 67 };
      { name = "Angie"; score = 40 };
    ]

let () =
  let d = Display.init_round () in
  match Data.init metadata_path with
  | exception e ->
      Display.show_error d ("Couldn't load data: " ^ Printexc.to_string e)
  | data ->
      let g = Game.init (Random.State.make [| 3110 |]) data in
      let g = Game.submit (Game.place_pin g bakerlab) in
      Display.reset_round d;
      Display.show_image d (Round.location (Game.current_round g));
      Display.show_hud d g;
      Display.show_result d g;
      Display.show_leaderboard d leaderboard
