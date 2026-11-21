type coord = {
  lat : float;
  lon : float;
}

type location = {
  coord : coord;
  photo : string;
}

type t = { locations : location array }

(**[distance] calculates the manhattan distance between two coordinates*)
let distance (c1 : coord) (c2 : coord) : float =
  abs_float (c1.lon -. c2.lon) +. abs_float (c1.lat -. c2.lat)

(**[pick] randomly picks a photo*)
let pick (data : t) (rng : Random.State.t) : location =
  data.locations.(Random.int (Array.length data.locations))

(**[json_to_data] converts photo to metadata json*)
let json_of_photo (photo_path : string) : Yojson.Safe.t =
  let open Yojson.Safe.Util in
  (* terminal command that reads metadata of photo*)
  let cmd =
    Printf.sprintf "exiftool -json -n -GPSLatitude -GPSLongitude %s"
      (Filename.quote photo_path)
  in
  let ic = Unix.open_process_in cmd in
  let exif = Yojson.Safe.from_channel ic |> to_list |> List.hd in
  ignore (Unix.close_process_in ic);
  `Assoc
    [
      ("photo", `String photo_path);
      ("lat", member "GPSLatitude" exif);
      ("lon", member "GPSLongitude" exif);
    ]

(**[json_to_data] converts json to a location object*)
let location_of_json (j : Yojson.Safe.t) : location =
  let open Yojson.Safe.Util in
  {
    coord =
      {
        lat = j |> member "lat" |> to_float;
        lon = j |> member "lon" |> to_float;
      };
    photo = j |> member "photo" |> to_string;
  }

(**[init] initializes the data with a list of locations*)
let init (paths : string list) : t =
  (* retrieve photo from paths *)
  let locations =
    List.map (fun x -> location_of_json (json_of_photo x)) paths
  in
  { locations = Array.of_list locations }


(**[locations] returns all the locations of data *)
let locations (data:t) : location array  = data.locations