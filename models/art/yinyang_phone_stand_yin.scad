// Yin-Yang Phone Stand — DUAL COLOR
// File 1/2: Yin (dark) half — e.g. black PLA
// File 2/2: yinyang_yang.scad (light half)
// P2S Combo AMS: slot 1 = black, slot 2 = white
// 0.2mm, 4 walls, 20% infill, no supports

D        = 110;   // Disc diameter
THICK    = 12;    // Stand thickness
ANGLE    = 75;    // Phone lean angle
BASE_D   = 90;
BASE_H   = 6;
SLOT_W   = 8;     // Phone slot width (fits most cases)
SLOT_D   = 12;

module yinyang_half() {
    // Classic yin-yang: half circle + two small circles
    rotate_extrude(angle = 180, $fn = 80)
        translate([D/4, 0])
            circle(r = D/4, $fn = 60);
    // Small dot (opposite color inclusion)
    translate([0, D/4, 0])
        cylinder(d = D/4, h = THICK, $fn = 40);
    // Hollow dot for white inclusion
    difference() {
        translate([0, -D/4, 0])
            cylinder(d = D/4, h = THICK, $fn = 40);
        translate([0, -D/4, -1])
            cylinder(d = D/8, h = THICK + 2, $fn = 30);
    }
}

module stand_base() {
    difference() {
        cylinder(d = BASE_D, h = BASE_H, $fn = 60);
        // Weight-saving pocket
        translate([0, 0, BASE_H/2])
            cylinder(d = BASE_D - 16, h = BASE_H, $fn = 60);
    }
}

module phone_slot() {
    translate([-SLOT_W/2, -D/2 - 2, THICK])
        cube([SLOT_W, SLOT_D + 2, 50]);
}

difference() {
    union() {
        linear_extrude(THICK) yinyang_half();
        // Lean-back post
        translate([0, -D/2, 0])
            rotate([-( 90 - ANGLE), 0, 0])
                cube([SLOT_W, THICK, D * 0.6], center = true);
    }
    phone_slot();
}
