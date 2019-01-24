include <FlaviaPrims.scad>

XPitch = (TabLength * 1.5);
YPitch = TabLength * 1.2;

module G4Tabs() {
  GussetPlate();
  rotate([0, 0, 60]) GussetPlate();
  rotate([0, 0, 120]) GussetPlate();
  rotate([0, 0, 180]) GussetPlate();  
}

module G4()
{
  GussetHub();
  translate([0, 0, InnerThickness]) G4Tabs();
}

module BracedPlate()
{
  translate([0, InnerWidth, InnerThickness]) rotate([180, 0, 0]) InnerPlate();
  translate([0, 0.5 * (InnerThickness + InnerWidth), 0])
    rotate([90,0,0])
      linear_extrude(height = InnerThickness)
        polygon(points=[ [0, 0], [InnerWidth, 0], [0, InnerWidth] ]);  
}

module G4p1()
{
  translate([0, 0, 0.5*InnerWidth]) rotate([90, 0, 0]) {
    G4();
    rotate([0, 90, 90]) translate([0, -0.5 * InnerWidth, -0.5*InnerWidth]) BracedPlate();
  }
}

ModSep = 0.05; // 0.05 inches between objects

module G4Pair()
{
  translate([1.5 * TabLength, 2.0 * ModSep, 0]) {
    G4p1();
    translate([InnerWidth + ModSep, TabLength + ModSep, 0]) rotate([0, 0, 180]) G4p1();
  }
}



module G4Quad()
{
  G4Pair();
  translate([0, 2.0 * ModSep + 2.0 * InnerThickness + TabLength, 0]) G4Pair();
}

scale([25.4, 25.4, 25.4]) {
  G4Quad();
  translate([0, 4.0 * ModSep + 4.0 * InnerThickness + 2.0 * TabLength, 0]) G4Pair();
  translate([InnerThickness, 1.5 * TabLength + 3 * InnerThickness + 2 * ModSep, 0]) rotate([0, 0, -90]) G4p1();
  translate([3.5 * TabLength, 1.5 * TabLength + 3 * InnerThickness + 2 * ModSep, 0]) rotate([0, 0, 90]) G4p1();  
}
