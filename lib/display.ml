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
  mutable hud_timer : Dom_html.interval_id option;
      (* updating hud *)
}

let doc = Dom_html.document
let set_text el s = el##.textContent := Js.some (Js.string s)

let init_round () =
  let root = Dom_html.getElementById_exn "game" in
  let photo = Dom_html.createImg doc in
  let hud = Dom_html.createP doc in
  let result = Dom_html.createP doc in
  let status = Dom_html.createP doc in
  let guess_btn = Dom_html.createButton doc in
  let leaderboard, extra =
    match Dom_html.getElementById_coerce "leaderboard" Dom_html.CoerceTo.table with
    | Some tbl -> (tbl, [])
    | None ->
        let tbl = Dom_html.createTable doc in
        (tbl, [ (tbl :> Dom.node Js.t) ])
  in
  set_text guess_btn "Guess";
  List.iter (fun e -> Dom.appendChild root e)
    ([ (photo :> Dom.node Js.t); (hud :> Dom.node Js.t); (result :> Dom.node Js.t);
      (status :> Dom.node Js.t); (guess_btn :> Dom.node Js.t) ] @ extra);
  { photo; hud; result; status; guess_btn ; leaderboard; hud_timer = None }

let reset_round d = set_text d.result ""; set_text d.status "Where is this?"
let show_image d (loc : location) =
  d.photo##.src := Js.string loc.photo;
  d.photo##.alt := Js.string "Cornell Photo"

let show_result d (g : game) =
  match g.Game.result with
  | Some r ->
      set_text d.result
        (Printf.sprintf "%.0f m away, %d points" r.distance r.points)
  | None -> set_text d.result "No guess submitted."

(* get the time now *)
let now () = Js.to_float (new%js Js.date_now)##getTime /. 1000.

(* hud refresh rate *)
let hud_refresh_ms = 250.

(* stop hud *)
let stop_hud d =
  match d.hud_timer with
  | Some id ->
      Dom_html.window##clearInterval id;
      d.hud_timer <- None
  | None -> ()

(* time left from stop hud *)
let show_hud d (g : game) =
  stop_hud d;
  let round = Game.current_round g in
  let score = Game.total_points g in
  let draw () =
    let left = Float.max 0. (Round.time_left round) in
    set_text d.hud (Printf.sprintf "%.0fs left · %d pts" (Float.ceil left) score);
    left
  in
  if draw () > 0. then
    d.hud_timer <-
      Some
        (Dom_html.window##setInterval
           (Js.wrap_callback (fun () -> if draw () <= 0. then stop_hud d))
           (Js.float hud_refresh_ms))
let show_error d msg = set_text d.status msg
let show_final (t: t) (_ : game) = raise (Not_implemented "show_final")

(* Number of leaderboard rows to display. *)
let leaderboard_size = 10

let show_leaderboard d (l : leaderboard) =
  let table = d.leaderboard in
  table##.innerHTML := Js.string "";
  let add_row make_cell cells =
    let tr = Dom_html.createTr doc in
    List.iter
      (fun s ->
        let cell = make_cell doc in
        set_text cell s;
        Dom.appendChild tr cell)
      cells;
    Dom.appendChild table tr
  in
  add_row Dom_html.createTh [ "Rank"; "Name"; "Score" ];
  match Accounts.top leaderboard_size l with
  | [] -> add_row Dom_html.createTd [ "-"; "No scores yet"; "-" ]
  | entries ->
      List.iteri
        (fun i (e : Accounts.entry) ->
          add_row Dom_html.createTd
            [ string_of_int (i + 1); e.name; string_of_int e.score ])
        entries

