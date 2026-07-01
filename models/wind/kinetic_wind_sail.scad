// Kinetic Wind Sail Sculpture — Outdoor Garden Art
// Central hub + 5 compound wings, each with 3 sub-blades at offset angles
// Spins in wind; designed for PETG UV-resistance outdoors
// DUAL COLOR: hub + shaft (dark) | wings (bright/colorful)
// PETG — 0.2mm, 4 walls, 20% infill — vertical print, 0 supports

HUB_D    = 30;
HUB_H    = 25;
SHAFT_D  = 12;    // M10 rod or 10mm steel rod fits through
SHAFT_H  = 200;   // Ground stake height (printed separate piece)
N_WINGS  = 5;     // Primary wings
SUB_N    = 3;     // Sub-blades per wing
WING_L   = 90;    // Wing span (arm length)
WING_W   = 22;    // Wing width
WING_T   = 3.0;   // Wing thickness
TWIST    = 15;    // Wing twist (pitch angle for wind catch)
GAP      = 0.4;
BEARING_D = 22;   // Bearing bore (608 skate bearing = 22mm OD)

// ── Wind-catching wing profile ────────────────────────
module wing_blade(l, w, t, twist_ang) {
    // Twisted airfoil cross-section for wind catchment
    hull() {
        linear_extrude(1)
            scale([l, w*0.7])
                circle(d=1, $fn=20);
        translate([0, 0, l*0.6])
            rotate([twist_ang, 0, 0])
                linear_extrude(1)
                    scale([l*0.3, w*0.5])
                        circle(d=1, $fn=16);
    }
}

module wing_airfoil(l, w, t) {
    // Airfoil cross-section: rounded leading edge, tapered trailing edge
    linear_extrude(t) {
        hull() {
            circle(d=w*0.25, $fn=16);
            translate([l, 0]) scale([0.15, 0.4]) circle(d=w, $fn=14);
            translate([l*0.55, w*0.35]) circle(d=w*0.1, $fn=8);
            translate([l*0.55,-w*0.35]) circle(d=w*0.1, $fn=8);
        }
    }
}

// ── Primary wing arm ──────────────────────────────────
module wing_arm() {
    // Main arm
    rotate([90-TWIST, 0, 0])
        wing_airfoil(WING_L, WING_W, WING_T);

    // Sub-blades (3 perpendicular winglets at different radii)
    for (i=[0:SUB_N-1]) {
        r = WING_L * (0.35 + i*0.22);
        ang = 30 + i*20;   // Progressive twist angle
        translate([r, 0, WING_T/2])
            rotate([90-ang, 0, 90])
                wing_airfoil(WING_L*0.35, WING_W*0.6, WING_T*0.8);
    }
}

// ── Spinner hub ───────────────────────────────────────
module hub() {
    difference() {
        union() {
            // Main hub cylinder
            cylinder(d=HUB_D, h=HUB_H, $fn=40);
            // Wing mounting flanges
            for (i=[0:N_WINGS-1])
                rotate([0,0,i*360/N_WINGS])
                    translate([HUB_D/2-2, -8, 2])
                        cube([10, 16, HUB_H-4]);
        }
        // Bearing pocket (top: 608 bearing press-fit)
        translate([0,0,HUB_H-10])
            cylinder(d=BEARING_D+0.1, h=12, $fn=30);
        // Axle bore (through entire hub)
        cylinder(d=SHAFT_D+GAP, h=HUB_H+2, $fn=24);
        // Wing screw holes (M3 self-tap)
        for (i=[0:N_WINGS-1])
            rotate([0,0,i*360/N_WINGS])
                translate([HUB_D/2+3, 0, HUB_H/2])
                    rotate([0,90,0])
                        cylinder(d=3, h=12, $fn=10);
    }
    // Hub decorative ridges (visual detail)
    for (i=[0:7])
        rotate([0,0,i*45])
            translate([HUB_D/2-1, -1, 3])
                cube([2, 2, HUB_H-6]);
}

// ── Ground stake / wall mount post ────────────────────
module stake() {
    difference() {
        union() {
            cylinder(d=SHAFT_D+8, h=SHAFT_H, $fn=16);
            // Ground spike (tapered)
            translate([0,0,-40])
                cylinder(d1=0, d2=SHAFT_D+6, h=40, $fn=12);
            // Wall flange option (for wall mount)
            translate([-20, -20, SHAFT_H-5])
                cube([40, 40, 10]);
        }
        // Axle bore
        cylinder(d=SHAFT_D+GAP*2, h=SHAFT_H+2, $fn=24);
        // Wall mount screw holes
        for (y=[-8,8])
            translate([0, y, SHAFT_H+1])
                rotate([0,90,0])
                    cylinder(d=5, h=50, center=true, $fn=12);
    }
}

// ── Decorative cap (top of spinner) ───────────────────
module spinner_cap() {
    difference() {
        sphere(d=HUB_D*0.9, $fn=30);
        cylinder(d=SHAFT_D+GAP, h=HUB_D, center=true, $fn=20);
        translate([0,0,-HUB_D/2]) cube([HUB_D, HUB_D, HUB_D], center=true);
    }
}

// ── Assembly ──────────────────────────────────────────
// Color 1 (dark): hub + stake
hub();
translate([0, 0, -SHAFT_H]) stake();

// Color 2 (bright): wings + cap
for (i=[0:N_WINGS-1])
    rotate([0,0,i*360/N_WINGS])
        translate([HUB_D/2+8, 0, HUB_H/2])
            rotate([0,90,0])
                wing_arm();

translate([0,0,HUB_H]) spinner_cap();
