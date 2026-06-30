// Kaleidoscope — Classic Optical Toy with Rotating Pattern Wheel
// Equilateral mirror triangle creates infinite reflections
// DUAL COLOR: body (dark) | eyepiece + end cap (brass/gold)
// PLA — 0.2mm, 4 walls, 15% infill
// Hardware: 3x craft mirror strips (14x120mm), mylar film, beads/sequins

BODY_L    = 160;  // Total tube length
BODY_ID   = 40;   // Inner tube diameter
BODY_OD   = 46;
MIRROR_W  = 13.5; // Mirror strip width (equilateral triangle inscribed)
MIRROR_T  = 1.2;  // Mirror thickness (craft mirror)
EYE_D     = 8;    // Eyehole diameter
WHEEL_D   = BODY_OD + 8; // Pattern wheel diameter
WHEEL_T   = 6;
BEAD_H    = 14;   // Bead chamber depth
WALL      = 3.0;

// ── Main tube body ────────────────────────────────────
module tube_body() {
    difference() {
        cylinder(d = BODY_OD, h = BODY_L, $fn = 40);
        // Inner bore
        translate([0, 0, -1])
            cylinder(d = BODY_ID, h = BODY_L + 2, $fn = 36);
        // Mirror channel grooves (3 channels at 120°)
        for (i = [0:2])
            rotate([0, 0, i * 120])
                translate([MIRROR_W/2 - MIRROR_T/2, -1, -1])
                    cube([MIRROR_T + 0.2, BODY_OD, BODY_L + 2]);
        // Grip knurling (outer)
        for (i = [0:23])
            rotate([0, 0, i * 15])
                translate([BODY_OD/2 - 0.8, -1, BODY_L * 0.3])
                    cube([1.2, 2, BODY_L * 0.4]);
    }
}

// ── Eyepiece end cap (Color 2 — brass) ────────────────
module eyepiece() {
    difference() {
        union() {
            cylinder(d = BODY_OD + 4, h = 14, $fn = 36);
            // Decorative ring
            translate([0, 0, 10])
                difference() {
                    cylinder(d = BODY_OD + 10, h = 4, $fn = 36);
                    cylinder(d = BODY_OD + 4, h = 5, $fn = 36);
                }
        }
        // Bore (fits over tube)
        translate([0, 0, -1])
            cylinder(d = BODY_OD + 0.4, h = 12, $fn = 36);
        // Eye hole
        translate([0, 0, 10])
            cylinder(d = EYE_D, h = 5, $fn = 20);
        // Stepped eye recess (eyecup)
        translate([0, 0, 7])
            cylinder(d = EYE_D + 8, h = 8, $fn = 20);
    }
    // Decorative ribs
    for (i = [0:7])
        rotate([0, 0, i * 45])
            translate([BODY_OD/2 + 3, -1, 0])
                cube([2, 2, 10]);
}

// ── Object cell / bead chamber (spinning end) ─────────
module bead_chamber() {
    difference() {
        union() {
            // Chamber body
            cylinder(d = BODY_OD + 4, h = BEAD_H, $fn = 36);
            // Lens retainer ring
            translate([0, 0, BEAD_H])
                cylinder(d1 = BODY_OD + 4, d2 = BODY_OD + 8, h = 4, $fn = 36);
        }
        // Interior cavity (holds beads/sequins)
        translate([0, 0, 2])
            cylinder(d = BODY_ID + 2, h = BEAD_H, $fn = 32);
        // Translucent window seat (for mylar/acetate)
        translate([0, 0, -0.5])
            cylinder(d = BODY_ID - 4, h = 3, $fn = 32);
        // Tube socket
        cylinder(d = BODY_OD + 0.4, h = 6, $fn = 36);
    }
}

// ── Rotating pattern wheel (creates different designs) ─
module pattern_wheel() {
    difference() {
        cylinder(d = WHEEL_D, h = WHEEL_T, $fn = 40);
        // Center hole (fits on tube end)
        cylinder(d = BODY_OD + 0.5, h = WHEEL_T + 1, $fn = 32);
        // Pattern cutouts (geometric — light passes through)
        for (i = [0:5]) {
            rotate([0, 0, i * 60])
                translate([BODY_ID/2 + 4, 0, -1])
                    cylinder(d = 8, h = WHEEL_T + 2, $fn = 8);
            rotate([0, 0, i * 60 + 30])
                translate([BODY_ID/2 + 9, 0, -1])
                    cylinder(d = 5, h = WHEEL_T + 2, $fn = 6);
        }
        // Grip knurling (outer rim)
        for (i = [0:15])
            rotate([0, 0, i * 22.5])
                translate([WHEEL_D/2 - 1, -1, -1])
                    cube([2, 2, WHEEL_T + 2]);
    }
}

// ── Mirror triangle insert (print to guide placement) ─
module mirror_guide() {
    // Equilateral triangle guide — place real mirrors in slots
    difference() {
        cylinder(d = BODY_ID - 0.5, h = BODY_L - 20, $fn = 3);
        cylinder(d = BODY_ID - WALL*2, h = BODY_L, $fn = 3);
    }
}

// Print layout
tube_body();
translate([0, BODY_OD + 10, 0]) eyepiece();
translate([0, BODY_OD + 40, 0]) bead_chamber();
translate([BODY_OD + 20, 0, 0]) pattern_wheel();
translate([BODY_OD + 60, 0, 0]) mirror_guide();
