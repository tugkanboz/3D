// Parametric Wall Hook - Minimalist
// Etsy: $4-8 each, often sold in sets of 4
// Print: 0.2mm, 4 walls, 40% infill (needs strength), no supports

HOOK_W       = 40;
HOOK_D       = 50;
HOOK_H       = 6;
HOOK_TIP_H   = 30;
BACKPLATE_H  = 60;
BACKPLATE_W  = 40;
SCREW_D      = 4.5;   // M4 screw hole
SCREW_OFFSET = 10;

module backplate() {
    hull() {
        cube([BACKPLATE_W, HOOK_H, BACKPLATE_H]);
        translate([5, 0, 5])
            cube([BACKPLATE_W - 10, HOOK_H, BACKPLATE_H - 10]);
    }
}

module hook_arm() {
    translate([BACKPLATE_W/2 - HOOK_W/2, 0, 0]) {
        // Horizontal arm
        cube([HOOK_W, HOOK_D, HOOK_H]);
        // Upward tip
        translate([HOOK_W - HOOK_H, HOOK_D - HOOK_H, 0])
            cube([HOOK_H, HOOK_H, HOOK_TIP_H]);
    }
}

difference() {
    union() {
        backplate();
        translate([0, HOOK_H, BACKPLATE_H - HOOK_H - 2]) hook_arm();
    }
    // Screw holes
    for (z = [SCREW_OFFSET, BACKPLATE_H - SCREW_OFFSET])
        translate([BACKPLATE_W/2, -1, z])
            rotate([-90, 0, 0])
                cylinder(d = SCREW_D, h = HOOK_H + 2, $fn = 20);
}
