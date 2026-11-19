(** [entry] is a row in a leaderboard containing a player's [name] and their [score]. *)
type entry = { name : string; score : int }

(** The leaderboard. Represented as an [entry list]. Always sorted from best (highest) to worst score. *)
type board

(** [valid_name s] checks whether a player name [s] is valid. Example: Names must be at most 22 characters long. *)
val valid_name : string -> bool

(** [empty] is a leaderboard with no entries, for initialization. *)
val empty : board

(** [add b e] returns a new board with entry [e] inserted in order into [b]. *)
val add : board -> entry -> board

(** [top n b] returns a subset of the board [b] with the top [n] entries. *)
val top : int -> board -> entry list

(** [to_json b] turns the board [b] into JSON. *)
val to_json : board -> string

(** [of_json s] converts the JSON string [s] to a board. *)
val of_json : string -> (board, string) result
