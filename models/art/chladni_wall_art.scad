// Chladni Figure Wall Art — 6-Panel Scientific Pattern Collection
// Ernst Chladni (1756-1827): sand sprinkled on vibrating plates forms nodal lines
// These are the vibration modes of a square elastic plate
// Mode (m,n): m nodal lines parallel to X, n parallel to Y → f ∝ m²+n²
// DUAL COLOR: frame (contrast) | raised pattern (material color)
// PLA 0.20mm, 4 walls, 20% infill — each panel 100×100mm, gallery wall set
// Mathematical beauty: identical to quantum harmonic oscillator wave functions

$fn = 32;

// ── Panel dimensions ──────────────────────────────────────
PANEL_W  = 100;    // Panel width/height (square)
PANEL_T  = 4.5;    // Panel base thickness
FRAME_W  = 5.5;    // Frame border width
RAISE_H  = 1.8;    // Height of raised pattern above surface
PATTERN_R = 1.8;   // Pattern line radius (tube radius)
NODE_STEPS = 80;   // Resolution for each curve segment
WALL_HOLE_D = 5;   // Keyhole mount diameter

// ── Chladni pattern function (square plate mode m,n) ──────
// Nodal lines where: sin(m*π*x/L) * sin(n*π*y/L) = 0
// sin(m*π*x/L) = 0 → x = k*L/m for k=0..m
// sin(n*π*y/L) = 0 → y = k*L/n for k=0..n
// Raised lines are the ANTI-NODAL regions (maximum amplitude)
// We render: the pattern lines where the two sin() terms peak together

L = PANEL_W - FRAME_W*2;  // Active plate area
STEP = L / NODE_STEPS;

// Sample the Chladni pattern height at a point
function chladni(x, y, m, n) =
    sin(m * 180 * x / L) * sin(n * 180 * y / L);

// ── Render a mode as a raised pattern ─────────────────────
// Strategy: threshold the function and extrude bumps where |f| > THRESH
module chladni_mode(m, n, thresh=0.55) {
    THRESH = thresh;
    GRID = 48;    // Grid density (more = smoother but slower)
    GS = L / GRID;
    for(ix=[0:GRID-1]) for(iy=[0:GRID-1]) {
        x = ix*GS; y = iy*GS;
        val = abs(chladni(x+GS/2, y+GS/2, m, n));
        if (val >= THRESH) {
            // Raised bump proportional to amplitude
            h = RAISE_H * (val - THRESH) / (1 - THRESH);
            translate([x + FRAME_W, y + FRAME_W, PANEL_T])
                cube([GS, GS, h+0.01]);
        }
    }
}

// ── Panel frame ────────────────────────────────────────────
module panel_frame(m, n) {
    difference() {
        cube([PANEL_W, PANEL_W, PANEL_T]);
        // Inner plate recess (0.3mm to show plate area)
        translate([FRAME_W-0.3, FRAME_W-0.3, PANEL_T-0.4])
            cube([PANEL_W-FRAME_W*2+0.6, PANEL_W-FRAME_W*2+0.6, 0.5]);
        // Keyhole mount (top center)
        translate([PANEL_W/2, PANEL_W-FRAME_W/2, -1])
            cylinder(d=WALL_HOLE_D, h=PANEL_T+2, $fn=20);
        translate([PANEL_W/2-1.5, PANEL_W-FRAME_W/2-WALL_HOLE_D, 1.5])
            cube([3, WALL_HOLE_D, PANEL_T]);
        // Mode label (bottom center)
        translate([PANEL_W/2-18, FRAME_W*0.4, PANEL_T-0.8])
            linear_extrude(1.2)
                text(str("MODE (", m, ",", n, ")"), size=4.5, halign="center", $fn=4);
        // Frequency label
        translate([PANEL_W/2-12, 1.5, PANEL_T-0.8])
            linear_extrude(1.2)
                text(str("f ∝ ", m*m+n*n), size=3.5, halign="center", $fn=4);
    }
}

// ── Single panel (frame + pattern) ────────────────────────
module chladni_panel(m, n) {
    // Color 1: frame
    panel_frame(m, n);
    // Color 2: raised Chladni pattern
    chladni_mode(m, n);
}

// ── Nodal line grid pattern (alternative: show nodal lines directly) ──
module nodal_lines(m, n) {
    // Draw the actual zero-lines as extruded channels
    // X-direction nodal lines: where sin(m*π*x/L) = 0 → x = k*L/m
    for(k=[1:m-1]) {
        x = k * L / m;
        translate([x + FRAME_W - PATTERN_R, FRAME_W, PANEL_T])
            cube([PATTERN_R*2, L, RAISE_H]);
    }
    // Y-direction nodal lines: where sin(n*π*y/L) = 0 → y = k*L/n
    for(k=[1:n-1]) {
        y = k * L / n;
        translate([FRAME_W, y + FRAME_W - PATTERN_R, PANEL_T])
            cube([L, PATTERN_R*2, RAISE_H]);
    }
}

// ── 6 Panels: Classic Chladni mode set ────────────────────
// Grid layout: 3 columns × 2 rows, 15mm gap
GAP = 15;

// Row 1: simplest modes
translate([0*(PANEL_W+GAP), 0, 0]) chladni_panel(1, 1);   // X shape
translate([1*(PANEL_W+GAP), 0, 0]) chladni_panel(2, 1);   // 3-column
translate([2*(PANEL_W+GAP), 0, 0]) chladni_panel(2, 2);   // grid

// Row 2: more complex modes
translate([0*(PANEL_W+GAP), -(PANEL_W+GAP), 0]) chladni_panel(3, 1);   // 4-column
translate([1*(PANEL_W+GAP), -(PANEL_W+GAP), 0]) chladni_panel(3, 2);   // complex
translate([2*(PANEL_W+GAP), -(PANEL_W+GAP), 0]) chladni_panel(3, 3);   // 9-cell grid

// Print note (in BambuStudio: assign each panel separately for colors)
// Optional: linking rail for gallery wall display
translate([0, -(PANEL_W+GAP)*1.6, 0]) {
    difference() {
        cube([3*(PANEL_W+GAP)-GAP, 12, 5]);
        // Mounting slots
        for(x=[30, 3*(PANEL_W+GAP)/2-10, 3*(PANEL_W+GAP)-60])
            translate([x, 2, -1]) cube([20, 8, 7]);
        translate([(3*(PANEL_W+GAP))/2-55, 1, 3.5])
            linear_extrude(2) text("CHLADNI FIGURES — RESONANCE ART", size=6, $fn=4);
    }
}
