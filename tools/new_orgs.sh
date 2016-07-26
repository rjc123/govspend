#!/bin/bash

for i in {1..100}
do

  curl "https://www.gov.uk/api/organisations?page=$i"
  echo

done > organisations_list.json

g
