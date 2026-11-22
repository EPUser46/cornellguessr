open Game
open Account

type game = Game.t

type leaderboard = Accounts.board

type location = Data.location

type t

(* Initiates UI for entire round may or may not be needed? *)
val init_round : unit -> t
val reset_round : t -> unit

(* Shows image of random location*)
val show_image: t -> location -> unit

(* shows result (points) of the round*)
val show_result: t -> game -> unit

(* updates minutes left *)
val show_hud : t -> game -> unit

(* Shows final result of the game *)
val show_final : t -> game -> unit

(* shows leaderboard *)
val show_leaderboard : t -> leaderboard -> unit

(* shows error*)
val show_error : t-> string -> unit
