type coord = {lat: float; lon: float}
type location = {coord: coord; photo: string}

(**[t] represents the data*)
type t

(**[init] initializes the data with a path to metadata json*)
val init: string -> t

(**[distance] calculates the distance between two coordinates*)
val distance : coord -> coord -> float

(**[pick] randomly picks a photo*)
val pick : t -> Random.State.t -> location

(**[json_to_data] converts json to a location object*)
val location_of_json : Yojson.Safe.t -> location

(**[locations] returns all the locations of data *)
val locations: t -> location array
