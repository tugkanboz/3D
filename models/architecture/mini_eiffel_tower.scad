// Eiffel Tower Miniature - Desk Decor
// PLA — 0.15mm, 4 walls, 20% infill
// Print vertically — tall + thin, use brim for adhesion
// ~22cm tall at 1:1500 scale

HEIGHT   = 220;
BASE_W   = 80;
LEVEL1_H = 60;   // First floor
LEVEL2_H = 110;  // Second floor
TOP_W    = 6;
LEG_T    = 4.5;
TRUSS_T  = 2.2;
ARCH_T   = 3.0;

module leg(from_w, to_w, h, t) {
    hull() {
        translate([from_w/2, 0, 0]) cylinder(d = t, h = 1, $fn = 12);
        translate([to_w/2,  0, h]) cylinder(d = t * 0.7, h = 1, $fn = 12);
    }
}

module truss_ring(w, z, t) {
    for (i = [0:3])
        rotate([0, 0, i * 90])
            translate([w/2, 0, z])
                rotate([0, 90, 0])
                    cylinder(d = t, h = w, $fn = 10);
}

module diagonal_bracing(w0, w1, z0, z1, t) {
    for (i = [0:3])
        rotate([0, 0, i * 90]) {
            hull() {
                translate([w0/2, -w0/8, z0]) sphere(d = t, $fn = 8);
                translate([w1/2,  w1/8, z1]) sphere(d = t, $fn = 8);
            }
            hull() {
                translate([w0/2,  w0/8, z0]) sphere(d = t, $fn = 8);
                translate([w1/2, -w1/8, z1]) sphere(d = t, $fn = 8);
            }
        }
}

module base_arch(w, h, t) {
    for (i = [0:3])
        rotate([0, 0, i * 90])
            translate([0, 0, 0])
                rotate([90, 0, 0])
                    difference() {
                        cylinder(d = w * 0.95, h = t, center = true, $fn = 40);
                        cylinder(d = w * 0.95 - t*2, h = t+1, center = true, $fn = 40);
                        translate([-w, -w, -t]) cube([w*2, w, t*2]);
                    }
}

union() {
    // Base platform
    cube([BASE_W, BASE_W, 4], center = true);

    // 4 Legs (base to level 1)
    for (i = [0:3])
        rotate([0, 0, i*90 + 45])
            translate([0, 0, 4])
                leg(BASE_W * 0.65, BASE_W * 0.2, LEVEL1_H, LEG_T);

    // Arch between legs at base
    translate([0, 0, 4]) base_arch(BASE_W * 0.55, 20, ARCH_T);

    // Level 1 ring
    truss_ring(BASE_W * 0.4, LEVEL1_H, TRUSS_T * 1.4);

    // Level 1 to Level 2
    for (i = [0:3])
        rotate([0, 0, i*90 + 45])
            translate([0, 0, LEVEL1_H])
                leg(BASE_W * 0.4, BASE_W * 0.1, LEVEL2_H - LEVEL1_H, LEG_T * 0.75);

    diagonal_bracing(BASE_W * 0.4, BASE_W * 0.1,
                     LEVEL1_H, LEVEL2_H - 5, TRUSS_T);

    // Level 2 ring
    truss_ring(BASE_W * 0.18, LEVEL2_H, TRUSS_T);

    // Spire (level 2 to top)
    translate([0, 0, LEVEL2_H])
        cylinder(d1 = BASE_W * 0.15, d2 = TOP_W, h = HEIGHT - LEVEL2_H, $fn = 20);

    // Antenna tip
    translate([0, 0, HEIGHT])
        cylinder(d1 = TOP_W, d2 = 1, h = 18, $fn = 12);
}
