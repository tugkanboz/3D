// Monstera Leaf Bowl / Tray
// Iconic tropical leaf shape — keys, coins, jewelry dish
// PLA/PETG — 0.2mm, 3 walls, 15% infill, no supports
// Print flat on bed — natural look, zero support needed

LEAF_L   = 200;  // Leaf length
LEAF_W   = 160;  // Max leaf width
BOWL_H   = 22;   // Rim height
WALL_T   = 2.5;
STEM_L   = 45;
STEM_D   = 10;

// Monstera leaf outline (simplified, stylized)
module leaf_2d() {
    scale([LEAF_L/200, LEAF_W/160])
    offset(r = 2)
    polygon([
        // Main lobe
        [0, 0], [20, 40], [10, 80], [30, 130], [50, 170],
        [80, 185], [100, 190], [120, 185], [145, 165],
        [160, 130], [170, 85], [155, 45], [130, 15],
        [100, 0], [80, 10], [60, 5],
        // Left lobes (characteristic splits)
        [55, 30], [35, 55], [20, 55], [15, 35],
        // Back to base
        [0, 0]
    ]);
}

module split_cutout(x, y, w, h, angle) {
    translate([x, y, -1])
        rotate([0, 0, angle])
            linear_extrude(BOWL_H + 2)
                scale([w, h])
                    circle(r = 1, $fn = 20);
}

module stem() {
    translate([-STEM_L, LEAF_W * 0.45, 0])
        rotate([0, 0, -10])
            cylinder(d1 = STEM_D * 0.7, d2 = STEM_D, h = BOWL_H, $fn = 20);
}

difference() {
    union() {
        // Bowl body from leaf outline
        linear_extrude(BOWL_H)
            leaf_2d();
        stem();
    }
    // Hollow interior
    translate([0, 0, WALL_T])
        linear_extrude(BOWL_H)
            offset(r = -WALL_T)
                leaf_2d();
    // Monstera splits (the characteristic holes)
    split_cutout(60,  80,  18, 30, 70);
    split_cutout(90,  55,  15, 25, 50);
    split_cutout(125, 70,  18, 28, 115);
    split_cutout(145, 100, 14, 22, 130);
    // Vein texture on top rim
    for (i = [0:6])
        translate([50 + i*18, 120 - i*8, BOWL_H - 1.2])
            rotate([0, 0, 60 + i*5])
                cube([40, 1.2, 2], center = true);
}
