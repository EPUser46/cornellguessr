type result = {
     guess: Data.coord option;
     distance: float option;
     points: int;
}

(**[t] represents the round*)
type t = {location: Data.location; start_time: float}

(**[create] creates a new round. takes in a random number generator *)
let create (rng:Random.State.t) (now:float) : t = failwith "not implemented"

(**[location] returns the round's location*)
let location t : Data.location = failwith "not implemented"

(**[time_left] returns the amount of time left in the round*)
let time_left t (now:float) : float = failwith "not implemented"

(**[guess] lets the user create a guess and returns the result*)
let guess t (guess:Data.coord) (now:float) : result = failwith "not implemented"