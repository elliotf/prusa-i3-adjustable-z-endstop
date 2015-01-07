include <util.scad>;
//
// i3-z-endstop.scad
//

left  = -1;
right = 1;
front = -1;
rear  = 1;

da6 = 1 / cos(180 / 6) / 2;

clearance       = 0.25;
frame_thickness = 6.15;
rod_diam        = 8 + clearance;
rod_frame_gap   = 24.75;
rod_frame_center_to_center = rod_frame_gap + frame_thickness/2 + rod_diam/2;
rod_endstop_center_to_center = 16;

endstop_width  = 6 + clearance;
endstop_length = 20 + clearance;
endstop_height = 8;

thickness = 3;
height    = 10;

extrusion_width  = 0.5;
extrusion_height = 0.3;

module z_endstop_holder() {
  difference() {
    z_frame();
    z_holes();
  }

  % cylinder(r=rod_diam/2,h=height*2,center=true);
}

module z_frame() {
  // main body
  translate([-1*(rod_diam/2+thickness+3),-rod_diam/2-thickness*2,-height/2])
    cube([rod_diam+thickness*2+3,rod_diam+frame_thickness+rod_frame_gap+thickness*3,height]);

  // endstop mount
  translate([-rod_endstop_center_to_center+3,3,0])
    cube([endstop_width+thickness*2+6,endstop_length+thickness*2,height],center=true);
}

module z_holes() {
  // frame slot // FIXME -- frame is not lined up, the slot needs to be more open to the left
  translate([thickness/2-1.5,rod_frame_center_to_center,0])
    cube([rod_diam+thickness+3,frame_thickness,height*2],center=true);

  // smooth rod slot
  cylinder(r=(rod_diam+0.25)/2,h=height*2,$fn=72,center=true);
  //translate([0,-1*(rod_diam),0]) cube([2,rod_diam*2+thickness,height*2],center=true);
  # translate([0,rod_diam,0]) cube([2,rod_diam*2+thickness,height*2],center=true);

  // clamp screw shaft
  translate([0,rod_diam,0]) rotate([90,0,0]) rotate([0,90,0]) {
    cylinder(r=3.1*da6,h=rod_diam+thickness*4,$fn=6,center=true);

    translate([3,height/2,0])
      % cylinder(r=3.1*da6,h=rod_diam+thickness*4,$fn=6,center=true);
  }

  translate([0,rod_diam,0]) {
    // captive clamp nut
    translate([-rod_diam/2-thickness+2,0,0]) {
      rotate([0,90,0]) cylinder(r=5.5*da6,h=3,$fn=6,center=true);
      translate([0,0,height/2]) cube([3,5.5,height],center=true);
    }

    // clamp screw recess
    translate([rod_diam/2+thickness/1.5,0,0]) rotate([90,0,0]) rotate([0,90,0]) cylinder(r=6.5*da6,h=5,$fn=6,center=true);
  }

  // empty space between rod clamp and frame
  translate([0,rod_frame_gap/2+4+thickness,0])
    cube([rod_diam+thickness+3,rod_frame_gap-thickness*2-8,height*2],center=true);

  // endstop stuffs
  translate([-16,3,0]) {
    // crevice
    translate([0,0,height-endstop_height]) cube([endstop_width,endstop_length,height-2],center=true);

    // bottom hole
    translate([0,0,-thickness]) cube([endstop_width-2,endstop_length-1,height*2],center=true);

    // side opening, to allow wires through
    translate([-1*(endstop_width),0,0]) cube([endstop_width*2,endstop_length/1.5,height*2],center=true);

    // zip tie slot for a lever-free endstop
    translate([endstop_width+1,0,0]) cube([2,3,height*2],center=true);
    translate([endstop_width-5,0,height/2]) cube([11,3,2],center=true);
    translate([endstop_width-5,0,-height/2]) cube([11,3,2],center=true);
  }

  % translate([-1,-rod_diam,0]) rotate([90,0,0]) rotate([0,90,0]) cylinder(r=3/2,h=10,$fn=32,center=true);
  % translate([rod_diam,rod_frame_gap/2+rod_diam/2,height/2]) cube([1,rod_frame_gap,1],center=true);
}

translate([40,0,0]) {
  //z_endstop_holder();
}
