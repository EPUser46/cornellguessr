(* Notes: 
- by default, all mouse and touch interactions on the map are enabled, 
  and it has zoom and attribution controls.
- many leaflet functions have arguments which require labeled arguments,
  do this by "~[ARG_NAME]:(var_name)"
- so a tile layer is necessary to actually display what the geographic map looks like
- there are like 23 options for creating a tile layer but using defaults rn
- tile layer uses OpenStreetMap
- there are also 12 options for creating a marker
*)

let convert_coords (coords:Data.coord) =
  Leaflet.Latlng.create ~lat:(coords.lat) ~lng:(coords.lon)

let create_map id start_coords zoom =
  let latlng = convert_coords start_coords in
  let new_map = Leaflet.Map.create_on id in
  Leaflet.Map.set_view latlng ~zoom:zoom new_map;
  (* add tile (openstreetmap) to map*)
  let tile_layer = Leaflet.Layer.create_tile_osm [||] in
  Leaflet.Layer.add_to new_map tile_layer;
  new_map

let change_marker marker map clicked_coords  =
  (match !marker with
  | Some marker -> Leaflet.Layer.remove marker
  | None  -> ());
  (* was thinking maybe you have to convert here, but can maybe do it elsewhere*)
  let latlng = clicked_coords in
  let new_marker = Leaflet.Marker.create latlng [||] in
  Leaflet.Layer.add_to map new_marker;
  marker:= Some new_marker

let get_coords coords : Data.coord =
  {Data.lat = Leaflet.Latlng.lat coords; Data.lon = Leaflet.Latlng.lng coords}

let update_guess marker map guess_callback coords =
  change_marker marker map coords;
  guess_callback (get_coords coords)
  (* guess_callback is passed in by client, says what to do when new guess made. 
    - guess coordinates are argument to callback *)


let map_click_handler map callback =
  let current_marker = ref None in
  Leaflet.Map.on Leaflet.Event.Click (
    fun event ->
      (* check if um this converts coords correctly to Data.t
        actually can either return latlng or data.t depending on if I want to expose
          this function *)
      update_guess current_marker map callback (Leaflet.Event.latlng event)
  ) map

let create_line (guess_coords: Data.coord )(img_coords: Data.coord) map =
  let coords = [| convert_coords guess_coords; convert_coords img_coords|] in
  let line = Leaflet.Layer.create_polyline coords in
  Leaflet.Layer.add_to map line