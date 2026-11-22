type result = {
     distance: float;
     points: int;
}

(**[t] represents the round*)
type t = {location: Data.location; timer: Timer.t}

(**[create] creates a new round. takes in a random number generator *)
let create (rng:Random.State.t) (data:Data.t) : t = 
     {location = Data.pick data rng; start_time = now; timer = Timer.create 5}

(**[location] returns the round's location*)
let location t : Data.location = t.location

(**[time_left] returns the amount of time left in the round*)
let time_left t : float = Timer.left t.timer

let points (distance:float) : int  = int_of_float distance

(**[guess] lets the user create a guess and returns the result*)
let guess t (guess:Data.coord): result = 
     let distance = (guess.lon -. t.location.coord.lon) +. (guess.lat -. t.location.coord.lat) in
     {distance = distance; points = (points distance)}

