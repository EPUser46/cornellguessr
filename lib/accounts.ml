type entry = {
  name : string;
  score : int;
}

(* AF: The entry list [[e1; e2; ...; en]] represents a leaderboard where [e1] is
   first, [e2] is second, and so on. RI: The list is ordered by [score] from
   highest to lowest. Entries with equal scores stay in the order they were
   added. *)
type board = entry list

let empty = []

let rec add b e =
  match b with
  | [] -> [ e ]
  | x :: rest -> if x.score >= e.score then x :: add rest e else e :: b

let rec top n b =
  if n <= 0 then []
  else
    match b with
    | [] -> []
    | e :: rest -> e :: top (n - 1) rest

let to_json _b = failwith "to_json not implemented yet"
let of_json _s = failwith "of_json not implemented yet"
