// Retro Game Cartridge Display Stand
// Holds SNES / Game Boy / N64 cartridges upright
// PLA — 0.2mm, 3 walls, 15% infill, no supports
// Each slot is labeled with embossed logo area

SLOTS       = 8;
// Cartridge sizes (mm) — SNES ≈ 55x128x18
CART_W      = 56;
CART_H      = 55;   // How high cart sticks out above holder
CART_T      = 19;
SLOT_DEPTH  = 35;   // How deep the slot grips the cart
WALL_T      = 3.0;
BASE_H      = 8;
LABEL_H     = 8;    // Embossed label band height

total_W = SLOTS * (CART_T + WALL_T) + WALL_T;
total_D = SLOT_DEPTH + WALL_T * 2;
body_H  = SLOT_DEPTH + BASE_H;

module label_band(w, h) {
    // Recessed area for painting/labeling each slot
    translate([1, total_D - WALL_T - 1, BASE_H + 5])
        cube([w - 2, 2, h]);
}

module slot_body(i) {
    x = WALL_T + i * (CART_T + WALL_T);
    translate([x, WALL_T, BASE_H])
        cube([CART_T, SLOT_DEPTH, body_H]);
}

difference() {
    union() {
        // Base slab
        cube([total_W, total_D, BASE_H]);
        // Back wall
        translate([0, 0, 0])
            cube([total_W, WALL_T, body_H + CART_H * 0.3]);
        // Side walls + dividers
        for (i = [0 : SLOTS])
            translate([i * (CART_T + WALL_T), 0, 0])
                cube([WALL_T, total_D, body_H]);
        // Front lip (keeps carts from sliding out)
        translate([0, total_D - WALL_T, 0])
            cube([total_W, WALL_T, BASE_H + 12]);
    }
    // Slot cutouts
    for (i = [0 : SLOTS - 1])
        slot_body(i);
    // Label recesses
    for (i = [0 : SLOTS - 1]) {
        x = WALL_T + i * (CART_T + WALL_T);
        translate([x, 0, BASE_H + 5])
            label_band(CART_T, LABEL_H);
    }
}
