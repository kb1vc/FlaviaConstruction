include <FlaviaPrims.scad>

XPitch = (TabLength * 1.5);
YPitch = TabLength * 1.2;
TailLength = InnerThickness * 1.5;
module DoveTail() {
  linear_extrude(height = InnerWidth)
    polygon(points = [ [-InnerThickness, 0], [InnerThickness, 0],
    		       [InnerThickness * 0.5, TailLength], [-InnerThickness * 0.5, TailLength] ]);
}

module TabNTail() {
  translate([0, -TailLength, 0]) DoveTail();
  translate([-InnerThickness * 0.5, -0.010, 0]) rotate([90, 0, 90]) InnerPlate();
}

module Slots() {
  sc = 1.05;
  difference() {
    cube([InnerWidth * 2, 3 * InnerThickness, InnerWidth]);
    union() {
    translate([InnerWidth * 0.15, InnerThickness * 2, 0]) cylinder(d = 0.5*InnerThickness, h = InnerWidth * 1.2);
    translate([InnerWidth * 0.5, 3 * InnerThickness - TailLength, -0.1 * TailLength]) scale([1.05, 1.05, 1.2]) DoveTail();
    translate([InnerWidth * 1.0, 3 * InnerThickness - TailLength, -0.1 * TailLength]) scale([1.10, 1.10, 1.2]) DoveTail();
    translate([InnerWidth * 1.5, 3 * InnerThickness - TailLength, -0.1 * TailLength]) scale([1.15, 1.15, 1.2]) DoveTail();
    }
  }
}

BarrelRad = 3*TailLength;
BarrelHeight = InnerWidth + 2.1 * TailLength;
module RadialTab(sc) {
  translate([0, BarrelRad, 0.1]) scale([sc, sc, 1.1]) TabNTail();
}


module BarrelN(n, sc)
{
  pitch = 360 / n;

  difference() {
    cylinder(d = 2.0 * BarrelRad, h = BarrelHeight);
    union() {
//      translate([0, 0, -0.1]) cylinder(d = 0.8 * BarrelRad, h = BarrelHeight + 0.2);
      for(ang = [0:pitch:360])
        rotate([0, 0, ang])
          translate([0, 0, -0.35 * InnerWidth]) scale([1,1,1.75]) RadialTab(sc);

      translate([0, 2.5 * InnerWidth, BarrelHeight]) rotate([90, 0, 0]) scale([sc, sc, 5]) TabNTail();      
      rotate([0, 180,0])    translate([0, 2.5 * InnerWidth, -0.01]) rotate([90, 0, 0]) scale([sc, sc, 5]) TabNTail();
    }
  }
}

module ExpPair()
{
   translate([0, TailLength, 0]) TabNTail();
   translate([InnerThickness * 1.5, 0, 0]) Slots();
}

scale([25.4, 25.4, 25.4]) {
  for(x=[BarrelRad:2.1*BarrelRad:2])
    for(y = [BarrelRad:2.1*BarrelRad:2])
      translate([x, y, 0]) BarrelN(6, DoveTailSlotMul);
}
