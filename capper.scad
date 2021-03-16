include <variables.scad>
use <inc.scad>

// Can add ~0.25-0.5mm to adjust for accuracy, however thickness must be increased otherwise the prism will easily fall through
prismhole=[30.2, 30.4, 30.2];

// Note: this model is upside down
module capper() {
    // Slot for gravity hold of prism
    module prism() difference() {
        color ("red") union() {
            translate([mainsize.x / 2, mainsize.y / 2, 0])
            rotate([0, 45, 0])
            cube(prismhole, center=true);
        }
    }

    difference() {
        // Top cover
        color("yellow") cube([mainsize.x, mainsize.y, thickness / 2]);
        prism();
    }
    
    // Add "fins" to the prism hole to ensure it stays put with a looser fit
    if (enable_fins)
    difference() {
        union() {
            color("cyan")
            // TODO: This 0.5mm relates to a thickness of 3mm and needs to not be hardcoded
            translate([mainsize.x / 2 - sqrt(pow(prismhole.x, 2)+pow(prismhole.y, 2))/2 + 0.5, mainsize.y / 2, thickness / 2])
            rotate([0, 45, 0])
            cube([thickness / 2, prismhole.y, 10], center=true);
            
            color("cyan")
            translate([mainsize.x / 2 + sqrt(pow(prismhole.x, 2)+pow(prismhole.y, 2))/2 - 0.5, mainsize.y / 2, thickness / 2])
            rotate([0, -45, 0])
            cube([thickness / 2, prismhole.y, 10], center=true);
        }
        color("orange", 0.25) translate([0, 0, -500.01]) cube(500); // Remove excess from bottom
        color("cyan") translate([0, 0, thickness / 2 + 3]) cube(500); // Trim the tops of the fins to be flat on the XY plane
    }
    
    // The camera post
    //translate([mainsize.x / 2 - sqrt(pow(30, 2)*2), mainsize.y / 2, cameraPostHeight / 2 + thickness / 2])
    if (enable_camerapost)
    translate([thickness / 2 + (thickness * 3) / 2, mainsize.y / 2, cameraPostHeight / 2 + thickness / 2])
    // TODO: Make the inner difference model lock-step with the cutout from the model below
    difference() {
        cube([thickness * 3, camerasize.y + thickness, cameraPostHeight], center=true);        
        translate([3, 0, cameraPostHeight / 2 + 4]) rotate([0, 45, 0]) {
            union() color("red") {
                // Inner cutout for camera module into the camera post itself
                cube([3.8, camerasize.y, 10*camerasize.x + 0.01], center=true);
                // May affect sturctucal integrity, and shouldn't be necessary
                translate([thickness, 0, 0]) cube([thickness * 2, 9.5, 10*camerasize.x + 0.01], center=true);
            }
        }
    }

    if (enable_camerapost)
    color("yellow")
    //translate([mainsize.x / 2 - sqrt(pow(30, 2)*2) + 15 / 2, mainsize.y / 2, cameraPostHeight + thickness / 2])
    difference() {
        translate([thickness / 2 + (thickness * 3) / 2 + 3, mainsize.y / 2, cameraPostHeight + thickness / 2 + 4])
        rotate([0, 45, 0])
        difference() {
            // Outer shell for camera module
            cube([thickness * 3, camerasize.y + thickness, camerasize.x], center=true);
            union() color("red") {
                // Inner cutout for camera module to fit inside
                // ~3.6mm Z height of board plus ribbon cable mount
                cube([3.8, camerasize.y, camerasize.x + 0.01], center=true);
                translate([thickness, 0, 0]) cube([thickness * 2, 9.5, camerasize.x + 0.01], center=true);
            }
        }
        // Trim the back off to make it fit
        color("orange", 0.25) rotate([0, 0, 0]) translate([-500.01 + thickness / 2, 0, thickness / 2]) cube(500);
    }

    // Version
    color("brown") translate([mainsize.x - thickness / 2 - 18, mainsize.y - thickness / 2 - 26, thickness / 2])
    linear_extrude(1) {
        text(txtversion, 8, "Bahnschrift");
    }
    
    // Friction joints. Uses the "flex" of PLA to create a friction joint. PETG would also work and have greater strength and allow larger overhang values
    if (enable_frictionjoints)
    color("cyan") translate([0, 0, thickness / 2]) {
        translate([thickness/2,              thickness/2,              0])                     frictionjoint(5, 5, 0.01); // Bottom left
        translate([mainsize.x - thickness/2, thickness/2,              0]) rotate([0, 0, 90])  frictionjoint(5, 5, 0.01); // Bottom right
        translate([mainsize.x - thickness/2, mainsize.y - thickness/2, 0]) rotate([0, 0, 180]) frictionjoint(5, 5, 0.01); // Top right
        translate([thickness/2,              mainsize.y - thickness/2, 0]) rotate([0, 0, 270]) frictionjoint(5, 5, 0.01); // Top left
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