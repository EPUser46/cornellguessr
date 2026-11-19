type result = {
     guess: Data.coord option;
     distance: float option;
     points: int;
}

(**[t] represents the round*)
type t

(**[create] creates a new round. takes in a random number generator *)
val create: Random.State.t -> float -> t

(**[location] returns the round's location*)
val location: t -> Data.location

(**[time_left] returns the amount of time left in the round*)
val time_left: t -> float -> float

(**[guess] lets the user create a guess and returns the result*)
val guess: t -> Data.coord -> float -> result