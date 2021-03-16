thickness = 3;
cameraPostHeight=40;

//mainsize = [101.0 + thickness, 58.5 + thickness, 19.5 + thickness];
// 20mm added for RPi board clearance. Technically correct solution would be cameraPostHeight plus sqrt(b^2+c^2) minus intersection of the camera mount but that would be a hassle
mainsize = [101.0 + thickness, 58.5 + thickness, cameraPostHeight + thickness + 20];
camerasize = [23.8, 25.5, thickness];
q = 8; // render quality, low for preview high for render
$fs = 1; // low for high quality, high for low quality

txtversion = "R10";
preview_cut = true;

enable_camerapost = true;
enable_fins = true;
enable_frictionjoints = true;

assert(mainsize.x - thickness >= 101.0 && mainsize.y - thickness >= 58.5 && mainsize.z - thickness >= 19.5, "Too thick");
