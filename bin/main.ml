
(** setting up arbitrary map in "map" <div> with Baker Lab coords and some zoom*)
let () = 
  let _map =
    Cornellguessr.Map.create_map "map" {lat = 42.450528; lon = -76.481892} (Some 100)
  in ()