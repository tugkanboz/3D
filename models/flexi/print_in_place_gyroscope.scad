// Print-in-Place Gyroscope / Gimbal
// 3 nested spinning rings — prints assembled, no glue
// Print: 0.15mm, 2 walls, 10% infill
// CRITICAL: 0.3mm clearance between rings

RING_COUNT = 3;
GAP        = 0.35;   // Ring clearance — increase if rings fuse
RING_T     = 3.5;    // Ring thickness
R0         = 10;     // Innermost sphere radius

module torus(r_major, r_minor) {
    rotate_extrude($fn = 64)
        translate([r_major, 0, 0])
            circle(r = r_minor, $fn = 20);
}

module ring(r, axis_r) {
    difference() {
        torus(r, RING_T);
        // Axle holes for pivots
        for (rot = [[0,0,0],[90,0,0]])
            rotate(rot)
                cylinder(d = axis_r * 2 + GAP * 2, h = r * 3, center = true, $fn = 20);
    }
}

module pivot_pin(r, h) {
    cylinder(d = r * 2, h = h, center = true, $fn = 20);
}

module gyroscope() {
    // Inner spinner sphere
    sphere(r = R0, $fn = 48);

    // 3 gimbal rings + pivot pins, nested with gaps
    for (i = [0 : RING_COUNT - 1]) {
        r_major = R0 + RING_T + (RING_T * 2 + GAP * 2) * i + GAP * (i + 1);

        // Alternate ring axis per level
        rotate([0, 0, i * 60])
            ring(r_major, RING_T * 0.4);

        // Pivot pins connecting to next outer ring
        if (i < RING_COUNT - 1) {
            next_r = R0 + RING_T + (RING_T * 2 + GAP * 2) * (i + 1) + GAP * (i + 2);
            rotate([0, 0, i * 60 + 30])
                for (s = [0, 180])
                    rotate([0, 0, s])
                        translate([r_major, 0, 0])
                            rotate([0, 90, 0])
                                pivot_pin(RING_T * 0.35, next_r - r_major + GAP);
        }
    }
}

gyroscope();
