// Modular Hex Terrain Tiles — DnD / Tabletop RPG Gaming
// 4 tile types: plains, forest, mountain, water
// Snap-fit edge tabs — tiles interlock without glue
// DUAL COLOR: base terrain (earthy PLA) | features (accent color)
// PLA — 0.2mm, 3 walls, 15% infill
// Standard 4" hex (100mm flat-to-flat), 25mm tall

HEX_R    = 58;    // Hex circumradius (100mm FTF = ~115mm circumradius)
HEX_FTF  = 100;   // Flat-to-flat
HEX_H    = 22;    // Tile height
WALL_T   = 3.0;
TAB_W    = 12;    // Edge tab width
TAB_H    = 4.5;   // Tab height (snap height)
TAB_D    = 3.0;   // Tab depth
CLEAR    = 0.4;   // Tab clearance

R = HEX_FTF / 2 / cos(30);  // Circumradius from FTF

// ── Hexagon base ──────────────────────────────────────
module hex_base(r, h) {
    cylinder(r = r, h = h, $fn = 6);
}

// ── Edge snap tabs ─────────────────────────────────────
module edge_tabs(r, h, male = true) {
    for (i = [0:5]) {
        rotate([0, 0, i * 60 + 30])
            translate([r - 0.5, -TAB_W/2, h - TAB_H]) {
                if (male) {
                    // Male tab protrudes
                    cube([TAB_D + 1, TAB_W, TAB_H]);
                    // Snap head
                    translate([TAB_D, TAB_W/2, TAB_H/2])
                        rotate([0, 90, 0])
                            cylinder(d1 = TAB_H - 1, d2 = TAB_H + 1, h = 1.5, $fn = 14);
                } else {
                    // Female socket recessed
                    translate([-TAB_D, 0, 0])
                        cube([TAB_D + 0.5, TAB_W + CLEAR, TAB_H + 1]);
                }
            }
    }
}

// ── PLAINS TILE ───────────────────────────────────────
module plains_tile() {
    difference() {
        union() {
            hex_base(R, HEX_H);
            // Rolling hills texture (gentle bumps)
            for (i = [0:8])
                translate([cos(i * 40) * R * 0.4, sin(i * 40) * R * 0.4, HEX_H])
                    scale([2, 1.5, 0.4])
                        sphere(d = 20, $fn = 14);
        }
        // Hollow underside
        translate([0, 0, WALL_T])
            hex_base(R - WALL_T, HEX_H);
    }
    edge_tabs(R, HEX_H - 2, male = true);
    // Grass tufts (Color 2)
    for (i = [0:5])
        translate([cos(i * 60) * R * 0.5, sin(i * 60) * R * 0.5, HEX_H])
            for (a = [0, 30, 60])
                rotate([0, -20, a])
                    translate([0, 0, 0])
                        cylinder(d1 = 2.5, d2 = 0.5, h = 10, $fn = 8);
}

// ── FOREST TILE ───────────────────────────────────────
module tree(x, y, h, trunk_d) {
    translate([x, y, HEX_H]) {
        // Trunk
        cylinder(d = trunk_d, h = h * 0.35, $fn = 8);
        // Canopy layers
        for (layer = [0:2]) {
            z = h * (0.25 + layer * 0.22);
            d = (trunk_d * 5) * (1 - layer * 0.25);
            translate([0, 0, z])
                cylinder(d1 = d, d2 = d * 0.3, h = h * 0.3, $fn = 12);
        }
    }
}

module forest_tile() {
    difference() {
        union() {
            hex_base(R, HEX_H);
            // Ground undulation
            for (i = [0:4])
                translate([cos(i * 72) * R * 0.3, sin(i * 72) * R * 0.3, HEX_H - 2])
                    scale([2, 2, 0.5]) sphere(d = 14, $fn = 10);
        }
        translate([0, 0, WALL_T]) hex_base(R - WALL_T, HEX_H);
    }
    edge_tabs(R, HEX_H - 2, male = true);
    // Trees (Color 2)
    tree(-20, -15, 40, 5);
    tree(15, -10, 48, 6);
    tree(-5, 20, 35, 4.5);
    tree(25, 15, 38, 5);
    tree(-28, 8, 42, 5.5);
}

// ── MOUNTAIN TILE ─────────────────────────────────────
module mountain_tile() {
    difference() {
        union() {
            hex_base(R, HEX_H);
            // Main peak
            translate([5, 0, HEX_H])
                cylinder(d1 = 70, d2 = 0, h = 55, $fn = 5);
            // Secondary peak
            translate([-22, 10, HEX_H])
                cylinder(d1 = 45, d2 = 0, h = 38, $fn = 5);
            // Ridge
            hull() {
                translate([5, 0, HEX_H + 20]) sphere(d = 12, $fn = 10);
                translate([-22, 10, HEX_H + 10]) sphere(d = 10, $fn = 10);
            }
        }
        translate([0, 0, WALL_T]) hex_base(R - WALL_T, HEX_H);
    }
    edge_tabs(R, HEX_H - 2, male = true);
    // Snow cap (Color 2)
    translate([5, 0, HEX_H + 42])
        cylinder(d1 = 22, d2 = 0, h = 13, $fn = 5);
    translate([-22, 10, HEX_H + 28])
        cylinder(d1 = 14, d2 = 0, h = 10, $fn = 5);
}

// ── WATER TILE ────────────────────────────────────────
module water_tile() {
    difference() {
        union() {
            hex_base(R, HEX_H * 0.4);
            // Shallow water (lower than other tiles)
        }
        translate([0, 0, WALL_T]) hex_base(R - WALL_T, HEX_H);
    }
    // Wave pattern (Color 2 — blue)
    for (i = [0:3])
        translate([0, 0, HEX_H * 0.4])
            difference() {
                cylinder(r = R * (0.2 + i * 0.2), h = 1, $fn = 6);
                cylinder(r = R * (0.2 + i * 0.2) - 2, h = 2, $fn = 6);
            }
    edge_tabs(R, HEX_H * 0.4 - 2, male = true);
}

// ── Print layout ──────────────────────────────────────
plains_tile();
translate([R * 2 + 5, 0, 0]) forest_tile();
translate([0, R * 2 + 5, 0]) mountain_tile();
translate([R * 2 + 5, R * 2 + 5, 0]) water_tile();
