// Stacking Succulent Planters - Tiered Tower
// Self-draining: water flows down to next tier
// PETG recommended (water resistance), PLA works indoors
// 0.2mm, 4 walls, 20% infill — no supports if printed per-tier

TIERS     = 3;
D0        = 120;   // Bottom tier diameter
TAPER     = 0.75;  // Each tier shrinks by this
HEIGHT    = 65;    // Per-tier height
WALL_T    = 2.8;
DRAIN_D   = 12;
OFFSET    = 25;    // Horizontal offset per tier (cascade effect)
LIP_H     = 8;    // Insert lip that locks tiers together

module tier(d, h) {
    inner_d = d - WALL_T * 2;
    difference() {
        union() {
            // Outer pot
            cylinder(d1 = d * 0.85, d2 = d, h = h, $fn = 56);
            // Locking rim at top
            translate([0, 0, h - LIP_H])
                cylinder(d = d + WALL_T, h = LIP_H, $fn = 56);
        }
        // Inner cavity
        translate([0, 0, WALL_T])
            cylinder(d1 = inner_d * 0.85, d2 = inner_d, h = h, $fn = 56);
        // Central drain hole
        cylinder(d = DRAIN_D, h = WALL_T + 1, $fn = 24);
        // Locking socket (receives tier below's rim)
        cylinder(d = d * 0.85 - WALL_T, h = LIP_H + 1, $fn = 56);
    }
    // Interior drain pedestal (keeps roots from blocking drain)
    translate([0, 0, WALL_T])
        difference() {
            cylinder(d = DRAIN_D + WALL_T * 2, h = 10, $fn = 24);
            cylinder(d = DRAIN_D, h = 11, $fn = 24);
        }
    // Textured exterior ridges
    for (i = [0:7])
        rotate([0, 0, i * 45])
            translate([d/2 - 1, 0, 4])
                cylinder(d = 3, h = h - 8, $fn = 12);
}

// Stacked layout (each tier slightly offset for organic cascade look)
for (i = [0 : TIERS - 1]) {
    d = D0 * pow(TAPER, i);
    translate([i * OFFSET, i * OFFSET, i * (HEIGHT - LIP_H)])
        tier(d, HEIGHT);
}
