// Klein Bottle-Inspired Vase
// Topology art — inside connects to outside, one surface
// Print: 0.2mm, 2 walls, vase mode optional
// Conversation piece, gallery-worthy

STEPS  = 120;
R_TUBE = 8;
R_BIG  = 30;
HEIGHT = 120;

// Parametric Klein-inspired surface (simplified, printable variant)
// u = angular around tube, v = position along path
module klein_vase() {
    union() {
        // Main torus body
        rotate_extrude(angle = 360, $fn = STEPS)
            translate([R_BIG, 0, 0])
                union() {
                    circle(r = R_TUBE, $fn = 24);
                    // Flared bottom
                    translate([0, -R_TUBE])
                        scale([1.8, 1])
                            circle(r = R_TUBE * 0.6, $fn = 24);
                }

        // Neck that re-enters (the "impossible" bit — printable approximation)
        translate([0, 0, R_BIG])
        rotate([0, 90, 0])
        rotate_extrude(angle = 200, $fn = 60)
            translate([R_BIG * 0.5, 0, 0])
                scale([0.4, 1])
                    circle(r = R_TUBE, $fn = 20);

        // Tall neck/spout
        translate([R_BIG, 0, 0])
            cylinder(d1 = R_TUBE * 1.6, d2 = R_TUBE, h = HEIGHT * 0.6, $fn = 32);
    }
}

klein_vase();
