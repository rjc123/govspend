import csv
import json
import os
import sqlite3

root_dir = "../data/rawfiles/"
spec_filename = "spec.json"
db_file = "govspend.db"

db = sqlite3.connect(db_file)
try:
  db.execute("DROP TABLE data")
except:
  pass
db.execute("CREATE TABLE data (org text, expense_type text, expense_area text, supplier text, amount integer)")

for dirpath, dirnames, filenames in os.walk(root_dir):
  org = os.path.basename(dirpath)
  if not org:
    continue
  if spec_filename in filenames:
    with open(os.path.join(dirpath, spec_filename)) as specfile:
      spec = json.loads(specfile.read())
    print "Processing data for " + org
    for filename in filenames:
      if filename == spec_filename:
        continue
      with open(os.path.join(dirpath, filename)) as csv_file:
        count = 0
        skipped = 0
        for row in csv.reader(csv_file):
          if count + skipped < spec["row_skip"]:
            skipped += 1
            continue
          type = row[spec['fields']['type']].replace("'","`")
          area = row[spec['fields']['area']].replace("'","`")
          supplier = row[spec['fields']['supplier']].replace("'","`")
          amount = row[spec['fields']['amount']]
          query = "INSERT INTO data VALUES ('{}', '{}', '{}', '{}', {})".format(org, type, area, supplier, amount)
          try:
            db.execute(query)
            count += 1
          except:
            # print "  Skipped: " + query
            skipped += 1
        print " - Inserted {} lines of data from {} (skipped {} lines)".format(count, filename, skipped)
  else:
    print "No spec for " + org



