// Calder-Style Balance Mobile — Kinetic Ceiling Sculpture
// Hanging arcs balance and rotate with air currents
// PETG (light, flexible) — 0.15mm, 2 walls, 10% infill
// Print flat, assemble with monofilament line
// DUAL COLOR: main arms (black) + balance weights (accent)

WIRE_D    = 3.0;    // Arm rod diameter
WIRE_T    = 2.5;    // Arm thickness (flat)
BALL_D    = 22;
PIVOT_D   = 4.5;
PIVOT_H   = 8;
FISH_HOLE = 1.5;    // Monofilament hole

// ── Single arm ───────────────────────────────────────
module arm(length, taper = 0.7) {
    hull() {
        cylinder(d = WIRE_D, h = WIRE_T, $fn = 12);
        translate([length, 0, 0])
            cylinder(d = WIRE_D * taper, h = WIRE_T, $fn = 10);
    }
    // Pivot loop at root
    translate([0, 0, WIRE_T/2])
        difference() {
            cylinder(d = PIVOT_D + 2, h = PIVOT_H, $fn = 16);
            cylinder(d = PIVOT_D, h = PIVOT_H + 1, $fn = 16);
            translate([0, 0, PIVOT_H - 2])
                cube([PIVOT_D + 3, PIVOT_D + 3, 3], center = true);
        }
    // End eye for hanging weight/arm
    translate([length, 0, WIRE_T/2])
        difference() {
            cylinder(d = PIVOT_D, h = PIVOT_H * 0.7, $fn = 16);
            cylinder(d = FISH_HOLE * 2, h = PIVOT_H, $fn = 12);
        }
}

// ── Teardrop weight (Color 2) ─────────────────────────
module teardrop_weight(d, h_offset) {
    translate([0, 0, h_offset])
    difference() {
        union() {
            sphere(d = d, $fn = 24);
            translate([0, 0, -d/2])
                cylinder(d1 = 0, d2 = d * 0.6, h = d * 0.4, $fn = 20);
        }
        // Suspension hole
        translate([0, 0, d/2 - 5])
            cylinder(d = FISH_HOLE * 2, h = 8, $fn = 10);
    }
}

// ── Spiral weight ─────────────────────────────────────
module spiral_weight(d) {
    difference() {
        union() {
            for (i = [0:11])
                rotate([0, 0, i * 30])
                    translate([d/2 * 0.35, 0, i * 2])
                        sphere(d = d * 0.35, $fn = 14);
        }
        // Center hole
        cylinder(d = FISH_HOLE * 2, h = 30, center = true, $fn = 10);
    }
}

// ── Mobile layout (print flat for assembly) ──────────
// Tier 1: main horizontal arm
translate([0, 0, 0]) arm(160);
// Tier 2 arms
translate([20, 30, 0])  arm(110, 0.65);
translate([130, 40, 0]) arm(90, 0.65);
// Tier 3 arms
translate([20, 80, 0])  arm(70, 0.5);
translate([90, 80, 0])  arm(60, 0.5);

// Color 2: weights
translate([200, 0, 0]) {
    teardrop_weight(BALL_D, 0);
    translate([30, 0, 0]) teardrop_weight(BALL_D * 0.75, 0);
    translate([60, 0, 0]) teardrop_weight(BALL_D * 0.9, 0);
    translate([90, 0, 0]) spiral_weight(BALL_D * 0.8);
    translate([120, 0, 0]) teardrop_weight(BALL_D * 0.6, 0);
    translate([150, 0, 0]) spiral_weight(BALL_D);
    translate([180, 0, 0]) teardrop_weight(BALL_D * 1.1, 0);
}
