#!/bin/bash
CMD="../src/tone_mapping.py"
for x in 1 2 4 8 16 64; do
        python3 ${CMD} ../base_images/chest.tiff -O . -vvv -c 4 -e 0.7 -b 512 -x $x  --postfix=_downsampling_${x} -o png
done
