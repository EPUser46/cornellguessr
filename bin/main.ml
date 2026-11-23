open Js_of_ocaml
open Cornellguessr

let metadata_path = "/static/metadata.json"

(* Starting coordinates for the map *)
let bakerlab_coord : Data.coord = { lat = 42.450528; lon = -76.481892 }

let () =
  let display = Display.init_round () in
  let map = Map.create_map "map" bakerlab_coord (Some 100) in

  Map.map_click_handler map (fun coords ->
      let status = Dom_html.getElementById "status" in
      let text =
        Printf.sprintf "Clicked coordinates: %f %f" coords.lat coords.lon
      in
      status##.textContent := Js.some (Js.string text));

  (* Load data and start game *)
  match Data.init metadata_path with
  | exception e ->
      Display.show_error display ("Couldn't load data: " ^ Printexc.to_string e)
  | data ->
      let game = Game.init (Random.State.make_self_init ()) data in
      Display.show_image display (Round.location (Game.current_round game))
