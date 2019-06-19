SlotSplit = 1.3;

$fn=32; // round things are drawn in 32 segments

InnerWidth = 0.6;
SlotWidth = 0.3;
InnerThickness = 0.1;
TabLength = 1.0;
Offset = 0.125; 
JoinerWidth = SlotWidth * 1.5;

BumpDia = 0.2;
DimpleDia = 0.4;
BumpOffset = TabLength - 0.22;


StringHoleDia = 0.125;

module RoundedBumpPlate() {
  translate([0,0.5*InnerWidth, 0]) cylinder(d=InnerWidth, h=InnerThickness);
  cube([TabLength, InnerWidth, InnerThickness], false);
  translate([BumpOffset, InnerWidth * 0.5, 0.75 * InnerThickness]) sphere(d=BumpDia);
  translate([BumpOffset, InnerWidth * 0.5, 0.25 * InnerThickness]) sphere(d=BumpDia);  
}

module RoundedDimplePlate() {
  difference() {
    union() {       
      translate([0,0.5*InnerWidth, 0]) cylinder(d=InnerWidth, h=InnerThickness);
      cube([TabLength, InnerWidth, InnerThickness], false);
    }
    union() {
      translate([BumpOffset, InnerWidth * 0.5, 0.6 * DimpleDia]) sphere(d=DimpleDia);
   }
 }
}


module BumpPlate() {
  cube([TabLength, InnerWidth, InnerThickness], false);
  translate([BumpOffset, InnerWidth * 0.5, InnerThickness]) sphere(d=BumpDia);
  translate([BumpOffset, InnerWidth * 0.5, 0]) sphere(d=BumpDia);  
}

BallDia = 2.0 * InnerThickness; 

module OneBumpTab(XOffset)
{
  translate([0.5 * InnerWidth, 0.5 * InnerThickness, -0]) rotate([90, 0, 0]) 
  union() {
    RoundedDimplePlate();
    translate([0.0 * (BallDia + XOffset), InnerWidth * 0.5 , 0.5 * InnerThickness]) sphere(d=BallDia);
  }
}

module RoundedBallTab(XOffset)
{
  translate([0.5 * InnerWidth, 0.5 * InnerThickness, -0]) rotate([90, 0, 0]) 
  union() {
    RoundedBumpPlate();
    translate([0.0 * (BallDia + XOffset), InnerWidth * 0.5 , 0.5 * InnerThickness]) sphere(d=BallDia);
  }
}

module Spike()
{
    translate([0.5*InnerWidth,0.5*InnerWidth,0.5*InnerThickness]) rotate([0,90,0]) cylinder(h=InnerWidth, d=0.5*BallDia, center=true);
    translate([0.8 * InnerWidth, 0.5 * InnerWidth, 0]) linear_extrude(height=InnerThickness) 
        polygon(points = [[0, -0.5 * InnerWidth], [0, 0.5 * InnerWidth],
	                  [-0.5 * InnerWidth, 0]]);
}

module ExtendedBallTab(XOffset)
{
  translate([0.5 * InnerWidth, 0.5 * InnerThickness, -0])
  union() {
    intersection() {
      RoundedBumpPlate();
      translate([1.3 * InnerWidth, 0, 0]) cube([InnerWidth, 2.0 * InnerWidth, InnerWidth], true);
    }
    translate([0.0 * (BallDia + XOffset), InnerWidth * 0.5 , 0.5 * InnerThickness]) sphere(d=1.05 * BallDia);
    Spike();    
  }
}

module SplitExtendedBallTab(XOffset)
{
  intersection() {
    ExtendedBallTab(XOffset);
    translate([0,0,0.5*InnerThickness]) cube([100*InnerWidth, 100*InnerWidth, 100*InnerWidth]);
  }
}

module SplitSet()
{
  PairXOff = 1.5 * InnerWidth;

  for(x = [0:1:0]) {
    for(y = [0:1:0]) {
      translate([x * 3 * InnerWidth, 1.25 * y * InnerWidth, 0]) 
      union() {
        translate([PairXOff, 0.5 * InnerWidth, 0]) rotate([0, 0, 180]) SplitExtendedBallTab(-0.1);  
        SplitExtendedBallTab(-0.1);
      }
    }
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
  difference() {
    union() {
      Socket(split);
      rotate([0, 0, 120]) Socket(split);
      rotate([0, 0, -120]) Socket(split);
    }
    translate([0,0,-0.01]) cylinder(d=StringHoleDia, h = 3 * InnerWidth);
  }
}

module Vertex_3()
{
  translate([-0.85 * TabLength, -8 * InnerThickness,0]) {
    translate([0.5 * TabLength, 1.5 * TabLength, 0]) Hub_3(SlotSplit);
    for(y = [0:1:2])
      translate([0, y * 3 * InnerThickness, 0]) RoundedBallTab(-0.1);
  }
}

module VertexSet_3()
{
  x_start = 0.5 * TabLength;
  x_mid_adj = -0.1 * TabLength;
  x_pitch = .65 * TabLength;
  y_start = 0.7 * TabLength;
  y_pitch = 1.37 * TabLength;
  y_offset = y_pitch * 0.5;
  for(x = [0:1:4])
    for(y = [0:1:1]) {
      if((y != 4) || ((x % 2) != 1)) {
      nx = x * x_pitch + x_start + ((x % 2) * x_mid_adj);
      ny = y * y_pitch + y_start + ((x % 2) * y_offset);
      translate([nx, ny, 0]) rotate([0,0,(x%2)*60]) Hub_3(SlotSplit);
      }
    }
}

module Hub_4(split) {
  difference() {
    union() {
      for(ang = [0:90:359]) 
        rotate([0, 0, ang]) Socket(split);
    }
    translate([0,0,-0.01]) cylinder(d=StringHoleDia, h = 3 * InnerWidth);    
  }
}

module Hub_4Half(split) {
  difference() {
    union() {
      for(ang = [0:45:190]) 
        rotate([0, 0, ang]) Socket(split);
    }
    union() {
      translate([0,0,-0.01]) cylinder(d=StringHoleDia, h = 3 * InnerWidth);
      translate([-50,-10.1245,-0.01]) cube([100,10,100]);
    }
  }
}

module Hub_3Half(split) {
  difference() {
    union() {
      for(ang = [0:60:190]) 
        rotate([0, 0, ang]) Socket(split);
    }
    union() {
      translate([0,0,-0.01]) cylinder(d=StringHoleDia, h = 3 * InnerWidth);
      translate([-50,-10.1245,-0.01]) cube([100,10,100]);
    }
  }
}

module Hub_T(split) {
  difference() {
    union() {
      for(ang = [0:90:190]) 
        rotate([0, 0, ang]) Socket(split);
    }
    union() {
      translate([0,0,-0.01]) cylinder(d=StringHoleDia, h = 3 * InnerWidth);
      translate([-50,-10.1245,-0.01]) cube([100,10,100]);
    }
  }
}

module Vertex_4() {
  Hub_4(SlotSplit);
  for(y = [-2*ForkThickness:ForkThickness:2*ForkThickness])
    if ( y != 0 )
      translate([ForkThickness * 0.75, y, 0])
        RoundedBallTab(-0.1);
}

module VertexSet_4sq()
{
  x_start = 0.7*TabLength;
  y_start = 0.8*TabLength;
  x_pitch = 1.8 * TabLength;
  y_pitch = 0.8 * TabLength;
  x_step = 0.5 * x_pitch;
  y_step = 0.5 * y_pitch;
  for(x = [0:1:3]) 
    for(y = [0:1:6]) {
      if((x != 3) || ((y % 2) == 0)) {
        x_loc = x_start + x * x_pitch + ((y % 2) ? (0.5 * x_pitch) : 0);
        y_loc = y_start + y * y_pitch; 
        translate([x_loc, y_loc, 0]) Hub_4();
      }
    }
}

module VertexSet_4()
{
  x_start = 0.6 * TabLength;
  x_mid_adj = -0.1 * TabLength;
  x_pitch = .65 * TabLength;
  y_start = 0.6 * TabLength;
  y_pitch = 1.37 * TabLength;
  y_offset = y_pitch * 0.5;
  for(x = [0:2:3])
    for(y = [0:1:3]) {
      if((y != 2) || ((x % 2) != 1)) {
      nx = x * x_pitch + x_start + ((x % 2) * x_mid_adj);
      ny = y * y_pitch + y_start + ((x % 2) * y_offset);
      translate([nx, ny, 0]) rotate([0,0,45])  Hub_4(SlotSplit);
      }
    }
}


module VertexSet_4Half()
{
  x_start = 0.6 * TabLength;
  x_pitch = 1.5 * TabLength;
  y_start = 0.6 * TabLength;
  y_pitch = 0.9 * TabLength;
  y_offset = y_pitch * 0.5; 
  for(x = [0:1:3])
    for(y = [0:1:3]) {
      nx = x * x_pitch + x_start;
      ny = y * y_pitch + y_start;
      if((floor(y / 2) % 2) == 0) {
        echo(x,  y, floor(y/2));
        if((y % 2) == 0) {
          translate([nx, ny, 0])  Hub_4Half(SlotSplit);
        }
        else {
          translate([nx, ny, 0])  Hub_T(SlotSplit);
	}
      }
      else {
        if((y % 2) == 1) {
          translate([nx + 0.25 * x_pitch, ny, 0])  rotate([0, 0, 180]) Hub_4Half(SlotSplit);
        }
        else {
          translate([nx + 0.25 * x_pitch, ny, 0])  rotate([0, 0, 180])  Hub_T(SlotSplit);
	}
      }
    }
}

module VertexSet_3Half()
{
  x_start = 0.6 * TabLength;
  x_pitch = 1.8 * TabLength;
  y_start = 0.6 * TabLength;
  y_pitch = 0.85 * TabLength;
  y_offset = y_pitch * 0.5; 
  for(y = [0:1:1]) {
    lim = (y % 2) ? 2 : 3;
    for(x = [0:1:lim]) {    
      nx = x * x_pitch + x_start;
      ny = y * y_pitch + y_start;
      if((y % 2) == 0) {
        translate([nx, ny, 0])  Hub_3Half(SlotSplit);
      }
      else {
        translate([nx + 0.5 * x_pitch, ny, 0])  rotate([0,0,180]) Hub_3Half(SlotSplit);
      }
    }
  }
}

module Overlap()
{
  thickness = 0.8 * InnerThickness;
  z_offset = 0.5 * thickness + 0.05;
  translate([0,0,InnerWidth * 0.5]) rotate([90,0,0]) 
  union() {
    color("red") translate([0,0,z_offset]) cube([InnerWidth, InnerWidth, thickness], true);
    color("blue") translate([0,0,-z_offset]) cube([InnerWidth, InnerWidth, thickness], true);
    color("green") cube([SlotWidth, InnerWidth, 3 * 0.038], true);
  }
}

module VertexSet_4Half_Vert()
{
  x_start = 0.6 * TabLength;
  x_pitch = 1.5 * TabLength;
  y_start = 0.6 * TabLength;
  y_pitch = 1.2 * InnerWidth;
  y_offset = y_pitch * 0.5; 
  for(x = [0:1:3])
    for(y = [0:1:1]) {
      nx = x * x_pitch + x_start;
      ny = y * y_pitch + y_start;
      if((y % 2) == 0) {
        translate([nx, ny, 0]) rotate([90,0,0])  Hub_4Half(SlotSplit);
      }
      else {
        translate([nx, ny, 0]) rotate([90,0,0])  Hub_T(SlotSplit);      
      }
    }
}


module Hub_5(split) {
  difference() {
    union() {
      for(ang = [0:72:359]) 
        rotate([0, 0, ang]) Socket(split);
    }
    translate([0,0,-0.01]) cylinder(d=StringHoleDia, h = 3 * InnerWidth);    
  }
}

module Vertex_5() {
  Hub_5(SlotSplit);
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
  for(x = [0:1:3]) 
    for(y = [0:1:3]) {
      nx = x * x_pitch + x_start + (x_offset * (y % 2));
      ny = y * y_pitch + y_start;      
      translate([nx, ny, 0]) Hub_5(SlotSplit);
    }
}


module Hub_6(split) {
  difference() {
    union() {
      for(ang = [0:60:359]) 
        rotate([0, 0, ang]) Socket(split);
    }
    translate([0,0,-0.01]) cylinder(d=StringHoleDia, h = 3 * InnerWidth);    
  }
}

module Vertex_6() {
  Hub_6(SlotSplit);
  for(y = [0:1:5]) {
    translate([-0.6*TabLength, 0.8 * TabLength + y * ForkThickness, 0]) RoundedBallTab(-0.1);
  }
}

module oldVertexSet_6()
{
  x_start = 0.8 * TabLength;
  x_pitch = 1.15 * TabLength;
  y_start = 0.8 * TabLength;
  y_pitch = 1.5 * TabLength;
  y_offset = y_pitch * 0.5;
  for(x = [0:1:4])
    for(y = [0:1:3]) {
      nx = x * x_pitch + x_start;
      ny = y * y_pitch + y_start + ((x % 2) * y_offset);
      translate([nx, ny, 0]) rotate([0,0,(x%2)*30]) Hub_6(SlotSplit);
    }
}

module VertexSet_6()
{
  x_start = 0.8 * TabLength;
  x_pitch = 0.85 * TabLength;
  y_start = 0.8 * TabLength;
  y_pitch = 1.65 * TabLength;
  y_offset = y_pitch * 0.5;
  for(x = [0:1:5]) {
    for(y = [0:1:2]) {
      if ((x % 2 == 0) || (y < 3)) {
        nx = x * x_pitch + x_start;
        ny = y * y_pitch + y_start + ((x % 2) * y_offset);
        translate([nx, ny, 0])
	  Hub_6(SlotSplit);
      }
    }
  }
}

module JustDimpleTabs()
{
  x_start = 0.0;
  x_pitch = 0.7 * TabLength;
  y_start = InnerThickness * 1.1;
  y_pitch = ForkThickness * 1.5;
  y_offset = y_pitch * 0.5;
  x_offset = x_pitch * -0.55;
//  for(x = [0:1:5])
//    for(y = [0:1:4]) {
  for(x = [0:1:1])
    for(y = [0:1:1]) {
      nx = x * x_pitch + x_start + ((x % 2) * x_offset);;
      ny = y * y_pitch + y_start + ((x % 2) * y_offset);
      translate([nx, ny, 0]) OneBumpTab(-0.1);
    }
}

module JustTabs()
{
  x_start = 0.0;
  x_pitch = 0.7 * TabLength;
  y_start = InnerThickness * 1.1;
  y_pitch = ForkThickness * 1.5;
  y_offset = y_pitch * 0.5;
  x_offset = x_pitch * -0.55;
  for(x = [0:1:5])
    for(y = [0:1:6]) {
      nx = x * x_pitch + x_start + ((x % 2) * x_offset);;
      ny = y * y_pitch + y_start + ((x % 2) * y_offset);
      translate([nx, ny, 0]) RoundedBallTab(-0.1);
    }
  if(0) {
  for(x = [0:1:3])
    for(y = [0:1:1])
      translate([3.2 * TabLength + x * y_pitch * 0.5,
                 y*TabLength*1.4 + ((x%2) * y_offset * 1.6), 0]) rotate([0,0,90]) RoundedBallTab(-0.1);
  }
}

if(1) {
scale([25.4,25.4,25.4]) {
// Vertex_3();
//  VertexSet_3(); 
//  VertexSet_4(); 
  VertexSet_5();
//  VertexSet_6();
//  Hub_4Half(SlotSplit);
//  VertexSet_4Half();
//   VertexSet_3Half();
// Hub_3(SlotSplit);
//   Hub_6(SlotSplit);
//  Socket(1.35);
//  translate([0, 0.4, 0]) Socket(1.30);  
//  SplitExtendedBallTab(-0.1);
//  SplitSet();
// JustTabs();
//  Overlap();
//  OneBumpTab(-0.1);
//    JustDimpleTabs();
  }
}

