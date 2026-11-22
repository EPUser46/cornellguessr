type t = {
  rng : Random.State.t;
  data : Data.t;
  pin : Data.coord option;
  current : Round.t;
  result : Round.result option;
  finished : Round.t * Round.result list
} 
let total_rounds = 5

let init rng data =
  {rng; data; pin = None; current = Round.create rng data time; result = None; finished = []} (**unsure about time arg. to Round.create / where game gets it from*)
  
let next_round state = 
  let r = match state.result with 
  | Some r -> r
  | None -> {Round.distance = infinity; points = 0}
in
  {state with pin = None; current = Round.create state.rng state.data; result = None; finished = (state.current, r) :: state.finished}

let place_pin state coord = 
  if state.result = None then {state with pin = Some coord} else state

let submit state =
  match state.pin, state.result with
  | Some coord, None -> { state with result = Some (Round.guess state.current coord time_taken)} (**currently unsure about time arg.*)
  | _ -> state

let current_round state = 
  state.current

let round_number state =
  List.length state.finished + 1

let finished_rounds state = 
  List.rev state.finished

let total_points state =
  let finished_points = List.fold_left (fun acc (_, (r : Round.result)) -> acc + r.points) 0 state.finished
in
  match state.result with 
  | Some r ->  finished_points + r.points
  | None -> finished_points

let is_over state = 
  if List.length state.finished = total_rounds then true else false