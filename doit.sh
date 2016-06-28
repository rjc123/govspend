#!/bin/bash

echo '1. Get the data from the web according to landing pages'
sh tools/getdata.sh

echo '2. Clean the raw data into clean files, and make the fieldnames unique, without spaces'
sh tools/cleanrawfiles.sh

echo '3. Align the columns of the raw files and append to existing outputs, noting any changes or additions'
sh tools/combine.sh

# 4. Commit the new data and changes to the data in the repo
# sh tools/commit.sh
