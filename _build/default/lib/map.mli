(* Map:
  - Uses Leaflet library
  - Mark location on map
  - Need to get coord of image and coord of user guess
  - Need to draw line on map between 2 coords.
*)

val create_map: string -> Leaflet.Map.t
(** [create_map id start_coords zoom] takes in the DOM id of the <div> element where the map will be created,
  a Data.coord, and an int option for some zoom value, and returns a Leaflet Map module at start_coord with 
  the appropriate zoom. *)

