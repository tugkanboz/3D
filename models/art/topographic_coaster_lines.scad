// Topographic Coaster — DUAL COLOR
// File 2/2: Topo contour lines (Color 2 — e.g. black PETG)
// Sits in the recessed pocket of topographic_coaster_base.scad
// Height = exactly 1.2mm so it sits flush with base top

D        = 100;
H        = 1.2;   // Must match base recess depth
WALL_T   = 2.5;
RADIUS   = D/2 - WALL_T;

// Concentric mountain rings — parametric topo map
// Adjust ring positions to simulate any peak

module topo_ring(r, width) {
    difference() {
        cylinder(r = r,         h = H, $fn = 80);
        cylinder(r = r - width, h = H, $fn = 80);
    }
}

module mountain_peak(cx, cy, peak_r, rings, ring_gap, ring_w) {
    for (i = [0 : rings - 1]) {
        r = peak_r - i * ring_gap;
        if (r > 0)
            translate([cx, cy, 0])
                topo_ring(r, ring_w);
    }
}

union() {
    // Main central mountain
    mountain_peak(0, 0, 36, 7, 5, 2.2);

    // Secondary peak offset
    mountain_peak(18, 14, 18, 4, 4.5, 2.0);

    // Tertiary small peak
    mountain_peak(-22, -10, 12, 3, 4, 1.8);

    // River/valley line
    rotate([0, 0, -30])
        translate([0, -1, 0])
            cube([RADIUS * 0.7, 2, H]);

    // Outer boundary ring
    topo_ring(RADIUS, 2.5);
}
