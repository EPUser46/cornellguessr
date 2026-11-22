open Game
open Accounts
open Data
open Js_of_ocaml

type game = Game.t
type leaderboard = Accounts.board
type location = Data.location

exception Not_implemented of string

type t = {
  photo : Dom_html.imageElement Js.t;
  hud : Dom_html.element Js.t;
  result : Dom_html.element Js.t;
  status : Dom_html.element Js.t;
  guess_btn : Dom_html.buttonElement Js.t;
  leaderboard: Dom_html.tableElement Js.t;
}

let doc = Dom_html.document
let set_text el s = el##.textContent := Js.some (Js.string s)

let init () =
  let root = Dom_html.getElementById_exn "game" in
  let photo = Dom_html.createImg doc in
  let hud = Dom_html.createP doc in
  let result = Dom_html.createP doc in
  let status = Dom_html.createP doc in
  let guess_btn = Dom_html.createButton doc in
  let leaderboard = Dom_html.createTable doc in
  set_text guess_btn "Guess";
  List.iter (fun e -> Dom.appendChild root e)
    [ (photo :> Dom.node Js.t); (hud :> Dom.node Js.t); (result :> Dom.node Js.t);
      (status :> Dom.node Js.t); (guess_btn :> Dom.node Js.t) ];
  { photo; hud; result; status; guess_btn ; leaderboard}

let reset_round d = set_text d.result ""; set_text d.status "Where is this?"
let show_file d (loc : Data.location) = d.photo##.src := Js.string loc.photo
let show_result d (r : Round.result) =
  set_text d.result (Printf.sprintf "%.0f m away, %d points" r.distance r.points)
let show_hud d ~time_left ~score =
  set_text d.hud (Printf.sprintf "%.0fs left · %d pts" time_left score)
let show_error d msg = set_text d.status msg
let show_file (_ : location) = raise (Not_implemented "show_folder")
let show_result (_ : game) = raise (Not_implemented "show_result")
let show_hud (_ : game) = raise (Not_implemented "show_hud")
let show_final (_ : game) = raise (Not_implemented "show_final")

let show_leaderboard t l = 
    Accounts.top 10 l in
    

let show_error (_ : string) = raise (Not_implemented "show_error")