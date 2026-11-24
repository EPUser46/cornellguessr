type result = {
  distance : float;
  points : int;
}

type t = {
  location : Data.location;
  timer : Timer.t;
}

let create (rng : Random.State.t) (data : Data.t) : t =
  { location = Data.pick data rng; timer = Timer.create_timer 3.0 }

let location t : Data.location = t.location
let time_left t : float = Timer.get_remaining_time t.timer

(**[points d] calculates the points given the distance*)
let points (distance : float) : int = int_of_float distance

(**[haversine_m a b] returns the meter difference between two coordinates *)
let haversine_m (a : Data.coord) (b : Data.coord) : float =
  (*convert to radians*)
  let rad d = d *. Float.pi /. 180.0 in
  let earth_r_m = 6_371_000.0 in
  let dlat = rad (b.lat -. a.lat) in
  let dlon = rad (b.lon -. a.lon) in
  (* h = sin²(Δφ/2) + cos φ₁ · cos φ₂ · sin²(Δλ/2) *)
  let h =
    (sin (dlat /. 2.0) ** 2.0)
    +. (cos (rad a.lat) *. cos (rad b.lat) *. (sin (dlon /. 2.0) ** 2.0))
  in
  (* 2R · arcsin(√h) *)
  2.0 *. earth_r_m *. asin (sqrt h)

let guess t (guess : Data.coord) : result =
  let distance = haversine_m guess t.location.coord in
  { distance; points = points distance }

let update_round (round : t) (dt : float) : t =
  { round with timer = Timer.decr_time round.timer dt }
