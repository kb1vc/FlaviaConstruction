include <knurledFinishLib_v2.scad>

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
CenterHoleDia = 0.15; // little bigger than a number 6 screw

CDHoleDia = 0.56; // little smaller than a CD mounting hole
HexNutLen=0.31; // #6 hex nut 
HexNutDiag = HexNutLen / sin(60);
HexNutWidth = sqrt(HexNutDiag * HexNutDiag - HexNutLen * HexNutLen);
NutThickness = 0.1;

Slot8020Metric = 0.254 ; // sound familiar?
PegDia = Slot8020Metric * 0.95; // a little lee-way.

// T slot profile -- from 8020.net/shop/25-2525-black.html dimensioned drawing
TWidth = 0.98;
TSlotDepth = 0.3; // too tight at 0.315
TSlotCutWidth = 0.25;
TPlateThickness = 0.090;
TTrapezoidBase = 0.55;
TTrapezoidTop = 0.21;
TTrapezoidHeight = 0.18; // lots of room -- good choice for 0.2mm resolution in Z..
SlugLength = 1.75; // was 0.625;
echo(TTrapezoidHeight=TTrapezoidHeight, TSlotDepth = TSlotDepth, TPlateThickness = TPlateThickness);

ScrewHeadDia = 0.270; // a little oversized for a #6

CDThickness = 0.070; // actually about 0.05... 

echo(HexNutWidth = HexNutWidth, HexNutDiag = HexNutDiag, HexNutLen = HexNutLen);
module HexNut() {
  scale([1.05, 1.05, 1]) // scale it a little loose
  translate([0,0,0.5 * NutThickness])
    for(ang = [0, 60, 120]) {
      rotate([0, 0, ang]) cube([HexNutLen, HexNutWidth, NutThickness], center=true);
    }
}

module ReliefRing(dia)
{
  translate([0,0,-0.001]) difference() {
    cylinder(d = dia *10, h = 0.05);
    translate([0,0,-0.001]) cylinder(d = dia - 0.05, h = 2);
  }
}
module DummyDisk()
{
  difference() {
    cylinder(d = InnerWidth, h = InnerThickness * 3); // used on the edges, gets a little space for the screw to seat.
    union() {
      translate([0, 0, -0.001]) {
        cylinder(d = CenterHoleDia, h = InnerThickness * 5);
	translate([0,0,InnerThickness + 0.05]) scale([1,1,2]) HexNut();
      }
      ReliefRing(InnerWidth);
    }
  }
}

module CDPlate()
{
    union() {
      translate([0, 0, 0.999 * InnerThickness]) cylinder(d = CDHoleDia, h = CDThickness);
      cylinder(d = 1.25 * CDHoleDia, h = InnerThickness);    
    }
}

CDMountThickness = InnerThickness + CDThickness; 
module CDMount()
{
  difference() {
    CDPlate();
    translate([0, 0, -0.001]) {
      HexNut();
      cylinder(d = CenterHoleDia, h = 2);      
    }
  }
}

TrapOffset = CDMountThickness + TPlateThickness * 1.05  + 0.045;
module TSlotSlugBody()
{
  translate([0, 0, TrapOffset]) 
  // rescale
    translate([-0.5 * SlugLength, 0, TTrapezoidHeight])    rotate([0, 90, 0])
    // extrude
    linear_extrude(height = SlugLength) {
      // build the trapezoid
      polygon(points = [[TTrapezoidHeight, -0.5 * TTrapezoidBase], [TTrapezoidHeight, 0.5 * TTrapezoidBase],
                        [0, 0.5 * TTrapezoidTop], [0, -0.5 * TTrapezoidTop]]);
    }

  translate([0, 0, 2.4 * InnerThickness]) rotate([0, 90, 0]) cube([2.5 * TPlateThickness , 0.95 * TSlotCutWidth , SlugLength ], true);  
  translate([0,0,CDMountThickness]) rotate([0, 180, 0]) CDPlate();
}

module TSlotSlug()
{ 
  difference() {    TSlotSlugBody();
    union() {
      translate([0, 0, TrapOffset + 0.05]) scale([1,1,10]) HexNut();
      translate([0,0,-0.001]) cylinder(d = CenterHoleDia, h = 2);
    }
  }
}

module BSlotSlugBody()
{
  translate([0, 0, TrapOffset]) {
    // rescale
    translate([-0.5 * SlugLength, 0, TTrapezoidHeight])    rotate([0, 90, 0]) {
      // extrude
        linear_extrude(height = SlugLength) {
        // build the trapezoid
        polygon(points = [[TTrapezoidHeight, -0.5 * TTrapezoidBase], [TTrapezoidHeight, 0.5 * TTrapezoidBase],
                        [0, 0.5 * TTrapezoidTop], [0, -0.5 * TTrapezoidTop]]);

      }
    }
  }

  translate([0, 0, 2.4 * InnerThickness]) rotate([0, 90, 0]) cube([2.5 * TPlateThickness , 0.95 * TSlotCutWidth , SlugLength ], true);  
  translate([0,0,CDMountThickness]) rotate([0, 180, 0]) CDPlate();
}

module RoundOff()
{
  RHeight=10*TTrapezoidHeight;
  intersection() {
    union() {
      translate([-0.5 * (SlugLength), 0, -0.5 * RHeight]) cylinder(d = InnerWidth, h = RHeight);
      translate([0.5*(SlugLength), 0, -0.5 * RHeight]) cylinder(d = InnerWidth, h = RHeight);
      translate([-0.5 * SlugLength, -1 *InnerWidth, 0]) cube([SlugLength, 2 * InnerWidth, RHeight]);      
    }

    translate([0,0.5 * RHeight, -InnerWidth]) rotate([90,0,0]) cylinder(d = 4*InnerWidth, h = RHeight);
  }

}

module BSlotSlug()
{ 
  difference() {
    intersection() { 
      BSlotSlugBody();
      RoundOff();
    }
    union() {
      translate([0, 0, TrapOffset + 0.05]) scale([1,1,10]) HexNut();
      translate([0,0,-0.001]) cylinder(d = CenterHoleDia, h = 2);
    }
  }
}


module RoundedBumpPlate() {
  translate([0,0.5*InnerWidth, 0]) {
    difference() {
      cylinder(d=InnerWidth, h=InnerThickness);
      ReliefRing(InnerWidth);
    }
  }
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

module Knob()
{
  difference() {
    union() {
      knurl(k_cyl_hg = InnerThickness * 2, k_cyl_od = 1.25 * CDHoleDia, 
            knurl_wd = 0.08, knurl_hg = 0.08, knurl_dp = 0.02, 
            e_smooth = 0.02, s_smooth = 0);
      translate([0,0,InnerThickness * 2 - 0.01]) cylinder(d = CDHoleDia, h = InnerThickness);
    }
    union() {
      translate([0,0,-0.01]) cylinder(d = ScrewHeadDia, h = InnerThickness * 2);
      cylinder(d = CenterHoleDia, h = 2);
      ReliefRing(1.26*CDHoleDia);
    }
  }
}

module EdgeTabSet() {
  XOffset = 1.0;
  YOffset = 0.0;
  YStep = 0.75;
  XStep = 1.35;
  for(y = [0 : 1 : 1]) {
    translate([XOffset, YOffset + YStep * y, 0]) PlateWithSpacer();
  }
  translate([XOffset + XStep, YOffset, 0]) DummyDisk();

  Y2Step = 1.33 * CDHoleDia ;
  for(y = [0 : 1 : 0]) {
    translate([0, Y2Step * (2 * y + 1), 0]) Knob();
    translate([0, Y2Step * 2* y, 0]) BSlotSlug();
  }
}

module InteriorTabSet() {
  XOffset = 0.75;
  YOffset = 0.0;
  YStep = 0.75;
  XStep = 1.35;
  for(x = [0 : 1 : 1])
    for(y = [0 : 1 : 1]) {
     translate([XOffset + XStep * x, YOffset + YStep * y, 0]) PlateWithSpacer();
    }

  Y2Step = 1.33 * CDHoleDia ;
  for(y = [0 : 1 : 0]) {
    translate([0, Y2Step * y, 0]) {
      difference() {
        CDMount();
	ReliefRing(1.25*CDHoleDia);
      }
    }
  }

  translate([0, Y2Step, 0]) Knob();
}

scale([25.4,25.4,25.4])
{
 // CDMount();
 BSlotSlug();
 //color("red") RoundOff();
 //EdgeTabSet();
 //DummyDisk();
 //InteriorTabSet(); 
}