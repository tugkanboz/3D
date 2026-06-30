// Mechanical Iris / Aperture Box Lid
// Twist to open — satisfying mechanism
// Print: 0.15mm, 3 walls, 20% infill
// Two parts: base + iris lid (print separately)

BLADES     = 6;
IRIS_D     = 100;   // Outer diameter
IRIS_H     = 8;     // Mechanism height
BLADE_T    = 1.8;   // Blade thickness
HUB_D      = 20;    // Center hub diameter
BOX_H      = 60;    // Box body height
GAP        = 0.3;   // Mechanism clearance

// ─── Iris Blade ──────────────────────────────────────────
module blade() {
    // Teardrop shaped blade
    hull() {
        circle(d = 18, $fn = 24);
        translate([IRIS_D * 0.28, 0]) circle(d = 8, $fn = 16);
    }
}

module iris_ring() {
    // Outer stationary ring
    difference() {
        cylinder(d = IRIS_D, h = IRIS_H, $fn = 64);
        cylinder(d = IRIS_D - 8, h = IRIS_H + 1, $fn = 64);
        // Blade guide slots — curved
        for (i = [0 : BLADES - 1])
            rotate([0, 0, i * 360/BLADES + 15])
                translate([IRIS_D/2 - 12, 0, -1])
                    rotate([0, 0, -25])
                        cube([4 + GAP, 22, IRIS_H + 2]);
    }
}

module iris_rotor() {
    // Inner rotating disc with blades
    difference() {
        cylinder(d = IRIS_D - 8 - GAP*2, h = BLADE_T, $fn = 64);
        cylinder(d = HUB_D + GAP*2, h = BLADE_T + 1, $fn = 32);
    }
    // Blades attached to rotor
    for (i = [0 : BLADES - 1])
        rotate([0, 0, i * 360/BLADES])
            translate([HUB_D/2 + 4, 0, 0])
                linear_extrude(BLADE_T)
                    rotate([0, 0, 30])
                        blade();
}

module box_body() {
    difference() {
        cylinder(d = IRIS_D - 2, h = BOX_H, $fn = 64);
        translate([0, 0, 3])
            cylinder(d = IRIS_D - 10, h = BOX_H, $fn = 64);
    }
}

// Print separately:
translate([0, 0, 0])    box_body();
translate([120, 0, 0])  iris_ring();
translate([120, 0, IRIS_H + 2]) iris_rotor();
