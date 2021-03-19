thickness = 3;
cameraPostHeight=40;

//mainsize = [101.0 + thickness, 58.5 + thickness, 19.5 + thickness];
// 23mm added for RPi board clearance. Technically correct solution would be cameraPostHeight plus sqrt(b^2+c^2) minus intersection of the camera mount but that would be a hassle
mainsize = [101.0 + thickness, 58.5 + thickness, cameraPostHeight + thickness + 23];
camerasize = [23.8, 25.5, thickness];

q = $preview ? 8 : 256;
$fs = $preview ? 1 : 0.01;

txtversion = "R13";
preview_cut = false;

enable_camerapost = true;
enable_fins = true;
enable_frictionjoints = false;
enable_dovetail = false;
enable_clipjoints = true;
enable_fan = true;
enable_braces = false; // Braces are incomplete and untested

// HDMI0 and HDMI1 are labelled on the RPi board
enable_hdmi0 = true;
enable_hdmi1 = false;


assert(mainsize.x - thickness >= 101.0 && mainsize.y - thickness >= 58.5 && mainsize.z - thickness >= 19.5, "Too thick");
