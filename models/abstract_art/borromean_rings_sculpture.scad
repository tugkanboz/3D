// Borromean Rings Desk Sculpture — Topological Impossibility
// 3 interlocking rings: remove ANY one ring and the other two fall apart
// Print-in-place with 0.35mm gaps — no assembly needed
// DUAL COLOR (swap filament mid-print): ring pair 1+3 (color 1) | ring 2 (color 2)
// PLA — 0.1mm, 4 walls, 20% gyroid infill — 0 supports, print vertical

// Parameters
RING_R    = 38;   // Ring center radius
RING_TUBE = 8.5;  // Ring tube diameter
GAP       = 0.35; // Print-in-place gap
BASE_H    = 12;
BASE_D    = 90;

// ── Single torus ring ─────────────────────────────────
module ring(r=RING_R, tube=RING_TUBE) {
    rotate_extrude($fn=80)
        translate([r, 0, 0])
            circle(d=tube, $fn=24);
}

// ── Borromean configuration ───────────────────────────
// Ring A: lies in XY plane
// Ring B: lies in XZ plane, offset so it threads THROUGH Ring A
// Ring C: lies in YZ plane, offset so it threads THROUGH Rings A and B
// The key: A threads B, B threads C, C threads A — no pair is directly linked

module borromean_rings() {
    // Ring A — XY plane (horizontal)
    ring();

    // Ring B — XZ plane (vertical, perpendicular to A)
    // Offset in Y so it interlocks through A
    rotate([90, 0, 0])
        ring();

    // Ring C — YZ plane (third axis)
    // Offset in X so it interlocks through A and B
    rotate([0, 90, 0])
        ring();
}

// ── Decorative pedestal ───────────────────────────────
module pedestal() {
    difference() {
        union() {
            // Main column
            cylinder(d=BASE_D*0.35, h=BASE_H+RING_R-RING_TUBE/2, $fn=40);
            // Flared cap where rings rest
            translate([0, 0, BASE_H+RING_R-RING_TUBE/2])
                cylinder(d=RING_TUBE+4, h=3, $fn=32);
            // Base plinth
            hull() {
                cylinder(d=BASE_D, h=BASE_H, $fn=6);
                translate([0, 0, BASE_H])
                    cylinder(d=BASE_D*0.7, h=2, $fn=6);
            }
        }
        // Hollow column
        translate([0, 0, BASE_H*0.5])
            cylinder(d=BASE_D*0.2, h=RING_R+10, $fn=24);
        // Logo engraving on base top face
        translate([0, 0, BASE_H-0.8])
            linear_extrude(1)
                text("∞", size=12, halign="center", valign="center", $fn=4);
        // Base bottom recess
        translate([0, 0, -1])
            cylinder(d=BASE_D*0.7, h=3, $fn=6);
    }
    // Ring support collar at junction point
    translate([0, 0, BASE_H+RING_R-RING_TUBE/2])
        difference() {
            sphere(d=RING_TUBE*1.8, $fn=20);
            cylinder(d=RING_TUBE+GAP*2, h=RING_TUBE*2, center=true, $fn=20);
        }
}

// ── Nameplate ─────────────────────────────────────────
module nameplate() {
    translate([-28, -BASE_D/2+1, BASE_H*0.5-2])
        rotate([90,0,0]) {
            difference() {
                cube([56, 10, 2.5]);
                translate([3, 1.5, -0.5])
                    linear_extrude(4)
                        text("BORROMEAN RINGS", size=4.5, $fn=4);
            }
        }
}

// Color 1 (bronze/gold): Ring A + Ring C + pedestal
translate([0, 0, RING_R+BASE_H+3]) {
    ring();                    // Ring A (XY)
    rotate([0, 90, 0]) ring(); // Ring C (YZ)
}
pedestal();
nameplate();

// Color 2 (silver): Ring B
translate([0, 0, RING_R+BASE_H+3])
    rotate([90, 0, 0]) ring();  // Ring B (XZ)
