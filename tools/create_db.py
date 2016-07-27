# -*- coding: utf-8 -*-
import csv
import json
import os
import sqlite3

root_dir = "../data/rawfiles/"
spec_filename = "spec.json"
db_file = "govspend.db"
debug = False

db = sqlite3.connect(db_file)
try:
  db.execute("DROP TABLE data")
except:
  pass
db.execute("CREATE TABLE data (org text, dept text, suborg text, date text, supplier text, amount integer, ref text, description text)")

def parse_text(row, fields, fieldname):
  try:
    return row[fields[fieldname]].replace("'","`")
  except:
    return ""

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
      fields = spec['fields']
      if 'except' in spec:
        for exception in spec['except']:
          if filename.replace("£","") in exception['filenames']:
            print "    Using exception field spec"
            fields = exception['fields']
          else:
            pass
            # print filename.decode().encode('utf-8'), "not in", exception['filenames']
      with open(os.path.join(dirpath, filename)) as csv_file:
        count = 0
        skipped = 0
        if 'delimiter' in spec and spec["delimiter"] in csv_file.readline():
          csv_data = csv.reader(csv_file, delimiter=";")
        else:
          csv_data = csv.reader(csv_file)
        for row in csv_data:
          if count + skipped < spec["row_skip"]:
            skipped += 1
            continue
          try:
            dept = parse_text(row, fields, 'dept')
            suborg = parse_text(row, fields, 'suborg')
            date = parse_text(row, fields, 'date')
            supplier = parse_text(row, fields, 'supplier')
            ref = parse_text(row, fields, 'ref')
            description = parse_text(row, fields, 'description')
            amount = int(float(row[fields['amount']].replace(",","").replace("\xa3","")))
            query = "INSERT INTO data VALUES ('{}', '{}', '{}', '{}', '{}', {}, '{}', '{}')".format(org, dept, suborg, date, supplier, amount, ref, description)
          except Exception as e:
            if debug: print "    Could not process: " + str(row) + "\n      " + str(e)
            skipped += 1
            continue
          try:
            db.execute(query)
            count += 1
          except:
            if debug: print "    Skipped: " + query
            skipped += 1
            continue
        print " - Inserted {} lines of data from {} (skipped {} lines)".format(count, filename, skipped)
  else:
    print "No spec for " + org



