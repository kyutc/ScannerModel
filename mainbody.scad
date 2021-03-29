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
        portwidth = 11.5;
        translate([thickness / 2 + 7.7 + 3.5 + 2.8 - portwidth / 2, -1, thickness / 2 + 2.5])
        color("red") roundedcube([portwidth, thickness + 2, 6.5], radius = 3, apply_to = "y");
        
        // Mini HDMI port 0
        if (enable_hdmi0)
        translate([thickness / 2 + 7.7 + 3.5 + 2.8 + 14.8 - 13.5 / 2, -1, thickness / 2 + 2.5])
        color("red") roundedcube([13.5, thickness + 2, 8.0], radius = 1, apply_to = "y");
        
        // Mini HDMI port 1
        if (enable_hdmi1)
        translate([thickness / 2 + 7.7 + 3.5 + 2.8 + 14.8 + 13.5 - 13 / 2, -1, thickness / 2 + 2.5])
        color("red") roundedcube([13.5, thickness + 2, 8.0], radius = 1, apply_to = "y");
        
        // If both HDMI0 and HDMI1 are enabled, the middle bit is only good for printing support so just remove it
        if (enable_hdmi0 && enable_hdmi1)
        translate([thickness / 2 + 7.7 + 3.5 + 2.8 + 14.8 - 13.5 / 2, -1, thickness / 2 + 2.5])
        color("maroon") roundedcube([13.5*2, thickness + 2, 8.0], radius = 1, apply_to = "y");
        
        // Side fan vent holes and screw holes
        slats = 6;
        if (enable_fan)
        color("red") translate([mainsize.x / 2, mainsize.y - thickness/2, 35]) {
            difference() {
                rotate([90, 0, 0]) cylinder(thickness + 0.01, 15, 15, center=true);
                rotate([0, 45, 0])
                for (r = [0 : slats]) {
                    for (c = [0 : slats]) {
                        translate([r*(30 - thickness)/slats - 15 - thickness / 2, 0, -15]) {
                            cube([thickness / 2, thickness, 30]);
                        }
                    }
                }
                rotate([0, -45, 0])
                for (r = [0 : slats]) {
                    for (c = [0 : slats]) {
                        translate([r*(30 - thickness)/slats - 15 - thickness / 2, 0, -15]) {
                            cube([thickness / 2, thickness, 30]);
                        }
                    }
                }
                rotate([90, 0, 0]) cylinder(thickness + 0.02, 17.5/2, 17.5/2, center=true);
            }
            // Screw holes
            rotate([90, 0, 0]) translate([-15 + 1.5 + 1.25, -15 + 1.5 + 1.25, -10]) cylinder(30, 1.25, 1.25, $fn = q); // Bottom left
            rotate([90, 0, 0]) translate([ 15 - 1.5 - 1.25, -15 + 1.5 + 1.25, -10]) cylinder(30, 1.25, 1.25, $fn = q); // Bottom right
        }
        
        // Side air vents
        for (r = [-1 : 1]) {
            for (c = [-3 : 3]) {
                color("red")
                translate([mainsize.x / 2, 0, mainsize.z / 2]) {
                    translate([c*((mainsize.x - thickness/2 - (10)) / 7), thickness/2/2 - 0.01, r*((mainsize.z - thickness/2 - (26)) / 3)])
                    rotate([90, 0, 00])
                    cylinder(thickness/2 + 0.05, 1.5 + 0.10*(abs(c) + abs(r)), 1.5 + 0.10*(abs(c) + abs(r)), center=true);
                }
            }
        }

        if (enable_clipjoints)
        color("red") rotate([180, 0, 0]) translate([0, -mainsize.y, -thickness/2 -mainsize.z]) {
            translate([mainsize.x / 2 - 10/2, 0, thickness/2]) {
                // Note: intentionally offset slightly closer for looser tolerances
                translate([38, thickness/2, 0]) clipjoint_divot(10, thickness); // Front right
                translate([-38, thickness/2, 0]) clipjoint_divot(10, thickness); // Front left
                translate([10, mainsize.y - thickness/2, 0]) rotate([0, 0, 180]) clipjoint_divot(10, thickness); // Back middle
            }
        }
    }
    
    // Visualisation of the fan
    if ($preview && enable_fan)
    color("orange", 0.25) translate([mainsize.x / 2, mainsize.y - thickness/2 - 7.3/2, 35])
    difference() {
        roundedcube([30, 7.3, 30], radius=1.5, apply_to="y", center=true);
        rotate([90, 0, 0]) {
            translate([-15 + 1.5 + 1.25,  15 - 1.5 - 1.25, -10]) cylinder(30, 1.25, 1.25, $fn = q); // Top left
            translate([ 15 - 1.5 - 1.25,  15 - 1.5 - 1.25, -10]) cylinder(30, 1.25, 1.25, $fn = q); // Top right
            translate([-15 + 1.5 + 1.25, -15 + 1.5 + 1.25, -10]) cylinder(30, 1.25, 1.25, $fn = q); // Bottom left
            translate([ 15 - 1.5 - 1.25, -15 + 1.5 + 1.25, -10]) cylinder(30, 1.25, 1.25, $fn = q); // Bottom right
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
     
    if (enable_dovetail) {
        color("cyan") translate([mainsize.x / 2 - 10/2, -0.01, mainsize.z]) {
            translate([-30, 0, 0]) cube([10, thickness / 2 + 0.01, thickness / 2 + 0.02]);
            translate([-10, 0, 0]) cube([10, thickness / 2 + 0.01, thickness / 2 + 0.02]);
            translate([10, 0, 0]) cube([10, thickness / 2 + 0.01, thickness / 2 + 0.02]);
            translate([30, 0, 0]) cube([10, thickness / 2 + 0.01, thickness / 2 + 0.02]);
        }
        color("cyan") translate([mainsize.x / 2 - 10/2, mainsize.y - thickness/2 + 0.01, mainsize.z]) {
            translate([-20, 0, 0]) cube([10, thickness / 2 + 0.01, thickness / 2 + 0.02]);
            translate([20, 0, 0]) cube([10, thickness / 2 + 0.01, thickness / 2 + 0.02]);
            cube([10, thickness / 2 + 0.01, thickness / 2 + 0.02]);
        }
    }
    
    if (enable_braces) color("olive") union() {
        // Left side
        translate([-thickness/2, mainsize.y/2 - 3/2 + 24, 0]) cube([thickness/2, 3, mainsize.z]);
        translate([-thickness/2, mainsize.y/2 - 3/2 + 16, 0]) cube([thickness/2, 3, mainsize.z]);
        translate([-thickness/2, mainsize.y/2 - 3/2 + 8,  0]) cube([thickness/2, 3, mainsize.z]);
        translate([-thickness/2, mainsize.y/2 - 3/2    ,  0]) cube([thickness/2, 3, mainsize.z]);
        translate([-thickness/2, mainsize.y/2 - 3/2 - 8,  0]) cube([thickness/2, 3, mainsize.z]);
        translate([-thickness/2, mainsize.y/2 - 3/2 - 16, 0]) cube([thickness/2, 3, mainsize.z]);
        translate([-thickness/2, mainsize.y/2 - 3/2 - 24, 0]) cube([thickness/2, 3, mainsize.z]);
        // Right side
        translate([mainsize.x, mainsize.y/2 - 3/2 + 24, 0]) cube([thickness/2, 3, mainsize.z]);
        translate([mainsize.x, mainsize.y/2 - 3/2 + 16, 0]) cube([thickness/2, 3, mainsize.z]);
        translate([mainsize.x, mainsize.y/2 - 3/2 + 8,  0]) cube([thickness/2, 3, mainsize.z]);
        translate([mainsize.x, mainsize.y/2 - 3/2    ,  0]) cube([thickness/2, 3, mainsize.z]);
        translate([mainsize.x, mainsize.y/2 - 3/2 - 8,  0]) cube([thickness/2, 3, mainsize.z]);
        translate([mainsize.x, mainsize.y/2 - 3/2 - 16, 0]) cube([thickness/2, 3, mainsize.z]);
        translate([mainsize.x, mainsize.y/2 - 3/2 - 24, 0]) cube([thickness/2, 3, mainsize.z]);
        // TODO Back and front sides, reduce quantity for left and right sides?
    }

    // Posts which the board will rest on without using screws
    translate([thickness / 2, thickness / 2, thickness / 2]) {
        // 2.8mm added to x for SD card clearance
        // 2.3mm added to y for audio jack clearance
        // 3.5mm distance of holes from edge of board
        // Posts are back because they do add some stability to the RPi, might remove them again
        translate([3.5 + 2.8,        3.5 + 2.3,        0]) post(); // bottom left
        translate([3.5 + 2.8 + 58.0, 3.5 + 2.3,        0]) post(); // bottom right
        translate([3.5 + 2.8,        3.5 + 2.3 + 49.0, 0]) post(); // top left
        translate([3.5 + 2.8 + 58.0, 3.5 + 2.3 + 49.0, 0]) post(); // top right
    }
}
