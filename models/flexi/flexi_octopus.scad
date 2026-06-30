// Flexi Octopus - Print-in-Place, Wiggly Tentacles
// One of the most-printed flexi models on MakerWorld & Printables
// Print: 0.2mm, 3 walls, 15% infill, NO supports
// Best in TPU or PLA — TPU gives better flex

TENTACLES   = 8;
TENT_SEGS   = 10;
BODY_D      = 50;
BODY_H      = 35;
TENT_W0     = 8;    // Tentacle base width
TENT_W1     = 2;    // Tentacle tip width
TENT_H      = 8;    // Segment height
SEG_GAP     = 1.0;  // Joint clearance
JOINT_D     = 5.0;
JOINT_PLAY  = 0.5;

module body() {
    difference() {
        union() {
            // Main dome
            scale([1, 1, 1.1])
                sphere(d = BODY_D, $fn = 48);
            // Mantle bump
            translate([0, 0, BODY_D * 0.45])
                scale([0.5, 0.5, 0.8])
                    sphere(d = BODY_D, $fn = 32);
        }
        // Cut flat bottom for bed adhesion
        translate([0, 0, -BODY_D]) cube([BODY_D*2, BODY_D*2, BODY_D*1.5], center = true);
    }
    // Eyes
    for (s = [-1, 1])
        translate([s * 12, BODY_D/2 - 6, 6]) {
            sphere(d = 10, $fn = 24);
            translate([0, 3, 0]) sphere(d = 6, $fn = 20); // pupil bump
        }
}

module tent_segment(i, total, r_base) {
    t = i / total;
    w = TENT_W0 * (1 - t * 0.7);
    rotate([0, 0, 0])
    difference() {
        union() {
            cylinder(d1 = w, d2 = w * 0.85, h = TENT_H, $fn = 16);
            // Ball joint on top
            translate([0, 0, TENT_H])
                sphere(d = JOINT_D * (1 - t * 0.3), $fn = 20);
        }
        // Socket for ball below (printed as bridging gap)
        if (i > 0)
            translate([0, 0, -SEG_GAP/2])
                sphere(d = JOINT_D * (1 - (i-1)/total * 0.3) + JOINT_PLAY, $fn = 20);
    }
}

module tentacle(angle) {
    rotate([0, 0, angle])
        translate([BODY_D * 0.3, 0, -2])
            for (i = [0 : TENT_SEGS - 1]) {
                translate([0, 0, i * (TENT_H + SEG_GAP)])
                    rotate([8 * i, 0, 0])   // curl outward
                        tent_segment(i, TENT_SEGS, BODY_D * 0.3);
            }
}

union() {
    body();
    for (i = [0 : TENTACLES - 1])
        tentacle(i * 360 / TENTACLES);
}
