// Universal Phone Stand - Adjustable Angle
// Best seller on Etsy & MakerWorld
// Print: 0.2mm, 3 walls, 20% infill, no supports

PHONE_W   = 80;   // Phone cradle width
CRADLE_D  = 12;   // Depth of cradle pocket
CRADLE_H  = 20;   // Height of cradle lip
ANGLE     = 70;   // Viewing angle (degrees from horizontal)
BASE_D    = 80;
BASE_H    = 4;
WALL_T    = 3;
CABLE_D   = 14;   // Bottom cutout for charging cable

module base() {
    hull() {
        cube([PHONE_W + 20, BASE_D, BASE_H]);
        translate([5, 5, 0]) cube([PHONE_W + 10, BASE_D - 10, BASE_H + 2]);
    }
}

module stand_body() {
    rotate([-(90 - ANGLE), 0, 0])
        union() {
            // Back wall
            cube([PHONE_W + 2*WALL_T, WALL_T, 60]);
            // Cradle shelf
            translate([0, WALL_T, 0])
                cube([PHONE_W + 2*WALL_T, CRADLE_D, CRADLE_H]);
            // Side walls
            cube([WALL_T, CRADLE_D + WALL_T, 60]);
            translate([PHONE_W + WALL_T, 0, 0])
                cube([WALL_T, CRADLE_D + WALL_T, 60]);
        }
}

difference() {
    union() {
        translate([10, 10, 0]) base();
        translate([10, 30, BASE_H]) stand_body();
    }
    // Cable notch at bottom of cradle
    translate([10 + PHONE_W/2 + WALL_T - CABLE_D/2, 28, BASE_H - 1])
        cube([CABLE_D, 20, CRADLE_H + 2]);
}
