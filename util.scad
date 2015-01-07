function accurate_diam(diam,sides) = 1 / cos(180/sides) / 2 * diam;
function accurate_vertice_diam(diam,sides) = 1 / cos(180/sides) / 2 * diam;

module hole(diam,len,sides=8) {
  rotate([0,0,180/sides]) {
    cylinder(r=accurate_diam(diam,sides),h=len,center=true,$fn=sides);
  }
}
