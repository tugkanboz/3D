// Skull Ring - Biker / Gothic Style
// Parametric: set your ring size
// Print: 0.1mm, 4 walls, 40% infill — needs strength
// Best in resin for detail, or PLA for prototype fit

RING_SIZE  = 19;      // Inner diameter mm (size 9 US ≈ 19mm)
BAND_H     = 8;
BAND_T     = 2.5;
SKULL_W    = 22;
SKULL_H    = 20;
SKULL_D    = 14;

module ring_band() {
    difference() {
        cylinder(d = RING_SIZE + 2*BAND_T, h = BAND_H, center = true, $fn = 64);
        cylinder(d = RING_SIZE, h = BAND_H + 1, center = true, $fn = 64);
        // Comfort-fit inner bevel
        for (z = [-1, 1])
            translate([0, 0, z * (BAND_H/2)])
                rotate_extrude($fn = 64)
                    translate([RING_SIZE/2, 0])
                        circle(r = 1, $fn = 12);
    }
}

module skull() {
    translate([0, 0, BAND_H/2 + SKULL_H * 0.3])
    difference() {
        union() {
            // Cranium
            scale([SKULL_W/2, SKULL_D/2, SKULL_H * 0.65])
                sphere(1, $fn = 32);
            // Jaw
            translate([0, 0, -SKULL_H * 0.3])
                scale([SKULL_W/2 * 0.85, SKULL_D/2 * 0.7, SKULL_H * 0.3])
                    sphere(1, $fn = 24);
        }
        // Eye sockets
        for (s = [-1, 1])
            translate([s * 5.5, SKULL_D * 0.35, SKULL_H * 0.1])
                scale([1, 0.7, 1.1])
                    sphere(d = 7, $fn = 20);
        // Nose cavity
        translate([0, SKULL_D * 0.42, -SKULL_H * 0.05])
            scale([0.7, 0.5, 1.2])
                sphere(d = 5, $fn = 16);
        // Teeth slots
        for (i = [-2:2])
            translate([i * 3.5, SKULL_D * 0.4, -SKULL_H * 0.3])
                cube([2.2, 4, 5], center = true);
    }
}

union() {
    ring_band();
    skull();
}
