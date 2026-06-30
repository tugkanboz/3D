// Self-Watering Double-Wall Planter — Wicking Reservoir System
// Inner pot sits in water reservoir; cotton rope wicks water up
// PETG (food-safe-ish, UV resistant, waterproof) — 0.2mm, 4 walls, 0% infill
// DUAL COLOR: outer pot (terracotta PLA) + inner pot (cream/white PETG)
// Hardware: 1x cotton rope (wick), ~30cm length

POT_OD    = 140;   // Outer pot outer diameter
POT_H     = 160;   // Total height
WALL      = 3.5;
LIP_H     = 8;
LIP_OVER  = 8;     // How much inner pot lip overhangs outer
INNER_OD  = POT_OD - WALL*2 - 8;  // Inner pot OD
INNER_H   = POT_H * 0.62;          // Inner pot height
RES_H     = POT_H - INNER_H - LIP_H; // Reservoir height
WICK_D    = 8.0;   // Wick hole diameter
DRAIN_D   = 6.0;
WINDOW_W  = 12;    // Water level window width
TEXTURE_R = 4;     // Outer ribbing radius

// ── Outer reservoir pot ───────────────────────────────
module outer_pot() {
    difference() {
        union() {
            // Body with gentle taper
            cylinder(d1 = POT_OD + 10, d2 = POT_OD, h = POT_H, $fn = 60);
            // Lip flange at top
            translate([0, 0, POT_H])
                cylinder(d = POT_OD + 16, h = LIP_H, $fn = 60);
        }
        // Hollow interior (reservoir bottom up to inner pot seat)
        translate([0, 0, WALL])
            cylinder(d = POT_OD - WALL*2, h = POT_H, $fn = 60);
        // Inner pot seat ring (ledge inside top)
        translate([0, 0, POT_H - 12])
            cylinder(d = INNER_OD + 0.8, h = 14, $fn = 60);
        // Water fill window (side — see water level)
        translate([POT_OD/2 - WALL - 0.5, -WINDOW_W/2, RES_H - 5])
            cube([WALL + 2, WINDOW_W, 30]);
        // Overflow drain hole (prevents overwatering)
        translate([0, POT_OD/2 - 1, RES_H + 5])
            rotate([90, 0, 0])
                cylinder(d = DRAIN_D, h = WALL + 2, $fn = 14);
        // Decorative vertical ribs (exterior)
        for (i = [0:11])
            rotate([0, 0, i * 30])
                translate([POT_OD/2 + 1, 0, 20])
                    cylinder(d = TEXTURE_R, h = POT_H - 30, $fn = 10);
    }
    // Water level indicator ridge on window edge
    for (z = [RES_H * 0.33, RES_H * 0.66, RES_H])
        translate([POT_OD/2 - 1, 0, z])
            rotate([0, 90, 0])
                torus_mark();
}

module torus_mark() {
    rotate_extrude($fn = 20)
        translate([2, 0, 0])
            circle(d = 2, $fn = 10);
}

// ── Inner planting pot ────────────────────────────────
module inner_pot() {
    difference() {
        union() {
            // Body
            cylinder(d1 = INNER_OD, d2 = INNER_OD * 0.88, h = INNER_H, $fn = 52);
            // Overhanging lip
            translate([0, 0, INNER_H])
                cylinder(d = INNER_OD + LIP_OVER*2, h = LIP_H, $fn = 52);
        }
        // Hollow for soil
        translate([0, 0, WALL])
            cylinder(d = INNER_OD - WALL*2, h = INNER_H, $fn = 52);
        // Wick hole (center bottom)
        cylinder(d = WICK_D, h = WALL + 1, $fn = 16);
        // Secondary wick holes (2 more for large pots)
        for (a = [0, 120, 240])
            rotate([0, 0, a])
                translate([INNER_OD * 0.25, 0, 0])
                    cylinder(d = WICK_D * 0.6, h = WALL + 1, $fn = 12);
        // Drain holes (for excess water from top)
        for (a = [45, 135, 225, 315])
            rotate([0, 0, a])
                translate([INNER_OD * 0.38, 0, 0])
                    cylinder(d = DRAIN_D, h = WALL + 1, $fn = 12);
    }
    // Wick guide tube (keeps rope in place)
    translate([0, 0, WALL - 1])
        difference() {
            cylinder(d = WICK_D + 4, h = 15, $fn = 16);
            cylinder(d = WICK_D, h = 16, $fn = 14);
        }
}

// Color 1 (terracotta PLA): outer pot
outer_pot();
// Color 2 (white PETG): inner pot
translate([POT_OD + 20, 0, 0]) inner_pot();
