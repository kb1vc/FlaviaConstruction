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


scale([25.4, 25.4, 25.4]) {
  DTLen = TailLength + TabLength * 1.2;
  for(x = [0:InnerThickness*3:1.8])
    for(y = [0:DTLen:2])
       translate([x, y, 0]) TabNTail();
}
