// Desk Cable Organizer - 5 slots
// Top seller: $8-15 on Etsy
// Print: 0.2mm, 3 walls, 15% infill, no supports

SLOTS     = 5;
SLOT_W    = 16;
SLOT_H    = 22;
SLOT_D    = 30;
WALL_T    = 2.5;
BASE_H    = 4;
CABLE_D   = 8;    // Cable hole diameter
ROUND_R   = 3;    // Corner rounding

total_W = SLOTS * (SLOT_W + WALL_T) + WALL_T;
total_D = SLOT_D + 2 * WALL_T;
total_H = BASE_H + SLOT_H + WALL_T;

module rounded_box(w, d, h, r) {
    hull() {
        for (x = [r, w-r], y = [r, d-r])
            translate([x, y, 0]) cylinder(r = r, h = h, $fn = 20);
    }
}

module organizer() {
    difference() {
        rounded_box(total_W, total_D, total_H, ROUND_R);

        // Slot cutouts
        for (i = [0 : SLOTS - 1]) {
            x = WALL_T + i * (SLOT_W + WALL_T);
            translate([x, WALL_T, BASE_H])
                cube([SLOT_W, SLOT_D, SLOT_H + 1]);
        }

        // Cable holes on front face
        for (i = [0 : SLOTS - 1]) {
            cx = WALL_T + i * (SLOT_W + WALL_T) + SLOT_W/2;
            translate([cx, -1, BASE_H + CABLE_D/2 + 2])
                rotate([-90, 0, 0])
                    cylinder(d = CABLE_D, h = WALL_T + 2, $fn = 20);
        }
    }
}

organizer();
