#!/bin/bash

for i in 3 4 5 6
do
    echo $i
    cat <<EOF > tmp${i}.scad
include <BallAndSocket.scad>
scale([25.4,25.4,25.4]) 
  VertexSet_$i();      
EOF
done    

	 
cat <<EOF > tmp.scad
include <BallAndSocket.scad>
scale([25.4,25.4,25.4]) 
  JustTabs();      
EOF

for i in 3 4 5 6
do
    openscad -o BandS_VS${i}.stl tmp${i}.scad &
done

openscad -o JustTabs.stl tmp.scad &

