(* Map:
  - Uses Leaflet library
  - Mark location on map
  - Need to get coord of image and coord of user guess
  - Need to draw line on map between 2 coords.
  Client can:
  - create map
  - use map_click_handler whenever they want some behavior to happen when user clicks map
  - can call create line to compare guess and actual
  - reset the map
*)
type t = {map: Leaflet.Map.t; 
mutable current_marker: [`Marker] Leaflet.Layer.t option; 
mutable current_line: [`Vector] Leaflet.Layer.t option}
(** Represents a map object which has the option to have a marker and has the option to have a line. *)

val create_map: string -> Data.coord -> int option -> t
(** [create_map id start_coords zoom] takes in the DOM id of the <div> element where the map will be created,
  a [Data.coord], and an int option for some zoom value, and returns a Leaflet Map module at [start_coords] with 
  the appropriate zoom. *)

val map_click_handler: t -> (Data.coord -> unit) -> unit
(** [map_click_handler map_record callback] creates an event listener for clickes on the map.
  It removes any old markers on the map in [map_record], and creates a new marker at the clicked coordinates.
  Pass in callback function, which has clicked coordinates as arguments as a [Data.coord] type*)

val create_line: Data.coord -> Data.coord -> t -> unit
(** [create_line guess_coords img_coords map_record] creates a line between [guess_coords] and [img_coords] on a layer on the map stored in [map_record] *)

val reset_map: t -> Data.coord -> int option -> unit
(** [reset_map map_record coords zoom] resets the map in [map_record] to have no marker, no line, and be centered at the given 
  coordinate point with the given zoom. *)