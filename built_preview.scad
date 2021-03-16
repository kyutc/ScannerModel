include <mainbody.scad>
include <capper.scad>

module built_preview() {
    mainbody();
    // TODO: A less unfortunate way to accomplish this task
    rotate([180, 0, 0])
    //translate([-mainsize.x, 0, -thickness/2 - mainsize.z])
    translate([0, -mainsize.y, -thickness/2 -mainsize.z])
    capper();
}

module print_layout() {
    // Do not recommend printing both parts at once, only meant for viewing
    mainbody();
    translate([0, mainsize.y + 15, 0]) capper();
}

//built_preview();
//print_layout();

//mainbody();
capper();
