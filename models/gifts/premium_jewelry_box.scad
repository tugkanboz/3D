// Premium Jewelry Box — Hinged Lid, Velvet Inlay Ready
// DUAL COLOR: body (wood-filament PLA) + ornamental overlay (gold PLA)
// P2S: 0.15mm, 4 walls, 15% infill
// Hardware: 2x 6x2mm neodymium magnets (latch), 1x M3 rod hinge

BOX_W  = 120;
BOX_D  = 80;
BOX_H  = 45;
LID_H  = 18;
WALL   = 3.5;
R      = 8;      // Corner radius
MAG_D  = 6.2;    // Magnet pocket diameter
MAG_H  = 2.2;    // Magnet pocket depth
HINGE_D = 4.0;   // Hinge pin hole (M3 bolt)
RING_SLOT_W = 22;
RING_SLOT_D = 12;
RING_SLOTS  = 4;

module rounded_box(w, d, h, r, wall) {
    difference() {
        minkowski() {
            cube([w - r*2, d - r*2, h - r]);
            translate([r, r, r]) cylinder(r = r, h = 1, $fn = 32);
        }
        translate([wall, wall, wall])
            cube([w - wall*2, d - wall*2, h]);
    }
}

module box_body() {
    difference() {
        rounded_box(BOX_W, BOX_D, BOX_H - LID_H, R, WALL);
        // Ring slots (foam insert guides)
        for (i = [0 : RING_SLOTS - 1])
            translate([10 + i * (RING_SLOT_W + 6), BOX_D/2 - RING_SLOT_D/2, BOX_H - LID_H - RING_SLOT_D])
                cube([RING_SLOT_W, RING_SLOT_D, RING_SLOT_D + 1]);
        // Magnet pockets (front)
        for (x = [BOX_W * 0.3, BOX_W * 0.7])
            translate([x, WALL - 0.1, BOX_H * 0.4])
                rotate([-90, 0, 0])
                    cylinder(d = MAG_D, h = MAG_H, $fn = 20);
        // Hinge barrel (back, pair of recesses)
        for (x = [BOX_W * 0.25, BOX_W * 0.75])
            translate([x, BOX_D - WALL, BOX_H - LID_H - 2])
                rotate([90, 0, 0])
                    cylinder(d = HINGE_D + 4, h = WALL * 2, $fn = 20);
    }
    // Hinge knuckles (body side — odd positions)
    for (x = [BOX_W * 0.25, BOX_W * 0.75])
        translate([x, BOX_D - WALL/2, BOX_H - LID_H - 8])
            rotate([90, 0, 0]) {
                cylinder(d = HINGE_D + 4, h = 6, center = true, $fn = 20);
                cylinder(d = HINGE_D, h = 18, center = true, $fn = 16);
            }
}

module lid() {
    translate([0, 0, BOX_H + 2])
    difference() {
        union() {
            rounded_box(BOX_W, BOX_D, LID_H, R, WALL);
            // Lip (fits inside box top)
            translate([WALL + 0.3, WALL + 0.3, -5])
                cube([BOX_W - WALL*2 - 0.6, BOX_D - WALL*2 - 0.6, 5]);
        }
        // Magnet pockets (front)
        for (x = [BOX_W * 0.3, BOX_W * 0.7])
            translate([x, WALL - 0.1, LID_H * 0.5])
                rotate([-90, 0, 0])
                    cylinder(d = MAG_D, h = MAG_H, $fn = 20);
        // Hinge knuckles (lid side)
        for (x = [BOX_W * 0.25, BOX_W * 0.75])
            translate([x, BOX_D - WALL/2, 0])
                rotate([90, 0, 0]) {
                    cylinder(d = HINGE_D + 4, h = 6, center = true, $fn = 20);
                    cylinder(d = HINGE_D, h = 18, center = true, $fn = 16);
                }
    }
}

module ornament_overlay() {
    // Color 2: decorative floral overlay on lid top (AMS)
    translate([0, 0, BOX_H + LID_H + 2.5]) {
        // Central medallion
        difference() {
            cylinder(d = 40, h = 1.5, $fn = 6);
            cylinder(d = 20, h = 2, $fn = 6);
        }
        // Petals
        for (a = [0:60:300])
            rotate([0, 0, a])
                translate([22, 0, 0])
                    cylinder(d = 14, h = 1.5, $fn = 8);
        // Corner flourishes
        for (x = [15, BOX_W - 15], y = [15, BOX_D - 15])
            translate([x - BOX_W/2 + BOX_W/2, y - BOX_D/2 + BOX_D/2, 0])
                cylinder(d = 12, h = 1.5, $fn = 5);
        // Border
        difference() {
            translate([5, 5, 0]) cube([BOX_W - 10, BOX_D - 10, 1.5]);
            translate([9, 9, -1]) cube([BOX_W - 18, BOX_D - 18, 3]);
        }
    }
}

// Color 1: box + lid
box_body();
lid();
// Color 2: ornamental overlay
ornament_overlay();
