type coord = {
  lat : float;
  lon : float;
}

type location = {
  coord : coord;
  photo : string;
}

type t = { locations : location array }

let pick (data : t) (rng : Random.State.t) : location =
  data.locations.(Random.State.int rng (Array.length data.locations))

let location_of_json (j : Yojson.Safe.t) : location =
  let open Yojson.Safe.Util in
  {
    coord =
      {
        lat = j |> member "GPSLatitude" |> to_float;
        lon = j |> member "GPSLongitude" |> to_float;
      };
    photo = j |> member "SourceFile" |> to_string;
  }

let init (json_path : string) : t =
  let open Yojson.Safe.Util in
  {
    locations =
      Yojson.Safe.from_file json_path
      |> to_list |> List.map location_of_json |> Array.of_list;
  }

let locations (data : t) : location array = data.locations
