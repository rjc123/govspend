#!/bin/bash

mkdir -p output

ls data/cleanfiles |
while read org
do

  ls data/cleanfiles/$org |
  while read filename
  do 

    awk -f tools/combinescript.awk data/cleanfiles/$org/$filename >> tempfile

  done 
  
  # make sure this matches the awk file 
  echo "Department|Entity|Payment Date|Expense Type|Expense Area|Supplier|Transaction Number|Amount|Expense Type 2|Expense Area 2" > output/$org.psv
  cat tempfile | sort | uniq | 
    grep -E -v '^\|+$' >> output/$org.psv
  rm tempfile

done 

