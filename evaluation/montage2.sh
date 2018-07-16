#!/bin/bash
CMD="../src/tone_mapping.py"
for b in 16 64 128 256 512 2048; do
        python3 ${CMD} ../base_images/chest.tiff -O . -vvv -c 4 -e 0.7 -b $b  --postfix=_discretization_${b} -o png
done
