type t = {
  rng : Random.State.t;
  data : Data.t;
  pin : Data.coord option;
  current : Round.t;
  result : Round.result option;
  finished : (Round.t * Round.result) list
} 
let total_rounds = 5

let current_round state = 
  state.current

let round_number state =
  List.length (state.finished) + 1

let finished_rounds state = 
  List.rev state.finished

let result state = 
  state.result

let init rng data =
  {rng; data; pin = None; current = Round.create rng data; result = None; finished = []} 

let game_tick state dt =
  match state.result with
  | Some _ -> state
  | None -> (* the round is pending *)
    let current = Round.update_round state.current dt in
    if Round.time_left current = 0.0
      then {state with current; pin = None; result = Some {Round.distance = infinity; points = 0}}
  else
    {state with current}

let next_round state = 
  match state.result with 
  | Some r when round_number state < total_rounds ->  {state with pin = None; current = Round.create state.rng state.data; result = None; finished = (state.current, r) :: state.finished}
  | _ ->  state (* round still in progress, so maintain current state (technically no next button enabled yet regardless)*)

let place_pin state coord = 
  if state.result = None then {state with pin = Some coord} else state

let submit state =
  match state.pin, state.result with
  | Some coord, None -> { state with result = Some (Round.guess state.current coord)} 
  | _ -> state

let total_points state =
  let finished_points = List.fold_left (fun acc (_, (r : Round.result)) -> acc + r.points) 0 state.finished
in
  match state.result with 
  | Some r ->  finished_points + r.points
  | None -> finished_points

let is_over state = 
  if List.length state.finished = total_rounds then true else false