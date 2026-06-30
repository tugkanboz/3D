// Penrose P3 Tiling Coaster Set — Mathematically Aperiodic Pattern
// Two tile types (kite + dart) tile the plane without repeating
// DUAL COLOR: kite tiles (light) + dart tiles (dark) — assemble 4 coasters
// PLA — 0.2mm, 3 walls, 15% infill
// Each coaster: ~100mm, fits in a set of 4

PHI   = 1.6180339887;  // Golden ratio
UNIT  = 30;            // Edge length
THICK = 4.0;
BUMP  = 0.8;           // Anti-slip ring height
CORK  = false;         // If true, add cork-texture bottom

// ── Kite tile (fat rhombus, 72/108 angles) ────────────
module kite() {
    // Kite has one long edge (PHI*UNIT) and four short edges (UNIT)
    // Angles: 72° at top/bottom, 108° at sides
    a72  = 36;   // half of 72
    pts = [
        [0,               0],
        [UNIT * cos(a72), UNIT * sin(a72)],
        [UNIT * PHI,      0],
        [UNIT * cos(a72), -UNIT * sin(a72)]
    ];
    difference() {
        linear_extrude(THICK) polygon(pts);
        // Arc marking (Penrose matching rule arc)
        translate([0, 0, THICK - BUMP])
            linear_extrude(BUMP + 0.1)
                difference() {
                    circle(r = UNIT * 0.6, $fn = 40);
                    circle(r = UNIT * 0.6 - 2, $fn = 40);
                    translate([-UNIT * PHI, -UNIT, 0]) square([UNIT * PHI * 2, UNIT]);
                }
        // Anti-slip dimples on bottom
        for (x = [UNIT * 0.3, UNIT * 0.7], y = [-3, 3])
            translate([x, y, -1])
                cylinder(d = 5, h = 2, $fn = 16);
    }
    // Subtle bevel edge
    translate([0, 0, THICK])
        linear_extrude(0.4) offset(r = -0.4) polygon(pts);
}

// ── Dart tile (thin rhombus, 36/144 angles) ───────────
module dart() {
    a36  = 18;
    pts = [
        [0,                    0],
        [UNIT * cos(a36),      UNIT * sin(a36)],
        [UNIT / PHI,           0],
        [UNIT * cos(a36),      -UNIT * sin(a36)]
    ];
    difference() {
        linear_extrude(THICK) polygon(pts);
        // Arc marking
        translate([UNIT / PHI, 0, THICK - BUMP])
            linear_extrude(BUMP + 0.1)
                difference() {
                    circle(r = UNIT * 0.55, $fn = 40);
                    circle(r = UNIT * 0.55 - 2, $fn = 40);
                    translate([-UNIT, 0, 0]) square([UNIT, UNIT]);
                    translate([-UNIT, -UNIT, 0]) square([UNIT, UNIT]);
                }
    }
}

// ── Coaster assembly using P3 sun pattern ─────────────
// Sun pattern: 5 kites radiating from center
module sun_coaster() {
    for (i = [0:4])
        rotate([0, 0, i * 72]) kite();
}

// ── Coaster with star pattern (5 darts) ──────────────
module star_coaster() {
    for (i = [0:4])
        rotate([0, 0, i * 72]) dart();
}

// ── Layout: 2 sun + 2 star coasters ──────────────────
// Color 1: kites (sun coasters)
translate([0, 0, 0])    sun_coaster();
translate([120, 0, 0])  sun_coaster();
// Color 2: darts (star coasters — print with 2nd filament)
translate([0, 120, 0])  star_coaster();
translate([120, 120, 0]) star_coaster();
