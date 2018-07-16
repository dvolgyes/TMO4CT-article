#!/bin/bash

for method in mantiuk08 fattal mantiuk06 drago durand ferradans reinhard02 reinhard05; do
  rm -f tmp
  for f in chest_${method}*.png.tmqi; do
    f2=${f/chest/head}
    a=`cat $f|awk '{print $3;}'`
    b=`cat $f2|awk '{print $3;}'`
    c=$(echo $a + $b | bc)
    name=${f/chest_/}
    name=${name/.png.tmqi/}
    echo ${name} $a $b  $c >> tmp
  done
  cat tmp |sort -k 4,4 -n| tail -1 > ${method}_max.txt
  rm -f tmp
done

(echo "Method" "chest_score" "head_score" "sum";cat *_max.txt)|column -t | tee best_method_parameters.txt
