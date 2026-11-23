type result = {
  distance : float;
  points : int;
}

type t
(**[t] represents the round*)

val create : Random.State.t -> Data.t -> t
(**[create rng data] creates a new round. takes in a random number generator *)

val location : t -> Data.location
(**[location t] returns the round's location*)

val time_left : t -> float
(**[time_left t] returns the amount of time left in the round*)

val guess : t -> Data.coord -> result
(**[guess t c] lets the user create a guess and returns the result*)

val update_round : t -> float -> t
(**[update_round t dt] decrements the time and returns record with new timer *)

val haversine_m : Data.coord -> Data.coord -> float
(**[haversine_m a b] returns the meter difference between two coordinates *)
