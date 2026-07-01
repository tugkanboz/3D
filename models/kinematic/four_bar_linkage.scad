// Four-Bar Linkage Mechanism — Complete Printable Kinematic Demonstrator
// Converts rotary input to complex coupler curve output — Grashof crank-rocker
// Coupler curve traces a figure-8 / petal path based on link lengths
// DUAL COLOR: ground link + frame (body) | crank + coupler + rocker (accent)
// PLA 0.15mm, 4 walls, 15% infill — pin joints use M4 bolts, 0.40mm gaps
// Link ratios: crank=1, coupler=2.5, rocker=2, ground=2.8 (Grashof: L+S < P+Q)

$fn = 32;

// ── Link dimensions ───────────────────────────────────────
LINK_W  = 14;    // Link width (perpendicular to axis)
LINK_T  = 6;     // Link thickness
PIN_D   = 4.2;   // M4 bolt clearance
HUB_D   = 16;    // Hub diameter around pins
GAP     = 0.40;  // Print-in-place clearance (NOT print-in-place — assemble with bolts)

// ── Grashof link lengths ──────────────────────────────────
// Grashof condition: Lmin + Lmax < Lp + Lq (where p,q are remaining links)
// Using: crank=40, coupler=100, rocker=80, ground=112
// → 40 + 112 = 152 < 100 + 80 = 180 ✓ (Grashof satisfied — full crank rotation)
L_CRANK  = 40;
L_COUPLE = 100;
L_ROCKER = 80;
L_GROUND = 112;

// ── Coupler point (traces the curve) ─────────────────────
CP_D = 80;   // Distance from coupler A end
CP_A = 60;   // Angle along coupler (degrees from coupler axis)

// ── Basic link module ─────────────────────────────────────
module link(length, w=LINK_W, t=LINK_T, hub_d=HUB_D, pin_d=PIN_D) {
    difference() {
        union() {
            // Link body
            hull() {
                translate([hub_d/2-2, 0, 0]) cube([length-hub_d+4, w, t], center=false);
                translate([0, 0, 0]) cylinder(d=hub_d, h=t, $fn=24);
                translate([length, 0, 0]) cylinder(d=hub_d, h=t, $fn=24);
                translate([hub_d/2-2, -w/2, 0]) cube([length-hub_d+4, w, t]);
            }
            // Reinforcement ribs
            for(x=[length*0.33, length*0.66])
                translate([x-2, -w/2, 0]) cube([4, w, t+2]);
        }
        // Pin holes at both ends
        translate([0, 0, -1]) cylinder(d=pin_d, h=t+2, $fn=16);
        translate([length, 0, -1]) cylinder(d=pin_d, h=t+2, $fn=16);
        // Lightening holes (weight reduction)
        for(x=[length*0.3, length*0.55, length*0.75])
            translate([x, 0, -1]) cylinder(d=w*0.55, h=t+2, $fn=16);
    }
}

// ── Crank (input link — full 360° rotation) ──────────────
module crank() {
    difference() {
        union() {
            // Crank arm
            hull() {
                cylinder(d=HUB_D*1.4, h=LINK_T, $fn=24);
                translate([L_CRANK, 0, 0]) cylinder(d=HUB_D, h=LINK_T, $fn=24);
            }
            // Balancing counterweight (opposite side)
            hull() {
                cylinder(d=HUB_D*1.4, h=LINK_T, $fn=24);
                translate([-L_CRANK*0.4, 0, 0]) cylinder(d=HUB_D*0.7, h=LINK_T, $fn=24);
            }
        }
        // Drive shaft (D-flat for grip)
        cylinder(d=PIN_D, h=LINK_T+2, $fn=16);
        translate([-PIN_D/2, PIN_D*0.4, -1]) cube([PIN_D, PIN_D, LINK_T+3]);
        // Coupler pin hole
        translate([L_CRANK, 0, -1]) cylinder(d=PIN_D, h=LINK_T+2, $fn=16);
        // Crank label (1)
        translate([L_CRANK*0.5, -4, LINK_T-0.5]) linear_extrude(1)
            text("CRANK", size=4.5, halign="center", $fn=4);
    }
}

// ── Coupler (floating link with coupler point) ────────────
module coupler() {
    link(L_COUPLE);
    // Coupler point indicator (traces the curve)
    translate([CP_D * cos(CP_A), CP_D * sin(CP_A), 0])
        difference() {
            cylinder(d=10, h=LINK_T+4, $fn=20);
            cylinder(d=3, h=LINK_T+5, $fn=10);  // Pen hole!
        }
    // Label
    translate([L_COUPLE*0.4, 6, LINK_T-0.5]) linear_extrude(1)
        text("COUPLE", size=4, $fn=4);
}

// ── Rocker (output link — oscillates back and forth) ─────
module rocker() {
    difference() {
        union() {
            link(L_ROCKER);
            // Output indicator arm
            translate([L_ROCKER, 0, LINK_T])
                cylinder(d=10, h=18, $fn=8);  // Arrow indicator
        }
        // Arrow top
        translate([L_ROCKER, 0, LINK_T+15]) cylinder(d1=14, d2=0, h=6, $fn=8);
    }
    translate([L_ROCKER*0.4, 6, LINK_T-0.5]) linear_extrude(1)
        text("ROCKER", size=4, $fn=4);
}

// ── Ground link (fixed frame) ──────────────────────────────
module ground_link() {
    FW = L_GROUND + HUB_D*2;
    FH = max(L_ROCKER, L_COUPLE)*1.2;
    difference() {
        union() {
            // Base plate
            translate([0, -FH*0.55, 0]) cube([FW, FH, LINK_T-1]);
            // Ground pins (fixed bearings)
            cylinder(d=HUB_D*1.5, h=LINK_T+4, $fn=24);
            translate([L_GROUND, 0, 0]) cylinder(d=HUB_D*1.5, h=LINK_T+4, $fn=24);
        }
        // Drive shaft bore
        cylinder(d=PIN_D, h=LINK_T+6, $fn=16);
        // Rocker pivot bore
        translate([L_GROUND, 0, -1]) cylinder(d=PIN_D, h=LINK_T+6, $fn=16);
        // Mounting holes (4x)
        for(x=[FW*0.15, FW*0.85]) for(y=[-FH*0.4, FH*0.15])
            translate([x-HUB_D/2, y, -1]) cylinder(d=4, h=LINK_T+1, $fn=10);
        // Scale markings
        for(i=[0:5])
            translate([L_GROUND*i/5-1, -FH*0.52, LINK_T-2])
                cube([2, 4, 2]);
        // Label
        translate([L_GROUND/2, -FH*0.50, LINK_T-2])
            linear_extrude(2) text("4-BAR LINKAGE", size=5.5, halign="center", $fn=4);
        // Coupler curve tracing area (grid)
        for(x=[0:8:L_GROUND]) for(y=[0:8:FH*0.6])
            translate([x, y-FH*0.3, -1]) cylinder(d=1.5, h=2, $fn=6);
    }
    // Coupler curve tracing board overlay
    translate([0, 0, LINK_T+4]) difference() {
        translate([0, -FH*0.55, 0]) cube([FW, FH, 1.5]);
        // Tracing grid holes
        for(x=[10:12:FW-10]) for(y=[-FH*0.4:12:FH*0.35])
            translate([x, y, -1]) cylinder(d=4, h=3, $fn=8);
        // Border
        translate([3,3-FH*0.55,0]) cube([FW-6, FH-6, 2]);
    }
}

// ── Pin spacers (printed separately, slip on M4 bolts) ────
module pin_spacer(h=LINK_T+2) {
    difference() {
        cylinder(d=HUB_D*0.72, h=h, $fn=20);
        cylinder(d=PIN_D+0.2, h=h+1, $fn=16);
    }
}

// ── Assembly ──────────────────────────────────────────────
// Color 1 (body): ground link
ground_link();

// Color 2 (accent): moving links (shown in separated positions)
translate([0, 0, LINK_T+12]) {
    crank();
    translate([L_CRANK, 0, 0]) coupler();
    translate([L_GROUND, 0, 0]) rocker();
}

// Pin spacers (accent color — 4 sets)
translate([0, -HUB_D*3, 0]) for(i=[0:3])
    translate([i*HUB_D*1.8, 0, 0]) pin_spacer();
