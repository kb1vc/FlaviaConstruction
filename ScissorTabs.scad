
// all measurements in inches
$fn=32; // round things are drawn in 32 segments

InnerWidth = 0.6;
SlotWidth = 0.3;
InnerThickness = 0.1;
TabLength = 1.0;
Offset = 0.125; 
JoinerWidth = SlotWidth * 1.5;

BumpDia = 0.2;
BumpOffset = TabLength - 0.22; 

SheetThickness = 0.038; // thickness of the flavia stick plastic sheet + a little
CenterHoleDia = 0.12; // little bigger than a number 4 screw

module RoundedBumpPlate() {
  translate([0,0.5*InnerWidth, 0]) cylinder(d=InnerWidth, h=InnerThickness);
  cube([TabLength, InnerWidth, InnerThickness], false);
  intersection() {
    translate([BumpOffset, InnerWidth * 0.5, 0.75 * InnerThickness]) sphere(d=BumpDia);
      cube([TabLength, InnerWidth, 2 * InnerThickness], false);    
  }
  //translate([BumpOffset, InnerWidth * 0.5, 0.25 * InnerThickness]) sphere(d=BumpDia);  
}

module PlateWithSpacer() {
  difference() {
    union() {
      translate([0,-0.5*InnerWidth, 0]) RoundedBumpPlate();
      translate([0, 0, InnerThickness * 0.999]) cylinder(d = InnerWidth, h = SheetThickness * 2.02);
    }
    translate([0, 0, -0.001]) cylinder(d = CenterHoleDia, h = InnerThickness * 10);
  }
}

scale([25.4,25.4,25.4])
{
  PlateWithSpacer(); 
}