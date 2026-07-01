// Mondrian Composition — Parametric Wall Art Panel
// De Stijl movement: primary colors + black grid lines
// 4-COLOR AMS: white background, red, blue, yellow rectangles + black lines
// PLA — 0.15mm, 3 walls, 15% infill
// 200x200mm — fits P2S; tile multiple for gallery wall

PANEL_W = 200;
PANEL_H = 200;
PANEL_T = 6.0;
LINE_W  = 7.0;   // Black grid line width
LINE_H  = 3.5;   // Line raise height above base
RECT_H  = 2.8;   // Color rectangle raise height
BEVEL   = 0.8;

// ── Grid line positions (parametric — change for different compositions) ──
// Vertical lines (x positions)
V_LINES = [45, 90, 145];
// Horizontal lines (y positions)
H_LINES = [55, 110, 160];

// ── Colored rectangles [x, y, w, h, color_idx] ───────
// color_idx: 1=red, 2=blue, 3=yellow, 0=white
RECTS = [
    [0,   0,   45,  55,  1],   // red bottom-left
    [97,  0,   103, 110, 2],   // blue right-center
    [0,   167, 90,  33,  3],   // yellow top-left
    [152, 117, 48,  83,  3],   // yellow top-right small
    [0,   62,  38,  91,  0],   // white left-center
    [97,  117, 48,  43,  0],   // white mid-right
    [152, 0,   48,  110, 0],   // white far-right tall
    [0,   167, 90,  33,  3],
];

// ── Panel base (white PLA — Color 1) ─────────────────
module panel_base() {
    difference() {
        cube([PANEL_W, PANEL_H, PANEL_T]);
        // Hanging holes
        for (x=[12, PANEL_W-12])
            translate([x, PANEL_H-14, -1])
                cylinder(d=5, h=PANEL_T+2, $fn=14);
        // Rear weight reduction
        translate([5, 5, -1])
            cube([PANEL_W-10, PANEL_H-10, PANEL_T-2]);
    }
}

// ── Color fill rectangles (Colors 2/3/4) ─────────────
module color_fills() {
    for (r = RECTS) {
        if (r[4] > 0) {  // Skip white (base handles it)
            x=r[0]; y=r[1]; w=r[2]; h=r[3];
            translate([x+LINE_W/2, y+LINE_W/2, PANEL_T-0.5])
                cube([w-LINE_W, h-LINE_W, RECT_H]);
        }
    }
}

// ── Black grid lines (Color 4 — black) ────────────────
module grid_lines() {
    // Vertical lines
    for (x = V_LINES)
        translate([x-LINE_W/2, 0, PANEL_T-0.5])
            cube([LINE_W, PANEL_H, LINE_H]);
    // Horizontal lines
    for (y = H_LINES)
        translate([0, y-LINE_W/2, PANEL_T-0.5])
            cube([PANEL_W, LINE_W, LINE_H]);
    // Border frame (black outer edge)
    difference() {
        translate([-0.5,-0.5, PANEL_T-0.5])
            cube([PANEL_W+1, PANEL_H+1, LINE_H]);
        translate([LINE_W, LINE_W, PANEL_T-1])
            cube([PANEL_W-LINE_W*2, PANEL_H-LINE_W*2, LINE_H+2]);
    }
}

// Layout — in BambuStudio assign AMS colors by height:
// PANEL_T-0.5 to PANEL_T+RECT_H → color rectangles
// Grid lines → black filament
panel_base();
color_fills();
grid_lines();
