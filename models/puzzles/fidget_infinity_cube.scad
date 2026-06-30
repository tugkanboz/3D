// Fidget Infinity Cube - 8 Hinged Cubes
// Each pair folds 360°, the set folds infinitely
// Print: 0.15mm, 3 walls, 30% infill
// CRITICAL: print hinge pairs together with 0.3mm gap

CUBE_S    = 28;    // Each sub-cube size
HINGE_D   = 4.0;  // Hinge pin diameter
HINGE_GAP = 0.3;  // Print-in-place clearance
HINGE_W   = 5.0;  // Hinge flange width

module sub_cube() {
    difference() {
        cube([CUBE_S, CUBE_S, CUBE_S]);
        // Hollow for weight / feel
        translate([3, 3, 3])
            cube([CUBE_S - 6, CUBE_S - 6, CUBE_S - 6]);
    }
}

module hinge_pin() {
    cylinder(d = HINGE_D, h = HINGE_W * 2 + HINGE_GAP, center = true, $fn = 20);
}

module hinge_socket() {
    difference() {
        cylinder(d = HINGE_D + 3.5, h = HINGE_W, center = true, $fn = 24);
        cylinder(d = HINGE_D + HINGE_GAP, h = HINGE_W + 1, center = true, $fn = 20);
    }
}

// One hinged pair — print these together
// Pair layout: two cubes side by side with hinge at shared edge
module hinge_pair(pair_idx) {
    // Cube A
    translate([0, 0, 0]) {
        sub_cube();
        // Hinge pins protruding from right face
        for (z = [CUBE_S * 0.3, CUBE_S * 0.7])
            translate([CUBE_S, HINGE_W/2, z])
                rotate([0, 90, 0]) hinge_pin();
    }

    // Cube B — gap = HINGE_GAP from cube A edge
    translate([CUBE_S + HINGE_GAP + 1, 0, 0]) {
        difference() {
            sub_cube();
            // Socket holes to receive pins
            for (z = [CUBE_S * 0.3, CUBE_S * 0.7])
                translate([-1, HINGE_W/2, z])
                    rotate([0, 90, 0])
                        cylinder(d = HINGE_D + HINGE_GAP, h = HINGE_W + 2, $fn = 20);
        }
    }
}

// Print 4 pairs
for (i = [0 : 3])
    translate([i * (CUBE_S * 2 + 8), 0, 0])
        hinge_pair(i);
