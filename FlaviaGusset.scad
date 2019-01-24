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
  G4Tabs();
}

module G4p1()
{
  G4();
  rotate([0, -90, 90]) translate([0, -0.5 * InnerWidth, -0.5*InnerThickness]) InnerPlate();
}

scale([25.4, 25.4, 25.4]) {
  G4();
}
