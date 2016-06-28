#!/usr/bin/awk -f

BEGIN { 
  FS="|" 

  # create an endgame order
  split("DEPARTMENT|ENTITY|DATE|EXPENSETYPE|EXPENSEAREA|SUPPLIER|TRANSACTIONNUMBER|AMOUNT|EXPENSETYPE2|EXPENSEAREA2|DESCRIPTION|POSTCODE|PERIOD",endgame,FS)  
  }

{
# Set the order based on fileheaders
  if ( NR==1 ) { 
    split ($0, headers, FS )
  }
  else
  {
  for (i=1; i<=NF; i++) 
    { 
      data[headers[i]]=$i 
    }

  for (j=1; j<=13; j++) 
    { 
      printf ("%s",data[endgame[j]]"|")
    }
  }
  printf "\n"
}
