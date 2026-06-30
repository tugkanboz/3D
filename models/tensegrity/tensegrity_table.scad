// Tensegrity Floating Table — Desk Centerpiece / Mind-Bender
// The top platform appears to float — held by tension cables only
// DUAL COLOR: platform + feet (dark) | connector nodes (accent)
// Hardware: 4x ~200mm fishing line or thin steel cable
// PLA — 0.2mm, 4 walls, 20% infill
// The PHYSICS: compression struts push apart; tension strings pull together

PLAT_W   = 120;   // Top platform width
PLAT_D   = 90;
PLAT_H   = 8;
BASE_W   = 100;
BASE_D   = 70;
BASE_H   = 6;
LEG_H    = 130;   // Strut (compression leg) length
LEG_D    = 10;
NODE_D   = 18;
HOLE_D   = 2.2;   // Cable hole (string through)
STRUT_T  = 6;
LEAN     = 25;    // Strut lean angle from vertical
R        = 8;     // Corner radius

// ── Platform ─────────────────────────────────────────
module platform() {
    difference() {
        minkowski() {
            cube([PLAT_W - R*2, PLAT_D - R*2, PLAT_H - R]);
            translate([R, R, R]) cylinder(r = R, h = 1, $fn = 24);
        }
        // 4 cable holes (corners)
        for (x = [PLAT_W * 0.18, PLAT_W * 0.82],
             y = [PLAT_D * 0.18, PLAT_D * 0.82])
            translate([x, y, -1])
                cylinder(d = HOLE_D, h = PLAT_H + 2, $fn = 12);
    }
}

// ── Base ─────────────────────────────────────────────
module base() {
    difference() {
        minkowski() {
            cube([BASE_W - R*2, BASE_D - R*2, BASE_H - R]);
            translate([R, R, R]) cylinder(r = R, h = 1, $fn = 24);
        }
        // 4 cable holes (corners — offset from platform corners)
        for (x = [BASE_W * 0.82, BASE_W * 0.18],
             y = [BASE_D * 0.18, BASE_D * 0.82])
            translate([x, y, -1])
                cylinder(d = HOLE_D, h = BASE_H + 2, $fn = 12);
    }
}

// ── Compression struts (3 legs, angled outward) ───────
module strut() {
    // Strut rod
    cylinder(d = LEG_D, h = LEG_H, $fn = 16);
    // End nodes (cable attachment points)
    for (z = [0, LEG_H])
        translate([0, 0, z])
            difference() {
                sphere(d = NODE_D, $fn = 20);
                // 2 cable holes through node (perpendicular)
                for (a = [0, 90])
                    rotate([0, 0, a])
                        cylinder(d = HOLE_D, h = NODE_D + 1, center = true, $fn = 10);
            }
}

// ── Print layout ─────────────────────────────────────
// Platform (print upside down — flat face on bed)
translate([(BASE_W - PLAT_W)/2, (BASE_D - PLAT_D)/2, LEG_H + BASE_H + 20])
    platform();

// Base (on bed)
base();

// 3 Struts (print separately — they're round, print vertically)
// In Bambu Studio: place vertically, supports not needed
for (i = [0:2])
    translate([BASE_W + 20 + i * (LEG_D + 10), 0, 0])
        strut();
