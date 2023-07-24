# /bin/bash

dir=$(pwd)

mkdir -p "$OUTPUT_DIR"
cd $INPUT_DIR

for folder in *; do
    zip -r "${dir}/${OUTPUT_DIR}/${folder}.zip" "$folder"
done