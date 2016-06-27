#!/bin/bash

while read line 
do
  
  org=$(echo $line | cut -f1 -d " " )
  lp=$(echo $line | cut -f2 -d " " )

  mkdir data/rawfiles/$org

  curl $lp |
  grep -o 'http[^\"]*csv' |
  sort |
  uniq |
  xargs wget -N -P data/rawfiles/$org 

done < landingpages.txt
