// Vinyl Record Display Stand — Tilted Showcase Holder
// Displays 12" LP record at 15° tilt with album cover slot
// DUAL COLOR: stand body (dark walnut PLA) | record prop + grooves (accent)
// PLA — 0.2mm, 4 walls, 20% infill
// Includes: dummy record face plate + album cover slot

RECORD_D  = 302;   // 12" LP = 305mm, with play gap
RECORD_T  = 3.0;   // Record thickness
LABEL_D   = 108;   // Center label diameter
GROOVE_T  = 0.5;   // Groove relief depth
N_GROOVES = 40;
TILT      = 15;    // Display tilt angle
STAND_W   = 120;   // Stand base width
STAND_D   = 80;    // Stand base depth
STAND_H   = 12;    // Stand base height
SPINE_H   = 60;    // Back support spine height
SPINE_T   = 10;
COVER_W   = 315;   // Album cover slot width
COVER_T   = 8.0;   // Cover slot thickness
WALL      = 5.0;

// ── Record face plate (Color 2 — dark vinyl look) ─────
module record_plate() {
    difference() {
        cylinder(d=RECORD_D, h=RECORD_T, $fn=120);
        // Center spindle hole
        cylinder(d=7.2, h=RECORD_T+1, $fn=16);
        // Groove area (grooves between label and outer edge)
        // (Concentric rings represent grooves)
        for (i=[0:N_GROOVES-1]) {
            r = LABEL_D/2 + 5 + i*(RECORD_D/2-LABEL_D/2-12)/N_GROOVES;
            translate([0,0,RECORD_T-GROOVE_T])
                difference() {
                    cylinder(r=r+0.5, h=GROOVE_T+0.1, $fn=80);
                    cylinder(r=r, h=GROOVE_T+0.2, $fn=80);
                }
        }
    }
    // Label area (raised center)
    translate([0,0,RECORD_T])
        difference() {
            cylinder(d=LABEL_D, h=0.8, $fn=40);
            cylinder(d=7, h=1, $fn=14);
        }
    // Label text (circular)
    translate([0,0,RECORD_T+0.8])
        linear_extrude(0.8)
            text("SIDE A", size=7, halign="center", $fn=4);
    translate([0,-15,RECORD_T+0.8])
        linear_extrude(0.8)
            text("33⅓ RPM", size=5, halign="center", $fn=4);
}

// ── Stand base ────────────────────────────────────────
module base() {
    difference() {
        hull() {
            cube([STAND_W, STAND_D, STAND_H]);
            translate([STAND_W*0.1, STAND_D*0.1, STAND_H])
                cube([STAND_W*0.8, STAND_D*0.8, 2]);
        }
        // Non-slip pad recesses
        for (x=[10,STAND_W-20], y=[10,STAND_D-20])
            translate([x, y, -1]) cylinder(d=12, h=3, $fn=8);
        // Weight reduction
        translate([10, 10, 3])
            cube([STAND_W-20, STAND_D-20, STAND_H]);
    }
}

// ── Record cradle (tilted ledge) ──────────────────────
module record_cradle() {
    translate([STAND_W/2, 0, STAND_H])
        rotate([TILT, 0, 0]) {
            // Spine (back support)
            translate([-SPINE_T/2, -SPINE_T/2, 0])
                cube([SPINE_T, SPINE_T, SPINE_H]);
            // Record groove ledge (catches bottom edge of record)
            translate([-(RECORD_D/2+5), 0, 0])
                rotate([0, 0, 0]) {
                    difference() {
                        cube([RECORD_D+10, WALL*1.5, 15]);
                        translate([5, -1, 5])
                            cube([RECORD_D, WALL*2, 12]);
                        // Record slot groove
                        translate([5, WALL*1.5-RECORD_T-0.5, -1])
                            cube([RECORD_D, RECORD_T+1, 17]);
                    }
                }
            // Album cover slot (behind record)
            translate([-(COVER_W/2), RECORD_T+1, -5])
                difference() {
                    cube([COVER_W, COVER_T, SPINE_H+20]);
                    translate([WALL, WALL, -1])
                        cube([COVER_W-WALL*2, COVER_T, SPINE_H+22]);
                }
        }
}

// Color 1 (walnut dark): stand + cradle
base();
record_cradle();
// Color 2 (dark vinyl): record face plate
translate([STAND_W/2, STAND_D*0.4, STAND_H+SPINE_H*0.7])
    rotate([90-TILT, 0, 0])
        record_plate();
