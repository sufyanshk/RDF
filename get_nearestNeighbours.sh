#!/bin/zsh
#This needs my_pymatgen to be activated before running


#Execute the program as ./get_allNearestNeighbours.sh <lattice parameter from bulk relaxation>

lp=$1 #Here the $1 is user inputted lattice parameter found out from bulk relaxation
natoms=`awk 'NR==7{for (i=1; i<=NF; i++) sum=sum+$i; print sum}' CONTCAR` #Here we are extracting the number of atoms present in the CONTCAR file

python ~/Documents/projects/vasputil/scripts/vasputil_nearestneighbors -n $natoms CONTCAR > all63NearestNeighbours.txt

awk -v CONVFMT=%.6f '!a[$3]++' all63NearestNeighbours.txt > uniques.txt

#Here the first nearest neighbor distance is further increased by 10% to accommodate the deviations
awk -v CONVFMT=%.6f -v lp="$lp" '{if (NR<=2) print $0; else if ($3<(lp*1.10*sqrt(3)/2)) print $0}' uniques.txt > all63NearestNeighbours.txt
rm uniques.txt 

awk -v CONVFMT=%.6f -v lp="$lp" '{if (NR<=2) print $0; else print $1,$2,$3,($3-(lp*sqrt(3)/2)),($3-(lp*sqrt(3)/2))^2}' all63NearestNeighbours.txt > tmp

awk -v CONVFMT=%.6f -v lp="$lp" -v sum="0" '{sum=sum+$4*$4} END{print lp*sqrt(3)/2"  <--Ideal first NN distance"; print sqrt(sum/(NR-2))"  <--Root mean squared error"}' tmp > tmp2

cat tmp tmp2 > all63NearestNeighbours.txt
rm tmp tmp2

tail -2 all63NearestNeighbours.txt
