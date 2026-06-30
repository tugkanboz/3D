// Roman Colosseum Miniature — Desk Centerpiece
// 3-tier elliptical arcade structure, highly detailed
// PLA — 0.15mm, 4 walls, 20% infill
// ~180mm diameter, fits P2S bed

TIERS      = 3;
BASE_RX    = 88;   // X radius (ellipse)
BASE_RY    = 70;   // Y radius (ellipse)
TIER_H     = 22;
WALL_T     = 3.0;
ARCH_W     = 12;
ARCH_H     = 16;
ARCHES     = 24;   // Arches per tier
PILLAR_W   = 5;
FLOOR_T    = 4;
INNER_SCALE = 0.82; // Inner ellipse scale factor

module ellipse_ring(rx, ry, h, wall) {
    difference() {
        scale([rx, ry, 1]) cylinder(r = 1, h = h, $fn = 80);
        translate([0, 0, -1])
            scale([rx - wall, ry - wall, 1]) cylinder(r = 1, h = h + 2, $fn = 80);
    }
}

module arch_cutout(rx, ry, arches, arch_w, arch_h, offset_h) {
    // Place arch openings around the ellipse
    for (i = [0 : arches - 1]) {
        angle = i * 360 / arches;
        x = cos(angle) * rx;
        y = sin(angle) * ry;
        // Normal to ellipse surface
        nx = cos(angle) * ry;
        ny = sin(angle) * rx;
        len = sqrt(nx*nx + ny*ny);
        rot = atan2(ny/len, nx/len);
        translate([x, y, offset_h])
            rotate([0, 0, rot + 90]) {
                // Arch = rectangle + half-cylinder
                translate([-arch_w/2, -WALL_T - 1, 0])
                    cube([arch_w, WALL_T + 2, arch_h - arch_w/2]);
                translate([0, 0, arch_h - arch_w/2])
                    rotate([-90, 0, 0])
                        cylinder(d = arch_w, h = WALL_T + 2, $fn = 16);
            }
    }
}

module tier(rx, ry, tier_num) {
    h = TIER_H;
    offset = tier_num * TIER_H;
    shrink = 1 - tier_num * 0.12;

    difference() {
        union() {
            // Outer wall
            translate([0, 0, offset])
                ellipse_ring(rx * shrink, ry * shrink, h, WALL_T);
            // Floor slab
            translate([0, 0, offset])
                difference() {
                    scale([rx * shrink, ry * shrink, 1]) cylinder(r = 1, h = FLOOR_T, $fn = 80);
                    translate([0, 0, -1])
                        scale([(rx * shrink - WALL_T * 2.5), (ry * shrink - WALL_T * 2.5), 1])
                            cylinder(r = 1, h = FLOOR_T + 2, $fn = 80);
                }
        }
        // Arch openings
        arch_cutout(rx * shrink, ry * shrink, ARCHES - tier_num * 2,
                    ARCH_W - tier_num * 1.5, ARCH_H - tier_num * 2, offset + FLOOR_T);
    }
}

module attic_story() {
    shrink = 1 - TIERS * 0.12;
    offset = TIERS * TIER_H;
    difference() {
        translate([0, 0, offset])
            ellipse_ring(BASE_RX * shrink, BASE_RY * shrink, 14, WALL_T * 1.5);
        // Small rectangular windows
        for (i = [0 : 31])
            translate([cos(i * 11.25) * BASE_RX * shrink,
                       sin(i * 11.25) * BASE_RY * shrink, offset + 6])
                rotate([0, 0, i * 11.25 + 90])
                    cube([6, WALL_T * 2 + 1, 7], center = true);
    }
}

module arena_floor() {
    // Elliptical arena floor with cross pattern
    difference() {
        scale([BASE_RX * 0.55, BASE_RY * 0.55, 1]) cylinder(r = 1, h = 2, $fn = 60);
        // Cross channel (gladiator gate trenches)
        cube([BASE_RX * 1.1, 5, 3], center = true);
        rotate([0, 0, 90]) cube([BASE_RY * 1.1, 5, 3], center = true);
    }
}

module colosseum() {
    for (t = [0 : TIERS - 1]) tier(BASE_RX, BASE_RY, t);
    attic_story();
    arena_floor();
    // Base plinth
    translate([0, 0, -6])
        difference() {
            scale([BASE_RX + 10, BASE_RY + 10, 1]) cylinder(r = 1, h = 6, $fn = 80);
            translate([0, 0, 2])
                scale([BASE_RX + 5, BASE_RY + 5, 1]) cylinder(r = 1, h = 6, $fn = 80);
        }
}

colosseum();
