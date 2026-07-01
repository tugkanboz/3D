// Swiss Lever Escapement — Complete Clock Heart Display
// The escapement is the mechanism that makes a clock "tick" — it releases
// the gear train tooth-by-tooth, controlled by the oscillating balance wheel
// Every mechanical watch/clock since 1750 uses this fundamental mechanism
// DUAL COLOR: frame + escape wheel (body) | pallet fork + balance wheel (accent)
// PLA 0.15mm, 5 walls, 20% gyroid — M3 pivot shafts, 608 bearings for smooth motion
// Educational display: all parts printed separately, assembles with M3 pins

$fn = 60;

// ── Parameters ────────────────────────────────────────────
N_TEETH    = 15;      // Escape wheel tooth count (classic Swiss)
EW_R       = 48;      // Escape wheel radius (pitch)
EW_THICK   = 8;       // Escape wheel thickness
FORK_LEN   = 70;      // Pallet fork length (pivot to guard pin)
PALLET_W   = 6;       // Pallet stone width
PALLET_H   = 5;       // Pallet stone height (impulse face)
BW_R       = 30;      // Balance wheel radius
BW_THICK   = 5;       // Balance wheel thickness
FRAME_T    = 8;       // Frame plate thickness
FRAME_W    = 250;     // Frame width
FRAME_H    = 180;     // Frame height
PIVOT_D    = 3.1;     // Pivot shaft diameter (M3)
BEARING_D  = 22.2;    // 608 bearing outer diameter

// ── Tooth geometry ────────────────────────────────────────
// Swiss lever tooth: impulse face at 45°, locking face at 0° (radial)
// Each tooth has a sharp point, impulse face, and locking face
IMPULSE_ANG = 45;   // Impulse face angle
LOCK_ANG    = 10;   // Locking face angle (slight undercut)
TOOTH_H     = 7;    // Tooth height (from pitch circle)

module escape_wheel_tooth_2d() {
    // Tooth cross-section: asymmetric with impulse (sloped) and locking faces
    PITCH_W = 360/N_TEETH;
    polygon([
        [0, 0],                                          // root
        [-TOOTH_H*0.4, TOOTH_H*0.12],                  // locking shoulder
        [-TOOTH_H*0.12, TOOTH_H],                       // tip (locking side)
        [TOOTH_H*0.25, TOOTH_H],                        // tip (impulse side)
        [TOOTH_H*0.55, 0],                              // impulse ramp base
    ]);
}

module escape_wheel() {
    difference() {
        union() {
            // Wheel disk (spoked for lightness)
            difference() {
                cylinder(r=EW_R+TOOTH_H+1, h=EW_THICK, $fn=120);
                // 5 lightening holes (spoke pattern)
                for(i=[0:4]) rotate([0,0,i*72])
                    translate([EW_R*0.52, 0, -1]) cylinder(r=EW_R*0.22, h=EW_THICK+2, $fn=30);
            }
            // Teeth (15 asymmetric impulse teeth)
            for(i=[0:N_TEETH-1]) rotate([0,0, i*360/N_TEETH]) {
                translate([EW_R, 0, 0])
                    rotate([0,0, -5])  // slight tilt for correct geometry
                        linear_extrude(EW_THICK)
                            escape_wheel_tooth_2d();
            }
            // Hub
            cylinder(r=EW_R*0.22, h=EW_THICK+4, $fn=20);
        }
        // Pivot hole
        cylinder(d=PIVOT_D, h=EW_THICK+6, $fn=12);
        // Center hollow (hub interior)
        translate([0,0,2]) cylinder(r=EW_R*0.14, h=EW_THICK-4, $fn=20);
        // Engagement tick marks
        for(i=[0:N_TEETH-1]) rotate([0,0,i*360/N_TEETH])
            translate([EW_R+TOOTH_H+3, -0.3, EW_THICK-0.5])
                cube([3, 0.6, 0.8]);
    }
}

// ── Pallet fork (lever) ────────────────────────────────────
// The fork has two pallet stones that alternately catch and release teeth
// Entry pallet: catches tooth at one end of balance swing
// Exit pallet: catches tooth at other end of balance swing
ENTRY_ANG  = -24;   // Entry pallet angle from fork center
EXIT_ANG   =  24;   // Exit pallet angle from fork center

module pallet_stone(impulse_face=true) {
    difference() {
        cube([PALLET_H, PALLET_W, EW_THICK], center=true);
        // Beveled impulse face
        if(impulse_face)
            translate([0, -PALLET_W*0.6, -EW_THICK/2-1])
                rotate([0, 0, IMPULSE_ANG*0.5])
                    cube([PALLET_H*1.5, PALLET_W, EW_THICK+2]);
    }
}

module pallet_fork() {
    FORK_W = 10;
    difference() {
        union() {
            // Main fork body (Y-shaped lever)
            hull() {
                cylinder(d=18, h=EW_THICK, $fn=20);
                translate([FORK_LEN*0.6, 0, 0]) cylinder(d=12, h=EW_THICK, $fn=16);
            }
            // Fork prongs (the part that goes around the balance wheel)
            for(s=[-1,1]) translate([0, s*20, 0]) {
                hull() {
                    cylinder(d=8, h=EW_THICK, $fn=12);
                    translate([0, s*8, 0]) cylinder(d=5, h=EW_THICK, $fn=10);
                }
            }
            // Entry pallet arm
            rotate([0,0, ENTRY_ANG]) translate([EW_R*0.85, 0, 0])
                cylinder(d=PALLET_W+2, h=EW_THICK, $fn=16);
            // Exit pallet arm
            rotate([0,0, EXIT_ANG]) translate([EW_R*0.85, 0, 0])
                cylinder(d=PALLET_W+2, h=EW_THICK, $fn=16);
        }
        // Pivot hole (center of fork rotation)
        cylinder(d=PIVOT_D, h=EW_THICK+2, $fn=12);
        // Balance wheel slot (notch for roller jewel engagement)
        translate([-5, -6, -1]) cube([10, 12, EW_THICK+2]);
        // Label
        translate([10, -3, EW_THICK-1]) linear_extrude(1.2)
            text("PALLET", size=5, $fn=4);
    }
    // Entry pallet stone
    rotate([0,0, ENTRY_ANG]) translate([EW_R*0.85, 0, EW_THICK/2])
        pallet_stone(true);
    // Exit pallet stone
    rotate([0,0, EXIT_ANG]) translate([EW_R*0.85, 0, EW_THICK/2])
        pallet_stone(false);
    // Guard pin (prevents over-rotation)
    translate([-18, 0, EW_THICK]) cylinder(d=2, h=5, $fn=8);
}

// ── Balance wheel ──────────────────────────────────────────
// The timekeeper: oscillates at controlled frequency
// In a real watch: connected to hairspring coil
N_SPOKES = 5;
module balance_wheel() {
    difference() {
        union() {
            // Rim
            difference() {
                cylinder(r=BW_R, h=BW_THICK, $fn=80);
                cylinder(r=BW_R-4, h=BW_THICK+1, $fn=80);
            }
            // Spokes
            for(i=[0:N_SPOKES-1]) rotate([0,0,i*360/N_SPOKES])
                translate([0, -1.5, 0]) cube([BW_R-3, 3, BW_THICK]);
            // Hub
            cylinder(d=10, h=BW_THICK+3, $fn=20);
            // Roller jewel (impulse pin — small cylinder at right angle)
            translate([BW_R*0.45, 0, BW_THICK+1])
                cylinder(d=2.5, h=4, $fn=8);
        }
        // Pivot
        cylinder(d=PIVOT_D, h=BW_THICK+5, $fn=12);
        // Timing screws (4 small holes in rim for regulation)
        for(i=[0,90,180,270]) rotate([0,0,i])
            translate([BW_R-3, 0, -1]) cylinder(d=2.5, h=BW_THICK+2, $fn=8);
        // Label
        translate([-20, BW_R*0.25, BW_THICK-1]) linear_extrude(1.2)
            text("BALANCE", size=5.5, $fn=4);
    }
    // Hairspring simulation (flat spiral spring)
    for(i=[0:8]) rotate([0,0, i*45]) translate([BW_R*0.25 + i*1.2, -0.3, -1])
        cube([BW_R*0.08, 0.6, BW_THICK*0.8]);
}

// ── Frame plate ────────────────────────────────────────────
module frame_plate() {
    difference() {
        // Main plate
        cube([FRAME_W, FRAME_H, FRAME_T]);
        // Pivot holes (3 bearings)
        // Escape wheel pivot
        translate([FRAME_W*0.5, FRAME_H*0.55, -1])
            cylinder(d=PIVOT_D+0.3, h=FRAME_T+2, $fn=12);
        // Pallet fork pivot
        translate([FRAME_W*0.5+EW_R*1.5, FRAME_H*0.35, -1])
            cylinder(d=PIVOT_D+0.3, h=FRAME_T+2, $fn=12);
        // Balance wheel pivot
        translate([FRAME_W*0.5+EW_R*2.5, FRAME_H*0.55, -1])
            cylinder(d=PIVOT_D+0.3, h=FRAME_T+2, $fn=12);
        // Decorative window (shows gear train behind)
        translate([15, 15, -1]) cube([FRAME_W*0.35, FRAME_H-30, FRAME_T+2]);
        // Border chamfer
        translate([FRAME_W*0.1, FRAME_H*0.12, FRAME_T-1.5])
            linear_extrude(2) text("SWISS LEVER ESCAPEMENT", size=7, $fn=4);
        translate([FRAME_W*0.1, FRAME_H*0.05, FRAME_T-1.5])
            linear_extrude(2) text(str(N_TEETH," TEETH · 3Hz · EW∅=",EW_R*2,"mm"), size=5.5, $fn=4);
        // Corner mounting holes
        for(x=[15,FRAME_W-15]) for(y=[15,FRAME_H-15])
            translate([x,y,-1]) cylinder(d=4.2, h=FRAME_T+2, $fn=10);
    }
}

// ── Pillar posts ───────────────────────────────────────────
module pillar_post() {
    difference() {
        cylinder(d=10, h=EW_THICK+8, $fn=12);
        cylinder(d=3.5, h=EW_THICK+10, $fn=10);
    }
    cylinder(d=5, h=EW_THICK+12, $fn=10);
}

// ── Assembly ──────────────────────────────────────────────
EW_X = FRAME_W*0.5;  EW_Y = FRAME_H*0.55;
FP_X = EW_X+EW_R*1.5;  FP_Y = FRAME_H*0.35;
BW_X = EW_X+EW_R*2.5;  BW_Y = FRAME_H*0.55;

// Color 1 (body): frame + escape wheel
frame_plate();
translate([EW_X, EW_Y, FRAME_T+1]) escape_wheel();

// Color 2 (accent): pallet fork + balance wheel (in operating position)
translate([FP_X, FP_Y, FRAME_T+1]) pallet_fork();
translate([BW_X, BW_Y, FRAME_T+2]) balance_wheel();

// Pillar posts (4 posts hold the two frame plates)
for(x=[30, FRAME_W-30]) for(y=[30, FRAME_H-30])
    translate([x, y, FRAME_T]) pillar_post();
