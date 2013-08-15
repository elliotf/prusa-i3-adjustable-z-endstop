//
// Original version
//

da6 = 1 / cos(180 / 6) / 2;

clearance       = 0.5;
frame_thickness = 6;
rod_diam        = 8 + clearance;
rod_frame_gap   = 25.3;
rod_frame_center_to_center = rod_frame_gap + frame_thickness/2 + rod_diam/2;
rod_endstop_center_to_center = 16;

endstop_width  = 6 + clearance;
endstop_length = 20 + clearance;
endstop_height = 8;

thickness = 3;
height    = 10;

module z_endstop_holder() {
  difference() {
    z_frame();
    z_holes();
  }

  % cylinder(r=rod_diam/2,h=height*2,center=true);

}

module z_frame() {
  // main body
  translate([-1*(rod_diam/2+thickness),-rod_diam/2-thickness,-height/2])
    cube([rod_diam+thickness*2,rod_diam+frame_thickness+rod_frame_gap+thickness*2,height]);

  // clamp area
  translate([0,-8,0])
    cube([rod_diam+thickness*2,16,height],center=true);

  // joint between clamp and endstop
  translate([0,-8,0])
    translate([-8,-0.25*(6+thickness),0]) cube([6.1+thickness,5.5+thickness*2,height],center=true);

  // endstop mount
  translate([-rod_endstop_center_to_center,-2.75,0]) endstop_support();
}

module z_holes() {
  // frame slot
  translate([thickness/2,rod_frame_center_to_center,0])
    cube([rod_diam+thickness*1.1,frame_thickness,height*2],center=true);

  // smooth rod slot
  cylinder(r=rod_diam/2,h=height*2,$fn=72,center=true);
  translate([0,-1*(rod_diam),0]) cube([2,rod_diam*2+thickness,height*2],center=true);

  // clamp screw
  translate([0,-10,0]) rotate([90,0,0]) rotate([0,90,0]) cylinder(r=3.1*da6,h=rod_diam+thickness*3,$fn=6,center=true);

  translate([0,-rod_diam-thickness/2,0]) {
    // captive clamp nut
    translate([-rod_diam/2-thickness+.5,0,0]) {
      rotate([0,90,0]) cylinder(r=5.5*da6,h=6,$fn=6,center=true);
      translate([0,0,height/2]) cube([6,5.5,height],center=true);
    }

    // clamp screw recess
    translate([rod_diam/2+thickness/1.5,0,0]) rotate([90,0,0]) rotate([0,90,0]) cylinder(r=5.5*da6,h=5,$fn=6,center=true);
  }

  // empty space between rod and frame
  translate([0,rod_frame_center_to_center/2,0])
    cube([rod_diam,rod_frame_gap-thickness*2,height*2],center=true);
}
% translate([-1,-10,0]) rotate([90,0,0]) rotate([0,90,0]) cylinder(r=3/2,h=10,$fn=32,center=true);

module endstop_support() {
  difference() {
    cube([endstop_width+thickness*2,endstop_length+thickness*2,height],center=true);

    // crevice
    translate([0,0,height-endstop_height]) cube([endstop_width,endstop_length,height-2],center=true);

    // bottom hole
    translate([0,0,-thickness]) cube([endstop_width-thickness,endstop_length-2,height*2],center=true);

    // side opening, to allow wires through
    translate([-1*(endstop_width),0,0]) cube([endstop_width*2,endstop_length/2,height*2],center=true);
  }
}

z_endstop_holder();
