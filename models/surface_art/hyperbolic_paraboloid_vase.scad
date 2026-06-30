// Hyperbolic Paraboloid Saddle Vase — Pure Math Sculpture
// The "saddle" surface: z = x²/a² − y²/b² mapped onto a twist
// PETG translucent or silk PLA — 0.15mm, 2 walls, 0% infill
// Stunning with a candle or LED inside — ribs glow

HEIGHT   = 180;
BASE_D   = 70;
TOP_D    = 60;
RIBS     = 20;     // Number of vertical ribs
TWIST    = 90;     // Total twist angle (degrees) from base to top
RIB_W   = 4.0;
WALL_T   = 2.5;
FLOOR_T  = 5.0;
STEPS    = 60;     // Vertical resolution

module saddle_rib(rib_idx) {
    // Each rib follows a path that twists as it rises
    base_angle = rib_idx * 360 / RIBS;

    for (i = [0 : STEPS - 1]) {
        t0 = i / STEPS;
        t1 = (i+1) / STEPS;
        z0 = t0 * HEIGHT;
        z1 = t1 * HEIGHT;

        // Radius varies sinusoidally → saddle effect
        r0 = (BASE_D/2 + (TOP_D/2 - BASE_D/2) * t0)
             * (1 + 0.25 * sin(t0 * 180));
        r1 = (BASE_D/2 + (TOP_D/2 - BASE_D/2) * t1)
             * (1 + 0.25 * sin(t1 * 180));

        // Twist angle at each height
        a0 = base_angle + TWIST * t0;
        a1 = base_angle + TWIST * t1;

        p0 = [r0 * cos(a0), r0 * sin(a0), z0];
        p1 = [r1 * cos(a1), r1 * sin(a1), z1];

        hull() {
            translate(p0) sphere(d = RIB_W * (0.7 + 0.3 * sin(t0 * 360)), $fn = 10);
            translate(p1) sphere(d = RIB_W * (0.7 + 0.3 * sin(t1 * 360)), $fn = 10);
        }
    }
}

module vase() {
    // All ribs
    for (i = [0 : RIBS - 1]) saddle_rib(i);

    // Solid floor
    cylinder(d = BASE_D, h = FLOOR_T, $fn = 60);

    // Top rim ring
    translate([0, 0, HEIGHT - 4])
        difference() {
            cylinder(d = TOP_D + RIB_W, h = 4, $fn = 60);
            cylinder(d = TOP_D - WALL_T, h = 5, $fn = 60);
        }

    // Bottom connection ring
    difference() {
        cylinder(d = BASE_D + RIB_W, h = FLOOR_T + 8, $fn = 60);
        translate([0, 0, FLOOR_T])
            cylinder(d = BASE_D - WALL_T, h = 10, $fn = 60);
    }
}

vase();
