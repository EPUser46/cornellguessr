type result = {
  distance : float;
  points : int;
}

type t = { location : Data.location; timer : Timer.t }
(**[t] represents the round*)

(**[create] creates a new round. takes in a random number generator *)
let create (rng : Random.State.t) (data : Data.t) : t =
  { location = Data.pick data rng; timer = Timer.create_timer 5.0}

(**[location] returns the round's location*)
let location t : Data.location = t.location

(**[time_left] returns the amount of time left in the round*)
let time_left t : float = Timer.get_remaining_time t.timer

let points (distance : float) : int = int_of_float distance

(**[guess] lets the user create a guess and returns the result*)
let guess t (guess : Data.coord) : result =
  let distance =
    guess.lon -. t.location.coord.lon +. (guess.lat -. t.location.coord.lat)
  in
  { distance; points = points distance }

(**[update_round] decrements the time and returns record with new timer *)
let update_round (round : t) (dt : float) : t =
  { round with timer = Timer.decr_time round.timer dt }
