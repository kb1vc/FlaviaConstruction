include <FlaviaPrims.scad>

BumpOffset = TabLength - 0.425;
BumpDia = 0.18;

TailLength = InnerThickness * 1.5;

module BumpPlate() {
  cube([TabLength, InnerWidth, InnerThickness], false);
  translate([BumpOffset, InnerWidth * 0.5, InnerThickness]) sphere(d=BumpDia);
}

module DoveTail() {
  linear_extrude(height = InnerWidth)
    polygon(points = [ [-InnerThickness, 0], [InnerThickness, 0],
    		       [InnerThickness * 0.5, TailLength], [-InnerThickness * 0.5, TailLength] ]);
}

module TabNTail() {
  translate([0, -TailLength, 0]) DoveTail();
  translate([-InnerThickness * 0.5, -0.010, 0]) rotate([90, 0, 90]) BumpPlate();
}


scale([25.4, 25.4, 25.4]) {
  DTLen = TailLength + TabLength * 1.2;
  for(x = [0:InnerThickness*3:1.8])
    for(y = [0:DTLen:2])
       translate([x, y, 0]) TabNTail();
}
