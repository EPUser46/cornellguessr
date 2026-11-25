open Js_of_ocaml
open Cornellguessr
open Js_of_ocaml_lwt

let metadata_path = "/static/metadata.json"

(* Starting coordinates for the map. *)
let bakerlab_coord : Data.coord = { lat = 42.450528; lon = -76.481892 }

(* [on_click id f] runs [f ()] whenever the button with id [id] is clicked. *)
let on_click id f =
  let button = Dom_html.getElementById id in
  button##.onclick :=
    Dom_html.handler (fun _ ->
        f ();
        Js._true)

(* [set_disabled id b] disables the button with id [id] if [b] is true. *)
let set_disabled id b =
  match Dom_html.getElementById_coerce id Dom_html.CoerceTo.button with
  | Some button -> button##.disabled := Js.bool b
  | None -> ()

(* [set_status msg] shows [msg] in the status line at the top of the page. *)
let set_status msg =
  let status = Dom_html.getElementById "status" in
  status##.textContent := Js.some (Js.string msg)

(* [show_round_number g] shows which round [g] is on. Example: "Round 2 of
   5". *)
let show_round_number g =
  set_status
    (Printf.sprintf "Round %d of %d" (Game.round_number g) Game.total_rounds)

(* [set_hidden id b] hides the element with id [id] if [b] is true, and shows it
   if [b] is false. *)
let set_hidden id b =
  let el = Dom_html.getElementById id in
  if b then el##setAttribute (Js.string "hidden") (Js.string "")
  else el##removeAttribute (Js.string "hidden")

(* For localStorage. *)
let leaderboard_key = "cornellguessr-leaderboard"

(* [load_leaderboard ()] is the saved leaderboard, or an empty one if nothing is
   saved yet or the saved text can't be read. *)
let load_leaderboard () =
  match Js.Optdef.to_option Dom_html.window##.localStorage with
  | None -> Accounts.empty
  | Some storage -> (
      match Js.Opt.to_option (storage##getItem (Js.string leaderboard_key)) with
      | None -> Accounts.empty
      | Some saved -> (
          match Accounts.of_json (Js.to_string saved) with
          | Ok board -> board
          | Error _ -> Accounts.empty))

let save_leaderboard board =
  match Js.Optdef.to_option Dom_html.window##.localStorage with
  | None -> ()
  | Some storage ->
      storage##setItem
        (Js.string leaderboard_key)
        (Js.string (Accounts.to_json board))

(* Game Loop: if some result, exit loop and return promise unit; o/w take a tick on game of 1.0s and loop *)
let rec game_loop game round_up =
  if !round_up then Lwt.return_unit
  else
  match (Game.result !game) with
  | Some result -> Lwt.return_unit
  | None -> 
    let%lwt () = Lwt_js.sleep 1.0 in
    if !round_up then Lwt.return_unit
    else begin
      game := Game.game_tick !game 1.0;
      game_loop game round_up
    end

let check_end game =
  if Game.round_number !game < Game.total_rounds then set_disabled "next-btn" false
  else begin
    set_status (Printf.sprintf "Game over! Total: %d points" (Game.total_points !game));
    set_hidden "finish" false
  end


(** Umm work in progress !!! ignore dis3 
let key_bindings_setup key callback = 
  Dom_html.document##.keypress :=
    Dom_html.handler (fun event ->
      if Js.to_string event##.key = key then
        callback();
        Js._true)
        *)



(* check if round up, if not, set to true; 
  get game pin. If not placed, show no guess;
  if placed, submit, show result, create line on map;
  either way, disable guess button and check if game ended*)
let submit_guess (game: Game.t ref) display map_record round_up =
  if not !round_up then begin
    round_up := true;
    (match (!game).pin with
      | None ->
        Display.show_error display "No Guess."
      | Some pin ->
        Display.show_result display !game;
        let answer = (Round.location (Game.current_round !game)).coord in
        Map.create_line pin answer map_record);
    set_disabled "guess-btn" true;
    check_end game
  end

(* to be called at every start of round
  starts game loop; when game loop returns, submit guess*)
let start_round_timer game display map_record =
      (* start game loop, and returns *)
      Lwt.async (fun () ->
        let round_up = ref false in
      let%lwt () = game_loop game round_up in
      game := Game.submit !game;
      submit_guess game display map_record round_up;
      Lwt.return_unit
        )

let player_name () =
  match
    Dom_html.getElementById_coerce "player-name" Dom_html.CoerceTo.input
  with
  | Some input -> Js.to_string input##.value
  | None -> ""

let () =
  let display = Display.init_round () in
  let default_zoom = Some 100 in
  let map_record = Map.create_map "map" bakerlab_coord default_zoom in

  (* Load leaderboard. *)
  let board = ref (load_leaderboard ()) in
  Display.show_leaderboard display !board;

  (* Load data and start game. *)
  match Data.init metadata_path with
  | exception e ->
      set_status "Couldn't start the game.";
      Display.show_error display ("Couldn't load data: " ^ Printexc.to_string e)
  | data ->
      let game = ref (Game.init (Random.State.make_self_init ()) data) in
      Display.show_image display (Round.location (Game.current_round !game));
      show_round_number !game;

      let round_up = ref false in
      (* start roudn timer *)
      start_round_timer game display map_record;

      (* Event handler for map pin place. *)
      Map.map_click_handler map_record (fun coords ->
          game := Game.place_pin !game coords);

      (* Event handler for guess submit. *)
      on_click "guess-btn" (fun () ->
          match !game.pin with
          | None ->
              Display.show_error display "Click the map to place a pin first."
          | Some pin ->
              game := Game.submit !game;
              submit_guess game display map_record round_up);

      (* Event handler for saving the score at the end of the game. *)
      on_click "save-btn" (fun () ->
          match player_name () with
          | "" -> Display.show_error display "Enter your name first."
          | name ->
              board :=
                Accounts.add !board { name; score = Game.total_points !game };
              save_leaderboard !board;
              Display.show_leaderboard display !board;
              set_hidden "finish" true;
              set_status "Score saved!");

      (* Event handler for next round. *)
      on_click "next-btn" (fun () ->
          game := Game.next_round !game;
          round_up := false;
          (* start NEW roudn timer *)
          start_round_timer game display map_record;
          Display.reset_round display;
          Display.show_image display (Round.location (Game.current_round !game));
          Map.reset_map map_record bakerlab_coord default_zoom;
          show_round_number !game;
          set_disabled "guess-btn" false;
          set_disabled "next-btn" true)
