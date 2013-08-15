// DO NOT USE THIS
// The i3 and its derivatives do not clamp the z smooth rod, so this part can spin with the smooth rod, potentially causing misalignment with the endstop.

da6 = 1 / cos(180 / 6) / 2;

clearance        = 0.5;
rod_diam         = 8 + 0;
center_to_center = 16;

endstop_width    = 6 + clearance;
endstop_length   = 20 + clearance;
endstop_height   = 8;

thickness = 3;
height    = 12;

total_length = endstop_length + thickness*2;
total_width  = center_to_center + rod_diam/2 + endstop_width/2 + thickness*2;

module z_endstop_holder() {
  difference() {
    z_frame();
    z_holes();
    corner_trim();
  }

  % cylinder(r=rod_diam/2,h=height*2,center=true);
}

module z_frame() {
  translate([-1*center_to_center/2,-1*(endstop_length*.1),0])
    difference() {
      cube([total_width,total_length,height],center=true);
      for(side=[-1,1]) {
        translate([-total_width/2,side*total_length/2,0]) rotate([0,0,45]) cube([2,2,height*2],center=true);
      }
      translate([total_width/2,total_length/2+1,0]) rotate([0,0,30]) cube([10,100,height*2],center=true);
      translate([total_width/2-1,total_length/2,0]) rotate([0,0,60]) cube([10,100,height*2],center=true);
    }
}

module z_holes() {
  // smooth rod slot
  cylinder(r=rod_diam/2,h=height*2,$fn=72,center=true);
  translate([0,-1*(rod_diam),0]) cube([rod_diam-clearance*2,rod_diam*2+thickness,height*2],center=true);

  // endstop holder
  translate([-center_to_center,-1*(endstop_length*.1),height/2]) {
    cube([endstop_width,endstop_length,endstop_height*2],center=true);
    cube([endstop_width-2,endstop_length-1,height*3],center=true);
    translate([-thickness,0,0]) cube([thickness*3,thickness,height*3],center=true);
  }

  // clamp screw
  translate([0,-10,0]) rotate([90,0,0]) rotate([0,90,0]) cylinder(r=3.1*da6,h=rod_diam+thickness*3,$fn=6,center=true);

  // captive clamp nut
  translate([-rod_diam/2-thickness-2,-10,0]) {
    rotate([0,90,0]) cylinder(r=5.5*da6,h=5,$fn=6,center=true);
    translate([0,0,height/2]) cube([5,5.5,height],center=true);
  }
}

z_endstop_holder();
