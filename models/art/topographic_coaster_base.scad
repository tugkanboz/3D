// Topographic Coaster — DUAL COLOR
// File 1/2: Base layer (Color 1 — e.g. wood PLA)
// File 2/2: topo_lines.scad (Color 2 — e.g. black PETG)
// BambuStudio: import both STLs, assign AMS slot 1 & 2
// P2S Combo: 0.2mm, 3 walls, 20% infill, no supports

D      = 100;  // Coaster diameter
H_BASE = 4;    // Base thickness
WALL_T = 2.5;
FOOT_H = 1.5;

difference() {
    union() {
        cylinder(d = D, h = H_BASE, $fn = 80);
        // Anti-slip feet ring
        translate([0, 0, -FOOT_H])
            difference() {
                cylinder(d = D - 4, h = FOOT_H, $fn = 80);
                cylinder(d = D - 14, h = FOOT_H + 1, $fn = 80);
            }
    }
    // Recessed pocket for topo lines (Color 2 sits flush)
    translate([0, 0, H_BASE - 1.2])
        cylinder(d = D - WALL_T*2, h = 1.4, $fn = 80);
}
