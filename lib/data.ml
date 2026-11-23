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
  data.locations.(Random.State.int rng (Array.length data.locations))

(**[json_to_data] converts json to a location object*)
let location_of_json (j : Yojson.Safe.t) : location  =
  let open Yojson.Safe.Util in
  {
    coord =
      {
        lat = j |> member "GPSLatitude" |> to_float;
        lon = j |> member "GPSLongitude" |> to_float;
      };
    photo = j |> member "SourceFile" |> to_string;
  }

(**[init] initializes the data with a path to metadata json*)
let init (json_path : string) : t =
  let open Yojson.Safe.Util in
  { locations = Yojson.Safe.from_file json_path |> to_list |> List.map location_of_json |> Array.of_list }

(**[locations] returns all the locations of data *)
let locations (data : t) : location array = data.locations
