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

let () =
  let display = Display.init_round () in
  let map = Map.create_map "map" bakerlab_coord (Some 100) in

  (* Load data and start game. *)
  match Data.init metadata_path with
  | exception e ->
      Display.show_error display ("Couldn't load data: " ^ Printexc.to_string e)
  | data ->
      let game = ref (Game.init (Random.State.make_self_init ()) data) in
      Display.show_image display (Round.location (Game.current_round !game));

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
              set_disabled "guess-btn" true)
