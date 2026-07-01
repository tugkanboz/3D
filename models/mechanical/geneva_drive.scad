// Geneva Drive Mechanism — 4-Slot Intermittent Motion
// Drive wheel pin enters Geneva wheel slots → converts continuous to step rotation
// 1 drive revolution = 90° Geneva step (4-slot = 4 steps per revolution)
// DUAL COLOR: drive wheel (dark) | Geneva wheel (accent)
// PLA — 0.2mm, 4 walls, 20% infill — print flat, axle holes for M5 bolts
// Used in: film projectors, watches, escapements, vending machines

SLOTS     = 4;      // Number of slots (4=most common, 3/5/6 also valid)
MOD       = 2.5;    // Module (tooth size) — not used here but sets scale
// Derived geometry (exact Geneva relations):
// Lock radius = center distance * sin(π/n)
// Drive radius such that pin circle = center distance

CENTER_D  = 80;     // Center-to-center distance between axles
PIN_R     = 6;      // Drive pin radius
SLOT_W    = PIN_R * 2 + 0.5;  // Slot width (pin diameter + clearance)
SLOT_D    = CENTER_D * 0.55;  // Slot depth
WHEEL_T   = 10;     // Wheel thickness
WALL      = 3.5;
AXLE_D    = 5.2;    // M5 bolt clearance

// ── Geneva wheel geometry ──────────────────────────────
// Radius of Geneva wheel = CENTER_D * sin(π/SLOTS) / cos(π/SLOTS) + some
// Lock arc radius = CENTER_D * sin(π/SLOTS)
LOCK_R  = CENTER_D * sin(180/SLOTS);
GW_R    = CENTER_D - LOCK_R;  // Geneva wheel outer radius (approximate)

module geneva_wheel() {
    difference() {
        union() {
            // Main disc
            cylinder(r=GW_R, h=WHEEL_T, $fn=80);
            // Hub
            cylinder(d=AXLE_D*3, h=WHEEL_T+4, $fn=24);
        }
        // Center axle
        cylinder(d=AXLE_D, h=WHEEL_T+6, $fn=16);
        // 4 radial slots (for drive pin to enter)
        for (i=[0:SLOTS-1])
            rotate([0,0, i*360/SLOTS])
                translate([GW_R*0.45, -SLOT_W/2, -1])
                    cube([SLOT_D, SLOT_W, WHEEL_T+2]);
        // Lock arc cutouts (prevent rotation between steps)
        for (i=[0:SLOTS-1])
            rotate([0,0, i*360/SLOTS + 360/(SLOTS*2)])
                translate([GW_R-LOCK_R*0.18, 0, -1])
                    cylinder(r=LOCK_R*0.22, h=WHEEL_T+2, $fn=20);
        // Spokes (weight reduction)
        for (i=[0:SLOTS-1])
            rotate([0,0, i*360/SLOTS + 45])
                translate([AXLE_D*2, -4, -1])
                    cube([GW_R-AXLE_D*2.5, 8, WHEEL_T+2]);
    }
    // Tooth marks (step indicator lines)
    for (i=[0:SLOTS-1])
        rotate([0,0, i*360/SLOTS])
            translate([GW_R-3, -0.75, WHEEL_T])
                cube([2.5, 1.5, 2]);
}

// ── Drive wheel (crank with pin) ──────────────────────
DRIVE_R  = CENTER_D - GW_R;

module drive_wheel() {
    difference() {
        union() {
            // Main disc
            cylinder(r=DRIVE_R, h=WHEEL_T, $fn=60);
            // Hub
            cylinder(d=AXLE_D*3, h=WHEEL_T+4, $fn=24);
            // Drive pin
            translate([DRIVE_R*0.72, 0, WHEEL_T])
                cylinder(d=PIN_R*2, h=PIN_R*1.5, $fn=20);
            // Locking arc (blocks Geneva between steps)
            // Raised arc that fits into Geneva lock cutout
            translate([0, 0, WHEEL_T-1])
                rotate([0, 0, 45])
                    difference() {
                        cylinder(r=DRIVE_R*0.85, h=2.5, $fn=60);
                        cylinder(r=DRIVE_R*0.72, h=3,   $fn=60);
                        // Cut to leave only locking arc sector
                        for (cut=[0,90,180])
                            rotate([0,0,cut])
                                translate([-CENTER_D,-CENTER_D,-1])
                                    cube([CENTER_D, CENTER_D*2, 5]);
                    }
        }
        // Axle bore
        cylinder(d=AXLE_D, h=WHEEL_T+8, $fn=16);
        // Spokes
        for (i=[0:2])
            rotate([0,0, i*120+30])
                translate([AXLE_D*1.8, -3, -1])
                    cube([DRIVE_R-AXLE_D*2, 6, WHEEL_T+2]);
    }
    // Arrow direction indicator
    translate([DRIVE_R*0.35, -2, WHEEL_T+0.5])
        linear_extrude(1.5)
            text("↺", size=8, halign="center", $fn=4);
}

// ── Frame plate ───────────────────────────────────────
module frame() {
    FW = CENTER_D*2 + GW_R + DRIVE_R + 20;
    FH = max(GW_R, DRIVE_R)*2 + 20;
    difference() {
        translate([-DRIVE_R-10, -FH/2, -WALL])
            cube([FW, FH, WALL]);
        // Axle holes
        cylinder(d=AXLE_D+0.3, h=WALL+2, $fn=16);
        translate([CENTER_D, 0, 0])
            cylinder(d=AXLE_D+0.3, h=WALL+2, $fn=16);
        // Mounting holes
        for (x=[-DRIVE_R, CENTER_D+GW_R-5], y=[-FH/2+8, FH/2-8])
            translate([x, y, -WALL-1])
                cylinder(d=4, h=WALL+2, $fn=10);
        // Label
        translate([CENTER_D/2-35, -FH/2+4, -WALL-0.5])
            linear_extrude(1.5)
                text(str(SLOTS, "-SLOT GENEVA DRIVE"), size=5.5, $fn=4);
    }
}

// ── Step counter indicator ────────────────────────────
module step_indicator() {
    translate([CENTER_D, 0, WHEEL_T+6]) {
        difference() {
            cylinder(d=AXLE_D*4, h=3, $fn=24);
            cylinder(d=AXLE_D+0.3, h=4, $fn=16);
        }
        for (i=[0:SLOTS-1])
            rotate([0,0, i*360/SLOTS])
                translate([AXLE_D*2.2, -0.8, 2.5])
                    linear_extrude(1.5)
                        text(str(i+1), size=3.5, $fn=4);
    }
}

// Color 1 (dark): frame + drive wheel
frame();
drive_wheel();
// Color 2 (accent): Geneva wheel + step indicator
translate([CENTER_D, 0, 0]) {
    geneva_wheel();
    step_indicator();
}
