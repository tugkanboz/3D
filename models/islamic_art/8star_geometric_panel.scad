// Islamic 8-Pointed Star Geometric Panel — Wall Art
// Classic Rub el Hizb / Khatam pattern — mathematically perfect
// DUAL COLOR: star lattice (dark) | background fill (light)
// PLA — 0.15mm, 3 walls, 15% infill
// Panel: 200x200mm — fits P2S bed; tile multiple for larger wall

PANEL_W = 200;
PANEL_H = 200;
PANEL_T = 5.0;
STRUT_W = 4.5;   // Lattice line width
STAR_S  = 45;    // Star cell size
RELIEF  = 1.8;   // Raised pattern height above base

// ── 8-pointed star unit ───────────────────────────────
module star_8(s, t) {
    // Octagram: two overlapping squares rotated 45°
    linear_extrude(t)
        union() {
            square(s, center=true);
            rotate([0,0,45]) square(s, center=true);
        }
}

// ── Khatam tile (one repeat unit: star + surrounding) ─
module khatam_unit(s) {
    r = s / 2;
    // Octagon outline
    linear_extrude(PANEL_T + RELIEF) {
        difference() {
            // Star shape
            union() {
                square(s * 0.95, center=true);
                rotate([0,0,45]) square(s * 0.95, center=true);
            }
            // Interior cutout (creates lattice outline)
            union() {
                square(s * 0.95 - STRUT_W*2, center=true);
                rotate([0,0,45]) square(s * 0.95 - STRUT_W*2, center=true);
            }
        }
    }
    // Cross arms between stars
    for (a = [0,45,90,135,180,225,270,315]) {
        rotate([0,0,a])
            translate([s * 0.95 / 2, -STRUT_W/2, 0])
                cube([s * 0.3, STRUT_W, PANEL_T + RELIEF]);
    }
}

// ── Small square fills (between stars) ────────────────
module small_square_fill(s) {
    sq = s * 0.28;
    linear_extrude(PANEL_T + RELIEF * 0.5)
        difference() {
            square(sq, center=true);
            square(sq - STRUT_W * 1.5, center=true);
        }
}

// ── Panel background ──────────────────────────────────
module panel_base() {
    difference() {
        cube([PANEL_W, PANEL_H, PANEL_T]);
        // Hanging holes
        for (x=[15, PANEL_W-15])
            translate([x, PANEL_H-12, -1])
                cylinder(d=5, h=PANEL_T+2, $fn=16);
        // Weight reduction (back)
        for (i=[0:2], j=[0:2])
            translate([10+i*60, 10+j*60, -1])
                cube([50, 50, PANEL_T-2]);
    }
}

// ── Full tiling ────────────────────────────────────────
// Stars tile on a grid with half-offset rows
COLS = 4;
ROWS = 4;
STEP = STAR_S * 1.055;

module tiled_panel() {
    panel_base();
    for (row=[0:ROWS-1], col=[0:COLS-1]) {
        x = col * STEP + (row%2) * STEP/2;
        y = row * STEP;
        if (x < PANEL_W - STEP/2 && y < PANEL_H - STEP/2)
            translate([x + STEP/2, y + STEP/2, PANEL_T - 0.5])
                khatam_unit(STAR_S);
        // Small rotated squares in gaps
        for (a=[0,90])
            translate([x + STEP*0.5, y + STEP*0.5, PANEL_T - 0.5])
                rotate([0,0,45+a])
                    translate([STAR_S * 0.75, 0, 0])
                        small_square_fill(STAR_S);
    }
}

// Border frame
module border_frame() {
    BW = 8;
    translate([0, 0, PANEL_T - 0.5])
        linear_extrude(RELIEF * 1.5)
            difference() {
                square([PANEL_W, PANEL_H]);
                square([PANEL_W - BW*2, PANEL_H - BW*2],
                        center=false);
            }
    // Corner stars
    for (x=[BW/2+4, PANEL_W-BW/2-4], y=[BW/2+4, PANEL_H-BW/2-4])
        translate([x, y, PANEL_T - 0.5])
            star_8(BW*1.2, RELIEF*1.5);
}

tiled_panel();
border_frame();
