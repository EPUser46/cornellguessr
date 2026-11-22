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

(**[json_to_data] converts photo to metadata json*)
let json_of_photo (photo_path : string) : Yojson.Safe.t =
  let open Yojson.Safe.Util in
  (* terminal command that reads metadata of photo. make sure to install
     exiftool: brew install exiftool *)
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

(**[jpg_of_heic] converts an heic photo to a jpg photo and returns new path*)
let jpg_of_heic (heic : string) : string =
  (*match teh heic extension*)
  match String.lowercase_ascii (Filename.extension heic) with
  | ".heic" | ".heif" ->
      (*/raw_photos*)
      let raw_dir = Filename.dirname heic in
      (*gets the directory of /raw_pohtos and append to front of
        /jps_photos/*.jpg*)
      let out_dir = Filename.concat (Filename.dirname raw_dir) "jpg_photos" in
      (*helpful message if not converted properly*)
      if Sys.command ("mkdir -p " ^ Filename.quote out_dir) <> 0 then
        failwith ("could not create " ^ out_dir);
      (* replace extension*)
      let jpg =
        Filename.concat out_dir (Filename.remove_extension (Filename.basename heic) ^ ".jpg")
      in
      (*only convert if the jpg doesn't exist yet*)
      if not (Sys.file_exists jpg) then begin
        let cmd =
          (* use magick. make sure to intall magick: brew install imagemagick *)
          Printf.sprintf "magick %s -quality 90 %s" (Filename.quote heic)
            (Filename.quote jpg)
        in
        if Sys.command cmd <> 0 then failwith ("HEIC conversion fialed: " ^ heic)
      end;
      jpg
  | _ -> heic

(**[json_to_data] converts json to a location object*)
let location_of_json (j : Yojson.Safe.t) : location =
  let open Yojson.Safe.Util in
  {
    coord =
      {
        lat = j |> member "lat" |> to_float;
        lon = j |> member "lon" |> to_float;
      };
    photo = j |> member "photo" |> to_string |> jpg_of_heic;
  }

(**[init] initializes the data with a list of locations*)
let init (paths : string list) : t =
  (* retrieve photo from paths *)
  let locations =
    List.map (fun x -> location_of_json (json_of_photo x)) paths
  in
  { locations = Array.of_list locations }

(**[locations] returns all the locations of data *)
let locations (data : t) : location array = data.locations
