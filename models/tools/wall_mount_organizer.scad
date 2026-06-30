// Pegboard-Style Wall Mount Organizer System
// Modular: hooks, shelves, bins — all click into same rail
// PETG (recommended) or PLA — 0.2mm, 4 walls, 20% infill
// One 200mm rail + mix of attachments

RAIL_W   = 200;
RAIL_H   = 20;
RAIL_T   = 8;
SLOT_W   = 6;
SLOT_H   = 10;
SLOT_PITCH = 20;   // Center-to-center spacing
WALL_T   = 3.0;
SCREW_D  = 4.5;   // M4 wall screws

// Attachment lug dimensions
LUG_W    = SLOT_W - 0.4;
LUG_H    = SLOT_H - 0.5;
LUG_T    = RAIL_T + 1;

module rail() {
    difference() {
        cube([RAIL_W, RAIL_T, RAIL_H]);
        // Mounting screw holes
        for (x = [15, RAIL_W - 15])
            translate([x, RAIL_T/2, RAIL_H/2])
                rotate([90, 0, 0])
                    cylinder(d = SCREW_D, h = RAIL_T + 1, center = true, $fn = 20);
        // Slot array
        n_slots = floor((RAIL_W - SLOT_PITCH) / SLOT_PITCH);
        for (i = [0 : n_slots])
            translate([SLOT_PITCH/2 + i * SLOT_PITCH - SLOT_W/2, -1, RAIL_H/2 - SLOT_H/2])
                cube([SLOT_W, RAIL_T + 2, SLOT_H]);
    }
}

module attach_lug() {
    // T-shaped lug that slides into rail slot
    union() {
        cube([LUG_W, LUG_T, LUG_H]);
        translate([-WALL_T, LUG_T - 2, 0])
            cube([LUG_W + WALL_T*2, 2, LUG_H]);
    }
}

module single_hook() {
    union() {
        attach_lug();
        // Hook arm
        translate([LUG_W/2 - 3, LUG_T, 0]) {
            cube([6, 35, LUG_H]);
            // Upward hook tip
            translate([0, 35, 0])
                cube([6, 5, LUG_H + 14]);
        }
    }
}

module mini_shelf(shelf_d) {
    union() {
        attach_lug();
        // Shelf platform
        translate([-10, LUG_T, 0])
            cube([LUG_W + 20, shelf_d, WALL_T]);
        // Side walls
        for (x = [-10, LUG_W + 10])
            translate([x, LUG_T, 0])
                cube([WALL_T, shelf_d, 30]);
    }
}

module bin(w, d, h) {
    union() {
        attach_lug();
        translate([-(w - LUG_W)/2, LUG_T, -h])
        difference() {
            cube([w, d, h]);
            translate([WALL_T, WALL_T, WALL_T])
                cube([w - WALL_T*2, d, h]);
        }
    }
}

// Layout all components for print
rail();
translate([0, RAIL_T + 15, 0])  single_hook();
translate([40, RAIL_T + 15, 0]) mini_shelf(60);
translate([100, RAIL_T + 15, 0]) bin(50, 55, 45);
