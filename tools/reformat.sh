#!/bin/bash

org=$1

cat output/$org.psv | tr '|' '\t' > output/$org.tsv
