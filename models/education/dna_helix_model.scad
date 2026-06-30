// DNA Double Helix — Educational + Desk Decor
// DUAL COLOR: strand_A (blue) + strand_B (red) + rungs (white)
// P2S AMS: 3 colors, dramatic result
// PLA — 0.15mm, 3 walls, 20% infill

TURNS      = 4;
HEIGHT     = 200;
R_HELIX    = 28;
STRAND_D   = 5.0;
RUNG_D     = 3.5;
STEPS      = 160;
BASE_D     = 55;
BASE_H     = 10;
RUNG_PITCH = 12;    // Distance between base pairs

// ── Strand A (Color 1) ────────────────────────────────
module strand_A() {
    for (i = [0 : STEPS - 1]) {
        t0 = i / STEPS;
        t1 = (i+1) / STEPS;
        a0 = TURNS * 360 * t0;
        a1 = TURNS * 360 * t1;
        z0 = HEIGHT * t0;
        z1 = HEIGHT * t1;
        hull() {
            translate([R_HELIX*cos(a0), R_HELIX*sin(a0), z0])
                sphere(d = STRAND_D, $fn = 12);
            translate([R_HELIX*cos(a1), R_HELIX*sin(a1), z1])
                sphere(d = STRAND_D, $fn = 12);
        }
    }
}

// ── Strand B (Color 2) — offset 180° ─────────────────
module strand_B() {
    for (i = [0 : STEPS - 1]) {
        t0 = i / STEPS;
        t1 = (i+1) / STEPS;
        a0 = TURNS * 360 * t0 + 180;
        a1 = TURNS * 360 * t1 + 180;
        z0 = HEIGHT * t0;
        z1 = HEIGHT * t1;
        hull() {
            translate([R_HELIX*cos(a0), R_HELIX*sin(a0), z0])
                sphere(d = STRAND_D, $fn = 12);
            translate([R_HELIX*cos(a1), R_HELIX*sin(a1), z1])
                sphere(d = STRAND_D, $fn = 12);
        }
    }
}

// ── Rungs / Base pairs (Color 3 — white) ─────────────
module rungs() {
    n_rungs = floor(HEIGHT / RUNG_PITCH);
    for (i = [0 : n_rungs]) {
        z = i * RUNG_PITCH;
        t = z / HEIGHT;
        a = TURNS * 360 * t;
        pa = [R_HELIX*cos(a),     R_HELIX*sin(a),     z];
        pb = [R_HELIX*cos(a+180), R_HELIX*sin(a+180), z];
        hull() {
            translate(pa) sphere(d = RUNG_D * 1.3, $fn = 10);
            translate(pb) sphere(d = RUNG_D * 1.3, $fn = 10);
        }
        // Sugar-phosphate nodes
        translate(pa) sphere(d = STRAND_D * 1.4, $fn = 14);
        translate(pb) sphere(d = STRAND_D * 1.4, $fn = 14);
    }
}

// ── Base ─────────────────────────────────────────────
module base() {
    difference() {
        cylinder(d = BASE_D, h = BASE_H, $fn = 48);
        translate([0, 0, 3])
            cylinder(d = BASE_D - 10, h = BASE_H, $fn = 48);
        // Strand anchor holes
        translate([R_HELIX, 0, -1]) cylinder(d = STRAND_D + 0.4, h = 6, $fn = 16);
        translate([-R_HELIX, 0, -1]) cylinder(d = STRAND_D + 0.4, h = 6, $fn = 16);
    }
}

// ── Print layout (separate files for AMS) ────────────
// For AMS: save each module as separate file and assign colors
base();
translate([0, 0, BASE_H]) {
    strand_A();
    strand_B();
    rungs();
}
