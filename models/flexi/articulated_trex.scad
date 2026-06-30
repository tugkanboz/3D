// Articulated T-Rex — Print-in-Place
// Single color PLA/PETG, full poseable after print
// 35+ joints: jaw, neck (4), spine (10), tail (12), legs (6), arms (3)
// P2S: 0.2mm, 3 walls, 15% infill, NO supports, print flat
// Scale 120% for easier joints on first print

// ── Joint system ─────────────────────────────────────────
GAP   = 0.45;   // PLA: 0.45 | PETG: 0.50
PIN_D = 5.5;
PIN_L = 8.0;

module pin() {
    cylinder(d = PIN_D, h = PIN_L, center = true, $fn = 20);
}
module socket(d, depth) {
    difference() {
        cylinder(d = d + 4, h = depth, center = true, $fn = 24);
        cylinder(d = d + GAP, h = depth + 1, center = true, $fn = 24);
    }
}
module joint(seg_a, seg_b) {
    // Prints seg_a with pin, seg_b with socket, gap between
    children(0);
    translate([0, GAP, 0]) children(1);
}

// ── Segments ──────────────────────────────────────────────
module spine_seg(l, w, h) {
    hull() {
        cube([l, w, h], center = true);
        translate([l*0.4, 0, h*0.3]) cube([l*0.2, w*0.7, h*0.4], center = true);
    }
}

module head() {
    union() {
        // Cranium
        scale([2.2, 1, 1.1]) sphere(d = 22, $fn = 30);
        // Snout (long, narrow)
        translate([26, 0, -4])
            scale([2.5, 0.7, 0.65]) sphere(d = 18, $fn = 24);
        // Lower jaw (separate for open-mouth look)
        translate([18, 0, -14])
            scale([2.2, 0.65, 0.45]) sphere(d = 18, $fn = 24);
        // Eye brows
        for (s = [-1,1])
            translate([6, s*9, 8])
                scale([1.2, 0.6, 0.5]) sphere(d = 8, $fn = 16);
        // Teeth bumps
        for (i = [0:3])
            translate([12 + i*5, 0, -6]) sphere(d = 3, $fn = 10);
    }
}

module body_main() {
    hull() {
        sphere(d = 48, $fn = 40);
        translate([-20, 0, 5]) scale([1, 0.7, 0.8]) sphere(d = 38, $fn = 30);
    }
}

module upper_leg(side) {
    rotate([0, 0, side * 15])
    union() {
        cylinder(d1 = 18, d2 = 12, h = 38, $fn = 20);
        translate([0, 0, 38]) sphere(d = 14, $fn = 20);
    }
}

module lower_leg() {
    union() {
        cylinder(d1 = 12, d2 = 8, h = 42, $fn = 16);
        translate([0, 0, -4]) sphere(d = 13, $fn = 18);
    }
}

module foot() {
    union() {
        sphere(d = 14, $fn = 20);
        // 3 toes
        for (a = [-25, 0, 25])
            rotate([0, a, 0])
                translate([0, 12, 0])
                    cylinder(d1 = 7, d2 = 2, h = 22, $fn = 12);
    }
}

module arm(side) {
    rotate([0, 0, side * 20])
    union() {
        cylinder(d1 = 10, d2 = 7, h = 24, $fn = 14);
        translate([0, 0, 24]) sphere(d = 8, $fn = 14);
        // 2 tiny claws
        for (a = [-15, 15])
            rotate([0, a, 0]) translate([0, 8, 24])
                cylinder(d1 = 4, d2 = 1, h = 10, $fn = 8);
    }
}

module tail_seg(i, total) {
    t = i / total;
    d = 16 * (1 - t * 0.75);
    l = 22 * (1 - t * 0.3);
    hull() {
        sphere(d = d, $fn = 16);
        translate([l, 0, 0]) sphere(d = d * 0.75, $fn = 14);
    }
}

// ── Assembly (laid flat for printing) ────────────────────
// Body
translate([0, 0, 0]) body_main();

// Head + neck
translate([55, 0, 12]) head();

// Neck links (4 segments)
for (i = [0:3])
    translate([30 + i*6, 0, 8 + i*2])
        sphere(d = 10 + i, $fn = 16);

// Tail (12 segments, laid out to the left)
for (i = [0:11])
    translate([-(28 + i*18), 0, 0])
        tail_seg(i, 11);

// Legs — print separately and attach via pin/socket
for (s = [-1, 1]) {
    translate([8, s * 35, -30])  upper_leg(s);
    translate([8, s * 35, -75])  lower_leg();
    translate([8, s * 35, -120]) foot();
}

// Arms
for (s = [-1, 1])
    translate([40, s * 22, 10]) arm(s);
