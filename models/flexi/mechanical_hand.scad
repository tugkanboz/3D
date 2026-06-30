// Articulated Mechanical Hand — Tendon-Actuated
// Pull fishing line through channels → fingers curl
// PLA/PETG — 0.2mm, 4 walls, 25% infill
// Print flat on bed, NO supports
// Each finger has 3 phalanges + print-in-place knuckle joints

GAP      = 0.45;
KNUCKLE_D = 7.0;

// ── Phalange (finger segment) ───────────────────────────
module phalange(l, w, h, is_tip) {
    difference() {
        union() {
            hull() {
                cube([l, w, h]);
                translate([l*0.1, w*0.1, h]) cube([l*0.8, w*0.8, h*0.1]);
            }
            // Distal ball joint
            if (!is_tip)
                translate([l + GAP, w/2, h/2])
                    sphere(d = KNUCKLE_D, $fn = 20);
        }
        // Proximal socket
        translate([-GAP, w/2, h/2])
            sphere(d = KNUCKLE_D + GAP*2, $fn = 20);
        // Tendon channel (for fishing line)
        translate([l/2, w/2, -1])
            cylinder(d = 2.2, h = h + 2, $fn = 12);
        // Fingertip groove
        if (is_tip)
            translate([l * 0.6, w/2, h - 1])
                rotate([90, 0, 0])
                    cylinder(d = 3, h = w + 1, center = true, $fn = 16);
    }
    // Knuckle hinge detail
    if (!is_tip)
        for (s = [-1, 1])
            translate([l + GAP, w/2 + s*(KNUCKLE_D/2 + 1.5), h/2])
                rotate([90, 0, 0])
                    cylinder(d = 2, h = 2, $fn = 12);
}

// ── Full finger (3 phalanges) ──────────────────────────
module finger(total_l, base_w) {
    SEG = 3;
    lens = [total_l * 0.45, total_l * 0.33, total_l * 0.22];
    for (i = [0 : SEG-1]) {
        ox = (i == 0) ? 0 : lens[0] + GAP*2 + (i > 1 ? lens[1] + GAP*2 : 0);
        translate([ox, 0, 0])
            phalange(lens[i], base_w * (1 - i*0.08), 12 - i, i == SEG-1);
    }
}

// ── Palm ──────────────────────────────────────────────
module palm() {
    difference() {
        hull() {
            cube([80, 70, 14]);
            translate([5, 5, 14]) cube([70, 60, 4]);
        }
        // Tendon channels through palm
        for (x = [10, 26, 42, 58, 72])
            translate([x, 35, -1])
                cylinder(d = 2.2, h = 20, $fn = 12);
        // Weight relief
        translate([10, 10, 4])
            cube([60, 50, 18]);
    }
}

// ── Assembly layout ────────────────────────────────────
palm();

// 4 fingers (index to pinky) — print alongside palm
FINGER_DATA = [
//  [x_offset, length, width]
    [90,  58, 16],   // index
    [90,  64, 15],   // middle
    [90,  60, 14],   // ring
    [90,  50, 12],   // pinky
];
for (i = [0:3])
    translate([FINGER_DATA[i][0], i * 20, 0])
        finger(FINGER_DATA[i][1], FINGER_DATA[i][2]);

// Thumb (shorter, angled)
translate([90, 88, 0]) rotate([0, 0, -20])
    finger(44, 18);
