include <variables.scad>
use <inc.scad>

// Note: this model is upside down
module capper() {
    module prism() difference() {
        // Slot for gravity hold of prism
        color ("red") union() {
            translate([mainsize.x / 2, mainsize.y / 2, 0])
            rotate([0, 45, 0])
            cube(30, center=true); // Can add ~0.25-0.5mm to adjust for accuracy, however thickness must be increased otherwise the prism will easily fall through
        }
    }

    difference() {
        // Top cover
        color("yellow") cube([mainsize.x, mainsize.y, thickness / 2]);
        prism();
    }
    
    // The camera post
    cameraPostHeight=30;
    //translate([mainsize.x / 2 - sqrt(pow(30, 2)*2), mainsize.y / 2, cameraPostHeight / 2 + thickness / 2])
    translate([thickness / 2 + (thickness * 3) / 2, mainsize.y / 2, cameraPostHeight / 2 + thickness / 2])
    // TODO: Create difference with inside of camera mount
    cube([thickness * 3, camerasize.y, cameraPostHeight], center=true);        
    
    color("yellow")
    //translate([mainsize.x / 2 - sqrt(pow(30, 2)*2) + 15 / 2, mainsize.y / 2, cameraPostHeight + thickness / 2])
    translate([thickness / 2 + (thickness * 3) / 2 + 8, mainsize.y / 2, cameraPostHeight + thickness / 2])
    rotate([0, 45, 0])
    difference() {
        cube([thickness * 3, camerasize.y, camerasize.x], center=true);
        union() color("red") {
            // ~3.6mm Z height of board plus ribbon cable mount
            cube([3.8, camerasize.y - thickness, camerasize.x + 0.01], center=true);
            translate([thickness, 0, 0]) cube([thickness * 2, 9.5, camerasize.x + 0.01], center=true);
        }
    }

    // Version
    color("brown") translate([mainsize.x - thickness / 2 - 18, mainsize.y - thickness / 2 - 14, thickness / 2])
    linear_extrude(1) {
        text(txtversion, 8, "Bahnschrift");
    }

    // This will not exist in the render
    if ($preview) {
        difference() {
            union() {
                color("orange", 0.25) prism();
                // Measuring stick 30+mm from the face of the prism is required for optimal focus
                color ("red", 0.25) union() {
                    translate([mainsize.x / 2, mainsize.y / 2 , 0])
                    rotate([0, 45, 0])
                    cube([1, 1, 30 + 60], center=true);
                }
                color ("red", 0.25) union() {
                    translate([mainsize.x / 2, mainsize.y / 2 , 0])
                    rotate([0, -45, 0])
                    cube([1, 1, 30 + 60], center=true);
                }
            }
            color("orange", 0.25) translate([0, 0, -500.01]) cube(500);
        }
    }
}