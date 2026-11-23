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

Install exiftool and imagemagick:
`brew install exiftool imagemagick`

Command line:
mkdir -p public/jpg_photos
for f in public/raw_photos/*.[Hh][Ee][Ii][Cc]; do
  magick "$f" -quality 90 "public/jpg_photos/$(basename "${f%.*}").jpg"
done

exiftool -json -n -ext jpg -GPSLatitude -GPSLongitude public/jpg_photos > public/metadata.json
