// Perpetual Wave Desk Toy — Newton's Wave (Kinetic)
// 9 hanging spheres on angled arms, hypnotic wave motion
// DUAL COLOR: frame (dark) + spheres (accent)
// PLA/PETG — 0.2mm, 4 walls, 20% infill
// Hardware: 9x M3 eyebolts + fishing line

BALLS      = 9;
BALL_D     = 28;
SPACING    = BALL_D + 4;
ARM_H      = 160;
ARM_W      = 8;
ARM_T      = 5;
BASE_W     = BALLS * SPACING + 20;
BASE_D     = 60;
BASE_H     = 12;
FRAME_H    = 200;
CROSS_T    = 6;
EYEBOLT_D  = 3.5;  // M3 eyebolt hole

module base() {
    difference() {
        union() {
            // Weighted base (thick for stability)
            hull() {
                cube([BASE_W, BASE_D, BASE_H]);
                translate([8, 8, BASE_H])
                    cube([BASE_W - 16, BASE_D - 16, 3]);
            }
            // Upright posts
            for (x = [12, BASE_W - 12])
                translate([x - ARM_T/2, BASE_D/2 - ARM_W/2, 0])
                    cube([ARM_T, ARM_W, FRAME_H]);
        }
        // Cable management slot
        translate([BASE_W/2 - 6, -1, 4])
            cube([12, 8, BASE_H]);
    }
}

module crossbar() {
    // Top horizontal bar connecting both posts
    translate([12, BASE_D/2 - CROSS_T/2, FRAME_H - CROSS_T])
        difference() {
            cube([BASE_W - 24, CROSS_T, CROSS_T]);
            // Eyebolt holes for each ball position
            for (i = [0 : BALLS - 1]) {
                x = (BASE_W - 24) * (i + 0.5) / BALLS;
                translate([x, CROSS_T/2, -1])
                    cylinder(d = EYEBOLT_D, h = CROSS_T + 2, $fn = 16);
            }
        }
}

module sphere_set() {
    // Spheres (Color 2) — print separately
    for (i = [0 : BALLS - 1])
        translate([12 + i * SPACING + SPACING/2, BASE_D/2, FRAME_H * 0.35])
            difference() {
                sphere(d = BALL_D, $fn = 32);
                // Eyebolt hole through top
                translate([0, 0, BALL_D/2 - 4])
                    cylinder(d = EYEBOLT_D, h = 8, $fn = 16);
            }
}

// Color 1: Frame
base();
crossbar();

// Color 2: Spheres (save as separate file for AMS)
// translate([BASE_W + 30, 0, 0]) sphere_set();
