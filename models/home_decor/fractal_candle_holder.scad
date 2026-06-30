// Fractal Tree Candle / Tea-light Holder
// Silhouette of branching tree — light glows through gaps
// Print: 0.2mm, 2 walls, 0% infill (wall-only structure)
// Stunning with flickering tea-light inside

BASE_D   = 90;
BASE_H   = 8;
HEIGHT   = 140;
WALL_T   = 2.5;
CUP_D    = 42;    // Tea-light diameter + clearance
CUP_H    = 22;

// Fractal branch recursion
BRANCH_L0    = 50;
BRANCH_W0    = 6;
BRANCH_ANGLE = 38;
BRANCH_SCALE = 0.68;
MAX_DEPTH    = 5;

module branch(len, w, depth) {
    if (depth <= MAX_DEPTH && w > 0.8) {
        // This segment
        cylinder(d1 = w, d2 = w * BRANCH_SCALE, h = len, $fn = 10);

        // Two child branches
        translate([0, 0, len]) {
            rotate([0,  BRANCH_ANGLE, 30])
                branch(len * BRANCH_SCALE, w * BRANCH_SCALE, depth + 1);
            rotate([0, -BRANCH_ANGLE, -30])
                branch(len * BRANCH_SCALE * 0.9, w * BRANCH_SCALE * 0.9, depth + 1);
        }
    }
}

module tree_silhouette() {
    // Trunk
    cylinder(d1 = BRANCH_W0 * 2, d2 = BRANCH_W0, h = HEIGHT * 0.25, $fn = 12);
    translate([0, 0, HEIGHT * 0.25])
        branch(BRANCH_L0, BRANCH_W0, 0);
}

module outer_cylinder() {
    difference() {
        cylinder(d = BASE_D, h = HEIGHT, $fn = 64);
        translate([0, 0, WALL_T])
            cylinder(d = BASE_D - 2*WALL_T, h = HEIGHT, $fn = 64);
    }
}

module candle_cup() {
    difference() {
        cylinder(d = CUP_D + 2*WALL_T, h = CUP_H, $fn = 48);
        translate([0, 0, WALL_T])
            cylinder(d = CUP_D, h = CUP_H, $fn = 48);
    }
}

difference() {
    union() {
        // Solid base
        cylinder(d = BASE_D, h = BASE_H, $fn = 64);
        // Outer wall cylinder
        translate([0, 0, BASE_H]) outer_cylinder();
        // Tea-light cup in center
        translate([0, 0, BASE_H]) candle_cup();
    }
    // Cut tree silhouette windows through outer wall
    for (i = [0 : 2])
        rotate([0, 0, i * 120])
            translate([BASE_D * 0.3, 0, BASE_H + 5])
                scale([1, 0.4, 1])
                    tree_silhouette();
}
