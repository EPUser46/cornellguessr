type t {
  rng : Random.State.t;
  data : Data.t;
  pin : Data.coord option;
  current : Round.t;
  result : Round.result option;
  finished : Round.t list
}
(**The state of a game currently in progress. Contents of [t] can only be accessed by the getter functions defined below.*)

val total_rounds : int
(** The number of total rounds in a game (5)*)

val init : Random.State.t -> Data.t -> t
(**[init rng locs] is a new game whose locations (rounds) are picks from [locs]*)

val place_pin : t -> float * float -> t
(**[place_pin state (lat, long)] is [state] with the current round's guess set to [(lat, lng)] (replaces earlier guesses). If current round submitted, [st] is unchanged.*)

val submit : t -> t
(**[submit state] scores the current round's guess. If no pin has been placed or if round already submitted, [state] unchanged.*)

val next_round : t -> t
(**[next_round state] transitions to the next round with a new random location. 
  Requires: the current state has been submitted or timer has run out, 
    and [round_number state < total_rounds].*)

val current_round : t -> Round.t
(**[current_round state] returns the round current played in the game.*)

val round_number : t -> int
(**[round_number state] is the current round in integer, from 1 to [total_rounds]*)

val finished_rounds : t -> Round.t list
(**[finished_rounds t] is the completed rounds, in order of which they were played.*)

val total_points : t -> int
(**[total_points state] takes the sum of the scores of all submitted rounds, including the current one if submitted.*)

val is_over : t -> bool
(**[is_over state] indicates whether the game has finished. Returns: [true] if the last round has been submitted, [false] otherwise.*)