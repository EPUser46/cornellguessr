type result = {
     distance: float;
     points: int;
}

(**TODO: Add timer *)

(**[t] represents the round*)
type t = {location: Data.location; start_time: float}

(**[create] creates a new round. takes in a random number generator *)
let create (rng:Random.State.t) (data:Data.t) (now:float) : t = 
     {location = Data.pick data rng; start_time = now}

(**[location] returns the round's location*)
let location t : Data.location = t.location

(**[time_left] returns the amount of time left in the round*)
let time_left t (now:float) : float = now -. t.start_time 

let points (distance:float) : int  = int_of_float distance

(**[guess] lets the user create a guess and returns the result*)
let guess t (guess:Data.coord) (now:float) : result = 
     let distance = (guess.lon -. t.location.coord.lon) +. (guess.lat -. t.location.coord.lat) in
     {distance = distance; points = (points distance)}

