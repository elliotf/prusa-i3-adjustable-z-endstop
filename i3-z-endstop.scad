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
  module body() {
    // main body
    translate([-1*(rod_diam/2+thickness+3),-rod_diam/2-thickness*2,-height/2])
      cube([rod_diam+thickness*2+3,rod_diam+frame_thickness+rod_frame_gap+thickness*3,height]);

    // endstop mount
    translate([-rod_endstop_center_to_center+3,3,0])
      cube([endstop_width+thickness*2+6,endstop_length+thickness*2,height],center=true);
  }

  module holes() {
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

  difference() {
    body();
    holes();
  }

  % cylinder(r=rod_diam/2,h=height*2,center=true);
}

module magnetic_z_endstop_holder() {
  padding     = 0.1;
  nut_diam    = 5.5 + padding;
  nut_height  = 5.5;
  screw_diam  = 3 + padding;
  rod_diam    = 8 + padding;

  zip_tie_width     = 3;
  zip_tie_thickness = 2;

  // plus padding
  endstop_width     = 4 + padding;
  endstop_height    = 3 + padding;
  endstop_thickness = 1.5 + padding*2;

  body_width  = rod_diam + thickness*3;
  body_depth  = rod_diam + frame_thickness + rod_frame_gap + thickness*3;
  body_height = nut_diam + thickness*1.5;

  clamp_pos_y = rod_diam/2+thickness*2+nut_diam/2;

  endstop_holder_width = endstop_width + thickness*2;
  endstop_holder_depth = clamp_pos_y+nut_diam/2+thickness*2;
  endstop_holder_height = 10;

  clamp_gap_width = 2;
  clamp_gap_depth = clamp_pos_y+screw_diam/2+thickness+clamp_gap_width;

  frame_hole_width = body_width-thickness;

  body_pos_x = left*thickness/2;
  body_pos_y = body_depth/2-rod_diam/2-thickness*2;
  body_pos_z = 0;

  endstop_holder_pos_x = left*rod_endstop_center_to_center;
  endstop_holder_pos_y = endstop_holder_depth/2-endstop_height/2-thickness;
  endstop_holder_pos_z = 0;

  echo("BOM: CLAMP SCREW LENGTH:", (body_pos_x+body_width/2) - (endstop_holder_pos_x - endstop_holder_width/2) - nut_height);

  module body() {
    // main body
    hull() {
      translate([body_pos_x,body_pos_y+body_depth/4,body_pos_z]) {
        cube([body_width,body_depth/2,body_height],center=true);
      }

      translate([endstop_holder_pos_x,endstop_holder_pos_y,endstop_holder_pos_z]) {
        cube([endstop_holder_width,endstop_holder_depth,endstop_holder_height],center=true);
      }

      hole(rod_diam+thickness*2,body_height,32);
    }

    translate([left*rod_endstop_center_to_center,0,0]) {
      % cube([1,1,20],center=true);
    }
  }

  module holes() {
    // frame slot // FIXME -- frame is not lined up, the slot needs to be more open to the left
    translate([frame_hole_width/2,rod_frame_center_to_center,0]) {
      cube([frame_hole_width*2,frame_thickness,height*2],center=true);
    }

    // smooth rod
    hull() {
      hole(rod_diam,body_height+1,32);
      translate([-rod_diam/2+clamp_gap_width/2,rod_diam/2,0]) {
        cube([clamp_gap_width,rod_diam/2,height+1],center=true);
      }
    }

    // clamp screw
    translate([0,clamp_pos_y,0]) {
      rotate([0,90,0]) {
        hole(screw_diam,body_width*4,6);
      }

      // clamp nut (inside)
      translate([body_pos_x+body_width/2,0,0]) {
        rotate([0,90,0]) {
          hole(nut_diam,nut_height*2,6);
        }
      }

      // clamp nut (outside)
      translate([endstop_holder_pos_x-endstop_holder_width/2,0,0]) {
        rotate([0,90,0]) {
          hole(nut_diam,nut_height*2,6);
        }
      }
    }

    // clamp gap
    translate([-rod_diam/2+clamp_gap_width/2,clamp_gap_depth/2,0]) {
      cube([clamp_gap_width,clamp_gap_depth,body_height+1],center=true);
    }
    translate([-rod_diam/2+body_width/2,clamp_gap_depth,0]) {
      cube([body_width,clamp_gap_width,body_height+1],center=true);
    }

    translate([left*rod_endstop_center_to_center,0,body_height/2]) {
      // A3144 endstop recess
      cube([endstop_width,endstop_height,endstop_thickness],center=true);

      translate([0,endstop_height/2,0]) {
        cube([endstop_width,endstop_height,1],center=true);
      }

      // A3144 enstop wiring recess
      translate([0,endstop_height+extrusion_width*2,0]) {
        hull() {
          cube([endstop_width,endstop_height,endstop_thickness*1.5],center=true);

          translate([0,endstop_height/4+body_depth/2,0]) {
            cube([endstop_width*1.5,body_depth,endstop_thickness*1.5],center=true);
          }
        }
      }

      // A3144 zip tie restraint
      for(side=[left,right]) {
        translate([(endstop_width/2+zip_tie_thickness/2+thickness/2)*side,0,0]) {
          cube([zip_tie_thickness,zip_tie_width,body_height*3],center=true);
        }
      }

      // wiring zip tie restraint
      for(side=[left,right]) {
        translate([((endstop_width*1.5)/4+zip_tie_thickness/2+thickness/2)*side,endstop_height*2,0]) {
          cube([zip_tie_thickness+.2,zip_tie_width,body_height*3],center=true);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module hinged_magnetic_z_endstop_holder() {
  padding     = 0.1;
  nut_diam    = 5.5 + padding;
  nut_height  = 5.5;
  screw_diam  = 3 + padding;
  rod_diam    = 8 + padding;

  zip_tie_width     = 3;
  zip_tie_thickness = 2;

  // plus padding
  endstop_width     = 4 + padding;
  endstop_height    = 3 + padding;
  endstop_thickness = 1.5 + padding*2;

  body_width  = rod_diam + thickness*3;
  body_depth  = rod_diam + frame_thickness + rod_frame_gap + thickness*3 + nut_diam;
  body_height = nut_diam + thickness*2;

  clamp_pos_y = rod_diam/2+thickness+nut_diam/2;

  endstop_holder_width = endstop_width + thickness*2;
  endstop_holder_depth = clamp_pos_y+nut_diam/2+thickness*2;
  endstop_holder_height = 10;

  clamp_gap_width = 2;
  clamp_gap_depth = clamp_pos_y+screw_diam/2+thickness+clamp_gap_width;

  frame_hole_width = body_width-thickness;

  body_pos_x = left*thickness/2;
  body_pos_y = body_depth/2-rod_diam/2-thickness*2;
  body_pos_z = 0;

  endstop_holder_pos_x = left*rod_endstop_center_to_center;
  endstop_holder_pos_y = endstop_holder_depth/2-endstop_height/2-thickness;
  endstop_holder_pos_z = 0;

  hinge_pos_y = rod_frame_center_to_center + frame_thickness/2 + thickness + nut_diam/2;
  hinge_pos_z = body_height/2;

  endstop_point_pos_x = left*rod_endstop_center_to_center;

  echo("BOM: CLAMP SCREW LENGTH:", (body_pos_x+body_width/2) - (endstop_holder_pos_x - endstop_holder_width/2) - nut_height);

  arm_spacer = 1;
  endstop_arm_width = 10;
  endstop_arm_hinge_diam = screw_diam + thickness*2;
  endstop_arm_thickness = endstop_arm_hinge_diam/2;
  endstop_arm_length = hinge_pos_y + endstop_arm_hinge_diam;
  endstop_arm_pos_x = body_pos_x - body_width/2 - arm_spacer - endstop_arm_width/2;
  endstop_arm_pos_z = hinge_pos_z + endstop_arm_thickness/2;

  fine_adjustment_area_height = body_height-endstop_arm_hinge_diam/2-.5;
  fine_adjustment_area_pos_y = clamp_gap_depth + (rod_frame_center_to_center - clamp_gap_depth)/2;
  fine_adjustment_area_pos_z = body_pos_z-body_height/2+fine_adjustment_area_height/2;

  module endstop_arm() {
    module body() {
      translate([0,hinge_pos_y,0]) {
        hull() {
          translate([0,-endstop_arm_length/2+endstop_arm_hinge_diam/2,endstop_arm_hinge_diam/2-endstop_arm_thickness/2]) {
            cube([endstop_arm_width,endstop_arm_length,endstop_arm_thickness],center=true);
          }
          /*
          translate([0,0,endstop_arm_hinge_diam/2-endstop_arm_thickness/2]) {
            cube([endstop_arm_width,endstop_arm_hinge_diam,endstop_arm_thickness],center=true);
          }
          */
          rotate([0,90,0]) {
            hole(endstop_arm_hinge_diam,endstop_arm_width,24);
          }
        }
      }
    }

    module holes() {
      translate([0,0,endstop_arm_hinge_diam/2]) {
        a3144_holes();
      }
    }

    difference() {
      body();
      holes();
    }
  }

  module body() {
    // main body
    hull() {
      translate([body_pos_x,0,body_pos_z]) {
        translate([0,hinge_pos_y,0]) {
          cube([body_width,nut_diam+thickness*2,body_height],center=true);
        }
        translate([0,clamp_pos_y,0]) {
          cube([body_width,nut_diam+thickness*2,body_height],center=true);
        }
      }

      hole(rod_diam+thickness*2,body_height,32);
    }

    // hinge body
    hull() {
      translate([body_pos_x,hinge_pos_y,body_pos_z]) {
        translate([0,0,body_pos_z]) {
          cube([body_width,nut_diam+thickness*2,body_height],center=true);
        }
        translate([0,0,hinge_pos_z]) {
          rotate([0,90,0]) {
            hole(nut_diam+thickness*2,body_width,24);
          }
        }
      }
    }

    // fine adjustment screw area
    hull() {
      translate([endstop_arm_pos_x,fine_adjustment_area_pos_y,fine_adjustment_area_pos_z]) {
        hole(nut_diam+thickness*2,fine_adjustment_area_height,32);
      }
      translate([body_pos_x,fine_adjustment_area_pos_y,fine_adjustment_area_pos_z]) {
        cube([body_width,nut_diam+thickness*2,fine_adjustment_area_height],center=true);
      }
      translate([body_pos_x,hinge_pos_y,fine_adjustment_area_pos_z]) {
        cube([body_width,nut_diam+thickness*2,fine_adjustment_area_height],center=true);
      }
    }
  }

  module holes() {
    // frame slot // FIXME -- frame is not lined up, the slot needs to be more open to the left
    translate([frame_hole_width/2,rod_frame_center_to_center,0]) {
      cube([frame_hole_width*2,frame_thickness,height*2],center=true);
    }

    // smooth rod
    hull() {
      hole(rod_diam,body_height+1,32);
      translate([-rod_diam/2+clamp_gap_width/2,rod_diam/2,0]) {
        cube([clamp_gap_width,rod_diam/2,height+1],center=true);
      }
    }

    // hinge screw
    translate([0,hinge_pos_y,hinge_pos_z]) {
      rotate([0,90,0]) {
        hole(3,body_width*4,16);
      }

      // clamp nuts inside
      translate([body_pos_x+(body_width/2),0,0]) {
        rotate([0,90,0]) {
          hole(nut_diam,nut_height,6);
        }
      }
    }

    // fine adjustment screw hole
    translate([endstop_arm_pos_x,fine_adjustment_area_pos_y,fine_adjustment_area_pos_z]) {
      hole(3,100,16);
    }

    // clamp screw
    translate([0,clamp_pos_y,0]) {
      rotate([0,90,0]) {
        hole(screw_diam,body_width*4,6);
      }

      // clamp nuts inside
      translate([body_pos_x+(body_width/2),0,0]) {
        rotate([0,90,0]) {
          hole(nut_diam,nut_height*2,6);
        }
      }

      // screw head outside
      translate([body_pos_x+(body_width/2)*left,0,0]) {
        rotate([0,90,0]) {
          hole(nut_diam,nut_height,6);
        }
      }
    }

    // clamp gap
    translate([-rod_diam/2+clamp_gap_width/2,clamp_gap_depth/2,0]) {
      cube([clamp_gap_width,clamp_gap_depth,body_height+1],center=true);
    }
    translate([-rod_diam/2+body_width/2,clamp_gap_depth,0]) {
      cube([body_width,clamp_gap_width,body_height+1],center=true);
    }
  }

  module a3144_holes() {
    // A3144 endstop recess
    cube([endstop_width,endstop_height,endstop_thickness],center=true);

    translate([0,endstop_height/2,0]) {
      cube([endstop_width,endstop_height,1],center=true);
    }

    // A3144 enstop wiring recess
    translate([0,endstop_height+extrusion_width*2,0]) {
      hull() {
        cube([endstop_width,endstop_height,endstop_thickness*1.5],center=true);

        translate([0,endstop_height/4+body_depth/2,0]) {
          cube([endstop_width*1.5,body_depth,endstop_thickness*1.5],center=true);
        }
      }
    }

    // A3144 zip tie restraint
    for(side=[left,right]) {
      translate([(endstop_width/2+zip_tie_thickness/2+thickness/2)*side,0,0]) {
        cube([zip_tie_thickness,zip_tie_width,body_height*3],center=true);
      }
    }

    // wiring zip tie restraint
    for(side=[left,right]) {
      translate([((endstop_width*1.5)/4+zip_tie_thickness/2+thickness/2)*side,endstop_height*2,0]) {
        cube([zip_tie_thickness+.2,zip_tie_width,body_height*3],center=true);
      }
    }
  }

  difference() {
    body();
    holes();

    translate([left*rod_endstop_center_to_center,0,endstop_arm_pos_z+endstop_arm_thickness/2]) {
      % cube([1,1,20],center=true);
    }
  }

  translate([endstop_arm_pos_x,0,hinge_pos_z]) {
    endstop_arm();
  }
}

translate([0,0,0]) {
  hinged_magnetic_z_endstop_holder();
}

translate([40,0,0]) {
  //magnetic_z_endstop_holder();
}

translate([40,0,0]) {
  //z_endstop_holder();
}
