// Marble Run — Spiral Tower
// Centerpiece of any marble run set — WOW factor
// PLA — 0.2mm, 3 walls, 15% infill, no supports
// 16mm marble, ~1 full rotation, 80mm drop

MARBLE_D  = 16.5;
TURNS     = 1.5;    // Spiral rotations
R_IN      = 40;     // Inner radius
HEIGHT    = 100;    // Tower height
STEPS     = 120;    // Smoothness
TRACK_W   = MARBLE_D + 8;
WALL_T    = 2.5;
POST_D    = 24;     // Central support post

module spiral_track() {
    for (i = [0 : STEPS - 1]) {
        t0 = i / STEPS;
        t1 = (i+1) / STEPS;
        a0 = TURNS * 360 * t0;
        a1 = TURNS * 360 * t1;
        z0 = HEIGHT * t0;
        z1 = HEIGHT * t1;

        mid_a = (a0 + a1) / 2;
        mid_z = (z0 + z1) / 2;

        hull() {
            translate([R_IN * cos(a0), R_IN * sin(a0), z0])
                rotate([0, 0, a0])
                    cube([TRACK_W, WALL_T, MARBLE_D + 3], center = true);
            translate([R_IN * cos(a1), R_IN * sin(a1), z1])
                rotate([0, 0, a1])
                    cube([TRACK_W, WALL_T, MARBLE_D + 3], center = true);
        }
        // Outer guard rail
        hull() {
            translate([(R_IN + TRACK_W/2) * cos(a0),
                       (R_IN + TRACK_W/2) * sin(a0), z0])
                sphere(d = WALL_T + 1, $fn = 8);
            translate([(R_IN + TRACK_W/2) * cos(a1),
                       (R_IN + TRACK_W/2) * sin(a1), z1])
                sphere(d = WALL_T + 1, $fn = 8);
        }
    }
}

union() {
    // Central post
    cylinder(d = POST_D, h = HEIGHT + 10, $fn = 32);
    spiral_track();
    // Entry funnel at top
    translate([R_IN * cos(TURNS*360), R_IN * sin(TURNS*360), HEIGHT])
        cylinder(d1 = MARBLE_D + 20, d2 = MARBLE_D + 5, h = 20, $fn = 32);
    // Exit platform at bottom
    translate([R_IN * cos(0), R_IN * sin(0) - TRACK_W/2, 0])
        cube([TRACK_W + 20, TRACK_W, WALL_T]);
}
