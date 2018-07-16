#!/bin/bash

rm -f head_metric.txt chest_metric.txt head_score.txt chest_score.txt

for TMO in drago durand fattal ferradans mantiuk06 mantiuk08 reinhard02 reinhard05 proposed; do
  python3 metric.py head_${TMO}.png >>head_metric.txt
done

for TMO in drago durand fattal  ferradans mantiuk06 mantiuk08 reinhard02 reinhard05 proposed; do
  python3 metric.py chest_${TMO}.png >>chest_metric.txt
done


for TMO in drago durand fattal ferradans mantiuk06 mantiuk08 reinhard02 reinhard05 proposed; do
  octave -qf ./TMQI_cli.m head.png head_${TMO}.png >>head_score.txt
done

for TMO in drago durand fattal ferradans mantiuk06 mantiuk08 reinhard02 reinhard05 proposed; do
  octave -qf ./TMQI_cli.m chest.png chest_${TMO}.png >>chest_score.txt
done

paste names.txt chest_score.txt head_score.txt chest_metric.txt head_metric.txt |column -t |awk '{print $1,"&",$4,"&",$7,"&", $9,"&",$12,"&",$10,"&",$13,"\\\\"}'|column -t|tee evalution.txt
