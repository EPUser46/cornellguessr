(* Timer:
  - You can start a timer, decrement a timer by exactly 1, 
    check if time is less than 0, and get remaining time (assume 0 end)
  Client has to:
  - start timer
  - handle decreasing timer
  - decide when to end timer
  - Designed to work in seconds, but nothing enforcing this (client controls this)
*)

val get_remaining_time: unit -> int
(** [get_remaining_time] returns the number of SECONDS remaining*)
val decr_time: unit -> unit
(** [decr_time] decrements the remaining time by exactly 1 seconds*)
val time_up: unit -> bool
(** [time_up] returns true when remaining time is less than 0*)
val start_time: int -> unit
(** [start_time minutes] expects an int in MINUTES, which it will convert to SECONDS *)