(* Map:
  - Uses Leaflet library
  - Mark location on map
  - Need to get coord of image and coord of user guess
  - Need to draw line on map between 2 coords.
  Client can:
  - create map
  - use map_click_handler whenever they want some behavior to happen when user clicks map
  - can call create line to compare guess and actual
*)

val create_map: string -> Data.coord -> int option -> Leaflet.Map.t
(** [create_map id start_coords zoom] takes in the DOM id of the <div> element where the map will be created,
  a [Data.coord], and an int option for some zoom value, and returns a Leaflet Map module at [start_coords] with 
  the appropriate zoom. *)

val map_click_handler: Leaflet.Map.t -> (Data.coord -> unit) -> unit
(** [map_click_handler map callback] creates an event listener for clickes on the map.
  It removes any old markers on the map, and creates a new marker at the clicked coordinates.
  Pass in callback function, which has clicked coordinates as arguments as a [Data.coord] type*)

val create_line: Data.coord -> Data.coord -> Leaflet.Map.t -> unit
(** [create_line guess_coords img_coords map] creates a line between [guess_coords] and [img_coords] on a layer on [map] *)