type coord = {lat: float; lon: float}
type location = {coord: coord; photo: string}

(**[t] represents the data*)
type t

(**[init] initializes the data given a list of photo paths *)
val init: string list -> t

(**[distance] calculates the distance between two coordinates*)
val distance : coord -> coord -> float

(**[pick] randomly picks a photo*)
val pick : t -> Random.State.t -> location

(**[json_to_data] converts photo into a location json object (lon, lat, file path)*)
val json_of_photo : string -> Yojson.Safe.t

(**[json_to_data] converts json to a location object*)
val location_of_json : Yojson.Safe.t -> location

(**[locations] returns all the locations of data *)
val locations: t -> location array

(**[jpg_of_heic] converts an heic photo to a jpg photo and returns new path*)
val jpg_of_heic : string -> string