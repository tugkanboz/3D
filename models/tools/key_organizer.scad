// Key Organizer - Quiet Carry Style
// PETG (durable, flexible tabs) — 0.2mm, 4 walls, 30% infill
// Holds 2-8 keys, M3 bolt pivot (hardware: 1x M3x20 + nut)

KEYS       = 5;    // Number of keys
BODY_W     = 30;
BODY_H     = 80;
BODY_T     = 8.0;
KEY_SLOT_W = 2.5;  // Key blade thickness + play
KEY_SLOT_H = 48;
PIVOT_D    = 3.6;  // M3 bolt + play
PIVOT_Z    = 12;
CORNER_R   = 6;
WALL_T     = 2.5;
SPRING_T   = 1.2;  // Friction spring tab thickness — PLA works, PETG better

module body_2d() {
    offset(r = CORNER_R)
        offset(r = -CORNER_R)
            square([BODY_W, BODY_H]);
}

module key_slot() {
    translate([BODY_W/2 - KEY_SLOT_W/2, PIVOT_Z + 4, -1])
        cube([KEY_SLOT_W, KEY_SLOT_H, BODY_T + 2]);
}

module pivot_hole() {
    translate([BODY_W/2, PIVOT_Z, -1])
        cylinder(d = PIVOT_D, h = BODY_T + 2, $fn = 20);
}

module friction_spring() {
    // Thin tab that presses against key stack for friction
    translate([BODY_W/2 - SPRING_T/2, PIVOT_Z + 1, BODY_T/2 - SPRING_T/2])
        rotate([0, 90, 0])
            cylinder(d = SPRING_T, h = BODY_W/2, $fn = 8);
}

module spacer() {
    // Spacer between keys — print 1 per key
    difference() {
        cylinder(d = 8, h = KEY_SLOT_W, $fn = 24);
        cylinder(d = PIVOT_D + 0.4, h = KEY_SLOT_W + 1, $fn = 20);
    }
}

// Main body
difference() {
    linear_extrude(BODY_T) body_2d();
    key_slot();
    pivot_hole();
    // Chamfer top corners for hand feel
    translate([0, BODY_H - 5, BODY_T - 2]) rotate([45, 0, 0])
        cube([BODY_W, 8, 8]);
}

// Carabiner hook slot
translate([BODY_W/2 - 5, BODY_H - 16, 0])
    difference() {
        cube([10, 14, BODY_T]);
        translate([2, 2, -1]) cube([6, 10, BODY_T + 2]);
    }

// Spacers (print 1 per key gap)
for (i = [0 : KEYS - 2])
    translate([BODY_W + 10 + i * 12, 0, 0])
        spacer();
