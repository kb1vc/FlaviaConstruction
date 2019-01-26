include <FlaviaPrims.scad>

module RoundedBumpPlate() {
  translate([0,0.5*InnerWidth, 0]) cylinder(d=InnerWidth, h=InnerThickness);
  cube([TabLength, InnerWidth, InnerThickness], false);
  translate([BumpOffset, InnerWidth * 0.5, InnerThickness]) sphere(d=BumpDia);
  translate([BumpOffset, InnerWidth * 0.5, 0]) sphere(d=BumpDia);  
}

module BumpPlate() {
  cube([TabLength, InnerWidth, InnerThickness], false);
  translate([BumpOffset, InnerWidth * 0.5, InnerThickness]) sphere(d=BumpDia);
  translate([BumpOffset, InnerWidth * 0.5, 0]) sphere(d=BumpDia);  
}

BallDia = 2.0 * InnerThickness; 

module RoundedBallTab(XOffset)
{
  translate([0.5 * InnerWidth, 0.5 * InnerThickness, -0]) rotate([90, 0, 0]) 
  union() {
    RoundedBumpPlate();
    translate([0.0 * (BallDia + XOffset), InnerWidth * 0.5 , 0.5 * InnerThickness]) sphere(d=BallDia);
  }
}

module BallTab(XOffset)
{
  translate([0, 0.5 * InnerThickness, -0]) rotate([90, 0, 0]) 
  union() {
    BumpPlate();
    translate([BallDia + XOffset, InnerWidth * 0.5 , 0.5 * InnerThickness]) sphere(d=BallDia);
  }
}

ForkThickness = 2.5 * InnerThickness;

module SocketTab()
{
  cube([InnerWidth + BallDia, ForkThickness, 0.99 * InnerWidth], center=true);
}

module Socket(split)
{
  translate([BallDia, 0, 0]) difference() {
    translate([BallDia * 0.5, 0, InnerWidth * 0.5]) SocketTab();
    translate([0, 0, -0.001]) scale([split, split, 1])  BallTab(+0.05);
  }
}

module Tripple(split)
{
  Socket(split);
  rotate([0, 0, 120]) Socket(split);
  rotate([0, 0, -120]) Socket(split);
}

module Vertex()
{
  translate([-0.85 * TabLength, -8 * InnerThickness,0]) {
  translate([0.5 * TabLength, 1.5 * TabLength, 0]) Tripple(1.25);
  for(y = [0:1:2])
    translate([0, y * 3 * InnerThickness, 0]) RoundedBallTab(-0.1);
  }
}

module VertexSet()
{
  translate([0, 9*InnerThickness, 0])
  for(x = [(0.85 * TabLength):1.8:3])
    translate([x, 0, 0]) {
       Vertex();
       translate([0, 1.85, 0]) rotate([0,0,180]) Vertex();
    }
}
scale([25.4,25.4,25.4]) {
  // VertexSet();
  // Tripple();
  RoundedBallTab(-0.1);
}