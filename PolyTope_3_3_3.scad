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

ForkThickness = 3. * InnerThickness;

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


module Hub_4E(split)
{
  difference() {
    union() {
      Socket(split);
      rotate([0, 0, 120]) Socket(split);
      rotate([0, 0, -120]) Socket(split);
      translate([InnerWidth * 0.5, 0, InnerWidth * 1.1]) rotate([0,270,0])
        difference() {
	   Socket(split);
	   translate([-0.3, 0, -1.7*SlotWidth]) scale([split, split, 1])  BallTab(+0.05);	   
        }
    }
    translate([0,0,-0.01]) cylinder(d=StringHoleDia, h = 3 * InnerWidth);
  }
}

module Hub_4C(split)
{
  translate([0,0,sin(30) * 1.1 * InnerWidth])
  difference() {
    union() {
      rotate([0, 30, 0]) Socket(split);
      rotate([0, 30, 120]) Socket(split);
      rotate([0, 30, -120]) Socket(split);
      translate([0,0,0.5*InnerWidth]) sphere(d=1.18*InnerWidth);
      translate([InnerWidth * 0.5, 0, InnerWidth * 0.75]) rotate([0,270,0])
        difference() {
	   Socket(split);
	   translate([-0.3, 0, -1.7*SlotWidth]) scale([split, split, 1])  BallTab(+0.05);	   
        }
    }
    //translate([0,0,-0.01]) cylinder(d=StringHoleDia, h = 3 * InnerWidth);
  }
}


module Center()
{
  Hub_4C(SlotSplit);
}

module Corner()
{
  Hub_4E(SlotSplit);
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
  //Corner();
   Center();
  }
}

