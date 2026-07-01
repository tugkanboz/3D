// Mechanical Music Box — Pin Cylinder + Steel Comb
// Rotating cylinder pins pluck a 15-note steel comb → plays melody
// DUAL COLOR: cylinder + frame (dark walnut PLA) | comb housing (brass PLA)
// PLA — 0.15mm, 4 walls, 20% infill
// Hardware: 1x music box comb movement ($8), or DIY steel comb
// Cylinder plays: "Happy Birthday" (15 pins, 1 rotation = 1 bar)

// ── Melody data: [tine_idx (0-14), angle_deg] ─────────
// 15-tine comb, C major scale (C4-B5)
// Happy Birthday melody pin positions (simplified)
PINS = [
    [4,  0],   // G
    [4,  18],  // G
    [6,  36],  // A
    [4,  54],  // G
    [9,  72],  // C
    [8,  90],  // B
    [4,  108], // G
    [4,  126], // G
    [6,  144], // A
    [4,  162], // G
    [11, 180], // D
    [9,  198], // C
    [4,  216], // G
    [4,  234], // G
    [4,  252], // G (high)
    [13, 270], // E
    [9,  288], // C
    [8,  306], // B
    [6,  324], // A
    [11, 342], // D (repeat bar)
];

TINES     = 15;
CYL_D     = 35;    // Cylinder diameter
CYL_L     = 55;    // Cylinder length
PIN_D     = 1.8;   // Pin diameter
PIN_H     = 2.5;   // Pin height above cylinder
PIN_PITCH = CYL_L / TINES;  // Axial spacing
AXLE_D    = 6.0;   // M6 axle
FRAME_W   = 70;
FRAME_D   = 90;
FRAME_H   = 50;
WALL      = 4.0;
COMB_H    = 45;
COMB_W    = CYL_L + 4;
COMB_T    = 6.0;

// ── Pin cylinder ──────────────────────────────────────
module pin_cylinder() {
    difference() {
        cylinder(d=CYL_D, h=CYL_L, $fn=80);
        // Axle bore
        translate([0,0,-1])
            cylinder(d=AXLE_D, h=CYL_L+2, $fn=16);
        // Winding key slot (one end)
        translate([-2, -2, CYL_L-8])
            cube([4,4,10]);
    }
    // Melody pins
    for (p = PINS) {
        tine = p[0];
        ang  = p[1];
        z    = tine * PIN_PITCH + PIN_PITCH/2;
        rotate([0,0,ang])
            translate([CYL_D/2, 0, z])
                cylinder(d=PIN_D, h=PIN_H, $fn=8);
    }
}

// ── Frame box (Color 1 — walnut PLA) ──────────────────
module frame() {
    difference() {
        cube([FRAME_W, FRAME_D, FRAME_H]);
        // Inner hollow
        translate([WALL,WALL,WALL])
            cube([FRAME_W-WALL*2, FRAME_D-WALL*2, FRAME_H]);
        // Cylinder window (top)
        translate([FRAME_W/2-CYL_D/2-2, WALL-1, FRAME_H-14])
            cube([CYL_D+4, FRAME_D-WALL*2+2, 16]);
        // Axle holes
        for (y=[FRAME_D*0.25, FRAME_D*0.75])
            translate([-1, y, FRAME_H*0.55])
                rotate([0,90,0])
                    cylinder(d=AXLE_D+0.5, h=FRAME_W+2, $fn=16);
        // Lid recess
        translate([1,1,FRAME_H-WALL])
            cube([FRAME_W-2, FRAME_D-2, WALL+1]);
        // Decorative inset (front panel)
        translate([WALL*1.5, -0.5, WALL*1.5])
            cube([FRAME_W-WALL*3, WALL, FRAME_H-WALL*4]);
    }
    // Corner wooden joints (box joints)
    for (x=[0,FRAME_W-3], z=[0, FRAME_H*0.33, FRAME_H*0.66])
        translate([x, FRAME_D, z])
            cube([3, 4, FRAME_H*0.25]);
    // Wind-up key housing (side)
    translate([FRAME_W, FRAME_D*0.25-6, FRAME_H*0.55-6])
        difference() {
            cube([10, 12, 12]);
            translate([0, 3, 3])
                cube([12, 6, 6]);
        }
}

// ── Comb housing (Color 2 — brass PLA) ────────────────
module comb_housing() {
    difference() {
        cube([COMB_W, COMB_T, COMB_H]);
        // Tine slots (15 slots create tines in real metal comb)
        for (i=[0:TINES-1])
            translate([i*PIN_PITCH+1, -1, 15])
                cube([PIN_PITCH-1.5, COMB_T+2, COMB_H]);
        // Mounting holes
        for (x=[5, COMB_W-5])
            translate([x, COMB_T/2, 5])
                rotate([90,0,0])
                    cylinder(d=3, h=COMB_T+1, $fn=12);
    }
    // Resonator bumps (one per tine — tuning mass)
    for (i=[0:TINES-1])
        translate([i*PIN_PITCH+PIN_PITCH/2, COMB_T, 8])
            cylinder(d=PIN_PITCH*0.5, h=3+i*0.5, $fn=10);
    // Decorative engraving boss
    translate([COMB_W/2, COMB_T, COMB_H-8])
        linear_extrude(1.5) text("♪", size=10, halign="center", $fn=8);
}

// ── Lid with music note inlay ─────────────────────────
module lid() {
    difference() {
        cube([FRAME_W-2, FRAME_D-2, WALL]);
        // Inset recess for decorative label
        translate([8, 8, WALL-1.5])
            cube([FRAME_W-18, FRAME_D-18, 2]);
    }
    // Music notes (raised)
    for (x=[10,25,40])
        translate([x, FRAME_D/2-5, WALL])
            linear_extrude(2)
                text("♩", size=9, halign="center", $fn=6);
}

// Layout: Color 1
frame();
translate([FRAME_W+10, 0, 0]) lid();
// Pin cylinder (Color 1 + pins color 2)
translate([FRAME_W+10, FRAME_D+10, 0]) pin_cylinder();
// Color 2 (brass): comb
translate([0, FRAME_D+10, 0]) comb_housing();
