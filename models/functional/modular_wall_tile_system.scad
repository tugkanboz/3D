// Modular Snap-Connect Wall Tile System
// Hexagonal tiles with male/female snap-locks on all 6 edges
// Mix patterns freely: geometric, Voronoi, plain, perforated
// DUAL COLOR: tile body (primary) | snap inserts (contrast)
// PLA 0.20mm, 4 walls, 20% infill — snap gap 0.3mm, 100mm flat-to-flat

$fn = 48;

// ── Tile geometry ─────────────────────────────────────────
HEX_SIZE  = 52;    // Flat-to-flat distance / 2 (so tile = 100mm f-to-f)
THICK     = 4.5;   // Tile body thickness
SNAP_H    = 8;     // Snap connector height
SNAP_T    = 4.0;   // Snap connector thickness
SNAP_W    = 12;    // Snap connector width
SNAP_GAP  = 0.30;  // Clearance between male/female
PATTERN_D = 3.5;   // Surface pattern cut depth
WALL      = 2.2;

// ── Hexagonal base ────────────────────────────────────────
module hex_base(h=THICK, chamfer=1.5) {
    cylinder(h=h-chamfer, d=HEX_SIZE*2, $fn=6);
    translate([0,0,h-chamfer])
        cylinder(h=chamfer, d1=HEX_SIZE*2, d2=HEX_SIZE*2-chamfer*2, $fn=6);
}

// ── Male snap connector (peg) ─────────────────────────────
module snap_male() {
    W = SNAP_W; T = SNAP_T; H = SNAP_H;
    translate([-W/2, 0, 0]) {
        // Body
        cube([W, T, H]);
        // Snap hook (barb)
        translate([0, T, H-3])
            cube([W, 2, 3]);
        // Tapered lead-in
        translate([0, T+2, H-3])
            rotate([45,0,0]) cube([W, 2, 2]);
    }
}

// ── Female snap receiver (slot) ───────────────────────────
module snap_female() {
    W = SNAP_W + SNAP_GAP*2;
    T = SNAP_T + SNAP_GAP*2;
    H = SNAP_H + SNAP_GAP;
    translate([-(W+SNAP_GAP)/2, 0, 0]) {
        cube([W+SNAP_GAP, T+4, H]);
        // Barb catch pocket
        translate([0, T-SNAP_GAP, H-4])
            cube([W+SNAP_GAP, 3.5, 4.5]);
    }
}

// ── Hex edge positions (6 edge midpoints of hexagon) ──────
// Hexagon flat-to-flat = HEX_SIZE; vertex-to-center = HEX_SIZE*2/sqrt(3)
EDGE_R  = HEX_SIZE * 0.866;  // Center to midpoint of edge

// ── Tile with connectors on all 6 edges ───────────────────
module hex_tile_base(male_mask=[1,1,1,1,1,1]) {
    // Body
    hex_base();
    // Male snaps on alternating edges (3 pairs for click-together)
    for (i=[0:5]) {
        ang = i * 60;
        if (male_mask[i]) {
            rotate([0,0,ang]) translate([0, EDGE_R, 0])
                rotate([0,0,180]) snap_male();
        }
    }
}

module hex_tile_cutouts(female_mask=[0,0,0,0,0,0]) {
    // Female slots on remaining edges
    for (i=[0:5]) {
        ang = i * 60;
        if (!female_mask[i]) {
            rotate([0,0,ang]) translate([0, EDGE_R, -1])
                snap_female();
        }
    }
}

// ════════════════════════════════════════════════════════
// ── TILE TYPE 1: Geometric Star Pattern ───────────────────
module tile_star() {
    difference() {
        hex_tile_base();
        // 6-pointed star cutout (overlapping hexagons)
        for(a=[0,60])
            rotate([0,0,a])
                translate([0,0,THICK-PATTERN_D])
                    cylinder(d=HEX_SIZE*1.1, h=PATTERN_D+1, $fn=6);
        // Keep wall
        cylinder(d=HEX_SIZE*0.5, h=THICK+2, $fn=6);
        hex_tile_cutouts();
    }
    // Raised center medallion
    translate([0,0,THICK])
        cylinder(d=22, h=2, $fn=6);
}

// ── TILE TYPE 2: Honeycomb Interior ───────────────────────
module tile_honeycomb() {
    CELL_R = 9;
    positions = [
        [0,0], [CELL_R*1.8, 0], [-CELL_R*1.8, 0],
        [CELL_R*0.9, CELL_R*1.56], [-CELL_R*0.9, CELL_R*1.56],
        [CELL_R*0.9,-CELL_R*1.56], [-CELL_R*0.9,-CELL_R*1.56],
    ];
    difference() {
        hex_tile_base();
        // Honeycomb holes
        for (p=positions)
            translate([p[0], p[1], THICK-PATTERN_D])
                cylinder(d=CELL_R*1.62, h=PATTERN_D+1, $fn=6);
        hex_tile_cutouts();
    }
}

// ── TILE TYPE 3: Sunburst / Mandala ───────────────────────
module tile_sunburst() {
    N_RAYS = 12;
    difference() {
        hex_tile_base();
        // Alternating ray channels
        for(i=[0:N_RAYS-1])
            rotate([0,0, i*360/N_RAYS + 15])
                translate([-2.5, 10, THICK-PATTERN_D])
                    cube([5, HEX_SIZE*0.7, PATTERN_D+1]);
        // Center circle
        translate([0,0,THICK-PATTERN_D+1])
            cylinder(d=16, h=PATTERN_D, $fn=24);
        hex_tile_cutouts();
    }
    // Raised dot center
    translate([0,0,THICK]) cylinder(d=12, h=2, $fn=24);
}

// ── TILE TYPE 4: Plain / Flat (for fills/spacers) ─────────
module tile_plain() {
    difference() {
        hex_tile_base();
        hex_tile_cutouts();
    }
    // Subtle edge bevel top
    translate([0,0,THICK-0.5])
        difference() {
            cylinder(d=HEX_SIZE*2-0.2, h=1, $fn=6);
            cylinder(d=HEX_SIZE*2-4, h=1.5, $fn=6);
        }
}

// ── CORNER CONNECTOR (3-way junction between tiles) ───────
module corner_connector() {
    difference() {
        // Small triangular plate
        cylinder(d=SNAP_W*1.5, h=THICK, $fn=3);
        cylinder(d=6, h=THICK+2, $fn=12);
    }
    // 3 female receptors for adjacent male snaps
    for(a=[0,120,240])
        rotate([0,0,a]) translate([0, SNAP_W*0.4, 0])
            snap_female();
}

// ── LAYOUT: Show all tile types ───────────────────────────
// Tile 1: Star (top-left)
translate([-HEX_SIZE*2.3, 0, 0]) tile_star();
// Tile 2: Honeycomb (top-right)
translate([ HEX_SIZE*2.3, 0, 0]) tile_honeycomb();
// Tile 3: Sunburst (bottom-left)
translate([-HEX_SIZE*1.15, -HEX_SIZE*2, 0]) tile_sunburst();
// Tile 4: Plain (bottom-right)
translate([ HEX_SIZE*1.15, -HEX_SIZE*2, 0]) tile_plain();
// Corner connector (center-bottom)
translate([0, -HEX_SIZE*3.8, 0]) corner_connector();
