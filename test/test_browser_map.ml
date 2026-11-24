(* This is just example code from the github *)
open Playwright

let () =
    (* initialize eio with environment env *)
    Eio_main.run @@ fun env ->
    (* initialize playwright *)
    Playwright.run ~env @@ fun pw ->
    (* launch browser*)
    let browser = BrowserType.launch (chromium pw) in
    (* create webpage *)
    let page = BrowserContext.new_page (Browser.new_context browser) in
    (* open webpage*)
    ignore (Page.goto page "http://localhost:8000/index.html");

    (* Test #1: Map initialized*)
    let map = Page.locator page "#map" in
    Expect.to_be_visible map;
    (* success *)
    print_endline "Map test passed.";

    (* Test #1: Click on map creates marker*)
    Locator.click map; (* This clicks on the map*)
    let marker = Page.locator page ".leaflet-marker-icon" in
    Expect.to_be_visible marker;
    (* success *)
    print_endline "Marker click test passed.";

    Browser.close browser