// Spiral Tower Vase / Sculpture
// Mathematical helicoid — zero infill, vase mode
// Print: 0.2mm, 1 wall, VASE MODE ON
// Mesmerizing on a shelf, popular on MakerWorld

TURNS    = 4;       // Full spiral rotations
HEIGHT   = 200;     // mm
R_BASE   = 45;      // Bottom radius
R_TOP    = 25;      // Top radius
BLADE_W  = 3;       // Spiral blade thickness
STEPS    = 300;     // Resolution — higher = smoother

CORE_D   = 12;      // Central column diameter

module spiral_blade() {
    for (i = [0 : STEPS - 1]) {
        t0 = i / STEPS;
        t1 = (i + 1) / STEPS;
        h0 = HEIGHT * t0;
        h1 = HEIGHT * t1;
        a0 = TURNS * 360 * t0;
        a1 = TURNS * 360 * t1;
        r0 = R_BASE + (R_TOP - R_BASE) * t0;
        r1 = R_BASE + (R_TOP - R_BASE) * t1;

        hull() {
            translate([r0 * cos(a0), r0 * sin(a0), h0])
                sphere(d = BLADE_W, $fn = 8);
            translate([r1 * cos(a1), r1 * sin(a1), h1])
                sphere(d = BLADE_W * 0.9, $fn = 8);
            // Connect to core
            translate([CORE_D/2 * cos(a0), CORE_D/2 * sin(a0), h0])
                sphere(d = BLADE_W, $fn = 8);
            translate([CORE_D/2 * cos(a1), CORE_D/2 * sin(a1), h1])
                sphere(d = BLADE_W * 0.9, $fn = 8);
        }
    }
}

module core_column() {
    cylinder(d = CORE_D, h = HEIGHT, $fn = 32);
}

union() {
    core_column();
    spiral_blade();
    // Solid base disc
    cylinder(d = R_BASE * 2, h = 4, $fn = 64);
}
