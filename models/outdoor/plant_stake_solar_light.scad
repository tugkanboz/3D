// Garden Solar Light Stake — Geometric Lantern Top
// PETG (UV + weather resistant) — outdoor essential
// 0.2mm, 3 walls, 20% infill
// Fits standard 60mm solar light module (cheap on Amazon)
// Decorative geometric cage diffuses light

SOLAR_D    = 62;    // Solar module OD + play
STAKE_H    = 250;   // Ground stake length
STAKE_D    = 12;
CAGE_H     = 90;
CAGE_D     = 80;
WALL_T     = 2.5;
PANEL_D    = 55;    // Solar panel diameter

module stake() {
    union() {
        cylinder(d = STAKE_D, h = STAKE_H, $fn = 16);
        // Pointed tip for ground penetration
        translate([0, 0, -18])
            cylinder(d1 = 0, d2 = STAKE_D, h = 18, $fn = 16);
        // Widened base for light module seat
        translate([0, 0, STAKE_H - 8])
            cylinder(d = SOLAR_D + WALL_T*2, h = 8, $fn = 32);
    }
}

module solar_seat() {
    difference() {
        cylinder(d = SOLAR_D + WALL_T*2, h = 20, $fn = 32);
        translate([0, 0, WALL_T])
            cylinder(d = SOLAR_D, h = 20, $fn = 32);
        // Solar panel window on top
        translate([0, 0, -1])
            cylinder(d = PANEL_D, h = WALL_T + 2, $fn = 32);
    }
}

module geometric_cage() {
    // Diamond-pattern cage around light
    FACES = 6;
    for (i = [0 : FACES - 1]) {
        rotate([0, 0, i * 360/FACES]) {
            // Vertical bar
            translate([CAGE_D/2 - WALL_T, -WALL_T/2, 0])
                cube([WALL_T, WALL_T, CAGE_H]);
            // Diagonal struts
            for (z = [0, CAGE_H/2]) {
                hull() {
                    translate([CAGE_D/2 - WALL_T, 0, z])
                        sphere(d = WALL_T + 1, $fn = 10);
                    rotate([0, 0, 360/FACES])
                        translate([CAGE_D/2 - WALL_T, 0, z + CAGE_H/2])
                            sphere(d = WALL_T + 1, $fn = 10);
                }
            }
        }
    }
    // Top ring
    difference() {
        cylinder(d = CAGE_D, h = WALL_T * 2, $fn = FACES);
        cylinder(d = CAGE_D - WALL_T*2, h = WALL_T * 2 + 1, $fn = FACES);
    }
    // Bottom ring
    translate([0, 0, CAGE_H])
        difference() {
            cylinder(d = CAGE_D, h = WALL_T * 2, $fn = FACES);
            cylinder(d = CAGE_D - WALL_T*2, h = WALL_T * 2 + 1, $fn = FACES);
        }
}

// Bottom
stake();
translate([0, 0, STAKE_H]) solar_seat();
translate([0, 0, STAKE_H + 20]) geometric_cage();
