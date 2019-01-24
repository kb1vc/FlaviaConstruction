include <FlaviaPrims.scad>

XPitch = (TabLength * 1.5);
YPitch = TabLength * 1.2;

module F4()
{
  translate([TabLength * 1.2, 0, InnerWidth]) rotate([-90, 0, 0]) {
    Hub();
    F4x60();
  }
}

module F3()
{
  translate([TabLength * 1.2, 0, InnerWidth]) rotate([-90, 0, 0]) {
    Hub();
    F3x60();
  }
}

module F2()
{
  translate([TabLength * 1.2, 0, InnerWidth]) rotate([-90, 0, 0]) {
    Hub();
    F2x60();
  }
}

module Pair()
{
  F4();
  translate([XPitch, 0.25 * YPitch, 0]) F4();
}

scale([25.4, 25.4, 25.4]) {
  F4();
  translate([XPitch * 2, YPitch * 0.05, 0])  rotate([0, 0, 90]) F3();
  translate([0, YPitch, 0]) F3();
//  translate([XPitch, 0, 0]) F2();
//  translate([XPitch, YPitch, 0]) F2();
//  translate([XPitch, YPitch * 2, 0]) F2();    
}
