// Main body
thickness = 3;
//mainsize = [105, 63, 24];
mainsize = [101.0 + thickness, 58.5 + thickness, 19.5 + thickness];
q = 256; // render quality, low for preview high for render

// Version
color("brown") translate([thickness / 2 + mainsize.x - 18, thickness / 2 + mainsize.y - 14, thickness / 2])
linear_extrude(1) {
    text("R4", 8, "Bahnschrift");
}

// From https://gist.githubusercontent.com/groovenectar/92174cb1c98c1089347e/raw/ea51e4a5700211078327c99168b2036ad321dc89/roundedcube.scad
module roundedcube(size = [1, 1, 1], center = false, radius = 0.5, apply_to = "all") {
    $fs = 0.01;
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate_min = radius;
	translate_xmax = size[0] - radius;
	translate_ymax = size[1] - radius;
	translate_zmax = size[2] - radius;

	diameter = radius * 2;

	obj_translate = (center == false) ?
		[0, 0, 0] : [
			-(size[0] / 2),
			-(size[1] / 2),
			-(size[2] / 2)
		];

	translate(v = obj_translate) {
		hull() {
			for (translate_x = [translate_min, translate_xmax]) {
				x_at = (translate_x == translate_min) ? "min" : "max";
				for (translate_y = [translate_min, translate_ymax]) {
					y_at = (translate_y == translate_min) ? "min" : "max";
					for (translate_z = [translate_min, translate_zmax]) {
						z_at = (translate_z == translate_min) ? "min" : "max";

						translate(v = [translate_x, translate_y, translate_z])
						if (
							(apply_to == "all") ||
							(apply_to == "xmin" && x_at == "min") || (apply_to == "xmax" && x_at == "max") ||
							(apply_to == "ymin" && y_at == "min") || (apply_to == "ymax" && y_at == "max") ||
							(apply_to == "zmin" && z_at == "min") || (apply_to == "zmax" && z_at == "max")
						) {
							sphere(r = radius);
						} else {
							rotate = 
								(apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? [0, 90, 0] : (
								(apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? [90, 90, 0] :
								[0, 0, 0]
							);
							rotate(a = rotate)
							cylinder(h = diameter, r = radius, center = true);
						}
					}
				}
			}
		}
	}
}


module post() union() {
    h = 3;
    r = 1.25; // d = ~2.7
    color("gray") cylinder(h, r, r, $fn = q);
    translate([0, 0, h]) color("yellow") sphere(r, $fn=q);
}

difference() {
    assert(mainsize.x - thickness >= 101.0 && mainsize.y - thickness >= 58.5 && mainsize.z - thickness >= 19.5, "Too thick");

    // Outer cube, solid body
    color("yellow") cube(mainsize);
    
    // Inner cube to hollow it out
    translate([thickness / 2, thickness / 2, thickness / 2]) 
    color("green")
    cube([mainsize.x - thickness, mainsize.y - thickness, mainsize.z + thickness]);
    
    // Power plug opening USB3 Type C
    //translate([thickness / 2 + 9.0, -1, thickness / 2 + 3.5])
    //color("red") cube([9.3, thickness / 2 + 2, 3.5]);
    // TODO: Confirm rounding radius
    portwidth = 11;
    translate([thickness / 2 + 7.7 + 3.5 - portwidth / 2, -1, thickness / 2 + 2.5])
    //color("red") cube([portwidth, 3.5, 6]);
    color("red") roundedcube([portwidth, 3.5, 6], radius = 3, apply_to = "y");
    
    // Bottom air vents
    for (r = [0 : 6]) {
        for (c = [0 : 8]) {
            color("red")
            translate([6.3 + 6 + c*6, 5.8 + 6 +r*6, -1])
            cube([2, 2, thickness + 2]);
        }
    }
    
}

// Posts which the board will rest on without using screws
translate([thickness / 2, thickness / 2, thickness / 2]) {
    // 2.8mm added to x for SD card clearance
    // 2.3mm added to y for audio jack clearance
    // 3.5mm distance of holes from edge of board
    translate([6.3,        3.5 + 2.3,        0]) post(); // bottom left
    translate([6.3 + 58.0, 3.5 + 2.3,        0]) post(); // bottom right
    translate([6.3,        3.5 + 2.3 + 49.0, 0]) post(); // top left
    translate([6.3 + 58.0, 3.5 + 2.3 + 49.0, 0]) post(); // top right
}