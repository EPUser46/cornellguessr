open Js_of_ocaml
open Cornellguessr

(** setting up arbitrary map in "map" <div> with Baker Lab coords and some zoom*)
let () = 
  let (bakerlab_coord: Data.coord) = {lat = 42.450528; lon = -76.481892} in
  let map =
    Map.create_map "map" bakerlab_coord (Some 100)
  (* Example of how you can use [Map.map_click_handler]
    -> use this in game to store guess coords *)
  in Map.map_click_handler map (fun coords ->
    let status = Dom_html.getElementById "status" in
    let text = Printf.sprintf "Clicked coordinates: %f %f\n" coords.lat coords.lon in
    status##.textContent := Js.some (Js.string text)
    )