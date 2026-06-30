// Monitor-Mount Headphone Hanger
// Clips over monitor top edge — no screws, no damage
// PLA/PETG — 0.2mm, 4 walls, 20% infill
// Fits monitors 15-30mm thick (parametric)

MONITOR_T  = 22;   // Monitor top edge thickness — adjust!
CLIP_DEPTH = 40;   // How far clip wraps over top
HANGER_L   = 120;
HANGER_D   = 28;
HOOK_D     = 32;
HOOK_T     = 5.0;
WALL_T     = 3.5;
TPU_PAD    = false; // Set true to add pad cutout for TPU insert

module clip() {
    difference() {
        union() {
            // Front jaw
            cube([HANGER_D + WALL_T*2, WALL_T * 2, CLIP_DEPTH]);
            // Back jaw
            translate([0, MONITOR_T + WALL_T * 2, 0])
                cube([HANGER_D + WALL_T*2, WALL_T * 2, CLIP_DEPTH * 0.6]);
            // Top bridge
            translate([0, 0, CLIP_DEPTH - WALL_T])
                cube([HANGER_D + WALL_T*2, MONITOR_T + WALL_T * 4, WALL_T]);
            // Hanger arm
            translate([0, -HANGER_L + WALL_T, 0])
                cube([HANGER_D + WALL_T*2, HANGER_L, WALL_T * 2]);
        }
        // Friction pad slots (for rubber pads or TPU inserts)
        if (TPU_PAD) {
            translate([2, -1, 4])
                cube([HANGER_D + WALL_T*2 - 4, 3, CLIP_DEPTH - 8]);
            translate([2, MONITOR_T + WALL_T * 2 + 1, 4])
                cube([HANGER_D + WALL_T*2 - 4, 3, CLIP_DEPTH * 0.6 - 8]);
        }
    }
}

module hook() {
    translate([WALL_T, -HANGER_L + WALL_T, 0])
    rotate([90, 0, 90])
    difference() {
        union() {
            cylinder(d = HOOK_D, h = HOOK_T, $fn = 40);
            translate([-HOOK_D/2, -HOOK_D, 0])
                cube([HOOK_D, HOOK_D, HOOK_T]);
        }
        translate([0, 0, -1])
            cylinder(d = HOOK_D - HOOK_T*2, h = HOOK_T + 2, $fn = 40);
        translate([-HOOK_D/2, -HOOK_D - 1, -1])
            cube([HOOK_D, HOOK_D * 0.6, HOOK_T + 2]);
    }
}

clip();
hook();
