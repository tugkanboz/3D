// Wheg (Wheel-Leg) Walking Robot Leg — Bio-Inspired Locomotion
// 3-spoke wheeled-leg that "rolls" over obstacles
// PETG (tough, flex-resistant) — 0.2mm, 4 walls, 25% infill
// DUAL COLOR: hub (dark) + spoke tips (bright grip material)
// Motor interface: M5 hex shaft (17mm flat-to-flat) or printed adapter

HUB_D     = 35;
HUB_H     = 20;
SHAFT_W   = 17;   // Hex shaft flat-to-flat
SHAFT_H   = 15;   // Shaft insert depth
SPOKE_L   = 75;   // Spoke length (determines stride)
SPOKE_W   = 14;
SPOKE_T   = 8;
TIP_D     = 22;   // Foot contact tip diameter
TIP_H     = 12;
N_SPOKES  = 3;
GRIP_T    = 3.0;  // Rubber-like outer grip layer

// ── Hub (Color 1) ─────────────────────────────────────
module hub() {
    difference() {
        union() {
            cylinder(d = HUB_D, h = HUB_H, $fn = 32);
            // Reinforcement flanges
            for (i = [0 : N_SPOKES - 1])
                rotate([0, 0, i * 360/N_SPOKES])
                    translate([HUB_D/2 - 4, -SPOKE_W/2, 0])
                        cube([4, SPOKE_W, HUB_H]);
        }
        // Hex shaft socket
        translate([0, 0, -1])
            cylinder(d = SHAFT_W / cos(30), h = SHAFT_H + 1, $fn = 6);
        // Set screw hole (M3, radial)
        translate([HUB_D/2, 0, SHAFT_H/2])
            rotate([0, 90, 0])
                cylinder(d = 3.2, h = HUB_D, $fn = 12);
        // Weight cutouts
        for (i = [0 : N_SPOKES - 1])
            rotate([0, 0, i * 360/N_SPOKES + 180/N_SPOKES])
                translate([HUB_D * 0.2, 0, 3])
                    cylinder(d = HUB_D * 0.22, h = HUB_H - 6, $fn = 14);
    }
}

// ── Spoke ─────────────────────────────────────────────
module spoke() {
    difference() {
        // Main spoke body (tapers toward tip)
        hull() {
            cylinder(d = SPOKE_W, h = SPOKE_T, $fn = 20);
            translate([SPOKE_L, 0, 0])
                cylinder(d = TIP_D, h = SPOKE_T, $fn = 20);
        }
        // Weight reduction hole
        translate([SPOKE_L * 0.25, -SPOKE_W/2 + 2.5, -1])
            cube([SPOKE_L * 0.5, SPOKE_W - 5, SPOKE_T + 2]);
        // Hub socket
        cylinder(d = HUB_D + 0.5, h = SPOKE_T + 1, $fn = 32);
    }
}

// ── Foot tip (Color 2 — flexible/grippy PETG) ────────
module foot_tip() {
    translate([SPOKE_L, 0, 0]) {
        difference() {
            // Curved contact surface
            sphere(d = TIP_D, $fn = 24);
            // Flat back (attaches to spoke)
            translate([-TIP_D, -TIP_D/2, -TIP_D/2])
                cube([TIP_D, TIP_D, TIP_D]);
            translate([-TIP_D/2, 0, 0])
                cylinder(d = 4, h = TIP_D, center = true, $fn = 12);
        }
        // Grip tread pattern
        for (a = [0, 30, 60, 90, 120, 150])
            rotate([a, 0, 0])
                translate([TIP_D/2 - 1, 0, 0])
                    cube([GRIP_T, 2.5, TIP_D * 0.5], center = true);
    }
}

// ── Full wheg assembly ────────────────────────────────
module wheg() {
    hub();
    for (i = [0 : N_SPOKES - 1])
        rotate([0, 0, i * 360/N_SPOKES]) {
            spoke();
            foot_tip();
        }
}

// Print layout
wheg();
// Print extra set of tips (Color 2)
translate([0, SPOKE_L + TIP_D + 10, 0])
    for (i = [0 : N_SPOKES - 1])
        rotate([0, 0, i * 360/N_SPOKES])
            translate([SPOKE_L, 0, 0])
                foot_tip();
