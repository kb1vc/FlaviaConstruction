include <FlaviaPrims.scad>

XPitch = TabLength + 0.125;
YPitch = TabLength * 2.0;
module Trio() {
  Corner();
  translate([XPitch, 0, 0]) Corner();
  translate([2.0 * XPitch, 0, 0]) Corner();
}

rotate([180, 0, 0]) scale([25.4, 25.4, 25.4]) {
  Trio();
  translate([0, YPitch, 0]) Trio();
}
