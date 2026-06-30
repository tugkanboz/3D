// City Skyline Silhouette Lamp — DUAL COLOR
// File 1/2: Lamp cylinder body (Color 1 — translucent PETG)
// File 2/2: city_skyline_cutout.scad (Color 2 — opaque PLA, sits in slots)
// Light source: USB LED strip or tea-light inside
// P2S: 0.15mm, 2 walls, 0% infill — VASE MODE for body
// PETG translucent = light diffuses beautifully

D      = 140;
H      = 180;
WALL_T = 1.8;  // Thin = more light through
BASE_H = 8;
BASE_T = 4;
LID_H  = 12;
CORD_D = 12;   // Power cord slot at base

// Body cylinder (vase mode — print with 1 wall)
difference() {
    union() {
        // Main cylinder
        cylinder(d = D, h = H, $fn = 80);
        // Solid base
        cylinder(d = D + BASE_T*2, h = BASE_H, $fn = 80);
    }
    // Hollow inside
    translate([0, 0, BASE_H])
        cylinder(d = D - WALL_T*2, h = H, $fn = 80);
    // Cord notch at base
    translate([-CORD_D/2, -D/2 - 1, 0])
        cube([CORD_D, BASE_T + 2, BASE_H + 1]);
    // Skyline window slots (receives Color 2 panel)
    // 4 faces, each 80mm wide panel slot, 1.8mm deep
    for (i = [0:3])
        rotate([0, 0, i * 90])
            translate([-40, D/2 - WALL_T - 0.2, BASE_H + 10])
                cube([80, WALL_T + 0.4, 120]);
}
