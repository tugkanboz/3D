// Castle Gateway Book Nook — LED-Lit Miniature Scene
// Insert between books on shelf; LED strip inside illuminates scene
// DUAL COLOR: stone walls (grey PLA) | windows + details (dark PLA)
// PLA — 0.15mm, 4 walls, 20% infill
// Hardware: 5V USB LED strip (cut to 3 LEDs), hot glue

NOOK_W   = 70;   // Width (fits between books)
NOOK_D   = 120;  // Depth (into shelf)
NOOK_H   = 200;  // Height
WALL_T   = 4.0;
STONE_T  = 2.0;  // Stone texture depth
ARCH_W   = 38;
ARCH_H   = 55;
TOWER_W  = 22;
TOWER_H  = NOOK_H + 30;
BATTL_W  = 8;    // Battlement tooth width
BATTL_H  = 12;
BATTL_GAP = 8;
LED_GROOVE = 5;  // LED strip groove width

// ── Stone texture (on faces) ──────────────────────────
module stone_course(w, h) {
    // Alternating brick courses
    BRICK_W = 18; BRICK_H = 9;
    for (row = [0 : floor(h/BRICK_H)])
        for (col = [0 : floor(w/BRICK_W) + 1]) {
            offset = (row % 2) * BRICK_W / 2;
            bx = col * BRICK_W - offset;
            by = row * BRICK_H;
            if (bx > -1 && bx < w + 1)
                translate([bx, by, -STONE_T])
                    cube([BRICK_W - 1.5, BRICK_H - 1.5, STONE_T + 0.1]);
        }
}

// ── Main gatehouse body ───────────────────────────────
module gatehouse() {
    difference() {
        union() {
            // Main wall slab
            cube([NOOK_W, WALL_T, NOOK_H]);
            // Side walls (create 3D depth)
            cube([WALL_T, NOOK_D, NOOK_H]);
            translate([NOOK_W - WALL_T, 0, 0])
                cube([WALL_T, NOOK_D, NOOK_H]);
            // Back wall
            translate([0, NOOK_D - WALL_T, 0])
                cube([NOOK_W, WALL_T, NOOK_H]);
            // Floor
            cube([NOOK_W, NOOK_D, WALL_T]);
        }
        // Arched gateway opening (front wall)
        translate([NOOK_W/2 - ARCH_W/2, -1, 0])
            union() {
                cube([ARCH_W, WALL_T + 2, ARCH_H - ARCH_W/2]);
                translate([ARCH_W/2, 0, ARCH_H - ARCH_W/2])
                    rotate([90, 0, 0])
                        cylinder(d = ARCH_W, h = WALL_T + 2, $fn = 32);
            }
        // Portcullis slot
        translate([NOOK_W/2 - ARCH_W/2 + 3, -1, ARCH_H])
            cube([ARCH_W - 6, WALL_T + 2, 15]);
        // Arrow slit windows (side walls)
        for (d = [NOOK_D*0.35, NOOK_D*0.65], z = [NOOK_H*0.45, NOOK_H*0.7])
            translate([-1, d, z])
                cube([WALL_T + 2, 6, 18]);
        // LED channel (back wall, horizontal)
        translate([5, NOOK_D - WALL_T - 1, NOOK_H * 0.6])
            cube([NOOK_W - 10, LED_GROOVE, LED_GROOVE]);
        // Cable exit hole
        translate([NOOK_W/2 - 3, NOOK_D - 1, NOOK_H * 0.1])
            cube([6, WALL_T + 1, 4]);
    }
    // Stone texture (raised on front face)
    translate([0, WALL_T, 0])
        stone_course(NOOK_W, NOOK_H);
}

// ── Towers ────────────────────────────────────────────
module tower(x_pos) {
    translate([x_pos - TOWER_W/2, -TOWER_W * 0.3, 0]) {
        difference() {
            cylinder(d = TOWER_W, h = TOWER_H, $fn = 16);
            // Window openings
            for (z = [NOOK_H * 0.3, NOOK_H * 0.55, NOOK_H * 0.75])
                translate([0, TOWER_W/2 - 1, z])
                    rotate([-90, 0, 0])
                        union() {
                            cube([5, 14, WALL_T + 1], center = true);
                            translate([0, 7, 0])
                                cylinder(d = 5, h = WALL_T + 1, $fn = 10);
                        }
        }
        // Battlements (merlons)
        for (i = [0 : 5]) {
            a = i * 60;
            translate([cos(a) * (TOWER_W/2 - 2), sin(a) * (TOWER_W/2 - 2), TOWER_H])
                cube([BATTL_W, BATTL_W, BATTL_H], center = true);
        }
    }
}

// ── Main battlements (top of gate wall) ───────────────
module wall_battlements() {
    n = floor((NOOK_W - 10) / (BATTL_W + BATTL_GAP));
    spacing = (NOOK_W - 10) / n;
    for (i = [0 : n - 1])
        translate([5 + i * spacing, 0, NOOK_H])
            cube([BATTL_W, WALL_T, BATTL_H]);
}

// ── Portcullis (decorative, Color 2) ──────────────────
module portcullis() {
    // Grid of vertical + horizontal bars
    for (x = [0 : 3])
        translate([NOOK_W/2 - ARCH_W/2 + 4 + x * 8, 0, ARCH_H - 2])
            cube([2.5, WALL_T, -(ARCH_H - 10)]);
    for (z = [0, 12, 24])
        translate([NOOK_W/2 - ARCH_W/2 + 4, 0, ARCH_H - 10 - z])
            cube([ARCH_W - 8, WALL_T, 2.5]);
    // Spikes at bottom
    for (x = [0 : 3])
        translate([NOOK_W/2 - ARCH_W/2 + 5.25 + x * 8, 0, ARCH_H - 10 - 24])
            cylinder(d1 = 0, d2 = 2.5, h = 8, $fn = 4);
}

// ── Miniature scene (inside — visible through arch) ───
module interior_scene() {
    // Cobblestone path
    translate([NOOK_W * 0.1, WALL_T + 2, WALL_T])
        for (row = [0:5], col = [0:3])
            translate([col * 14 + (row%2)*7, row * 10, 0])
                cylinder(d = 12, h = 1.2, $fn = 6);
    // Torch brackets on side walls
    for (z = [NOOK_H * 0.35, NOOK_H * 0.6])
        translate([WALL_T, NOOK_D * 0.3, z]) {
            cube([3, 5, 8]);
            translate([0, 2, 8])
                cylinder(d = 3, h = 12, $fn = 10);
            translate([0, 2, 20])
                sphere(d = 6, $fn = 12);
        }
    // Treasure chest (back of nook)
    translate([NOOK_W/2 - 8, NOOK_D * 0.7, WALL_T]) {
        cube([16, 12, 10]);
        translate([0, 0, 10])
            rotate([-15, 0, 0])
                cube([16, 12, 5]);
        // Lock
        translate([7, 12, 5]) sphere(d = 4, $fn = 10);
    }
}

// Color 1 (grey PLA): walls
gatehouse();
tower(0);
tower(NOOK_W);
wall_battlements();
// Color 2 (dark PLA): portcullis + interior detail
translate([0, WALL_T, 0]) portcullis();
interior_scene();
