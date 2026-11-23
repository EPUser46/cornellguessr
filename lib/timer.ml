let remaining_time = ref 0
let get_remaining_time () = !remaining_time
let decr_time () = decr remaining_time

let time_up () = !remaining_time <= 0

let minutes_to_seconds minutes = minutes * 60
let start_time duration = remaining_time := (minutes_to_seconds duration)