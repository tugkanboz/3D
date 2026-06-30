// Dual Controller Stand - PS5 / Xbox / Switch Pro
// PLA/PETG — 0.2mm, 3 walls, 15% infill, no supports
// Holds 2 controllers + charging cables through base slots

CTRL_W     = 160;  // Controller cradle width
CTRL_DEPTH = 50;   // Cradle depth
CRADLE_H   = 30;   // Height of grip pocket
ANGLE      = 15;   // Lean-back angle
BASE_W     = 380;
BASE_D     = 130;
BASE_H     = 6;
WALL_T     = 3.0;  // PLA: keep ≥ 3mm for strength
POST_H     = 60;
CABLE_W    = 18;   // USB-C slot width
CABLE_H    = 10;

module base_plate() {
    hull() {
        cube([BASE_W, BASE_D, BASE_H]);
        translate([8, 8, 0]) cube([BASE_W - 16, BASE_D - 16, BASE_H + 3]);
    }
}

module cradle() {
    difference() {
        union() {
            // Back wall
            cube([CTRL_W, WALL_T, POST_H + CRADLE_H]);
            // Side walls
            cube([WALL_T, CTRL_DEPTH + WALL_T, POST_H + CRADLE_H]);
            translate([CTRL_W - WALL_T, 0, 0])
                cube([WALL_T, CTRL_DEPTH + WALL_T, POST_H + CRADLE_H]);
            // Shelf
            translate([0, WALL_T, POST_H])
                cube([CTRL_W, CTRL_DEPTH, WALL_T]);
        }
        // Cable slots on shelf
        for (x = [CTRL_W/2 - CABLE_W/2, CTRL_W * 0.25 - CABLE_W/2, CTRL_W * 0.75 - CABLE_W/2])
            translate([x, WALL_T - 1, POST_H - 1])
                cube([CABLE_W, CTRL_DEPTH + 2, WALL_T + 2]);
    }
}

// Two cradles, symmetric
translate([10, 20, BASE_H])
    rotate([-ANGLE, 0, 0])
        cradle();

translate([BASE_W - CTRL_W - 10, 20, BASE_H])
    rotate([-ANGLE, 0, 0])
        cradle();

base_plate();
