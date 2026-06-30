// Marble Run — Modular Track System
// Piece 1: Straight section (print many)
// PLA — 0.2mm, 3 walls, 15% infill, no supports
// 16mm marble compatible — set MARBLE_D to your marble size

MARBLE_D  = 16.5;  // Marble diameter + 0.5mm play
TRACK_W   = MARBLE_D + 8;
TRACK_H   = MARBLE_D + 5;
WALL_T    = 2.5;
LENGTH    = 120;
SLOPE_DEG = 5;     // Print flat; tilt during assembly for roll speed
CONNECTOR_D = 22;  // Snap connector diameter

module channel() {
    translate([0, 0, WALL_T])
        cube([LENGTH + 4, MARBLE_D + 1, MARBLE_D + 1]);
}

module connector_male() {
    cylinder(d = CONNECTOR_D, h = 8, $fn = 28);
    translate([0, 0, 8])
        cylinder(d1 = CONNECTOR_D, d2 = CONNECTOR_D - 3, h = 3, $fn = 28);
}

module connector_female() {
    cylinder(d = CONNECTOR_D + 0.6, h = 11, $fn = 28);
}

module track_body() {
    difference() {
        cube([LENGTH, TRACK_W, TRACK_H]);
        // Channel
        translate([-1, WALL_T, WALL_T])
            cube([LENGTH + 2, MARBLE_D + 1, MARBLE_D + 4]);
        // Open top (so you can see marble + easy to print)
        translate([-1, WALL_T, TRACK_H - MARBLE_D * 0.4])
            cube([LENGTH + 2, MARBLE_D + 1, MARBLE_D]);
    }
}

difference() {
    union() {
        track_body();
        // Male connector at one end
        translate([LENGTH, TRACK_W/2, TRACK_H/2])
            rotate([0, 90, 0]) connector_male();
    }
    // Female connector at other end
    translate([-11, TRACK_W/2, TRACK_H/2])
        rotate([0, 90, 0]) connector_female();
}
