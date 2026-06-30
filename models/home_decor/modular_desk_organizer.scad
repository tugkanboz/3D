// Modular Desk Organizer System
// Snap-together tiles — mix sizes to build your layout
// Print: 0.2mm, 3 walls, 15% infill, no supports

// Tile variants: S (1x1), M (1x2), L (2x2)
TILE = "L";  // "S", "M", or "L"

UNIT   = 80;    // Base grid unit
HEIGHT = 60;
WALL_T = 2.5;
CLIP_H = 8;
CLIP_D = 6;
CLIP_PLAY = 0.3;

W = (TILE == "M" || TILE == "L") ? UNIT * 2 : UNIT;
D = (TILE == "L") ? UNIT * 2 : UNIT;

module clip_male() {
    cylinder(d = CLIP_D, h = CLIP_H, $fn = 20);
    translate([0, 0, CLIP_H])
        cylinder(d1 = CLIP_D, d2 = CLIP_D - 2, h = 2, $fn = 20);
}

module clip_female() {
    cylinder(d = CLIP_D + CLIP_PLAY * 2, h = CLIP_H + 1, $fn = 20);
}

module tile_base() {
    difference() {
        cube([W, D, HEIGHT]);
        // Hollow
        translate([WALL_T, WALL_T, WALL_T])
            cube([W - 2*WALL_T, D - 2*WALL_T, HEIGHT]);
        // Front opening (access)
        translate([-1, D - WALL_T - 1, HEIGHT * 0.2])
            cube([W + 2, WALL_T + 2, HEIGHT]);
    }
}

module connectors() {
    // Male clips on right and back edges
    for (x = [UNIT/2 : UNIT : W])
        translate([x, D, CLIP_H/2])
            rotate([90, 0, 0]) clip_male();
    for (y = [UNIT/2 : UNIT : D])
        translate([W, y, CLIP_H/2])
            rotate([0, -90, 0]) clip_male();

    // Female sockets on left and front
    difference() {
        cube([0,0,0]); // placeholder
        for (x = [UNIT/2 : UNIT : W])
            translate([x, 0, CLIP_H/2])
                rotate([-90, 0, 0]) clip_female();
        for (y = [UNIT/2 : UNIT : D])
            translate([0, y, CLIP_H/2])
                rotate([0, 90, 0]) clip_female();
    }
}

difference() {
    union() {
        tile_base();
        connectors();
    }
    // Female socket cutouts
    for (x = [UNIT/2 : UNIT : W])
        translate([x, -1, CLIP_H/2])
            rotate([-90, 0, 0]) clip_female();
    for (y = [UNIT/2 : UNIT : D])
        translate([-1, y, CLIP_H/2])
            rotate([0, 90, 0]) clip_female();
}
