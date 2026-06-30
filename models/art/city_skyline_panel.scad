// City Skyline Silhouette Lamp — DUAL COLOR
// File 2/2: Skyline panel (Color 2 — black/dark PLA)
// Print 4 copies — one per face of lamp body
// The silhouette blocks light, creating city-glow effect
// P2S: 0.15mm, 3 walls, 20% infill

PANEL_W  = 79;    // Fits lamp slot (80mm - 1mm tolerance)
PANEL_H  = 118;
PANEL_T  = 1.6;   // Thin enough for slot, stiff enough to hold

// Building heights (from left, normalized 0-1)
BUILDINGS = [
//  [x_start, width, height_fraction, has_antenna]
    [0,   8,  0.45, false],
    [8,   6,  0.60, false],
    [14,  10, 0.80, true ],   // Empire State style
    [24,  7,  0.55, false],
    [31,  5,  0.40, false],
    [36,  12, 0.90, true ],   // Main tower
    [48,  6,  0.65, false],
    [54,  9,  0.72, false],
    [63,  5,  0.50, false],
    [68,  7,  0.58, false],
    [75,  4,  0.35, false],
];

module building(x, w, h_frac, antenna) {
    h = PANEL_H * h_frac;
    translate([x, 0, 0]) {
        // Main block
        cube([w, PANEL_T, h]);
        // Windows (subtract — light dots)
        if (w >= 6)
            for (wx = [1 : 3 : w-3], wz = [8 : 10 : h - 10])
                translate([wx, -0.1, wz])
                    cube([2.5, PANEL_T + 0.2, 4]);
        // Stepped top (setbacks)
        if (w >= 8) {
            translate([w*0.15, 0, h])
                cube([w*0.7, PANEL_T, PANEL_H * 0.05]);
            translate([w*0.3, 0, h + PANEL_H * 0.05])
                cube([w*0.4, PANEL_T, PANEL_H * 0.04]);
        }
        // Antenna
        if (antenna)
            translate([w/2 - 0.75, 0, h + PANEL_H * 0.09])
                cube([1.5, PANEL_T, PANEL_H * 0.14]);
    }
}

// Ground strip
cube([PANEL_W, PANEL_T, 6]);

// All buildings
for (b = BUILDINGS)
    building(b[0], b[1], b[2], b[3]);

// Moon (circle cutout = glowing moon through panel)
translate([PANEL_W * 0.82, -0.1, PANEL_H * 0.72])
    rotate([-90, 0, 0])
        cylinder(d = 14, h = PANEL_T + 0.2, $fn = 30);
