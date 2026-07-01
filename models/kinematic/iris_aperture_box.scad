// Mechanical Iris Aperture Box — Camera-Shutter Lid Secret Box
// 8-blade print-in-place iris: rotate outer ring → blades open to reveal interior
// DUAL COLOR: blades (dark metallic) | ring housing (silver/light)
// PLA — 0.15mm, 4 walls, print flat — 0.38mm gap on all sliding surfaces

N_BLADES  = 8;
IRIS_D    = 140;   // Outer diameter of iris mechanism
BLADE_T   = 2.2;   // Blade thickness
RING_T    = 3.5;   // Ring track thickness
RING_H    = BLADE_T + 1.5;
GAP       = 0.38;  // Print-in-place clearance
PIVOT_D   = 6.5;   // Pivot pin diameter
SLOT_W    = 4.5;   // Spiral slot width
SLOT_GAP  = GAP;
BOX_H     = 40;    // Box body height
BOX_D     = IRIS_D + 8;
WALL      = 4.0;
LIP_H     = 6;

// Geometry derived values
INNER_R   = 12;    // Minimum iris opening radius
OUTER_PIVOT_R = IRIS_D*0.42; // Pivot circle radius (on outer fixed ring)
INNER_SLOT_R  = IRIS_D*0.25; // Spiral slot on rotating inner disc

// ── Single iris blade ─────────────────────────────────
// Trapezoidal blade with rounded corners + pivot hole + slot pin
module blade() {
    difference() {
        union() {
            // Blade body (tapered rectangle with curved tip)
            hull() {
                translate([-IRIS_D*0.14, -IRIS_D*0.05])
                    circle(d=IRIS_D*0.06, $fn=14);
                translate([IRIS_D*0.18, -IRIS_D*0.02])
                    circle(d=IRIS_D*0.04, $fn=12);
                translate([IRIS_D*0.12, IRIS_D*0.22])
                    circle(d=IRIS_D*0.05, $fn=12);
                translate([-IRIS_D*0.08, IRIS_D*0.20])
                    circle(d=IRIS_D*0.06, $fn=12);
            }
        }
        // Pivot hole (fixed on outer ring)
        translate([-IRIS_D*0.10, 0])
            circle(d=PIVOT_D+GAP, $fn=16);
        // Slot pin hole (slides in inner disc spiral slot)
        translate([IRIS_D*0.10, IRIS_D*0.10])
            circle(d=SLOT_W, $fn=12);
    }
    // Raised slot pin (tab that fits into spiral slot)
    translate([IRIS_D*0.10, IRIS_D*0.10])
        cylinder(d=SLOT_W-GAP*2, h=BLADE_T+RING_T*0.7+0.3, $fn=12);
}

// ── Fixed outer ring (has pivot pins, sits on box lid) ─
module outer_ring() {
    difference() {
        // Ring body
        cylinder(d=IRIS_D, h=RING_H, $fn=IRIS_D);
        // Bore (inner space)
        cylinder(d=IRIS_D*0.6, h=RING_H+2, $fn=80);
        // Blade pockets (recesses where blades sit + pivot)
        for (i=[0:N_BLADES-1])
            rotate([0,0,i*360/N_BLADES])
                translate([OUTER_PIVOT_R, 0, -1])
                    cylinder(d=PIVOT_D+GAP*2, h=RING_H+2, $fn=14);
        // Rotation track groove (inner disc rides here)
        translate([0,0,BLADE_T+0.4])
            difference() {
                cylinder(d=IRIS_D*0.62+GAP*2, h=RING_T+1, $fn=80);
                cylinder(d=IRIS_D*0.5, h=RING_T+2, $fn=80);
            }
    }
    // Pivot pins (integral, for blades to rotate on)
    for (i=[0:N_BLADES-1])
        rotate([0,0,i*360/N_BLADES])
            translate([OUTER_PIVOT_R, 0, 0])
                cylinder(d=PIVOT_D, h=RING_H, $fn=14);
}

// ── Rotating inner disc (has spiral slots, user turns this) ─
module inner_disc() {
    DISC_D = IRIS_D*0.62;
    difference() {
        cylinder(d=DISC_D, h=RING_T, $fn=80);
        // Center aperture
        cylinder(d=INNER_R*2, h=RING_T+2, $fn=40);
        // Spiral slots (one per blade — Archimedean spiral segment)
        for (i=[0:N_BLADES-1]) {
            base_ang = i*360/N_BLADES;
            // Each slot is a curved arc through the travel range
            for (step=[0:15]) {
                t = step/15;
                ang = base_ang + t*40;
                r = INNER_SLOT_R + t*(IRIS_D*0.24 - INNER_SLOT_R);
                translate([r*cos(ang), r*sin(ang), -1])
                    cylinder(d=SLOT_W+GAP*2, h=RING_T+2, $fn=10);
            }
        }
        // Grip notches on edge (finger turn grip)
        for (i=[0:15])
            rotate([0,0,i*22.5])
                translate([DISC_D/2-2, 0, RING_T*0.3])
                    cylinder(d=3.5, h=RING_T, $fn=8);
    }
}

// ── Box body (round) ──────────────────────────────────
module box_body() {
    difference() {
        cylinder(d=BOX_D, h=BOX_H, $fn=80);
        // Hollow interior
        translate([0,0,WALL])
            cylinder(d=BOX_D-WALL*2, h=BOX_H, $fn=80);
        // Lid lip groove
        translate([0,0,BOX_H-LIP_H])
            cylinder(d=BOX_D-WALL+GAP, h=LIP_H+1, $fn=80);
    }
    // Bottom engraving (camera aperture symbol)
    translate([0,0,1])
        linear_extrude(1.5)
            difference() {
                circle(d=40, $fn=40);
                circle(d=32, $fn=40);
                for (i=[0:5])
                    rotate([0,0,i*60])
                        translate([-1, 15]) square([2, 10]);
            }
}

// ── Lid ring (holds iris onto box) ────────────────────
module lid_ring() {
    difference() {
        cylinder(d=BOX_D-GAP*2, h=LIP_H+RING_H+2, $fn=80);
        // Bore
        cylinder(d=IRIS_D+GAP*2, h=LIP_H+RING_H+4, $fn=80);
        // Bottom lip (snaps into box groove)
        translate([0,0,-1])
            cylinder(d=BOX_D-WALL*2-GAP, h=LIP_H+1, $fn=80);
    }
}

// ── Assembled display ─────────────────────────────────
// Color 1 (dark): blades + box body
box_body();
for (i=[0:N_BLADES-1])
    rotate([0,0,i*360/N_BLADES + 10])
        translate([OUTER_PIVOT_R*cos(10), OUTER_PIVOT_R*sin(10), BOX_H+RING_H*0.5])
            rotate([180,0,0])
                linear_extrude(BLADE_T)
                    blade();

// Color 2 (silver): rings + inner disc + lid
translate([0, 0, BOX_H]) {
    outer_ring();
    translate([0,0,BLADE_T]) inner_disc();
}
translate([200, 0, 0]) lid_ring();
