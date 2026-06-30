// Crystal Faceted Vase — Sculptural Object / Gift
// PETG (translucent filament = stunning light play)
// Single color, 0.15mm, 2 walls, 0% infill (hollow)
// Bed: fits P2S 256x256mm

SIDES      = 8;     // Facet count (6 = hexagonal, 8 = octagonal, 12 = crystal)
HEIGHT     = 220;
BASE_D     = 90;
NECK_D     = 40;
MID_D      = 105;   // Widest point
WALL       = 2.8;
BASE_H     = 12;
NECK_H     = 175;   // Height of widest point from bottom
OPENING_D  = 50;

// Profile control points [height_fraction, radius]
profile = [
    [0.00, BASE_D/2],
    [0.05, BASE_D/2 * 0.95],
    [0.15, MID_D/2 * 0.85],
    [0.35, MID_D/2],
    [0.55, MID_D/2 * 0.92],
    [0.70, MID_D/2 * 0.75],
    [0.80, NECK_D/2 * 1.3],
    [0.90, NECK_D/2],
    [0.97, OPENING_D/2 * 1.05],
    [1.00, OPENING_D/2]
];

module vase_shell() {
    segments = len(profile) - 1;
    difference() {
        // Outer faceted form
        union() {
            for (i = [0 : segments - 1]) {
                h0 = profile[i][0]   * HEIGHT;
                h1 = profile[i+1][0] * HEIGHT;
                r0 = profile[i][1];
                r1 = profile[i+1][1];
                // Each segment is a prism frustum
                translate([0, 0, h0])
                    cylinder(r1 = r0, r2 = r1, h = h1 - h0, $fn = SIDES);
            }
        }
        // Inner cavity
        translate([0, 0, BASE_H]) {
            for (i = [0 : segments - 1]) {
                h0 = profile[i][0]   * HEIGHT - BASE_H;
                h1 = profile[i+1][0] * HEIGHT - BASE_H;
                r0 = max(profile[i][1]   - WALL, 2);
                r1 = max(profile[i+1][1] - WALL, 2);
                translate([0, 0, h0])
                    cylinder(r1 = r0, r2 = r1, h = h1 - h0 + 0.1, $fn = SIDES);
            }
        }
        // Clean opening
        translate([0, 0, HEIGHT - 0.5])
            cylinder(d = OPENING_D + WALL * 0.5, h = 10, $fn = SIDES);
    }
    // Solid base cap
    cylinder(d = BASE_D * 0.9, h = BASE_H * 0.6, $fn = SIDES);
}

module facet_groove() {
    // Subtle vertical groove at each facet edge — catches light
    for (i = [0 : SIDES - 1])
        rotate([0, 0, i * 360/SIDES + 180/SIDES])
            translate([BASE_D/2 - 2, 0, 0])
                cylinder(d = 3, h = HEIGHT * 0.7, $fn = 8);
}

difference() {
    vase_shell();
    facet_groove();
}
