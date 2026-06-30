// Flexi Snake — DUAL COLOR
// File 1/2: Body segments (Color 1 — main snake color e.g. green)
// File 2/2: snake_dual_color_belly.scad (Color 2 — belly e.g. cream)
// 20 interlocking segments, fully poseable
// P2S: 0.2mm, 3 walls, 15% infill, print flat, NO supports

SEGMENTS = 22;
GAP      = 0.45;
SEG_L    = 18;
SEG_W    = 16;
SEG_H    = 10;
JOINT_D  = 7.0;
TAPER    = 0.96;

module scale_pattern(w, l, h) {
    // Embossed diamond scales on top surface
    for (xi = [0 : 5 : l-5])
        for (zi = [0 : 4 : h])
            translate([xi + (zi%8)*2.5, w/2, zi])
                rotate([90, 45, 0])
                    cylinder(d = 3.5, h = 0.6, $fn = 4);
}

module body_seg(i) {
    sf = pow(TAPER, i);
    w  = SEG_W * sf;
    l  = SEG_L * sf;
    h  = SEG_H * sf;
    jd = JOINT_D * sf;

    difference() {
        union() {
            // Upper body (Color 1)
            hull() {
                cube([l, w, h * 0.6], center = true);
                translate([0, 0, h * 0.2]) cube([l*0.8, w*0.8, h*0.4], center = true);
            }
            // Forward ball joint
            translate([l/2 + GAP, 0, 0]) sphere(d = jd, $fn = 20);
        }
        // Belly cutout (Color 2 fills this via separate file)
        translate([0, 0, -h*0.5])
            cube([l + 2, w - 4, h * 0.35], center = true);
        // Socket for previous segment's ball
        if (i > 0)
            translate([-(l/2 + GAP), 0, 0])
                sphere(d = JOINT_D * pow(TAPER, i-1) + GAP*2, $fn = 20);
    }

    // Scale emboss on top
    translate([-l/2, -w/2, h*0.25]) scale_pattern(w, l, h*0.4);
}

module head() {
    union() {
        // Head shape
        hull() {
            sphere(d = SEG_W * 1.4, $fn = 30);
            translate([SEG_L * 0.8, 0, 0]) scale([1.2, 0.8, 0.6])
                sphere(d = SEG_W, $fn = 24);
        }
        // Forked tongue
        translate([SEG_L * 1.3, 0, 0]) {
            cylinder(d = 2, h = 12, $fn = 8);
            for (s = [-1,1])
                translate([10, s*4, 12]) sphere(d = 2.5, $fn = 10);
        }
        // Eyes
        for (s = [-1,1])
            translate([SEG_L*0.3, s * SEG_W*0.45, SEG_H*0.3])
                sphere(d = 5, $fn = 16);
    }
}

// Layout along X
translate([-SEG_L * 0.8, 0, 0]) head();
for (i = [0 : SEGMENTS-1])
    translate([i * (SEG_L + GAP*2), 0, 0])
        body_seg(i);
