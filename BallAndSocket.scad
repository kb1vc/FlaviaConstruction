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

module Hub_3(split)
{
  Socket(split);
  rotate([0, 0, 120]) Socket(split);
  rotate([0, 0, -120]) Socket(split);
}

module Vertex_3()
{
  translate([-0.85 * TabLength, -8 * InnerThickness,0]) {
  translate([0.5 * TabLength, 1.5 * TabLength, 0]) Hub_3(1.25);
  for(y = [0:1:2])
    translate([0, y * 3 * InnerThickness, 0]) RoundedBallTab(-0.1);
  }
}

module VertexSet_3()
{
  translate([0, 9*InnerThickness, 0])
  for(x = [(0.85 * TabLength):1.8:3])
    translate([x, 0, 0]) {
       Vertex_3();
       translate([0, 1.85, 0]) rotate([0,0,180]) Vertex_3();
    }
}

module Hub_4(split) {
  for(ang = [0:90:359]) 
    rotate([0, 0, ang]) Socket(split);
}

module Vertex_4() {
  Hub_4(1.25);
  for(y = [-2*ForkThickness:ForkThickness:2*ForkThickness])
    if ( y != 0 )
      translate([ForkThickness * 0.75, y, 0])
        RoundedBallTab(-0.1);
}

module VertexSet_4()
{
  for(x = [0.7*TabLength:1.65*TabLength:3.8 - 1.4*TabLength])
    for(y = [0.8*TabLength:1.5*TabLength:3.8 - 1.4*TabLength])
      translate([x, y, 0]) Vertex_4();
}


module Hub_5(split) {
  for(ang = [0:72:359]) 
    rotate([0, 0, ang]) Socket(split);
}

module Vertex_5() {
  Hub_5(1.25);
  for(y = [-2*ForkThickness:ForkThickness:2*ForkThickness])
    if ( y != 0 )
      translate([1.5 * ForkThickness , y, 0])
        RoundedBallTab(-0.1);
  translate([1.85*TabLength, -0.62 * TabLength, 0])
    rotate([0,0,90]) RoundedBallTab(-0.1);
}

module VertexSet_5()
{
  x_start = 0.65 * TabLength;
  x_pitch = 1.2 * TabLength;
  y_start = 0.7 * TabLength;
  y_pitch = 1.15 * TabLength;
  x_offset = 0.35*TabLength;
  x = 0;
  for(x = [0:1:2]) 
    for(y = [0:1:2]) {
      nx = x * x_pitch + x_start + (x_offset * (y % 2));
      ny = y * y_pitch + y_start;      
      translate([nx, ny, 0]) Hub_5();
    }
}


module Hub_6(split) {
  for(ang = [0:60:359]) 
    rotate([0, 0, ang]) Socket(split);
}

module Vertex_6() {
  Hub_6(1.25);
  for(y = [0:1:5]) {
    translate([-0.6*TabLength, 0.8 * TabLength + y * ForkThickness, 0]) RoundedBallTab(-0.1);
  }
}

module VertexSet_6()
{
  x_start = 0.8 * TabLength;
  x_pitch = 1.15 * TabLength;
  y_start = 0.8 * TabLength;
  y_pitch = 1.5 * TabLength;
  y_offset = y_pitch * 0.5;
  for(x = [0:1:2])
    for(y = [0:1:1]) {
      nx = x * x_pitch + x_start;
      ny = y * y_pitch + y_start + ((x % 2) * y_offset);
      translate([nx, ny, 0]) rotate([0,0,(x%2)*30]) Hub_6();
    }
}

module JustTabs()
{
  x_start = 0.0;
  x_pitch = 1.2 * TabLength;
  y_start = InnerThickness * 1.1;
  y_pitch = ForkThickness * 1.5;
  y_offset = y_pitch * 0.5;
  for(x = [0:1:2])
    for(y = [0:1:9]) {
      nx = x * x_pitch + x_start;
      ny = y * y_pitch + y_start + ((x % 2) * y_offset);
      translate([nx, ny, 0]) RoundedBallTab(-0.1);
    }
}


//scale([25.4,25.4,25.4]) {
//  VertexSet_4();
//  VertexSet_5();
//  VertexSet_6();  
  // Hub_3(1.25);
  //RoundedBallTab(-0.1);
//  JustTabs();
// }

