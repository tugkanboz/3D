// Geometric Mandala Wall Art — DUAL COLOR
// File 2/2: Mandala pattern overlay (Color 2 — bold accent PLA)
// Sits in pocket of mandala_wall_art_base.scad, 0.4mm proud
// P2S AMS: assign accent filament (gold, red, teal, etc.)

D       = 200;
H       = 1.2;    // Overlay height (0.8 in pocket + 0.4 proud)
WALL_T  = 2.5;
R       = D/2 - WALL_T;

RINGS   = 6;
PETALS  = 12;

module petal(r_in, r_out, angle_w) {
    intersection() {
        difference() {
            cylinder(r = r_out, h = H, $fn = 80);
            cylinder(r = r_in,  h = H, $fn = 80);
        }
        rotate([0, 0, -angle_w/2])
            linear_extrude(H)
                polygon([[0,0],
                         [r_out*2*cos( angle_w/2), r_out*2*sin( angle_w/2)],
                         [r_out*2*cos(-angle_w/2), r_out*2*sin(-angle_w/2)]]);
    }
}

module ring_of_petals(r_in, r_out, n, rot_offset) {
    for (i = [0 : n-1])
        rotate([0, 0, i * 360/n + rot_offset])
            petal(r_in, r_out, 360/n * 0.55);
}

union() {
    // Center rosette
    cylinder(d = 18, h = H, $fn = 6);

    // Radiating rings — alternating petal patterns
    ring_of_petals(10,  30,  6,  0);
    ring_of_petals(32,  50,  12, 15);
    ring_of_petals(52,  68,  8,  22);
    ring_of_petals(70,  86,  16, 11);
    ring_of_petals(88,  102, 12, 7);
    ring_of_petals(104, 116, 20, 9);

    // Outer border ring
    difference() {
        cylinder(r = R,     h = H, $fn = 120);
        cylinder(r = R - 4, h = H, $fn = 120);
    }

    // Spoke lines connecting rings
    for (i = [0 : PETALS - 1])
        rotate([0, 0, i * 360/PETALS])
            translate([14, -0.8, 0])
                cube([R - 18, 1.6, H]);
}
