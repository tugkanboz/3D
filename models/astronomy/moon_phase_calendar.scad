// Mechanical Moon Phase Calendar — Rotating Disc Display
// 30-day month disc + moon phase disc (8 positions) + day pointer
// DUAL COLOR: frame + base (dark) | moon disc + day ring (bright)
// PLA — 0.2mm, 4 walls, 20% infill
// Accurate to ±1 day per month; snap each night to advance

FRAME_D   = 180;   // Outer frame diameter
MOON_D    = 130;   // Moon phase disc diameter
DAY_D     = 155;   // Day number ring diameter
FRAME_H   = 12;
DISC_H    = 4.0;
POINTER_L = 20;
WALL      = 5.0;
GAP       = 0.4;   // Rotational clearance

// Moon phase names and illumination fractions
PHASES = [
    [0,   "NEW",     0  ],  // New moon
    [45,  "WXC",     0.5],  // Waxing crescent
    [90,  "FQT",     1.0],  // First quarter
    [135, "WXG",     1.0],  // Waxing gibbous
    [180, "FULL",    1.0],  // Full moon
    [225, "WNG",     1.0],  // Waning gibbous
    [270, "LQT",     0.5],  // Last quarter
    [315, "WNC",     0.5],  // Waning crescent
];

// ── Moon face (realistic shaded icon) ────────────────
module moon_face(illuminated_frac, ang_deg) {
    difference() {
        circle(d=14, $fn=20);  // Disc body
        // Dark side (remove illuminated portion)
        if (illuminated_frac < 1.0) {
            translate([0, -8])
                square([16*(1-illuminated_frac), 16], center=true);
        }
    }
    // Craters (decorative bumps)
    for (c=[[2,3,2.5],[5,-2,1.5],[-3,1,2],[-1,-4,1.8]])
        translate([c[0], c[1]])
            difference() {
                circle(d=c[2], $fn=8);
                circle(d=c[2]*0.6, $fn=8);
            }
}

// ── Phase disc ────────────────────────────────────────
module phase_disc() {
    difference() {
        cylinder(d=MOON_D, h=DISC_H, $fn=MOON_D);
        // Center axle bore
        cylinder(d=10+GAP, h=DISC_H+2, $fn=16);
        // 8 phase windows (radial cutouts for viewing phase art)
        for (i=[0:7])
            rotate([0,0,i*45])
                translate([MOON_D*0.35, -10, -1])
                    cube([20, 20, DISC_H+2]);
    }
    // Phase art (raised for each window)
    for (i=[0:7]) {
        ang = PHASES[i][0];
        frac = PHASES[i][2];
        rotate([0,0,ang])
            translate([MOON_D*0.36, 0, DISC_H])
                linear_extrude(1.5)
                    moon_face(frac, ang);
    }
    // Phase label text
    for (i=[0:7]) {
        ang = PHASES[i][0];
        name = PHASES[i][1];
        rotate([0,0,ang])
            translate([MOON_D*0.38, -6, DISC_H-0.5])
                linear_extrude(1)
                    text(name, size=3.5, halign="center", $fn=4);
    }
    // Detent bumps (8 click positions × 2 rings)
    for (i=[0:7])
        rotate([0,0,i*45+22.5])
            translate([MOON_D/2-3, 0, 0])
                cylinder(d=3, h=DISC_H+2, $fn=8);
}

// ── Day ring (30-day outer disc) ──────────────────────
module day_ring() {
    difference() {
        cylinder(d=DAY_D, h=DISC_H*0.8, $fn=DAY_D);
        cylinder(d=MOON_D+GAP*2, h=DISC_H+2, $fn=80);
        cylinder(d=10+GAP, h=DISC_H+2, $fn=16);
    }
    // Day numbers (1-30 around ring)
    for (i=[0:29]) {
        ang = i*12;
        rotate([0,0,ang])
            translate([DAY_D*0.44, -2.5, DISC_H*0.8])
                linear_extrude(1.5)
                    text(str(i+1), size=4, halign="center", $fn=4);
    }
    // Tick marks for each day
    for (i=[0:29]) {
        rotate([0,0,i*12])
            translate([DAY_D/2-4, -0.5, -0.5])
                cube([3, 1, DISC_H*0.8+2]);
    }
}

// ── Outer frame + wall mount ──────────────────────────
module frame() {
    difference() {
        union() {
            // Main ring frame
            difference() {
                cylinder(d=FRAME_D, h=FRAME_H, $fn=FRAME_D);
                translate([0,0,FRAME_H-8])
                    cylinder(d=DAY_D+GAP*2, h=10, $fn=80);
                cylinder(d=DAY_D+GAP*2, h=4, $fn=80);
            }
            // Pointer (top of frame, indicates current day)
            translate([-POINTER_L*0.5, FRAME_D/2-WALL, FRAME_H-3])
                cube([POINTER_L, WALL*1.5, 5]);
            // Pointer tip (arrow)
            translate([0, FRAME_D/2-3, FRAME_H-3])
                cylinder(d1=5, d2=0, h=5, $fn=3);
        }
        // Wall mount keyhole slots
        for (x=[-50,50])
            translate([x, FRAME_D/2-WALL*0.5-1, FRAME_H*0.4]) {
                rotate([90,0,0]) cylinder(d=6, h=WALL+2, $fn=12);
                translate([-4, 0, -14]) cube([8, WALL+2, 15]);
                rotate([90,0,0]) translate([0,-11,0]) cylinder(d=9, h=WALL+2, $fn=12);
            }
        // Phase window (viewing cutout)
        translate([0, 0, FRAME_H-8])
            cylinder(d=MOON_D*0.7, h=9, $fn=60);
    }
    // Center axle pin
    cylinder(d=10, h=FRAME_H+DISC_H*2+2, $fn=16);
}

// ── Moon phase legend banner ──────────────────────────
module legend() {
    translate([-FRAME_D/2, -FRAME_D/2-35, 0]) {
        difference() {
            cube([FRAME_D, 30, 4]);
            translate([2, 2, 1])
                cube([FRAME_D-4, 26, 4]);
        }
        translate([FRAME_D/2-50, 10, 3])
            linear_extrude(1.5)
                text("MOON PHASE CALENDAR", size=6, halign="center", $fn=4);
    }
}

// Color 1 (dark): frame + legend
frame();
legend();
// Color 2 (bright): phase disc + day ring
translate([0, 0, 4]) {
    phase_disc();
    day_ring();
}
