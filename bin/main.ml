open Js_of_ocaml
open Cornellguessr

let metadata_path = "/static/metadata.json"

(* Starting coordinates for the map *)
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

let () =
  let display = Display.init_round () in
  let map = Map.create_map "map" bakerlab_coord (Some 100) in

  (* Load data and start game. *)
  match Data.init metadata_path with
  | exception e ->
      set_status "Couldn't start the game.";
      Display.show_error display ("Couldn't load data: " ^ Printexc.to_string e)
  | data ->
      let game = ref (Game.init (Random.State.make_self_init ()) data) in
      Display.show_image display (Round.location (Game.current_round !game));
      show_round_number !game;

      (* Event handler for map pin place. *)
      Map.map_click_handler map (fun coords ->
          game := Game.place_pin !game coords);

      (* Event handler for guess submit. *)
      on_click "guess-btn" (fun () ->
          match !game.pin with
          | None ->
              Display.show_error display "Click the map to place a pin first."
          | Some pin ->
              game := Game.submit !game;
              Display.show_result display !game;
              let answer = (Round.location (Game.current_round !game)).coord in
              Map.create_line pin answer map;
              set_disabled "guess-btn" true;
              if Game.round_number !game < Game.total_rounds then
                set_disabled "next-btn" false
              else
                set_status
                  (Printf.sprintf "Game over! Total: %d points"
                     (Game.total_points !game)));

      (* Event handler for next round. *)
      on_click "next-btn" (fun () ->
          game := Game.next_round !game;
          Display.reset_round display;
          Display.show_image display (Round.location (Game.current_round !game));
          show_round_number !game;
          set_disabled "guess-btn" false;
          set_disabled "next-btn" true)
