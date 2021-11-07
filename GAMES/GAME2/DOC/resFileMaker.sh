#!/bin/bash
# Create directories and files for the resource database.
for i in {1..41}
do
  mkdir $i
  cd $i
  touch MIN.DAT MAX.DAT
	sed -n "$i"p "..\rp_min.csv"  > MIN.DAT
  sed -n "$i"p "..\rp_max.csv"  > MAX.DAT
  unix2dos MIN.DAT MAX.DAT
  cd ..
done
