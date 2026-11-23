type result = {
  distance : float;
  points : int;
}

type t = {
  location : Data.location;
  timer : Timer.t;
}

let create (rng : Random.State.t) (data : Data.t) : t =
  { location = Data.pick data rng; timer = Timer.create_timer 5.0 }

let location t : Data.location = t.location
let time_left t : float = Timer.get_remaining_time t.timer

(**[points d] calculates the points given the distance*)
let points (distance : float) : int = int_of_float distance

let guess t (guess : Data.coord) : result =
  let distance =
    guess.lon -. t.location.coord.lon +. (guess.lat -. t.location.coord.lat)
  in
  { distance; points = points distance }

let update_round (round : t) (dt : float) : t =
  { round with timer = Timer.decr_time round.timer dt }
