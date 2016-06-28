#!/bin/bash

org=$1

mkdir -p output

  ls data/cleanfiles/$org |
  while read filename
  do 

    echo "Combining $org/$filename"
    awk -f tools/combinescript.awk data/cleanfiles/$org/$filename >> tempfile
    tail tempfile

  done 
  
  # make sure the ordering and headers match the awk file 
  echo "Department|Entity|Date|Expense Type|Expense Area|Supplier|Transaction Number|Amount|Expense Type 2|Expense Area 2|Description|Supplier Postcode|Period" > output/$org.psv

  cat tempfile | sort | uniq | 
    grep -E -v '^\|*$' >> output/$org.psv
  rm tempfile
