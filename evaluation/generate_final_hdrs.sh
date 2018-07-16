#!/bin/bash

# Tone mapping operators: drago|durand|fattal|reinhard02|reinhard05|mantiuk06|mantiuk08|ferradans
# Most of the time default parameters are used but Durand had a far from perfect default.
#
# License: all rights are waived, the code in this file can be used or published without any restriction,
# for all and any purpose.
#

luminance-hdr-cli -V # Version  2.5.1 was used.


for CT in head.tiff chest.tiff; do
  output=${CT/.tiff/}
  # Drago
  bias=1.0
  target=${output}_drago.png
  CMD="luminance-hdr-cli -l $CT -o ${target} -q 100 --tmo drago  --tmoDrgBias $bias"
  echo "Drago: $bias"

  $CMD
  ./TMQI_cli.m ${output}.png ${target} | tee ${target}.tmqi

  # Durand
  base_contrast=4.0
  spatial_sigma=7.0
  range_sigma=1.5
  
  target=${output}_durand.png
  echo "Durand: $target"
  
  CMD="luminance-hdr-cli -l $CT -o $target -q 100 --tmo durand  --tmoDurSigmaS $spatial_sigma --tmoDurSigmaR $range_sigma --tmoDurBase $base_contrast"
  $CMD
  ./TMQI_cli.m ${output}.png ${target} | tee ${target}.tmqi
  
  # Fattal
  alpha=0.5
  beta=0.95
  noise=0.002
  target=${output}_fattal.png
  CMD="luminance-hdr-cli -l $CT -o $target -q 100 --tmo fattal  --tmoFatAlpha $alpha --tmoFatBeta $beta --tmoFatNoise $noise"
  echo "Fattal: $alpha $beta"
  
  $CMD
  ./TMQI_cli.m ${output}.png ${target} | tee ${target}.tmqi
  
  # Reinhard 05
  brightness=7.0
  chroma=1.0
  lightness=1.0
  target=${output}_reinhard05.png
  CMD="luminance-hdr-cli -l $CT -o $target -q 100 --tmo reinhard05  --tmoR05Brightness $brightness --tmoR05Chroma $chroma --tmoR05Lightness $lightness"
  echo "Reinhard05: $brigthness $chroma $lightness"
  $CMD
  ./TMQI_cli.m ${output}.png ${target} | tee ${target}.tmqi
  
  #Reinhard 02
  key=0.02
  phi=1.0
  target=${output}_reinhard02.png
  CMD="luminance-hdr-cli -l $CT -o $target -q 100 --tmo reinhard02  --tmoR02Key $key --tmoR02Phi $phi"
  echo "Reinhard02: $key $phi"
  
  $CMD
  ./TMQI_cli.m ${output}.png ${target} | tee ${target}.tmqi
  
  #Mantiuk06
  contrast=0.25
  detail=7.0
  saturation=0.5
  target=${output}_mantiuk06.png
  CMD="luminance-hdr-cli -l $CT -o $target -q 100 --tmo mantiuk06  --tmoM06Contrast $contrast --tmoM06Saturation $saturation --tmoM06Detail $detail"
  echo "Mantiuk06: $contrast $detail"
  
  $CMD
  ./TMQI_cli.m ${output}.png ${target} | tee ${target}.tmqi
  
  #Mantiuk08
  contrast=4.3
  saturation=1.0
  target=${output}_mantiuk08.png
  CMD="luminance-hdr-cli -l $CT -o $target -q 100 --tmo mantiuk08  --tmoM08ConstrastEnh $contrast --tmoM08ColorSaturation $saturation --tmoM08SetLuminance false"
  echo "Mantiuk08: $contrast"

  $CMD
  ./TMQI_cli.m ${output}.png ${target} | tee ${target}.tmqi

  # using luminance levels leads to less than optimal result, but it would be like this:
  #   contrast=3.3
  #   luminance=0.1
  #   target=${output}_mantiuk08_${contrast}_${luminance}.png
  #   CMD="luminance-hdr-cli -l $CT -o $target -q 100 --tmo mantiuk08  --tmoM08ConstrastEnh $contrast --tmoM08ColorSaturation $saturation --tmoM08LuminanceLvl $luminance --tmoM08SetLuminance true"
  #   echo "Mantiuk08: $contrast $luminance"
  #   $CMD
  #   ./TMQI_cli.m ${output}.png ${target} | tee ${target}.tmqi
  
  # Ferradans
  rho=0.4
  invalpha=5.5
  target=${output}_ferradans.png
  CMD="luminance-hdr-cli -l $CT -o $target -q 100 --tmo ferradans  --tmoFerRho $rho  --tmoFerInvAlpha $invalpha"
  echo "Ferradans: $rho $invalpha"
  $CMD
  ./TMQI_cli.m ${output}.png ${target} | tee ${target}.tmqi
done

TMO4CT_cli.py chest.tiff -O . -vvv -c 6 -e 1.0 -x 1 -b 2048  --postfix=_proposed -o png --overwrite
TMO4CT_cli.py head.tiff  -O . -vvv -c 6 -e 1.0 -x 1 -b 2048  --postfix=_proposed -o png --overwrite
