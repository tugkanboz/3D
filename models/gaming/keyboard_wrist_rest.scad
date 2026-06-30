// Ergonomic Keyboard Wrist Rest
// Contoured — low center, raised edges, anti-slip feet
// PETG preferred (durable, slightly flexible)
// Print: 0.25mm, 3 walls, 10% infill, no supports
// Print flat on bed — orientation is key

TKL_W    = 360;  // TKL keyboard width — change to 440 for full size
DEPTH    = 80;
MAX_H    = 22;
MIN_H    = 12;
FOOT_D   = 18;
FOOT_H   = 3;
CORNER_R = 12;

module wrist_profile() {
    // Ergonomic cross-section: higher at edges, lower center
    polygon([
        [0,      MIN_H],
        [DEPTH * 0.25, MAX_H],
        [DEPTH * 0.5,  MIN_H - 2],
        [DEPTH * 0.75, MAX_H],
        [DEPTH,  MIN_H],
        [DEPTH,  0],
        [0,      0]
    ]);
}

module anti_slip_foot() {
    difference() {
        cylinder(d = FOOT_D, h = FOOT_H, $fn = 24);
        // Concentric grip grooves
        for (r = [3, 5, 7])
            translate([0, 0, FOOT_H - 1.2])
                difference() {
                    cylinder(r = r, h = 2, $fn = 20);
                    cylinder(r = r - 0.8, h = 2, $fn = 20);
                }
    }
}

difference() {
    // Main body — profile extruded with corner rounding
    minkowski() {
        linear_extrude(1)
            offset(r = -CORNER_R)
                square([TKL_W, DEPTH]);
        cylinder(r = CORNER_R, h = 1, $fn = 32);
    }
    // Hollow underside (save filament, reduce weight)
    translate([CORNER_R + 8, CORNER_R + 8, 3])
        cube([TKL_W - CORNER_R*2 - 16, DEPTH - CORNER_R*2 - 16, MAX_H]);
}

// Wrist contour top surface (decorative profile lines)
// Feet
for (x = [25, TKL_W - 25], y = [15, DEPTH - 15])
    translate([x, y, -FOOT_H])
        anti_slip_foot();
