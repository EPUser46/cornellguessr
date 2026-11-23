type result = {
  distance : float;
  points : int;
}

type t
(**[t] represents the round*)

val create : Random.State.t -> Data.t -> t
(**[create] creates a new round. takes in a random number generator *)

val location : t -> Data.location
(**[location] returns the round's location*)

val time_left : t -> float
(**[time_left] returns the amount of time left in the round*)

val guess : t -> Data.coord -> result
(**[guess] lets the user create a guess and returns the result*)

val update_round : t -> float -> t
(**[update_round] decrements the time and returns record with new timer *)
