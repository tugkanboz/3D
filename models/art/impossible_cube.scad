// Impossible Cube - Optical Illusion Sculpture
// Escher-style interlocking frame that looks impossible
// Print: 0.2mm, 4 walls, 20% infill, supports for overhangs
// Stunning as desk decor or gift

SIZE   = 60;
BAR_W  = 8;
NOTCH  = BAR_W / 2 + 0.25;  // Interlock clearance

module bar(length) {
    cube([BAR_W, BAR_W, length]);
}

module frame_ring(axis) {
    rotate(axis)
    union() {
        // 4 bars forming a square ring
        translate([0,      0,      0     ]) bar(SIZE);
        translate([SIZE - BAR_W, 0, 0     ]) bar(SIZE);
        translate([0,      0,      SIZE - BAR_W]) rotate([0,90,0]) bar(SIZE);
        translate([0,      SIZE - BAR_W, SIZE - BAR_W]) rotate([0,90,0]) bar(SIZE);
    }
}

module impossible_cube() {
    // Three interlocking square frames, one per axis
    // Notched so they pass through each other (optical trick at corners)
    difference() {
        union() {
            frame_ring([0,   0, 0]);
            frame_ring([90,  0, 0]);
            frame_ring([0,  90, 0]);
        }
        // Corner notches — each frame yields half the corner to the others
        for (x = [0, SIZE - BAR_W], y = [0, SIZE - BAR_W], z = [0, SIZE - BAR_W])
            translate([x, y, z])
                cube([BAR_W, BAR_W, BAR_W]);  // remove full corner overlap
    }
    // Re-add corner cubes as unified solid (impossible joint illusion)
    for (x = [0, SIZE - BAR_W], y = [0, SIZE - BAR_W], z = [0, SIZE - BAR_W])
        translate([x, y, z])
            cube([BAR_W, BAR_W, BAR_W]);
}

impossible_cube();
