// Auxetic Cuff Bracelet — Negative Poisson Ratio Metamaterial
// Stretches when pulled, contracts when compressed — magical feel
// TPU 95A or flexible PLA — 0.15mm, 2 walls, 0% infill
// DUAL COLOR: cuff base (skin tone) + auxetic pattern (contrast)
// Print flat, flex onto wrist — adjustable by pulling ends

WRIST_C  = 170;   // Wrist circumference (mm) — adjust per size
CUFF_W   = 35;    // Cuff width
CUFF_T   = 3.0;   // Cuff thickness
UNIT     = 12;    // Auxetic cell unit size
GAP      = 1.6;   // Cut gap (determines stretch range)
WALL     = 1.4;   // Cell wall thickness
CLASP_L  = 25;    // Snap clasp length
CLASP_T  = 4.5;

// ── Auxetic re-entrant honeycomb cell ─────────────────
module auxetic_cell(u, g, w) {
    // Re-entrant hexagon — the key shape
    // Arms angle inward (negative) at θ=30°
    theta = 30;
    arm_l = u * 0.45;
    v_h   = u * 0.55;

    difference() {
        square([u, u], center = true);
        // Re-entrant hexagon cutout
        polygon([
            [-u/2 + w,     0],
            [-u/2 + w + arm_l * cos(theta),  arm_l * sin(theta)],
            [u/2 - w - arm_l * cos(theta),   arm_l * sin(theta)],
            [u/2 - w,      0],
            [u/2 - w - arm_l * cos(theta),  -arm_l * sin(theta)],
            [-u/2 + w + arm_l * cos(theta), -arm_l * sin(theta)],
        ]);
    }
}

// ── Cuff body (flat print, wrap onto wrist) ───────────
FLAT_L = WRIST_C - CLASP_L * 2;  // Flat span
COLS   = floor(FLAT_L / UNIT);
ROWS   = floor(CUFF_W / UNIT);

module cuff_flat() {
    difference() {
        // Base rectangle
        cube([FLAT_L, CUFF_W, CUFF_T]);
        // Auxetic pattern cutouts
        for (col = [0 : COLS - 1], row = [0 : ROWS - 1])
            translate([col * UNIT + UNIT/2, row * UNIT + UNIT/2, -0.1])
                linear_extrude(CUFF_T + 0.2)
                    auxetic_cell(UNIT, GAP, WALL);
    }
    // Rounded ends
    for (x = [0, FLAT_L])
        translate([x, CUFF_W/2, CUFF_T/2])
            rotate([0, 90, 0])
                cylinder(d = CUFF_W, h = 0.1, $fn = 32);
}

// ── Snap clasp (each end) ─────────────────────────────
module clasp_male() {
    // T-snap — press fit
    difference() {
        cube([CLASP_L, CUFF_W, CLASP_T]);
        // Slot for female counterpart
        translate([CLASP_L - 6, CUFF_W * 0.2, -1])
            cube([5, CUFF_W * 0.6, CLASP_T + 2]);
    }
    // Snap nub
    translate([CLASP_L - 3, CUFF_W/2, CLASP_T])
        cylinder(d = 4, h = 2.5, $fn = 16);
}

module clasp_female() {
    difference() {
        cube([CLASP_L, CUFF_W, CLASP_T]);
        // Nub hole
        translate([3, CUFF_W/2, CLASP_T - 1.5])
            cylinder(d = 4.3, h = 3, $fn = 16);
        // Slot
        translate([5, CUFF_W * 0.2, -1])
            cube([5, CUFF_W * 0.6, CLASP_T + 2]);
    }
}

// Color 1: cuff body
cuff_flat();
// Color 2: auxetic overlay (print as separate layer in BambuStudio → assign AMS 2)
// (In practice: the cutouts expose the bed color OR use pause-at-layer for 2-color)

// Clasps (same color as body)
translate([-CLASP_L - 2, 0, 0]) clasp_male();
translate([FLAT_L + 2, 0, 0])   clasp_female();
