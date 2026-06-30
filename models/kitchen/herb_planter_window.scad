// Window Sill Herb Planter — Modular, 3-pot system
// PETG (water + UV resistant) — essential for kitchen
// 0.2mm, 4 walls, 20% infill, no supports
// Label slots on front for herb names (dual-color option)

POTS     = 3;
POT_D    = 80;
POT_H    = 70;
TRAY_H   = 18;
WALL_T   = 3.0;
DRAIN_D  = 8;
LABEL_H  = 12;   // Front label slot height
LABEL_W  = 60;
SLOT_PLAY= 1.0;  // Pot-to-tray tolerance

module single_pot() {
    difference() {
        union() {
            // Tapered pot body
            cylinder(d1 = POT_D * 0.75, d2 = POT_D, h = POT_H, $fn = 48);
            // Rim
            translate([0, 0, POT_H - 3])
                cylinder(d1 = POT_D, d2 = POT_D + 6, h = 5, $fn = 48);
        }
        // Hollow
        translate([0, 0, WALL_T])
            cylinder(d1 = POT_D*0.75 - WALL_T*2, d2 = POT_D - WALL_T*2,
                     h = POT_H, $fn = 48);
        // Drain holes (3)
        for (a = [0, 120, 240])
            rotate([0, 0, a]) translate([POT_D*0.2, 0, -1])
                cylinder(d = DRAIN_D, h = WALL_T + 2, $fn = 16);
    }
    // Soil ridge (keeps mix from blocking drains)
    translate([0, 0, WALL_T])
        difference() {
            cylinder(d = POT_D*0.75 - WALL_T*2 - 4, h = 6, $fn = 48);
            cylinder(d = POT_D*0.75 - WALL_T*2 - 12, h = 7, $fn = 48);
        }
}

module tray() {
    TOTAL_W = POTS * POT_D + (POTS + 1) * WALL_T;
    TOTAL_D = POT_D + WALL_T * 2;

    difference() {
        cube([TOTAL_W, TOTAL_D, TRAY_H]);
        // Pot pocket holes (pots sit in, drain into tray)
        for (i = [0 : POTS - 1])
            translate([WALL_T + i*(POT_D + WALL_T) + POT_D/2,
                       TOTAL_D/2, -1])
                cylinder(d = POT_D * 0.75 - WALL_T + SLOT_PLAY,
                         h = TRAY_H + 2, $fn = 48);
        // Label slot on front
        for (i = [0 : POTS - 1])
            translate([WALL_T + i*(POT_D + WALL_T) + (POT_D - LABEL_W)/2,
                       -0.1, TRAY_H - LABEL_H])
                cube([LABEL_W, WALL_T + 0.2, LABEL_H + 0.1]);
    }
}

// Print layout
tray();
for (i = [0 : POTS - 1])
    translate([(i + 0.5) * (POT_D + WALL_T) + WALL_T/2,
               POT_D * 2, 0])
        single_pot();
