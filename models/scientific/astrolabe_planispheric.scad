// Planispheric Astrolabe — Medieval Navigation Instrument
// Functional: find time, latitude, star positions
// DUAL COLOR: mater/rete (brass-PLA) + tympan plate (dark PLA)
// PLA — 0.15mm, 4 walls, 15% infill
// Lat 41° preset (Istanbul / NY / Madrid) — fully parametric

LAT       = 41;   // Observer latitude
DIAM      = 200;  // Outer mater diameter
THICK     = 4.0;
RING_W    = 12;   // Suspension ring width
SCALE_T   = 1.2;
THRONE_H  = 22;
PIVOT_D   = 5.5;  // Center pivot bolt (M5)
RETE_T    = 3.0;  // Star rete plate thickness
TYMPH_T   = 2.5;  // Tympan plate thickness

// ── Mater (outer body — Color 1 brass) ───────────────
module mater() {
    difference() {
        cylinder(d = DIAM, h = THICK, $fn = 120);
        // Inner recess (holds tympan + rete)
        translate([0, 0, SCALE_T])
            cylinder(d = DIAM - RING_W*2, h = THICK, $fn = 100);
        // Center pivot
        cylinder(d = PIVOT_D, h = THICK + 1, $fn = 16);
        // Degree markings (outer limb — 360 x 1°)
        for (i = [0:359])
            rotate([0, 0, i])
                translate([DIAM/2 - RING_W + 1, -0.5, THICK - SCALE_T])
                    cube([(i % 5 == 0) ? (i % 10 == 0 ? RING_W - 3 : 5) : 3, 1, SCALE_T + 0.1]);
    }
    // Suspension ring + throne
    translate([0, DIAM/2, THICK])
        difference() {
            union() {
                cube([RING_W * 1.5, THRONE_H, THICK], center = true);
                translate([0, THRONE_H/2, 0])
                    difference() {
                        cylinder(d = RING_W * 2, h = THICK, center = true, $fn = 24);
                        cylinder(d = RING_W, h = THICK + 1, center = true, $fn = 20);
                    }
            }
        }
}

// ── Tympan plate (horizon + altitude circles — Color 2) ─
module tympan() {
    r = (DIAM - RING_W*2) / 2 - 1;
    difference() {
        cylinder(d = r*2, h = TYMPH_T, $fn = 100);
        cylinder(d = PIVOT_D + 0.3, h = TYMPH_T + 1, $fn = 16);
        // Altitude circles (every 10°) — stereographic projection
        for (alt = [10:10:80]) {
            proj_r = r * cos(LAT) / (sin(LAT) + sin(alt));
            proj_z = r * cos(alt) / (sin(LAT) + sin(alt));
            translate([0, proj_z, -0.1])
                difference() {
                    cylinder(r = proj_r + 1, h = TYMPH_T + 0.2, $fn = 80);
                    cylinder(r = proj_r, h = TYMPH_T + 0.4, $fn = 80);
                }
        }
        // Azimuth lines (every 30°)
        for (az = [0:30:330])
            rotate([0, 0, az])
                translate([-0.5, -r, -0.1])
                    cube([1, r*2, TYMPH_T + 0.2]);
        // Tropic of Cancer + Capricorn
        for (tropic_r = [r * 0.68, r * 1.18])
            difference() {
                cylinder(r = tropic_r + 1, h = TYMPH_T + 0.2, $fn = 80);
                cylinder(r = tropic_r, h = TYMPH_T + 0.4, $fn = 80);
            }
    }
}

// ── Rete (star map overlay — Color 1, openwork) ───────
module rete() {
    r = (DIAM - RING_W*2) / 2 - 1;
    STARS = [
        // [angle from vernal equinox, declination, name_ignored]
        [60, 45],  // Capella
        [116, 5],  // Betelgeuse
        [101, -8], // Rigel
        [214, 19], // Arcturus
        [246, -27],// Antares
        [310, 45], // Deneb
        [297, 8],  // Altair
        [279, 38], // Vega
        [152, 56], // Dubhe
    ];

    difference() {
        cylinder(d = r*2, h = RETE_T, $fn = 100);
        // Large cutaway (openwork — makes it translucent/open)
        rotate([0, 0, 30])
            translate([-r * 0.85, -r * 0.2, -0.1])
                cube([r * 1.7, r * 0.4, RETE_T + 0.2]);
        translate([-r * 0.5, r * 0.1, -0.1])
            scale([1, 1.5, 1])
                cylinder(r = r * 0.5, h = RETE_T + 0.2, $fn = 60);
        cylinder(d = PIVOT_D + 0.3, h = RETE_T + 1, $fn = 16);
    }
    // Star pointers
    for (s = STARS) {
        a = s[0];
        d = s[1];
        sr = r * cos(d) / (1 + sin(d));
        sz = r * sin(d) / (1 + sin(d)) * 0;
        translate([sr * cos(a), sr * sin(a), 0])
            cylinder(d = 5, h = RETE_T + 3, $fn = 5);
    }
    // Ecliptic circle
    ec = r * 0.9;
    difference() {
        cylinder(r = ec + 1.5, h = RETE_T, $fn = 80);
        cylinder(r = ec, h = RETE_T + 1, $fn = 80);
        cylinder(r = r * 0.3, h = RETE_T + 1, $fn = 40);
    }
}

// Color 1 (brass PLA): mater + rete
mater();
translate([0, 0, THICK + TYMPH_T + 0.3]) rete();
// Color 2 (dark PLA): tympan
translate([0, 0, THICK]) tympan();
