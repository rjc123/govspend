#!/bin/bash

org=$1

  mkdir -p data/cleanfiles/$org

  ls data/rawfiles/$org |
  while read filename
  do 
    echo 'Cleaning raw file '$org'/'$filename
    iconv -c -t 'UTF-8' data/rawfiles/$org/$filename |
    sed -E 's/\"([^\"]*),([^\"]*)\"/\"\1±\2\"/g;
        s/\"([^\"]*),([^\"]*±)([^\"]*)\"/\"\1±\2\3\"/g;
        s/\"([^\"]*),([^\"]*±)([^\"]*)\"/\"\1±\2\3\"/g;
        s/\"([^\"]*),([^\"]*±)([^\"]*)\"/\"\1±\2\3\"/g;
        s/\"([^\"]*),([^\"]*±)([^\"]*)\"/\"\1±\2\3\"/g;
        s/,/|/g;
        s/±/,/g;
        s/\"//g;' |
    tr -d $'\r' > tempfile
    # 1. Take things in double quotes and make the commas ±
    # 2. Take all other commas and make them pipes
    # Take all the ± and make them commas again
    # Get rid of all the double quotes
   
#    head -n 1 tempfile   # put the headers as is on the screen  
    
    head -n 1 tempfile |  
      sed 's/ //g;' |
      tr "[:lower:]" "[:upper:]" |
      sed 's/TRANSACTIONNO/TRANSACTIONNUMBER/g;
          s/DEPARTMENTALFAMILY/DEPARTMENT/g;
          s/DEPARTMENTFAMILY/DEPARTMENT/g;
          s/SUPPLIERPOSTCODE/POSTCODE/g;
          s/POSTALCODE/POSTCODE/g;
          s/SUMOFAMOUNT/AMOUNT/g;
          s/ITEMTEXT/DESCRIPTION/g;
          s/\|TEXT/|DESCRIPTION/g;
          s/PAYMENTDATE/DATE/g;' > tempheaders # remove spaces and standardise casing for headers

#    head -n 1 tempheaders   # put the new headers on the screen for comparison

    cat tempheaders | 
      tr "|" "\n" | 
      sort | uniq |
      while read headeroffocus
        do
          sed -E 's/(\|'$headeroffocus'\|.*\|'$headeroffocus')/\12/' tempheaders > whatever #increment duplicate headers to make unique
          mv whatever tempheaders
        done

    mv tempheaders data/cleanfiles/$org/$filename
    tail -n +2 tempfile >> data/cleanfiles/$org/$filename

    rm tempfile

  done
