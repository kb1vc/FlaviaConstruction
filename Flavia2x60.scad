// Joiner widget for the plastic rails that come with
// Flavia coffee packets.
$fn=32; // round things are drawn in 32 segments
include <FlaviaPrims.scad>

scale([25.4,25.4,25.4]) { // scale from inches to mm
  Hub();			
  F2x60();
}