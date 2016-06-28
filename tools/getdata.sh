#!/bin/bash

org=$1
lp=$2

mkdir data/rawfiles/$org

curl $lp |
grep -o 'http[^\"]*csv' |
sort |
uniq |
xargs wget -N -P data/rawfiles/$org 

