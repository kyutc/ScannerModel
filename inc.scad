// Variables common between each part
include <variables.scad>

module post(h = 3, r = 1.25) union() {
    color("gray") cylinder(h, r, r, $fn = q);
    translate([0, 0, h]) color("yellow") sphere(r, $fn=q);
}

module frictionjoint(size = 10, height = 5, overhang = 0.15) {
    polyhedron(
        points=[ [size,size,0],[size,0,0],[0,0,0],[0,size,0],
        [-overhang,-overhang,height]  ],
        faces=[ [0,1,4],[1,2,4],[2,3,4],[3,0,4],
        [1,0,3],[2,1,3] ]
     );
}

module clipjoint(w = 10, r = thickness) {
    union() {
        cube([w, r/2, r*2]);
        translate([0,           0, 0]) cube([r/2, r, r*2]);
        translate([w/2 - r/2/2, 0, 0]) cube([r/2, r, r*2]);
        translate([w - r/2,     0, 0]) cube([r/2, r, r*2]);
        hull() {
            translate([w/2/2, 0, r*2 - r/2])
            rotate([90, 0, 90])
            cylinder(w/2, r/2, r/2);
            translate([w/2/2, -r/2, r*2 - r/2])
            rotate([90, 10, 90])
            cylinder(w/2, r/2, r/2);
        }
    }
}

// Intended to be used with difference() to create the hole for a clipjoint to insert into
module clipjoint_divot(w = 10, r = thickness) {
    hull() {
        translate([w/2/2 - 0.25, r, r*2 - r/2 - 0.25])
        rotate([90, 0, 90])
        cylinder(w/2 + 0.5, r/2 + 0.5, r/2 + 0.5);
        translate([w/2/2 - 0.25, -r, r*2 - r/2 - 0.25])
        rotate([90, 10, 90])
        cylinder(w/2 + 0.5, r/2 + 0.5, r/2 + 0.5);
    }
}