thickness = 3;
//mainsize = [101.0 + thickness, 58.5 + thickness, 19.5 + thickness];
mainsize = [101.0 + thickness, 58.5 + thickness, 19.5 + 30 + thickness];
camerasize = [23.8, 25.5, thickness];
q = 8; // render quality, low for preview high for render
$fs = 1; // low for high quality, high for low quality

txtversion = "R6";
preview_cut = true;
    
assert(mainsize.x - thickness >= 101.0 && mainsize.y - thickness >= 58.5 && mainsize.z - thickness >= 19.5, "Too thick");
