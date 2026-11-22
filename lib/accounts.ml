type entry = {
  name : string;
  score : int;
}

(* AF: The entry list [[e1; e2; ...; en]] represents a leaderboard where [e1] is
   first, [e2] is second, and so on. RI: The list is ordered by [score] lowest
   (best) to highest. Entries with equal scores stay in the order they were
   added. *)
type board = entry list

let empty = []

let rec add b e =
  match b with
  | [] -> [ e ]
  | x :: rest -> if x.score <= e.score then x :: add rest e else e :: b

let rec top n b =
  if n <= 0 then []
  else
    match b with
    | [] -> []
    | e :: rest -> e :: top (n - 1) rest

(* [entry_to_json e] turns an entry [e] to a JSON [`Assoc] object, which is a
   list of (key, value) pairs. Example: turns one entry into the object
   {"name":"Julie","score":67}. *)
let entry_to_json e =
  `Assoc [ ("name", `String e.name); ("score", `Int e.score) ]

(* Each entry becomes a JSON object; the board becomes a JSON list of them. *)
let to_json b = Yojson.Safe.to_string (`List (List.map entry_to_json b))

(* [entry_of_json j] checks if the JSON [`Assoc] object for one entry is
   well-formed, then builds the entry as a record. Raises [Failure] if [j] is
   not an object with a string "name" and an int "score"; [of_json] catches
   it. *)
let entry_of_json j =
  match j with
  | `Assoc fields -> (
      match (List.assoc_opt "name" fields, List.assoc_opt "score" fields) with
      | Some (`String name), Some (`Int score) -> { name; score }
      | _ -> failwith "each entry needs a string \"name\" and an int \"score\"")
  | _ -> failwith "each entry must be a JSON object"

let of_json s =
  match Yojson.Safe.from_string s with
  | `List entries -> (
      try Ok (List.fold_left (fun b j -> add b (entry_of_json j)) empty entries)
      with Failure msg -> Error msg)
  | _ -> Error "a leaderboard must be a JSON list"
  | exception Yojson.Json_error msg -> Error ("invalid JSON: " ^ msg)
