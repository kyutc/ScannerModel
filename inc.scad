// Variables common between each part
include <variables.scad>

module post() union() {
    h = 3;
    r = 1.25; // d = ~2.7
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