type entry = {
  name : string;
  score : int;
}

(* AF: The entry list [[e1; e2; ...; en]] represents a leaderboard where [e1] is first, [e2] is second, and so on.
   RI: The list is ordered by [score] from highest to lowest. *)
type board = entry list

let valid_name _s = failwith "valid_name not implemented yet"
let empty = []

let add _b _e = failwith "add not implemented yet"
let top _n _b = failwith "top not implemented yet"
let to_json _b = failwith "to_json not implemented yet"
let of_json _s = failwith "of_json not implemented yet"
