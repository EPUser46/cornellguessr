type game = Game.t
type leaderboard = Accounts.board
type location = Data.location

exception Not_implemented of string

let init_round () = ()
let show_folder (_ : location) = raise (Not_implemented "show_folder")
let show_result (_ : game) = raise (Not_implemented "show_result")
let show_hud (_ : game) = raise (Not_implemented "show_hud")
let show_final (_ : game) = raise (Not_implemented "show_final")
let show_leaderboard (_ : leaderboard) = raise (Not_implemented "show_leaderboard")
let show_error (_ : string) = raise (Not_implemented "show_error")