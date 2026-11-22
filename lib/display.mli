open Game
open Accounts

type game = Game.t

type leaderboard = Accounts.board

type location = Data.location

(* Initiates UI for entire round may or may not be needed? *)
val init_round : unit -> unit

(* Shows image of random location*)
val show_folder: location -> unit

(* shows result (points) of the round*)
val show_result: game -> unit

(* updates minutes left *)
val show_hud : game -> unit

(* Shows final result of the game *)
val show_final : game -> unit

(* shows leaderboard *)
val show_leaderboard : leaderboard -> unit

(* shows error*)
val show_error : string -> unit
