type t = {remaining_time : float ref;}

let get_remaining_time t = !(t.remaining_time)
let decr_time t dt = t.remaining_time := !(t.remaining_time) -. dt;t

let time_up t = !(t.remaining_time) <= 0.0

let minutes_to_seconds minutes = minutes *. 60.0
let start_time duration = (minutes_to_seconds duration)

let create_timer duration = {remaining_time = ref (start_time duration)}