(* This is just example code from the github *)
open Playwright

let () =
    Eio_main.run @@ fun env ->
    Playwright.run ~env @@ fun pw ->
    let browser = BrowserType.launch (chromium pw) in
    let page = BrowserContext.new_page (Browser.new_context browser) in
    ignore (Page.goto page "https://playwright.dev");
    Page.get_by_role page `Link ~name:"Get started" |> Locator.click;
    Expect.to_be_visible (Page.get_by_role page `Heading ~name:"Installation");
    print_endline (Page.title page);
    Browser.close browser