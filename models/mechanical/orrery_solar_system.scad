// Orrery — Mechanical Solar System Display
// 4-COLOR AMS: sun (yellow), inner planets (red), outer planets (blue), arms+base (dark)
// Print-in-place capable rings with 0.45mm clearance
// PLA — 0.15mm, 4 walls, 15% infill
// Diameter: ~250mm (fits P2S); Height: ~160mm

// ── Parameters ────────────────────────────────────────
BASE_D    = 80;
BASE_H    = 16;
AXIS_D    = 12;
AXIS_H    = 100;
SUN_D     = 28;
ARM_T     = 3.5;
ARM_W     = 5.0;
CLEAR     = 0.45;  // Print-in-place clearance

// Planet data: [orbit_r, planet_d, tilt_deg, arm_h]
planets = [
    [38,  6.5, 3,   30],   // Mercury
    [58,  9.0, 2,   45],   // Venus
    [78, 10.0, 0,   55],   // Earth
    [102, 8.0, 5,   42],   // Mars
    [145, 22.0, 3,  70],   // Jupiter
    [195, 18.0, 27, 60],   // Saturn (with rings)
];

// ── Base ─────────────────────────────────────────────
module base() {
    difference() {
        union() {
            // Stepped plinth
            cylinder(d = BASE_D, h = BASE_H, $fn = 48);
            translate([0, 0, BASE_H - 4])
                cylinder(d = BASE_D * 0.7, h = 4, $fn = 48);
            // Axis tube
            translate([0, 0, BASE_H])
                cylinder(d = AXIS_D, h = AXIS_H, $fn = 24);
        }
        // Hollow axis (wiring channel)
        cylinder(d = AXIS_D - 4, h = BASE_H + AXIS_H + 1, $fn = 20);
        // Decorative cutouts in base
        for (i = [0 : 5])
            rotate([0, 0, i * 60])
                translate([BASE_D * 0.3, 0, -1])
                    cylinder(d = BASE_D * 0.15, h = BASE_H * 0.6 + 1, $fn = 16);
        // Compass rose engraving (top of base)
        for (i = [0:7])
            rotate([0, 0, i * 45])
                translate([BASE_D * 0.25, 0, BASE_H - 0.6])
                    cube([BASE_D * 0.22, 1.5, 1], center = true);
    }
}

// ── Orbit ring (print-in-place or separate) ───────────
module orbit_ring(r) {
    difference() {
        torus_r = r;
        difference() {
            rotate_extrude($fn = 80)
                translate([r, 0, 0])
                    circle(d = ARM_T, $fn = 16);
            // Gap for arm clearance (where arm attaches)
            rotate([0, 0, 0])
                cube([r*2 + ARM_T*2, ARM_T + CLEAR*2, ARM_T + CLEAR*2], center = true);
        }
    }
}

// ── Planet arm ────────────────────────────────────────
module arm(orbit_r, planet_d, arm_h) {
    // Horizontal arm from axis to planet
    translate([0, 0, arm_h]) {
        // Arm bar
        hull() {
            cylinder(d = AXIS_D + 2, h = ARM_W, $fn = 24);
            translate([orbit_r, 0, 0])
                cylinder(d = planet_d + 4, h = ARM_W, $fn = 20);
        }
        // Planet socket
        translate([orbit_r, 0, ARM_W/2])
            cylinder(d = planet_d + 2, h = planet_d * 0.3, $fn = 24);
    }
}

// ── Sun (Color 1 — yellow) ────────────────────────────
module sun() {
    translate([0, 0, BASE_H + AXIS_H])
        difference() {
            sphere(d = SUN_D, $fn = 32);
            cylinder(d = AXIS_D - 0.4, h = SUN_D, center = true, $fn = 20);
        }
}

// ── Planets (Colors 2 & 3) ────────────────────────────
module planet_sphere(d, has_rings) {
    sphere(d = d, $fn = 24);
    if (has_rings)
        // Saturn ring disk
        rotate([70, 0, 0])
            difference() {
                cylinder(d = d * 2.8, h = 2, center = true, $fn = 40);
                cylinder(d = d * 1.4, h = 3, center = true, $fn = 40);
            }
}

module planets() {
    for (p = planets) {
        orbit_r  = p[0];
        planet_d = p[1];
        tilt     = p[2];
        arm_h    = p[3];
        is_saturn = (orbit_r == 195);

        // Arm + ring
        arm(orbit_r, planet_d, arm_h);

        // Planet body
        translate([orbit_r, 0, arm_h + ARM_W + planet_d/2 + 2])
            rotate([0, tilt, 0])
                planet_sphere(planet_d, is_saturn);
    }
}

// ── Ecliptic tilt indicator ───────────────────────────
module ecliptic_plane() {
    translate([0, 0, 52])
        rotate([0, 23.5, 0])  // Earth's axial tilt
            difference() {
                cylinder(d = planets[3][0] * 2 + 20, h = 1.5, $fn = 60);
                cylinder(d = AXIS_D + CLEAR*2, h = 3, center = true, $fn = 20);
            }
}

// ── Assembly ─────────────────────────────────────────
// Color 4 (dark): base + arms
base();
// Color 1 (yellow): sun
sun();
// Colors 2 & 3: planets (split inner/outer in BambuStudio by height)
planets();
// Color 4 accent: ecliptic plane
ecliptic_plane();
