# /bin/bash

mkdir Zips
cd Avatars

for folder in *; do
    echo folder
    zip -r "../Zips/${folder}.zip" "$folder"
done