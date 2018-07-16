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
  # optimized Drago
  
  # Drago
  for bias in `seq 0.5 0.01 1.0`; do
    CMD="luminance-hdr-cli -l $CT -o ${output}_drago_${bias}.png -q 100 --tmo drago  --tmoDrgBias $bias"
    echo "Drago: $bias"
    target=${output}_drago_${bias}.png
    
    if [ ! -f ${target}.tmqi ]; then
      $CMD
      ./TMQI_cli.m ${output}.png ${target} | tee ${target}.tmqi
      rm  ${target}
    fi
  done
  
  # Durand
  for base_contrast in `seq 1. 0.5 6.0`; do
    for spatial_sigma in `seq 1. 0.5 7.0`; do
      for range_sigma   in `seq 1. 0.5 7.0`; do
        target=${output}_durand_${base_contrast}_${spatial_sigma}_${range_sigma}.png
        echo "Durand: $target"
        if [ ! -f ${target}.tmqi ]; then
          CMD="luminance-hdr-cli -l $CT -o $target -q 100 --tmo durand  --tmoDurSigmaS $spatial_sigma --tmoDurSigmaR $range_sigma --tmoDurBase $base_contrast"
          $CMD
          ./TMQI_cli.m ${output}.png ${target} | tee ${target}.tmqi
          rm  ${target}
        fi
      done
    done
  done
  
  # Fattal
  for alpha in `seq 0.5 0.05 1.2`; do
    for beta in `seq 0.75 0.05 1.0`; do
      for noise in 0.002 0.005 0.01 0.02 0.03  0.05  0.1 0.2; do
        target=${output}_fattal_${alpha}_${beta}_${noise}.png
        CMD="luminance-hdr-cli -l $CT -o $target -q 100 --tmo fattal  --tmoFatAlpha $alpha --tmoFatBeta $beta --tmoFatNoise $noise"
        echo "Fattal: $alpha $beta $noise"
        
        if [ ! -f ${target}.tmqi ]; then
          $CMD
          ./TMQI_cli.m ${output}.png ${target} | tee ${target}.tmqi
          rm  ${target}
        fi
      done
    done
  done
  
  # Reinhard 05
  for brightness in `seq -10 1.0 15`; do
    for chroma  in `seq 0.0 0.1 1.0`; do
      for lightness  in `seq 0.0 0.1 1.0`; do
        target=${output}_reinhard05_${brightness}_${chroma}_${lightness}.png
        CMD="luminance-hdr-cli -l $CT -o $target -q 100 --tmo reinhard05  --tmoR05Brightness $brightness --tmoR05Chroma $chroma --tmoR05Lightness $lightness"
        echo "Reinhard05: $brigthness $chroma $lightness"
        
        if [ ! -f ${target}.tmqi ]; then
          $CMD
          ./TMQI_cli.m ${output}.png ${target} | tee ${target}.tmqi
          rm  ${target}
        fi
      done
    done
  done
  
  #Reinhard 02
  for key in `seq 0.02 0.02 1.0`; do
    for phi in `seq 0.0 0.1 1.0`; do
      target=${output}_reinhard02_${key}_${phi}.png
      CMD="luminance-hdr-cli -l $CT -o $target -q 100 --tmo reinhard02  --tmoR02Key $key --tmoR02Phi $phi"
      echo "Reinhard02: $key $phi"
      
      if [ ! -f ${target}.tmqi ]; then
        $CMD
        ./TMQI_cli.m ${output}.png ${target} | tee ${target}.tmqi
        rm  ${target}
      fi
    done
  done
  
  #Mantiuk06
  for contrast in `seq 0.05 0.05 1.0`; do
    for detail in `seq 0.1 0.1 1.9` `seq 1.0 1.0 10.0`; do
      saturation=0.5
      target=${output}_mantiuk06_${contrast}_${detail}.png
      CMD="luminance-hdr-cli -l $CT -o $target -q 100 --tmo mantiuk06  --tmoM06Contrast $contrast --tmoM06Saturation $saturation --tmoM06Detail $detail"
      echo "Mantiuk06: $contrast $detail"
      
      if [ ! -f ${target}.tmqi ]; then
        $CMD
        ./TMQI_cli.m ${output}.png ${target} | tee ${target}.tmqi
        rm  ${target}
      fi
    done
  done
  
  #Mantiuk08
  for contrast in `seq 0.1 0.1 6.0`; do
    saturation=1.0
    target=${output}_mantiuk08_${contrast}_no_llevels.png
    CMD="luminance-hdr-cli -l $CT -o $target -q 100 --tmo mantiuk08  --tmoM08ConstrastEnh $contrast --tmoM08ColorSaturation $saturation --tmoM08SetLuminance false"
    echo "Mantiuk08: $contrast"
    if [ ! -f ${target}.tmqi ]; then
      $CMD
      ./TMQI_cli.m ${output}.png ${target} | tee ${target}.tmqi
      rm  ${target}
    fi
    
    for luminance in `seq 0.1 0.2 10.0`; do
      target=${output}_mantiuk08_${contrast}_${luminance}.png
      CMD="luminance-hdr-cli -l $CT -o $target -q 100 --tmo mantiuk08  --tmoM08ConstrastEnh $contrast --tmoM08ColorSaturation $saturation --tmoM08LuminanceLvl $luminance --tmoM08SetLuminance true"
      echo "Mantiuk08: $contrast $luminance"
      
      if [ ! -f ${target}.tmqi ]; then
        $CMD
        ./TMQI_cli.m ${output}.png ${target} | tee ${target}.tmqi
        rm  ${target}
      fi
    done
  done
  
  # Ferradans
  for rho in `seq 0.4 0.1 9.0`; do
    for invalpha in `seq 0.1 0.2 9.0` `seq 10 1 25` ; do
      target=${output}_ferradans${rho}_${invalpha}.png
      CMD="luminance-hdr-cli -l $CT -o $target -q 100 --tmo ferradans  --tmoFerRho $rho  --tmoFerInvAlpha $invalpha"
      echo "Ferradans: $rho $invalpha"
      
      if [ ! -f ${target}.tmqi ]; then
        $CMD
        ./TMQI_cli.m ${output}.png ${target} | tee ${target}.tmqi
        rm  ${target}
      fi
    done
  done
  
  # defaults
  continue
  output=${CT/.tiff/}
  CMD="luminance-hdr-cli -l $CT -o ${output}_durand_default.png -q 100 --tmo durand  --tmoDurSigmaS 5 --tmoDurSigmaR 5 --tmoDurBase 4"
  echo
  echo Durand
  echo
  $CMD
  ./TMQI_cli.m ${output}.png ${output}_durand_default.png | tee ${output}_durand_default.png.tmqi
  
  CMD="luminance-hdr-cli -l $CT -o ${output}_reinhard05_default.png -q 100 --tmo reinhard05 --tmoR05Brightness 0 "
  echo
  echo Reinhard05
  echo
  $CMD
  ./TMQI_cli.m ${output}.png ${output}_reinhard05_default.png | tee ${output}_reinhard05_default.png.tmqi
  
  for TMO in drago fattal ferradans mantiuk06 mantiuk08 reinhard02   ; do
    echo
    echo $TMO
    echo
    CMD1="luminance-hdr-cli -l $CT -o ${output}_${TMO}_default.png -q 100 --tmo $TMO"
    $CMD1
    ./TMQI_cli.m ${output}.png ${output}_${TMO}_default.png | tee ${output}_${TMO}_default.png.tmqi
    
  done
  
done

