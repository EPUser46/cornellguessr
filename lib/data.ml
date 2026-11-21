type coord = {lat: float; lon: float}
type location = {coord: coord; photo: string}

(**[t] represents the data*)
type t = {locations: location list}

(**[init] initializes the data with a list of locations*)
let init (paths:string list) : t = failwith "not implemented"

(**[distance] calculates the distance between two coordinates*)
let distance (c1:coord) (c2:coord) : float = failwith "not implemented"

(**[pick] randomly picks a photo*)
let pick (data:t) (rng:Random.State.t) : location = failwith "not implemented"

(**[json_to_data] converts photo into a location json object (lon, lat, file path)*)
let photo_to_json (s:string) : location = failwith "not implemented"

(**[json_to_data] converts json to a location object*)
let json_to_data (s:string) : location = failwith "not implemented"

(**[add_to_data] adds a location to data*)
let add_to_data (loc:location) : t = failwith "not implemented"