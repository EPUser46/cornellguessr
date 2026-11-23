(* Timer:
  - You can start a timer, decrement a timer by exactly 1, 
    check if time is less than 0, and get remaining time (assume 0 end)
  Client has to:
  - start timer
  - handle decreasing timer
  - decide when to end timer
  - Designed to work in seconds, but nothing enforcing this (client controls this)
  - time is represented as an int
  - idea ummm we probably want time as a float? -> idea = score based on time
  - but then want better way to update time idk maybe it would work
*)

type t
(** timer type *)

val get_remaining_time: t -> float
(** [get_remaining_time t] returns the number of SECONDS remaining in [t]*)
val decr_time: t -> float -> t
(** [decr_time t dt] decrements the remaining time in [t] by exactly [dt] seconds*)
val time_up: t -> bool
(** [time_up t] returns true when remaining time in [t] is less than 0*)
val create_timer: float -> t
(** [create_timer minutes] expects an int in MINUTES, which it will convert to SECONDS,
  and returns a timer *)
val seconds_to_minutes: float -> float
(** [seconds_to_minutes seconds] returns a float in SECONDS converted to a float in MINUTES*)