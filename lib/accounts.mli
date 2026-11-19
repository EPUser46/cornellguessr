type entry = {
  name : string;
  score : int;
}
(** [entry] is a row in a leaderboard containing a player's [name] and their
    [score]. *)

type board
(** The leaderboard. Represented as an [entry list]. Always sorted from best
    (highest) to worst score. *)

val valid_name : string -> bool
(** [valid_name s] checks whether a player name [s] is valid. Example: Names
    must be at most 22 characters long. *)

val empty : board
(** [empty] is a leaderboard with no entries, for initialization. *)

val add : board -> entry -> board
(** [add b e] returns a new board with entry [e] inserted in order into [b]. *)

val top : int -> board -> entry list
(** [top n b] returns a subset of the board [b] with the top [n] entries. *)

val to_json : board -> string
(** [to_json b] turns the board [b] into JSON. *)

val of_json : string -> (board, string) result
(** [of_json s] converts the JSON string [s] to a board. *)
