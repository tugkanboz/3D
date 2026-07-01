// Antikythera Mechanism — World's First Analog Computer (~150 BC)
// Discovered 1901 in a Roman-era shipwreck off Antikythera, Greece
// Built in Rhodes, contains 37+ meshing bronze gears in a wooden shoebox
// Predicts: solar/lunar positions, eclipse dates, Olympic games calendar,
// and the planetary positions of the 5 known planets
// Key gear ratios encode: Saros cycle (223 lunations), Metonic (235/19 years),
// Callipic (76 years), Exeligmos (3×Saros), Moon anomaly (epicyclic)
// DUAL COLOR: gearwheels + frame (body) | dials + inscription plate (accent)
// PLA 0.15mm, 4 walls — display piece, all gears individually printable
// Based on published gear tooth counts from the 2016 Antikythera Research Team

$fn = 60;

// ── Parameters ────────────────────────────────────────────
MODULE_  = 0.8;   // Gear module (tooth size) — small but printable
GEAR_T   = 5;     // Gear thickness
CASE_T   = 4;     // Case wall thickness
CASE_W   = 248;   // Overall width (just fits P2S bed)
CASE_H   = 168;   // Overall height
CASE_D   = 18;    // Case depth

// ── Historical gear tooth counts ─────────────────────────
// Saros cycle: 223 synodic months = 18 years 11.3 days
B1_TEETH = 223;   // Main Saros drive wheel (largest gear)
B2_TEETH = 64;    // Meshes with b1
C1_TEETH = 38;    // Mean sun/lunar anomaly
C2_TEETH = 48;    // Meshes with c1
D1_TEETH = 24;    // Metonic train
D2_TEETH = 127;   // Metonic output (127/19 ≈ 6.68)
E1_TEETH = 32;    // Epicyclic pin-and-slot (lunar anomaly)
E2_TEETH = 32;    // Paired with e1
F1_TEETH = 54;    // Callipic cycle
F2_TEETH = 30;    // Connects Callipic to Exeligmos

// ── Gear radius from tooth count ─────────────────────────
function gear_r(n) = MODULE_ * n / 2;

// ── Involute gear tooth profile ───────────────────────────
// Simplified triangular tooth (period-accurate style)
// Real ancient gears had triangular teeth (not involute)
module gear_tooth_2d(r_pitch, n_teeth) {
    TOOTH_H = MODULE_ * 1.0;
    TOOTH_W = 2 * PI * r_pitch / n_teeth * 0.6;
    polygon([
        [-TOOTH_W*0.4, 0],
        [TOOTH_W*0.4, 0],
        [TOOTH_W*0.25, TOOTH_H],
        [-TOOTH_W*0.25, TOOTH_H],
    ]);
}

// ── Bronze gear wheel module ───────────────────────────────
// Ancient gears: triangular teeth (equilateral, not involute)
// Spoked design — alternating spoke/window pattern
module gear_wheel(n_teeth, n_spokes=5, hub_r_frac=0.2) {
    R_PITCH = gear_r(n_teeth);
    R_HUB   = max(R_PITCH * hub_r_frac, 4);
    R_RIM   = R_PITCH - MODULE_*0.3;
    SPOKE_W = max(R_PITCH * 0.07, 2.0);

    difference() {
        union() {
            // Rim disk
            cylinder(r=R_PITCH+MODULE_, h=GEAR_T, $fn=max(60, n_teeth*2));
            // Teeth (triangular — ancient style)
            for(i=[0:n_teeth-1]) rotate([0,0, i*360/n_teeth])
                translate([R_PITCH, 0, 0])
                    rotate([0,0, 90])
                        linear_extrude(GEAR_T) gear_tooth_2d(R_PITCH, n_teeth);
        }
        // Hollow between hub and rim (except spokes)
        difference() {
            cylinder(r=R_RIM, h=GEAR_T+2, $fn=max(60, n_teeth*2));
            // Hub solid core
            cylinder(r=R_HUB, h=GEAR_T+2);
            // Spokes
            for(i=[0:n_spokes-1]) rotate([0,0,i*360/n_spokes])
                translate([-SPOKE_W/2, R_HUB-0.5, 0])
                    cube([SPOKE_W, R_RIM-R_HUB+1, GEAR_T+2]);
        }
        // Center axle hole
        cylinder(r=2.5, h=GEAR_T+2, $fn=12);
        // Identification mark (number of teeth etched)
        translate([-R_HUB*0.7, -2, GEAR_T-1.2])
            linear_extrude(1.5) text(str(n_teeth), size=3.5, $fn=4);
    }
}

// ── Front dial plate (zodiac + Egyptian calendar) ─────────
// The front face shows two concentric rings:
// - Outer: Egyptian calendar (365 days + 5 epagomenal days)
// - Inner: Greek Zodiac (12 signs × 30°)
module front_dial() {
    R_OUTER = 78;  // Egyptian calendar ring
    R_INNER = 55;  // Zodiac ring
    ZODIAC = ["♈","♉","♊","♋","♌","♍","♎","♏","♐","♑","♒","♓"];
    MONTHS  = ["I","II","III","IV","V","VI","VII","VIII","IX","X","XI","XII"];

    difference() {
        cylinder(r=R_OUTER+6, h=CASE_T, $fn=180);
        cylinder(r=14, h=CASE_T+2, $fn=20); // center axle opening
    }

    // Egyptian calendar ring (365 divisions)
    for(i=[0:364]) rotate([0,0, i*360/365])
        translate([R_OUTER+2, -0.2, CASE_T-0.8])
            cube([i%30==0 ? 3.5 : (i%5==0 ? 2.2 : 1.2),
                  0.4,
                  i%30==0 ? 1.5 : 0.8]);

    // Zodiac ring (12 × 30°)
    for(i=[0:11]) {
        // Division lines
        rotate([0,0, i*30]) translate([R_INNER-2, -0.3, CASE_T-1])
            cube([15, 0.6, 1.2]);
        // Zodiac symbol label
        rotate([0,0, i*30+15]) translate([R_INNER+4, -3.5, CASE_T-1.5])
            linear_extrude(1.8) text(ZODIAC[i], size=5, $fn=4);
    }

    // Inner pointer marks for Moon and Sun positions
    for(i=[0:11]) rotate([0,0, i*30+15]) {
        translate([R_INNER-6, -1, CASE_T-1.5]) cube([4, 2, 1.5]);
    }

    // Ptolemaic cosmos label
    translate([-24, -R_OUTER-3, CASE_T-1.5]) linear_extrude(1.5)
        text("ΖΩΔΙΑΚΟΣ ΚΥΚΛΟΣ", size=4, $fn=4);  // ZODIAC CIRCLE
    translate([-18, R_OUTER+1, CASE_T-1.5]) linear_extrude(1.5)
        text("ΑΙΓΥΠΤΙΑΚΟ", size=4, $fn=4);  // EGYPTIAN
}

// ── Back dial (Saros + Exeligmos spiral) ─────────────────
// The back shows the Saros 223-month spiral for eclipse prediction
// and the 669-month (3×Saros) Exeligmos spiral below
module saros_dial() {
    R_SAR = 65;   // Saros spiral outer radius
    R_EXE = 40;   // Exeligmos (inside Saros ring)

    difference() {
        cylinder(r=R_SAR+8, h=CASE_T, $fn=120);
        cylinder(r=12, h=CASE_T+2, $fn=20);
    }

    // Saros spiral (223 months in 4 turns)
    TURNS = 4;
    MONTHS_PER_TURN = 56;
    for(i=[0:222]) {
        t = i / 223;
        ang = t * TURNS * 360;
        r_s = (R_EXE+10) + (R_SAR-R_EXE-18) * t;
        sx = r_s * cos(ang); sy = r_s * sin(ang);
        translate([sx, sy, CASE_T-1]) cylinder(r=0.6, h=1.5, $fn=6);
        // Month labels every 19 months (eclipse season)
        if(i % 19 == 0)
            translate([sx-4, sy-2, CASE_T-2]) linear_extrude(1.8)
                text(str(i), size=3.5, $fn=4);
    }

    // Exeligmos (inner spiral, 3 turns for 669 months)
    for(i=[0:53]) {
        t = i / 54;
        ang = t * 3 * 360;
        r_e = 14 + (R_EXE-8) * t;
        translate([r_e*cos(ang), r_e*sin(ang), CASE_T-0.8])
            cylinder(r=0.5, h=1.0, $fn=6);
    }

    // Labels
    translate([-20, R_SAR+2, CASE_T-1.5]) linear_extrude(1.5)
        text("SAROS 223 MONTHS", size=4, $fn=4);
    translate([-18, -R_SAR-6, CASE_T-1.5]) linear_extrude(1.5)
        text("EXELIGMOS × 3", size=4, $fn=4);
}

// ── Wooden case frame ─────────────────────────────────────
module case_frame() {
    difference() {
        cube([CASE_W, CASE_H, CASE_D]);
        // Interior
        translate([CASE_T, CASE_T, CASE_T])
            cube([CASE_W-CASE_T*2, CASE_H-CASE_T*2, CASE_D]);
        // Front viewing windows
        translate([CASE_W*0.5-82, CASE_H*0.5-90, -1])
            cube([164, 155, CASE_T+2]);  // front dial window
        translate([CASE_W*0.5-74, 12, -1])
            cube([148, 60, CASE_T+2]);   // back dial window (below)
        // Title inscription
        translate([8, CASE_H-14, CASE_D-2]) linear_extrude(2.5)
            text("ΑΝΤΙΚΥΘΗΡΑ ΜΗΧΑΝΙΣΜΟΣ  ~150 BC  ΡΟΔΟΣ", size=5.5, $fn=4);
        // Corner dovetails (authentic to ancient woodworking)
        for(x=[0,CASE_W-CASE_T]) for(y=[15, CASE_H-30]) translate([x,y,-1])
            cube([CASE_T+1, 10, CASE_D+2]);
    }
    // Case hinge (right side)
    translate([CASE_W-2, 20, CASE_D/2]) rotate([90,0,0])
        difference() {
            cylinder(d=8, h=CASE_H-40, $fn=16);
            cylinder(d=3.5, h=CASE_H-38, $fn=8);
        }
}

// ── Gear train layout ─────────────────────────────────────
// Historical gear positions relative to front plate center
// Center of mechanism at (CASE_W/2, CASE_H/2, ...)
CX = CASE_W/2; CY = CASE_H*0.58;

// Gear mesh positions: each gear center placed so teeth mesh
// b1 and b2 mesh: r(b1)+r(b2) = center distance
R_B1 = gear_r(B1_TEETH); R_B2 = gear_r(B2_TEETH);
R_C1 = gear_r(C1_TEETH); R_C2 = gear_r(C2_TEETH);
R_D1 = gear_r(D1_TEETH); R_D2 = gear_r(D2_TEETH);
R_E1 = gear_r(E1_TEETH);
R_F1 = gear_r(F1_TEETH); R_F2 = gear_r(F2_TEETH);

// b1 is centered at mechanism center
B1_X = CX; B1_Y = CY;
B2_X = CX + R_B1 + R_B2; B2_Y = CY;
C1_X = B2_X; C1_Y = CY - (R_B2 + R_C1);
C2_X = C1_X + R_C1 + R_C2; C2_Y = C1_Y;
D1_X = C2_X; D1_Y = C1_Y - (R_C2 + R_D1);
D2_X = D1_X + R_D1 + R_D2; D2_Y = D1_Y;
E1_X = CX - (R_B1 + R_E1); E1_Y = CY;

// ── Assembly ──────────────────────────────────────────────
// Color 1 (body): gearwheels + case
case_frame();

// Main gear train (all body color)
translate([B1_X, B1_Y, CASE_T]) gear_wheel(B1_TEETH, 7, 0.15);
translate([B2_X, B2_Y, CASE_T]) gear_wheel(B2_TEETH, 5);
translate([C1_X, C1_Y, CASE_T]) gear_wheel(C1_TEETH, 4);
translate([C2_X, C2_Y, CASE_T]) gear_wheel(C2_TEETH, 5);
translate([D1_X, D1_Y, CASE_T]) gear_wheel(D1_TEETH, 4);
translate([E1_X, E1_Y, CASE_T]) gear_wheel(E1_TEETH, 4, 0.3);

// Color 2 (accent): front dial + Saros dial
translate([B1_X, B1_Y, 0]) front_dial();
translate([B1_X, CY-R_B1-90, 0]) saros_dial();

// Axle pins (visible in the case)
for(pos=[[B1_X,B1_Y],[B2_X,B2_Y],[C1_X,C1_Y],[C2_X,C2_Y],[D1_X,D1_Y],[E1_X,E1_Y]])
    translate([pos[0], pos[1], 0]) cylinder(d=3, h=CASE_T+GEAR_T+4, $fn=8);
