#!/bin/bash
CMD="../src/tone_mapping.py"
for e in 0.7 1.0 1.5 2.0; do
    for clip in 1.0 5.0 10 20; do
        python3 ${CMD} ../base_images/chest.tiff -O . -vvv -c $clip -e $e -b 512  --postfix=_${e}_${clip} -o png
    done
done

#use imagemagick
montage chest_0.7_1.0.png chest_0.7_5.0.png chest_0.7_10.png chest_0.7_20.png chest_1.0_1.0.png chest_1.0_5.0.png chest_1.0_10.png chest_1.0_20.png chest_1.5_1.0.png chest_1.5_5.0.png chest_1.5_10.png chest_1.5_20.png chest_2.0_1.0.png chest_2.0_5.0.png chest_2.0_10.png chest_2.0_20.png -tile 4x4 -geometry +5+5  ct_montage.png
