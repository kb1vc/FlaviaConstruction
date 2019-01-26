#!/bin/bash

for i in 3 4 5 6
do
    echo $i
    cat <<EOF > tmp.scad
include <BallAndSocket.scad>
scale([25.4,25.4,25.4]) 
  VertexSet_$i();      
EOF
   openscad -o BandS_VS${i}.stl tmp.scad
done    

cat <<EOF > tmp.scad
include <BallAndSocket.scad>
scale([25.4,25.4,25.4]) 
  JustTabs();      
EOF
openscad -o JustTabs.stl tmp.scad
