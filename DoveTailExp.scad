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
  translate([-InnerThickness * 0.5, 0, 0]) rotate([90, 0, 90]) InnerPlate();
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

module ExpPair()
{
   translate([0, TailLength, 0]) TabNTail();
   translate([InnerThickness * 1.5, 0, 0]) Slots();
}

scale([25.4, 25.4, 25.4]) {
  ExpPair();
}
