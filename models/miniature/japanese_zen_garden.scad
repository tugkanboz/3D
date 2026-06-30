// Japanese Zen Garden — Desktop Miniature
// DUAL COLOR: tray (stone-grey PLA) + raked pattern (sand PLA)
// Includes: raked sand, rock placeholders, mini bridge
// P2S: 0.15mm, 3 walls, 15% infill

TRAY_W   = 200;
TRAY_D   = 140;
TRAY_H   = 18;
WALL_T   = 4.0;
SAND_T   = 3.0;    // Sand layer thickness
RAKE_W   = 1.2;
RAKE_D   = 0.8;
RAKE_SPACING = 5;

// ── Tray (Color 1) ────────────────────────────────────
module tray() {
    difference() {
        // Outer
        hull() {
            cube([TRAY_W, TRAY_D, TRAY_H]);
            translate([4, 4, TRAY_H])
                cube([TRAY_W - 8, TRAY_D - 8, 2]);
        }
        // Inner cavity
        translate([WALL_T, WALL_T, WALL_T])
            cube([TRAY_W - WALL_T*2, TRAY_D - WALL_T*2, TRAY_H]);
        // Drainage holes (4 corners)
        for (x = [TRAY_W*0.2, TRAY_W*0.8], y = [TRAY_D*0.2, TRAY_D*0.8])
            translate([x, y, -1])
                cylinder(d = 5, h = WALL_T + 2, $fn = 16);
    }
    // Feet
    for (x = [15, TRAY_W - 15], y = [15, TRAY_D - 15])
        translate([x, y, -8])
            cylinder(d = 12, h = 8, $fn = 6);
}

// ── Raked sand pattern (Color 2) ──────────────────────
module rake_pattern() {
    // Concentric circles around rock areas
    // Straight lines across center
    translate([WALL_T, WALL_T, WALL_T]) {
        INNER_W = TRAY_W - WALL_T*2;
        INNER_D = TRAY_D - WALL_T*2;
        // Sand base
        cube([INNER_W, INNER_D, SAND_T * 0.4]);
        // Straight rake lines (parallel to X)
        for (i = [0 : floor(INNER_D / RAKE_SPACING)])
            translate([0, i * RAKE_SPACING, SAND_T * 0.4 - RAKE_D])
                cube([INNER_W, RAKE_W, RAKE_D + 0.1]);
        // Circular ripples around rock 1 position
        for (r = [18, 26, 34, 42, 50])
            translate([INNER_W * 0.25, INNER_D * 0.4, SAND_T * 0.4 - RAKE_D])
                difference() {
                    cylinder(r = r, h = RAKE_D + 0.1, $fn = 48);
                    cylinder(r = r - RAKE_W, h = RAKE_D + 0.2, $fn = 48);
                }
        // Circular ripples around rock 2 position
        for (r = [14, 22, 30, 38])
            translate([INNER_W * 0.65, INNER_D * 0.6, SAND_T * 0.4 - RAKE_D])
                difference() {
                    cylinder(r = r, h = RAKE_D + 0.1, $fn = 48);
                    cylinder(r = r - RAKE_W, h = RAKE_D + 0.2, $fn = 48);
                }
    }
}

// ── Rocks ────────────────────────────────────────────
module rock(w, d, h, fn) {
    scale([w, d, h]) sphere(r = 1, $fn = fn);
}

module rocks() {
    ox = WALL_T;
    oy = WALL_T;
    base_z = WALL_T + SAND_T * 0.4;
    // Rock cluster 1
    translate([ox + (TRAY_W - WALL_T*2)*0.25, oy + (TRAY_D - WALL_T*2)*0.4, base_z]) {
        rock(14, 12, 10, 12);
        translate([8, -5, -2]) rock(10, 9, 7, 10);
        translate([-6, 6, -3]) rock(7, 8, 6, 10);
    }
    // Rock cluster 2
    translate([ox + (TRAY_W - WALL_T*2)*0.65, oy + (TRAY_D - WALL_T*2)*0.6, base_z]) {
        rock(11, 10, 9, 12);
        translate([5, -3, -2]) rock(7, 7, 5, 10);
    }
}

// ── Mini arched bridge ────────────────────────────────
module bridge() {
    BW = 16; BD = 50; BH = 12; R = 8;
    translate([TRAY_W*0.5 - BW/2, TRAY_D*0.3, WALL_T + SAND_T * 0.4]) {
        // Deck
        difference() {
            cube([BW, BD, 3]);
            // Arch hole
            translate([3, BD/2 - R, -1])
                cube([BW - 6, R*2, 8]);
        }
        // Arch
        translate([3, BD/2 - R, -1]) {
            difference() {
                cube([BW - 6, R*2, BH]);
                translate([2, -1, -1]) cube([BW - 10, R*2 + 2, BH + 2]);
            }
        }
        // Railings
        for (x = [0.5, BW - 2.5])
            translate([x, 0, 3])
                cube([2, BD, 5]);
    }
}

// Color 1: tray
tray();
// Color 2: sand + rake pattern
rake_pattern();
// Single color: rocks + bridge (use grey/stone PLA)
rocks();
bridge();
