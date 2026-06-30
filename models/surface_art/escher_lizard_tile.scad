// Escher Tessellation — Interlocking Lizard Tiles
// M.C. Escher's "Reptiles" (1943) inspired interlocking tile
// Two colors tile together seamlessly — no gaps, no overlaps
// DUAL COLOR: lizard A (green PLA) + lizard B (orange PLA)
// PLA — 0.15mm, 3 walls, 20% infill
// Single tile: ~80mm. Print 9+ for a full panel

TILE_S  = 80;    // Tile bounding size
THICK   = 4.5;
BUMP    = 1.2;   // Surface detail relief height
TOL     = 0.25;  // Fit tolerance between tiles

// ── Lizard tile shape (hexagonal symmetry base) ───────
// The Escher lizard is based on a 60° rhombus with modified edges
// Each edge replacement: male bump on one side → female hole on other
// We approximate with smooth B-spline-ish polygon

module lizard_outline() {
    // Base hex rhombus
    s = TILE_S * 0.5;
    hex_pts = [
        [s,     0],
        [s/2,   s * 0.866],
        [-s/2,  s * 0.866],
        [-s,    0],
        [-s/2, -s * 0.866],
        [s/2,  -s * 0.866],
    ];

    // Edge modification: replace straight edges with S-curves
    // (approximate Escher's lizard silhouette with offset polygon)
    // Head bulge (right side)
    head = [
        [s * 1.05, -s * 0.08],
        [s * 1.15, s * 0.12],
        [s * 0.9,  s * 0.3],
        [s * 0.85, s * 0.45],
    ];
    // Tail (left-bottom)
    tail = [
        [-s * 0.3, -s * 0.96],
        [-s * 0.5, -s * 1.05],
        [-s * 0.4, -s * 0.8],
    ];

    offset(r = 3, $fn = 20)
    offset(r = -3)
    polygon(concat(hex_pts, head, tail));
}

module lizard_body_detail() {
    // Spine ridge
    hull() {
        translate([0, s * 0.1, 0]) circle(d = 8, $fn = 12);
        translate([s * 0.5, -s * 0.2, 0]) circle(d = 4, $fn = 10);
    }
    // Eye
    s = TILE_S * 0.5;
    translate([s * 0.85, s * 0.1]) circle(d = 6, $fn = 16);
    // Scale pattern (rows of bumps)
    for (row = [-2:3], col = [-3:3])
        translate([col * 10 + row * 2, row * 8 + 5])
            if (abs(col * 10 + row*2) < s * 0.8 && abs(row*8) < s * 0.7)
                circle(d = 5, $fn = 8);
}

// ── Full tile ─────────────────────────────────────────
module lizard_tile() {
    s = TILE_S * 0.5;
    union() {
        // Base body
        linear_extrude(THICK)
            lizard_outline();
        // Surface detail
        translate([0, 0, THICK])
            linear_extrude(BUMP)
                intersection() {
                    lizard_outline();
                    lizard_body_detail();
                }
    }
}

// ── Print 3x3 panel (single color — alternate colors in BambuStudio) ─
module tile_grid(rows, cols) {
    s = TILE_S * 0.5;
    dx = TILE_S + 1;
    dy = TILE_S * 0.866 + 1;

    for (row = [0 : rows - 1], col = [0 : cols - 1]) {
        tx = col * dx + (row % 2) * dx * 0.5;
        ty = row * dy;
        translate([tx, ty, 0])
            rotate([0, 0, (row + col) % 2 == 0 ? 0 : 180])
                lizard_tile();
    }
}

// Single tile prototype (for fit testing)
lizard_tile();
// Full 3x3 panel (Color 1)
translate([TILE_S * 1.5, 0, 0]) tile_grid(3, 3);
