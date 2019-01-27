
// all measurements in inches
$fn=32; // round things are drawn in 32 segments

InnerWidth = 0.6;
SlotWidth = 0.3;
InnerThickness = 0.1;
TabLength = 1.0;
Offset = 0.125; 
JoinerWidth = SlotWidth * 1.5;

DoveTailSlotMul = 1.10;

BumpDia = 0.2;
BumpOffset = TabLength - 0.22; 

module GussetHub() {
  translate([-0.5*InnerWidth, -0.5 * InnerWidth, 0])
    cube([InnerWidth, InnerWidth, InnerThickness]);
}

module GussetPlate() {
  rotate([180, 0, 0]) translate([0.25*TabLength, -0.5 * InnerWidth, 0]) InnerPlate();
}

module InnerPlate() {
  cube([TabLength, InnerWidth, InnerThickness], false);
  translate([BumpOffset, InnerWidth * 0.5, InnerThickness]) sphere(d=BumpDia);
}

module InnerPlateBump() {
  InnerPlate();
  yoff = 0.5 * (InnerWidth - SlotWidth);
  translate([0, yoff, -InnerThickness]) cube([TabLength, SlotWidth, InnerThickness], false);
}

module JoinerPlate() {
  cube([TabLength, JoinerWidth, InnerThickness]);
}


module Tab() {
  translate([Offset, 0, -InnerThickness / 2]) InnerPlate(); 
}

module Hub() {
  rotate([-90, 0, 0]) cylinder(d = Offset * 2.2, h = InnerWidth); 
}

module F2x60() {
  Tab();
  rotate([0, -60, 0]) Tab();
}

module F3x60() {
  Tab();
  rotate([0, -60, 0]) Tab();
  rotate([0, -120, 0]) Tab();  
}

module F4x60() {
  F2x60();
  rotate([0, -120, 0]) F2x60();
}

module Corner() {
  InnerPlateBump();
  xshift = InnerWidth; // 0.5 * (TabLength - InnerWidth);
  yshift = InnerWidth + 0.2;
  translate([xshift, yshift, 0]) rotate([0, 0, 90]) InnerPlateBump();
  xjshift = JoinerWidth + 0.5 * (InnerWidth - JoinerWidth);
  yjshift = 0.5 * (InnerWidth - SlotWidth);
  translate([xjshift, yjshift, -2 * InnerThickness]) rotate([0, 0, 90]) JoinerPlate();
}
