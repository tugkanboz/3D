// Car Vent Phone Holder — Universal Clip
// PETG (heat resistant — car interior gets hot!)
// 0.2mm, 4 walls, 30% infill — strength critical
// Fits phones 60-90mm wide (spring-loaded arms)
// NO tools, NO adhesive — just clip to vent fin

VENT_FIN_W   = 12;    // Vent fin width
VENT_FIN_T   = 4;     // Vent fin thickness
PHONE_W_MIN  = 60;
PHONE_W_MAX  = 90;
ARM_TRAVEL   = 15;    // Spring arm travel
WALL_T       = 3.0;
PIVOT_D      = 4.5;   // M4 pivot bolt
BALL_D       = 22;    // Ball joint diameter (for rotation)
BALL_PLAY    = 0.55;  // PETG tolerance

// ── Vent Clip ─────────────────────────────────────────
module vent_clip() {
    difference() {
        union() {
            // Front jaw
            cube([VENT_FIN_W + 10, WALL_T * 2, 28]);
            // Rear jaw
            translate([0, VENT_FIN_T + WALL_T * 2, 0])
                cube([VENT_FIN_W + 10, WALL_T * 2, 18]);
            // Top bridge
            cube([VENT_FIN_W + 10, VENT_FIN_T + WALL_T * 4, WALL_T * 2]);
            // Ball joint socket body
            translate([VENT_FIN_W/2 + 5, VENT_FIN_T/2 + WALL_T * 2, -BALL_D/2 - 4])
                sphere(d = BALL_D + WALL_T * 2, $fn = 32);
        }
        // Ball socket (open front for assembly)
        translate([VENT_FIN_W/2 + 5, VENT_FIN_T/2 + WALL_T * 2, -BALL_D/2 - 4])
            sphere(d = BALL_D + BALL_PLAY * 2, $fn = 32);
        translate([VENT_FIN_W/2 + 5, -10, -BALL_D/2 - 4])
            cube([BALL_D * 2, BALL_D * 2, BALL_D], center = false);
        // Grip teeth on jaws
        for (z = [4:4:24])
            translate([-1, -0.5, z])
                cube([VENT_FIN_W + 12, 1.5, 2]);
    }
}

// ── Phone Cradle with spring arms ────────────────────
module phone_cradle() {
    BASE_W = PHONE_W_MAX + WALL_T * 2;

    difference() {
        union() {
            // Back plate
            cube([BASE_W, WALL_T * 2, 120]);
            // Bottom lip
            cube([BASE_W, 18, WALL_T * 2]);
            // Fixed side wall (left)
            cube([WALL_T * 2, 18, 120]);
        }
        // Arm slot (right side spring arm slides here)
        translate([BASE_W - WALL_T * 2 - ARM_TRAVEL - 1, -1, 20])
            cube([ARM_TRAVEL + WALL_T + 2, WALL_T * 3, 80]);
    }

    // Spring arm (right — living hinge, print in place)
    translate([BASE_W - WALL_T * 2, 0, 20]) {
        cube([WALL_T * 2, 18, 80]);
        // Spring tab
        translate([-ARM_TRAVEL, -4, 30])
            cube([ARM_TRAVEL, WALL_T * 1.4, 40]);
    }

    // Ball joint ball (prints separate, press-fits)
    translate([BASE_W/2, -BALL_D/2 - 2, 60])
        sphere(d = BALL_D, $fn = 32);
}

vent_clip();
translate([60, 0, 0]) phone_cradle();
