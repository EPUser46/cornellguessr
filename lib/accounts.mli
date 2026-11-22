type entry = {
  name : string;
  score : int;
}
(** [entry] is a row in a leaderboard containing a player's [name] and their
    [score]. *)

type board
(** The leaderboard. Represented as an [entry list]. Always sorted from best
    (lowest) to worst score. *)

val empty : board
(** [empty] is a leaderboard with no entries, for initialization. *)

val add : board -> entry -> board
(** [add b e] returns a new board with entry [e] inserted in order into [b]. *)

val top : int -> board -> entry list
(** [top n b] returns a subset of the board [b] with the top [n] entries. *)

val to_json : board -> string
(** [to_json b] turns the board [b] into a JSON string for saving, listing
    entries from best to worst. Example:
    {v [{"name":"Clarice","score":22},{"name":"Julie","score":67}] v}
    [of_json (to_json b)] gives back [b]. *)

val of_json : string -> (board, string) result
(** [of_json s] is [Ok b] if [s] is a leaderboard saved by [to_json], where [b]
    is that board, and [Error msg] otherwise, e.g. if [s] is not valid JSON or
    an entry is missing a field. *)
