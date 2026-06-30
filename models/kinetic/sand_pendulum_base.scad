// Sand Pendulum / Lissajous Art Maker
// Swing the pendulum over sand — draws Lissajous patterns
// PETG (weight matters — heavier PETG = longer swing time)
// 0.2mm, 4 walls, 30% infill — heavy base needed
// DUAL COLOR: frame (dark) + pendulum bob (bright)

PIVOT_H    = 280;   // Tripod height
BASE_LEG_R = 120;   // Leg spread radius
LEG_D      = 14;
LEG_T      = 6;
PIVOT_D    = 8;     // Pivot bolt hole (M6)
BOB_D      = 55;    // Pendulum weight ball diameter
BOB_HOLE_D = 3.0;   // String hole
TRAY_D     = 300;   // Sand tray diameter
TRAY_H     = 30;
TRAY_T     = 3.0;
NOZZLE_D   = 3.5;   // Sand nozzle at bob tip
LEGS       = 3;

module tripod_leg(angle) {
    rotate([0, 0, angle])
        translate([BASE_LEG_R * 0.3, 0, 0])
            rotate([0, -75, 0])
                union() {
                    cylinder(d = LEG_D, h = PIVOT_H * 1.08, $fn = 16);
                    // Foot pad
                    translate([0, 0, PIVOT_H * 1.08])
                        cylinder(d1 = LEG_D * 2.5, d2 = LEG_D, h = 8, $fn = 20);
                }
}

module pivot_hub() {
    difference() {
        sphere(d = PIVOT_D * 5, $fn = 32);
        // Pivot hole (M6 bolt — pendulum hangs here)
        cylinder(d = PIVOT_D, h = PIVOT_D * 6, center = true, $fn = 16);
        // Leg sockets
        for (i = [0 : LEGS - 1])
            rotate([0, 0, i * 120]) rotate([0, -75, 0])
                cylinder(d = LEG_D + 0.6, h = 20, $fn = 16);
    }
}

module pendulum_bob() {
    // Heavy sphere with sand channel
    difference() {
        union() {
            sphere(d = BOB_D, $fn = 48);
            // Nozzle tip
            translate([0, 0, -BOB_D/2])
                cylinder(d1 = NOZZLE_D + 4, d2 = NOZZLE_D + 1, h = 15, $fn = 16);
        }
        // Internal sand chamber
        sphere(d = BOB_D - 6, $fn = 48);
        // Nozzle channel
        translate([0, 0, -BOB_D/2 - 16])
            cylinder(d = NOZZLE_D, h = 30, $fn = 12);
        // Fill hole at top
        translate([0, 0, BOB_D/2 - 8])
            cylinder(d = 8, h = 10, $fn = 20);
        // String holes (4 attach points for cross-string)
        for (a = [0, 90, 180, 270])
            rotate([0, 0, a])
                translate([0, 0, BOB_D * 0.3])
                    rotate([90, 0, 0])
                        cylinder(d = BOB_HOLE_D, h = BOB_D, $fn = 12);
    }
}

module sand_tray() {
    difference() {
        cylinder(d = TRAY_D, h = TRAY_H, $fn = 80);
        translate([0, 0, TRAY_T])
            cylinder(d = TRAY_D - TRAY_T * 2, h = TRAY_H, $fn = 80);
    }
}

// Layout
for (i = [0 : LEGS - 1]) tripod_leg(i * 120);
translate([0, 0, PIVOT_H]) pivot_hub();
// Pendulum bob (Color 2):
translate([TRAY_D + 30, 0, BOB_D/2]) pendulum_bob();
// Sand tray (print separately — too large for one piece):
translate([0, TRAY_D + 30, 0]) sand_tray();
