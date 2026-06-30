// Flexi Dragon - Print-in-Place Articulated
// Each body segment is linked via snap joints — prints as one piece
// Print: 0.2mm, 3 walls, 15% infill, NO supports, print flat
// Scale up 150% for better joint clearance on first print

SEGMENTS   = 18;
SEG_W      = 14;
SEG_H      = 10;
SEG_DEPTH  = 9;
SEG_GAP    = 1.2;    // Joint play — key for flex
JOINT_D    = 6.0;
JOINT_PLAY = 0.4;
TAPER      = 0.88;   // Each segment shrinks by this factor

module joint_ball(d) {
    sphere(d = d, $fn = 24);
}

module joint_socket(d, play) {
    // Open socket — prints bridging, no support needed
    difference() {
        sphere(d = d + 4, $fn = 24);
        sphere(d = d + play, $fn = 24);
        translate([0, 0, -d]) cube([d*2, d*2, d*2], center = true); // open bottom
        translate([0, 0, d/2]) cube([d*2, d*2, d], center = true);  // open top
    }
}

module body_segment(w, h, depth) {
    hull() {
        translate([-w/2, -depth/2, 0]) cube([w, depth, h * 0.6]);
        translate([-w/2 * 0.7, -depth/2 * 0.7, h * 0.6])
            cube([w * 0.7, depth * 0.7, h * 0.4]);
    }
}

module spine_segment(i) {
    scale_f = pow(TAPER, i);
    w = SEG_W * scale_f;
    h = SEG_H * scale_f;
    d = SEG_DEPTH * scale_f;
    jd = JOINT_D * scale_f;

    translate([0, 0, 0]) {
        body_segment(w, h, d);
        // Ball forward
        translate([0, d/2 + SEG_GAP, h/2])
            joint_ball(jd);
        // Socket backward (receives ball from previous)
        if (i > 0)
            translate([0, -d/2 - SEG_GAP, h/2])
                joint_socket(JOINT_D * pow(TAPER, i-1), JOINT_PLAY);
    }
}

module head() {
    union() {
        // Snout
        hull() {
            cube([18, 22, 12], center = true);
            translate([0, 14, 2]) cube([10, 4, 8], center = true);
        }
        // Horns
        for (s = [-1, 1])
            translate([s * 6, -8, 8])
                rotate([20 * s, 0, 0])
                    cylinder(d1 = 4, d2 = 1, h = 16, $fn = 16);
        // Eye bumps
        for (s = [-1, 1])
            translate([s * 7, -4, 5])
                sphere(d = 5, $fn = 16);
    }
}

module tail_tip() {
    hull() {
        sphere(d = 6, $fn = 20);
        translate([0, 0, -12]) sphere(d = 2, $fn = 16);
    }
}

// Assemble full dragon along Y axis
union() {
    // Head
    translate([0, -SEG_DEPTH/2 - 8, SEG_H/2]) head();

    // Body segments
    y = 0;
    for (i = [0 : SEGMENTS - 1]) {
        sf = pow(TAPER, i);
        translate([0, i * (SEG_DEPTH * sf + SEG_GAP * 2), 0])
            spine_segment(i);
    }

    // Tail tip
    translate([0, SEGMENTS * (SEG_DEPTH * pow(TAPER, SEGMENTS/2) + SEG_GAP * 2) + 5, SEG_H * pow(TAPER, SEGMENTS)/2])
        tail_tip();
}
