#!/bin/bash

for i in {1..100}
do

  curl "https://www.gov.uk/api/organisations?page=$i"
  echo

done > organisations_list.json

grep -o 'https[^"]*' organisations_list.json | 
  grep '/api/' | 
  grep -v 'page=' | 
  sort | uniq > templist

while read line
do
  curl $line >> organisations.json2
  echo >> organisations.json2

done < templist

mv organisations.json2 organisations.json

# rm templist