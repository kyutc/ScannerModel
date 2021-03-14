// Variables common between each part
include <variables.scad>

module post() union() {
    h = 3;
    r = 1.25; // d = ~2.7
    color("gray") cylinder(h, r, r, $fn = q);
    translate([0, 0, h]) color("yellow") sphere(r, $fn=q);
}