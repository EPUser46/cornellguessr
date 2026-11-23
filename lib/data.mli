type coord = {
  lat : float;
  lon : float;
}

type location = {
  coord : coord;
  photo : string;
}

type t
(**[t] represents the data*)

val init : string -> t
(**[init json_path] initializes the data with a path to metadata json*)

val distance : coord -> coord -> float
(**[distance c1 c2] calculates the distance between two coordinates*)

val pick : t -> Random.State.t -> location
(**[pick t rng] randomly picks a photo*)

val location_of_json : Yojson.Safe.t -> location
(**[json_to_data j] converts json to a location object*)

val locations : t -> location array
(**[locations t] returns all the locations of data *)
