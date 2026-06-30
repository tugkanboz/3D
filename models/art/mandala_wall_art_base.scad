// Geometric Mandala Wall Art — DUAL COLOR
// File 1/2: Base disc (Color 1 — white/light PLA)
// File 2/2: mandala_overlay.scad (Color 2 — accent color)
// P2S: 0.15mm, 3 walls, 15% infill
// Frame hole at top for hanging — no hardware needed

D       = 200;   // Disc diameter — fits P2S 256mm bed
THICK   = 4.0;
WALL_T  = 2.5;
HANG_D  = 6.0;
HANG_Z  = D/2 - 10;

difference() {
    // Base disc
    cylinder(d = D, h = THICK, $fn = 120);

    // Hanging hole
    translate([0, HANG_Z, -1])
        cylinder(d = HANG_D, h = THICK + 2, $fn = 20);

    // Pocket for overlay (0.8mm deep — overlay sits proud 0.4mm)
    translate([0, 0, THICK - 0.8])
        cylinder(d = D - WALL_T*2, h = 1, $fn = 120);
}
