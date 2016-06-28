#!/bin/bash

while read config_line 
do
  
  org=$(echo $config_line | cut -f1 -d " " )
  lp=$(echo $config_line | cut -f2 -d " " )

  echo '1. Get the data from the web according to landing pages for' $org 
  sh tools/getdata.sh $org $lp

  echo '2. Clean the raw data into clean files, and make the fieldnames unique, without spaces for' $org
  sh tools/cleanrawfiles.sh $org

  echo '3. Align the columns of the raw files and append to existing outputs, noting any changes or additions for' $org
  sh tools/combine.sh $org

done < landingpages.txt

# 4. Commit the new data and changes to the data in the repo
# sh tools/commit.sh

