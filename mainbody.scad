include <variables.scad> // Variables common between each part
use <ext.scad> // External function definitions
use <inc.scad> // Internal function definitions

module mainbody() {
    // Version
    color("brown") translate([mainsize.x - thickness / 2 - 18, mainsize.y - thickness / 2 - 14, thickness / 2])
    linear_extrude(1) {
        text(txtversion, 8, "Bahnschrift");
    }


    difference() {
        if ($preview && preview_cut) {
            // Cuts some of the shell to look inside for previews
            color("yellow") cube([mainsize.x, mainsize.y, 25]);
        } else {
            // Outer cube, solid body
            color("yellow") cube(mainsize);
        }
        
        // Inner cube to hollow it out
        translate([thickness / 2, thickness / 2, thickness / 2]) 
        color("green")
        cube([mainsize.x - thickness, mainsize.y - thickness, mainsize.z + thickness]);
        
        // Power plug opening USB3 Type C
        // TODO: Confirm rounding radius
        portwidth = 11;
        translate([thickness / 2 + 7.7 + 3.5 - portwidth / 2, -1, thickness / 2 + 2.5])
        //color("red") cube([portwidth, 3.5, 6]);
        color("red") roundedcube([portwidth, thickness + 2, 6], radius = 3, apply_to = "y");
        
        // Bottom air vents
        // TODO: Consider side air vents instead? Bottom vents without a stand won't work on flat surfaces
        // and printing with a stand would take longer
        // TODO: Also make sure the vents are aligned between the posts, higher thicknesses will
        // currently bring them out of proper alignment
        /* Removing in preference of side air vents
        for (r = [0 : 6]) {
            for (c = [0 : 8]) {
                color("red")
                translate([3.5 + 2.8 + 6 + c*6, 3.5 + 2.3 + 6 +r*6, -1])
                cube([2, 2, thickness + 2]);
            }
        }
        */
        
        // Side air vents
        for (r = [0 : 4]) {
            for (c = [0 : 4]) {
                color("red")
                translate([3.5 + 2.8 + 6 + c*((mainsize.x - thickness/2) / 6), -1, 3.5 + 2.3 + 6 +r*((mainsize.z - thickness/2) / 6)])
                roundedcube([3, thickness + 2, 3], radius=1.5, apply_to="y");
                //cube([2, thickness + 2, 2]);
            }
        }
    }

    /* Experimental mount position for camera module -- not likely to work due to clearance requirements with the board
    translate([thickness / 2, thickness / 2, thickness / 2]) {
        translate([camerasize.x / 2, (mainsize.y - thickness) / 2, 30 / 2 + 7.0])
        difference() {
            cube([camerasize.x, camerasize.y, 30], center=true);
            translate([0, 0, camerasize.y])
            rotate([0, 45, 0])
            cube([500, sqrt(pow(camerasize.x, 2)+pow(camerasize.y, 2)), sqrt(pow(camerasize.x, 2)+pow(camerasize.y, 2))], center=true);
        }
    }
    */

    // Posts which the board will rest on without using screws
    translate([thickness / 2, thickness / 2, thickness / 2]) {
        // 2.8mm added to x for SD card clearance
        // 2.3mm added to y for audio jack clearance
        // 3.5mm distance of holes from edge of board
        // Getting rid of the posts because they're not required and too fragile with PLA at this diameter
        //translate([3.5 + 2.8,        3.5 + 2.3,        0]) post(); // bottom left
        //translate([3.5 + 2.8 + 58.0, 3.5 + 2.3,        0]) post(); // bottom right
        //translate([3.5 + 2.8,        3.5 + 2.3 + 49.0, 0]) post(); // top left
        //translate([3.5 + 2.8 + 58.0, 3.5 + 2.3 + 49.0, 0]) post(); // top right
    }
}