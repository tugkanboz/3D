// Celtic Eternal Knotwork Panel — Mathematical Interlace
// True over/under weaving: strands pass above/below via Z-offset stepping
// 3×3 grid of Solomon's Knot tiles, 200×200mm wall panel
// DUAL COLOR: strand color A (dark) | strand color B (light) + frame
// PLA — 0.15mm, 3 walls — print flat

PANEL_W = 200;
PANEL_H = 200;
PANEL_T = 5.0;
FRAME_W = 8.0;
STRAND_W = 6.5;   // Strand tube width
STRAND_T = 3.5;   // Strand height above base
CROSS_H  = 1.8;   // Height of upper strand at crossings
GAP      = 0.4;   // Gap between crossing strands

// Tile grid: 3 columns × 3 rows of Solomon's knot tiles
TILE_N_X = 3;
TILE_N_Y = 3;
TILE_W   = (PANEL_W - FRAME_W*2) / TILE_N_X;
TILE_H   = (PANEL_H - FRAME_W*2) / TILE_N_Y;

// ── Single strand segment (rounded rectangle) ─────────
module strand_h(x, y, w, go_over=true) {
    z = go_over ? STRAND_T + CROSS_H : STRAND_T*0.3;
    translate([x, y-STRAND_W/2, z])
        cube([w, STRAND_W, STRAND_T]);
}

module strand_v(x, y, h, go_over=true) {
    z = go_over ? STRAND_T + CROSS_H : STRAND_T*0.3;
    translate([x-STRAND_W/2, y, z])
        cube([STRAND_W, h, STRAND_T]);
}

// Rounded strand segment
module strand_hr(x, y, w, go_over=true) {
    z = go_over ? STRAND_T + CROSS_H : STRAND_T*0.3;
    translate([0, 0, z])
        hull() {
            translate([x+STRAND_W/2, y]) cylinder(d=STRAND_W, h=STRAND_T, $fn=14);
            translate([x+w-STRAND_W/2, y]) cylinder(d=STRAND_W, h=STRAND_T, $fn=14);
        }
}

module strand_vr(x, y, h, go_over=true) {
    z = go_over ? STRAND_T + CROSS_H : STRAND_T*0.3;
    translate([0, 0, z])
        hull() {
            translate([x, y+STRAND_W/2]) cylinder(d=STRAND_W, h=STRAND_T, $fn=14);
            translate([x, y+h-STRAND_W/2]) cylinder(d=STRAND_W, h=STRAND_T, $fn=14);
        }
}

// ── Solomon's Knot tile ───────────────────────────────
// The classic Celtic knot: two interlocked ovals
// One oval is Color A (dark), other is Color B (light)
// Alternating over/under at 4 crossing points
module solomons_knot_tile_a(ox, oy) {
    // Strand A: horizontal oval (loops left/right)
    cx = ox + TILE_W/2;
    cy = oy + TILE_H/2;
    hw = TILE_W*0.35;
    hh = TILE_H*0.35;

    // Top horizontal
    strand_hr(cx-hw, cy+hh, hw*2, true);
    // Bottom horizontal
    strand_hr(cx-hw, cy-hh-STRAND_W, hw*2, false);
    // Left cap
    translate([cx-hw, cy, STRAND_T*0.5])
        rotate([0,90,0])
            rotate_extrude(angle=180, $fn=20)
                translate([hh, 0]) circle(d=STRAND_W, $fn=10);
    // Right cap
    translate([cx+hw, cy, STRAND_T*0.5])
        rotate([0,-90,0])
            rotate_extrude(angle=180, $fn=20)
                translate([hh, 0]) circle(d=STRAND_W, $fn=10);
}

module solomons_knot_tile_b(ox, oy) {
    cx = ox + TILE_W/2;
    cy = oy + TILE_H/2;
    hw = TILE_W*0.35;
    hh = TILE_H*0.35;

    // Left vertical
    strand_vr(cx-hw-STRAND_W, cy-hh, hh*2, true);
    // Right vertical
    strand_vr(cx+hw, cy-hh, hh*2, false);
    // Top cap
    translate([cx, cy+hh, STRAND_T*0.5])
        rotate_extrude(angle=180, $fn=20)
            translate([hw, 0]) circle(d=STRAND_W, $fn=10);
    // Bottom cap
    translate([cx, cy-hh, STRAND_T*0.5])
        rotate([0,0,180])
            rotate_extrude(angle=180, $fn=20)
                translate([hw, 0]) circle(d=STRAND_W, $fn=10);
}

// ── Border knotwork (continuous interweave frame) ─────
module frame_knot() {
    // Outer decorative frame with rope twist detail
    FW = FRAME_W;
    difference() {
        cube([PANEL_W, PANEL_H, PANEL_T]);
        translate([FW, FW, -1])
            cube([PANEL_W-FW*2, PANEL_H-FW*2, PANEL_T+2]);
    }
    // Rope twist texture on frame
    TWIST_N = 48;
    for (i=[0:TWIST_N-1]) {
        t = i / TWIST_N;
        peri = 2*(PANEL_W + PANEL_H);
        pos = t * peri;
        x = pos < PANEL_W ? pos :
            pos < PANEL_W+PANEL_H ? PANEL_W :
            pos < 2*PANEL_W+PANEL_H ? (2*PANEL_W+PANEL_H-pos) : 0;
        y = pos < PANEL_W ? 0 :
            pos < PANEL_W+PANEL_H ? (pos-PANEL_W) :
            pos < 2*PANEL_W+PANEL_H ? PANEL_H : (peri-pos);
        translate([x, y, PANEL_T-1])
            sphere(d=3, $fn=8);
    }
    // Hanging holes
    for (hx=[15, PANEL_W-15])
        translate([hx, PANEL_H-5, -1])
            cylinder(d=4, h=PANEL_T+2, $fn=12);
}

// ── Panel base ────────────────────────────────────────
module panel_base() {
    difference() {
        cube([PANEL_W, PANEL_H, PANEL_T]);
        // Weight saving pocket
        translate([FRAME_W, FRAME_W, 2])
            cube([PANEL_W-FRAME_W*2, PANEL_H-FRAME_W*2, PANEL_T-1]);
    }
}

// ── Full panel ────────────────────────────────────────
// Color 2 (light): base + frame + strand B
panel_base();
frame_knot();

for (row=[0:TILE_N_Y-1])
    for (col=[0:TILE_N_X-1]) {
        ox = FRAME_W + col*TILE_W;
        oy = FRAME_W + row*TILE_H;
        // Strand B (light, vertical ovals)
        translate([0,0,PANEL_T]) solomons_knot_tile_b(ox, oy);
    }

// Color 1 (dark): strand A (horizontal ovals — on top at crossings)
for (row=[0:TILE_N_Y-1])
    for (col=[0:TILE_N_X-1]) {
        ox = FRAME_W + col*TILE_W;
        oy = FRAME_W + row*TILE_H;
        translate([0,0,PANEL_T]) solomons_knot_tile_a(ox, oy);
    }
