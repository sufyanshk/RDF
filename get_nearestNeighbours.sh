#!/bin/zsh
#This needs my_pymatgen to be activated before running


#Execute the program as ./get_allNearestNeighbours.sh <RDF first peak>

lp=$1 #Here the $1 is the <RDF first peak>
lp=$(( lp * 1.10 )) #The RDF first peak is further extended by 10%

python ~/Documents/projects/vasputil/scripts/vasputil_nearestneighbors -n 63 CONTCAR > all63NearestNeighbours.txt

awk '!a[$3]++' all63NearestNeighbours.txt > uniques.txt

awk -v lp="$lp" '{if (NR<=2) print $0; else if ($3<lp) print $0}' uniques.txt > all63NearestNeighbours.txt
rm uniques.txt 

awk -F '    ' '{if (NR<=2) print $0; else print $1,$2,$3,$3*$3}' all63NearestNeighbours.txt > tmp

awk '{for (i=1;i<=NF;i++) sum[i]+=$i} END{print sum[3]/(NR-2)"  <--Average pair distance"; print sqrt(sum[4]/(NR-2))"  <--Root mean squared pair distance"}' tmp 

rm tmp
