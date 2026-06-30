// Toy Car - Printable in place (no supports, no assembly)
// Print: 0.2mm, 3 walls, 15% infill
// Scale: roughly 1:64 matchbox size

// ─── Dimensions ───────────────────────────────────────────
BODY_L = 80;
BODY_W = 34;
BODY_H = 16;

ROOF_L = 42;
ROOF_W = 30;
ROOF_H = 14;

WHEEL_D = 18;
WHEEL_W = 8;
AXLE_D  = 5;
AXLE_PLAY = 0.4;  // Clearance for rotating wheels

WHEEL_OFFSET_Z = WHEEL_D / 2 + 1;
FRONT_AXLE_X   = 16;
REAR_AXLE_X    = BODY_L - 16;

module body() {
    hull() {
        translate([10, 2, 0]) cube([BODY_L - 20, BODY_W - 4, BODY_H]);
        translate([0, 6, 4]) cube([BODY_L, BODY_W - 12, BODY_H - 4]);
    }
}

module roof() {
    translate([(BODY_L - ROOF_L)/2, (BODY_W - ROOF_W)/2, BODY_H])
        hull() {
            cube([ROOF_L, ROOF_W, 2]);
            translate([4, 4, ROOF_H - 2]) cube([ROOF_L - 8, ROOF_W - 8, 2]);
        }
}

module wheel() {
    difference() {
        union() {
            cylinder(d = WHEEL_D, h = WHEEL_W, $fn = 36);
            translate([0, 0, WHEEL_W/2 - 1])
                cylinder(d = WHEEL_D - 4, h = 2, $fn = 36); // hub detail
        }
        translate([0, 0, -1])
            cylinder(d = AXLE_D + AXLE_PLAY, h = WHEEL_W + 2, $fn = 24);
    }
}

module axle(length) {
    cylinder(d = AXLE_D, h = length, $fn = 20);
}

module car() {
    // Body + roof
    body();
    roof();

    // Wheel arches (cut from body visually — decorative)
    color("gray")
    for (x = [FRONT_AXLE_X, REAR_AXLE_X]) {
        translate([x, -1, WHEEL_OFFSET_Z])
            rotate([-90, 0, 0])
                cylinder(d = WHEEL_D + 2, h = BODY_W + 2, $fn = 36);
    }

    // Axles
    for (x = [FRONT_AXLE_X, REAR_AXLE_X]) {
        translate([x, -2, WHEEL_OFFSET_Z])
            rotate([-90, 0, 0])
                axle(BODY_W + 4);
    }

    // Wheels (left + right, front + rear)
    for (x = [FRONT_AXLE_X, REAR_AXLE_X]) {
        // Left
        translate([x, -2 - WHEEL_W, WHEEL_OFFSET_Z])
            rotate([-90, 0, 0])
                wheel();
        // Right
        translate([x, BODY_W + 2, WHEEL_OFFSET_Z])
            rotate([90, 0, 0])
                wheel();
    }
}

difference() {
    car();
    // Wheel arch cutouts
    for (x = [FRONT_AXLE_X, REAR_AXLE_X]) {
        translate([x, -2, WHEEL_OFFSET_Z])
            rotate([-90, 0, 0])
                cylinder(d = WHEEL_D + 2, h = BODY_W + 4, $fn = 36);
    }
}
