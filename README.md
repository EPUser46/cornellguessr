Elizabeth Pfauth
ep575

Julie Cai
jc3768

Eric Tang
et464

Clarice Shen
cs2582

Angie Zhang
az549


Install dependencies (leaflet in dune-project):
`opam install --deps-only`

Install Ocaml-Playwright to test browser:
`opam pin add playwright https://github.com/dmytro-melno/ocaml-playwright.git`
`opam install eio_main`

To add new photos/locations:

1. Install exiftool and imagemagick:
```sh
brew install exiftool imagemagick
```

2. Put images inside public/raw_photos

3. Run these commands in the terminal inside /public:
 ```sh
   cd public
   mkdir -p jpg_photos
   for f in raw_photos/*.[Hh][Ee][Ii][Cc]; do
     magick "$f" -quality 90 "jpg_photos/$(basename "${f%.*}").jpg"
   done
   exiftool -json -n -ext jpg -GPSLatitude -GPSLongitude jpg_photos > metadata.json
   cd ..
```

4. Commit the files
