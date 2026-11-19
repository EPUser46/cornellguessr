type coord = {lat: float; lon: float}
type location = {coord: coord; photo: string}

(**[t] represents the data*)
type t

(**[init] initializes the data with a list of locations*)
val init: location list -> t

(**[distance] calculates the distance between two coordinates*)
val distance : coord -> coord -> float

(**[pick] randomly picks a photo*)
val pick : t -> Random.State.t -> location