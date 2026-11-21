type coord = {lat: float; lon: float}
type location = {coord: coord; photo: string}

(**[t] represents the data*)
type t

(**[init] initializes the data with a list of location json *)
val init: string list -> t

(**[distance] calculates the distance between two coordinates*)
val distance : coord -> coord -> float

(**[pick] randomly picks a photo*)
val pick : t -> Random.State.t -> location

(**[json_to_data] converts photo into a location json object (lon, lat, file path)*)
val photo_to_json: string -> location

(**[json_to_data] converts json to a location object*)
val json_to_data: string -> location

(**[add_to_data] adds a location to data*)
val add_to_data: location -> t