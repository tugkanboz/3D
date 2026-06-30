// Infinity Knot Bracelet - Printable / Linkable
// Print flat, curve to wrist — PLA flex trick with thin walls
// Or print in TPU for true flex
// Print: 0.15mm, 2 walls, 10% infill

WRIST_C  = 180;   // Wrist circumference mm
BAND_W   = 12;
BAND_T   = 2.0;   // Thin = flexible when printed flat
KNOT_W   = 28;
KNOT_H   = 18;

RADIUS = WRIST_C / (2 * PI);

module band_segment(len) {
    cube([len, BAND_W, BAND_T], center = true);
}

module infinity_knot() {
    // Figure-8 lemniscate path, extruded
    steps = 80;
    a = KNOT_W / 2;
    b = KNOT_H / 2;

    for (i = [0 : steps - 1]) {
        t0 = i / steps * 2 * PI;
        t1 = (i + 1) / steps * 2 * PI;
        denom0 = 1 + pow(sin(t0 * 180/PI), 2);
        denom1 = 1 + pow(sin(t1 * 180/PI), 2);
        x0 = a * cos(t0 * 180/PI) / denom0;
        y0 = b * sin(t0 * 180/PI) * cos(t0 * 180/PI) / denom0;
        x1 = a * cos(t1 * 180/PI) / denom1;
        y1 = b * sin(t1 * 180/PI) * cos(t1 * 180/PI) / denom1;
        mid = [(x0+x1)/2, (y0+y1)/2, 0];
        ang = atan2(y1-y0, x1-x0);
        seg_len = sqrt(pow(x1-x0,2)+pow(y1-y0,2));
        translate(mid) rotate([0,0,ang])
            cube([seg_len+0.1, BAND_T * 1.8, BAND_T * 1.8], center=true);
    }
}

// Flat layout for printing — bend after
union() {
    // Band left
    translate([-(WRIST_C - KNOT_W * 1.5) / 4, 0, 0])
        band_segment((WRIST_C - KNOT_W * 1.5) / 2);
    // Knot center
    infinity_knot();
    // Band right
    translate([(WRIST_C - KNOT_W * 1.5) / 4, 0, 0])
        band_segment((WRIST_C - KNOT_W * 1.5) / 2);
    // Clasp bump (press-fit)
    translate([WRIST_C/2 - 8, 0, BAND_T/2])
        cylinder(d = 4, h = 3, $fn = 16);
    // Clasp hole
    translate([-(WRIST_C/2 - 8), 0, 0])
        cylinder(d = 4.4, h = BAND_T + 0.1, center = true, $fn = 16);
}
