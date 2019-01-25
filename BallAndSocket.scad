include <FlaviaPrims.scad>

module BumpPlate() {
  cube([TabLength, InnerWidth, InnerThickness], false);
  translate([BumpOffset, InnerWidth * 0.5, InnerThickness]) sphere(d=BumpDia);
}

BallDia = 2.0 * InnerThickness; 

module BallTab(XOffset)
{
  translate([0, 0.5 * InnerThickness, -0]) rotate([90, 0, 0]) 
  union() {
    BumpPlate();
    translate([BallDia + XOffset, InnerWidth * 0.5, 0.5 * InnerThickness]) sphere(d=BallDia);
  }
}

module Socket(split)
{
  difference() {
    cube([InnerWidth + BallDia, 3 * InnerThickness, 0.99 * InnerWidth]);
    translate([InnerWidth - BallDia,2 * InnerThickness - 0.5 * split * InnerThickness,-0.001]) scale([split, split, 1])  BallTab(+0.05);
  }
}

scale([25.4,25.4,25.4]) {
  BallTab(-0.1);
  translate([TabLength * 1.2, 0, 0]) Socket(1.05);
  translate([TabLength * 1.2, 4 * InnerThickness, 0]) Socket(1.1);
  translate([TabLength * 1.2, 8 * InnerThickness, 0]) Socket(1.2);    
}