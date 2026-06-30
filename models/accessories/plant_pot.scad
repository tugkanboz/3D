// Geometric Planter - Hexagonal Low Poly
// Trending on Etsy & MakerWorld — sells for $12-25
// Print: 0.2mm, 3 walls, 15% infill, no supports
// Use vase mode for thin walls (1 wall, 0 top layers)

VASE_MODE  = false;  // Set true to slice in vase mode

TOP_D    = 90;
BOT_D    = 60;
HEIGHT   = 100;
WALL_T   = 3;
DRAIN_D  = 8;
FACETS   = 6;       // 6 = hexagon, 8 = octagon, 5 = pentagon

module pot_outer() {
    cylinder(d1 = BOT_D, d2 = TOP_D, h = HEIGHT, $fn = FACETS);
}

module pot_inner() {
    translate([0, 0, WALL_T])
        cylinder(d1 = BOT_D - 2*WALL_T, d2 = TOP_D - 2*WALL_T,
                 h = HEIGHT, $fn = FACETS);
}

module drainage_holes() {
    count = 3;
    for (i = [0 : count - 1])
        rotate([0, 0, i * 360/count])
            translate([BOT_D/4, 0, -1])
                cylinder(d = DRAIN_D, h = WALL_T + 2, $fn = 16);
}

if (VASE_MODE) {
    pot_outer();
} else {
    difference() {
        pot_outer();
        pot_inner();
        drainage_holes();
    }
}
