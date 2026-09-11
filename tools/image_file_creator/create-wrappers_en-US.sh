#/bin/sh

pushd ..

python3 tools/image_file_creator/image_file_creator.py en-US/Characters_Codex/images.csv en-US
python3 tools/image_file_creator/image_file_creator.py en-US/Conductors_Companion/images.csv en-US
python3 tools/image_file_creator/image_file_creator.py en-US/Monstrous_Manuscript/images.csv en-US

popd