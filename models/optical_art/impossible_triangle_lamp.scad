// Penrose Impossible Triangle — Lamp / Night Light
// Optical illusion: each corner looks like a solid 90° join
// Light shines through the gap at the trick corner
// DUAL COLOR: frame (opaque dark) + light diffuser panel (translucent PETG)
// P2S: 0.2mm, 3 walls, 10% infill
// Base holds E14 LED bulb or tea light

SIDE_L   = 160;    // Triangle side length
BEAM_W   = 28;     // Beam cross-section width
BEAM_H   = 28;
WALL     = 3.5;
GAP      = 1.2;    // Trick gap at impossible corner
PANEL_T  = 2.0;    // Diffuser panel thickness

// ── One beam segment ──────────────────────────────────
module beam(length) {
    difference() {
        cube([length, BEAM_W, BEAM_H]);
        // Hollow core (diffuser window channel)
        translate([WALL, WALL, WALL])
            cube([length - WALL, BEAM_W - WALL*2, BEAM_H - WALL*2]);
    }
}

// ── Corner joint (solid) ──────────────────────────────
module corner_joint() {
    cube([BEAM_W, BEAM_W, BEAM_H]);
}

// ── Diffuser panel (fits inside beam hollow) ──────────
module diffuser(length) {
    translate([WALL, WALL, WALL])
        cube([length - WALL, BEAM_W - WALL*2, PANEL_T]);
}

// ── Impossible triangle assembly ─────────────────────
module impossible_triangle() {
    // The trick: one corner has a step that creates the illusion
    // Bottom beam
    beam(SIDE_L);
    // Right beam (angled 60°)
    translate([SIDE_L, 0, 0])
        corner_joint();
    translate([SIDE_L, 0, 0])
        rotate([0, 0, 60])
            beam(SIDE_L - BEAM_W);
    // Left return (creates illusion at top-left)
    rotate([0, 0, 120])
        translate([BEAM_W, 0, 0])
            beam(SIDE_L - BEAM_W * 2);
    // Trick corner: offset step creates impossible join
    translate([SIDE_L * cos(60) * 0.5, SIDE_L * sin(60) - BEAM_W, 0]) {
        // Normal-view corner
        corner_joint();
        // Hidden step (only visible from behind)
        translate([BEAM_W, 0, GAP])
            cube([GAP * 3, BEAM_W, BEAM_H - GAP]);
    }
}

// ── Base for standing display ─────────────────────────
module base() {
    translate([-10, -25, -20]) {
        difference() {
            hull() {
                cube([SIDE_L + 20, 30, 20]);
                translate([10, 5, 20])
                    cube([SIDE_L, 20, 1]);
            }
            // Bulb cavity (tea light, 40mm dia)
            translate([SIDE_L/2, 15, -1])
                cylinder(d = 42, h = 12, $fn = 32);
            // Cable exit slot
            translate([SIDE_L/2 - 5, -1, 6])
                cube([10, 8, 15]);
        }
    }
}

// Color 1: frame
impossible_triangle();
base();
// Color 2: diffuser panels (translucent PETG — print separately)
translate([0, BEAM_W + 30, 0]) {
    diffuser(SIDE_L);
    translate([0, 10, 0]) diffuser(SIDE_L - BEAM_W);
    translate([0, 20, 0]) diffuser(SIDE_L - BEAM_W * 2);
}
