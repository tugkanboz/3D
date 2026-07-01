// Sand Pendulum Harmograph — Lissajous Figure Tracing Machine
// A harmograph uses two pendulums (one X-axis, one Y-axis) to trace
// Lissajous curves in sand. The ratio of pendulum lengths determines the pattern:
// f_x/f_y = 1:1 → circle/ellipse | 2:1 → figure-8 | 3:2 → three-lobed knot
// Frequency ratio depends on pendulum LENGTH: f ∝ 1/√L
// DUAL COLOR: frame + base (body) | pendulum arms + sand funnel (accent)
// PLA 0.20mm, 4 walls — add sand to funnel, gently swing pendulum, watch!
// Pivot bearings: 608 (8×22×7) ball bearings press-fit in arms
// NOTE: fill tray underneath with fine sand (~0.5kg), 300×300mm area needed

$fn = 32;

// ── Base frame dimensions ─────────────────────────────────
FRAME_W  = 220;    // Frame width (X span)
FRAME_D  = 220;    // Frame depth (Y span)
FRAME_H  = 250;    // Frame height (pendulums hang from here)
TUBE_D   = 22;     // Frame tube outer diameter
TUBE_T   = 2.8;    // Frame tube wall thickness
BASE_T   = 8;      // Base plate thickness

// ── Pendulum parameters ────────────────────────────────────
PEND_W   = 18;     // Pendulum arm width
PEND_T   = 8;      // Pendulum arm thickness
PIVOT_D  = 22.2;   // 608 bearing outer diameter (press-fit)
PIVOT_H  = 7;      // 608 bearing height
WEIGHT_D = 50;     // Weight disk diameter
WEIGHT_H = 14;     // Weight disk height
THREAD_D = 3;      // Suspension thread hole diameter

// ── Sand funnel ────────────────────────────────────────────
FUNNEL_TOP_D = 80;   // Wide top of funnel
FUNNEL_BOT_D = 8;    // Sand flow nozzle diameter
FUNNEL_H     = 60;   // Funnel height

// ── Frame corner post ──────────────────────────────────────
module frame_post(height) {
    difference() {
        cylinder(d=TUBE_D, h=height, $fn=16);
        cylinder(d=TUBE_D-TUBE_T*2, h=height+1, $fn=16);
        // Mounting holes for crossbars
        for(h=[FRAME_H*0.5, FRAME_H*0.85, height-20])
            translate([0,0,h]) rotate([90,0,0])
                cylinder(d=6, h=TUBE_D+2, center=true, $fn=10);
    }
    // Base foot (flared)
    cylinder(d=TUBE_D+16, h=BASE_T, $fn=20);
}

// ── Frame crossbar ─────────────────────────────────────────
module frame_bar(length) {
    difference() {
        cylinder(d=TUBE_D*0.75, h=length, $fn=12);
        cylinder(d=TUBE_D*0.75-TUBE_T*2, h=length+1, $fn=12);
    }
}

// ── Pivot bracket (mounts at top of frame, holds bearing) ─
module pivot_bracket() {
    BW = TUBE_D*2.5;
    BH = 28;
    difference() {
        union() {
            cube([BW, BH, 15], center=true);
            translate([0,0,-7]) cylinder(d=PIVOT_D+6, h=PIVOT_H+4, center=true, $fn=24);
        }
        // Bearing pocket (press-fit 608)
        cylinder(d=PIVOT_D, h=PIVOT_H+1, center=true, $fn=24);
        // Mounting slot (for clamping to frame top bar)
        translate([0, 0, 6]) cube([TUBE_D*0.76, BH+2, 6], center=true);
        // Adjustment slot
        for(s=[-1,1]) translate([s*BW*0.3, 0, 0])
            cylinder(d=5, h=16, center=true, $fn=10);
    }
}

// ── Pendulum arm ──────────────────────────────────────────
// Physical principle: period T = 2π√(L/g) where L = arm length
// For 2:1 Lissajous ratio, one arm must be 4× longer than the other
// Short arm (X): 80mm active length → f ∝ 1/√80
// Long arm (Y): 160mm active length → f ∝ 1/√160 → ratio ≈ 1.41 ≈ √2:1
// For exact 2:1 ratio: L_Y = 4×L_X
ARM_SHORT = 90;    // X pendulum arm length
ARM_LONG  = 180;   // Y pendulum arm length (4× for 2:1 freq ratio)
ARM_ANGLE = 0;     // Initial displacement angle

module pendulum_arm(length, label="") {
    difference() {
        union() {
            // Main arm
            hull() {
                cylinder(d=PEND_W, h=PEND_T, $fn=20);
                translate([0, length, 0]) cylinder(d=PEND_W*0.6, h=PEND_T, $fn=16);
            }
            // Weight attachment boss (bottom)
            translate([0, length, 0]) cylinder(d=WEIGHT_D+4, h=PEND_T+4, $fn=40);
        }
        // Pivot bearing socket (top)
        translate([0,0,-1]) cylinder(d=PIVOT_D, h=PEND_T+3, $fn=24);
        // Thread hole for suspension adjustment
        translate([0, length*0.25, -1]) cylinder(d=THREAD_D, h=PEND_T+2, $fn=10);
        // Coupling rod hole (bottom — for attaching funnel arm)
        translate([0, length, -1]) cylinder(d=THREAD_D, h=PEND_T+6, $fn=10);
        // Weight mounting bore
        translate([0, length, PEND_T]) cylinder(d=6, h=WEIGHT_H+4, $fn=16);
        // Label
        if (label != "")
            translate([3, length*0.5, PEND_T-1])
                linear_extrude(1.2) text(label, size=6, $fn=4);
        // Length markings (every 20mm)
        for(lm=[20:20:length-20])
            translate([-PEND_W/2-0.5, lm, PEND_T-0.5])
                cube([PEND_W+1, 1, 1]);
    }
}

// ── Weight disk (adds mass for longer pendulum swing) ─────
module weight_disk(n=1) {
    difference() {
        cylinder(d=WEIGHT_D, h=WEIGHT_H*n, $fn=40);
        // Center bore for coupling rod
        cylinder(d=6.2, h=WEIGHT_H*n+2, $fn=16);
        // Grip flats
        for(a=[0,60,120]) rotate([0,0,a])
            translate([WEIGHT_D/2-1, -3, 0]) cube([5, 6, WEIGHT_H*n+2]);
        // Weight label
        translate([-18, -3, WEIGHT_H*n-1.2])
            linear_extrude(1.5) text(str(n,"× WEIGHT"), size=5, $fn=4);
    }
}

// ── Sand funnel ────────────────────────────────────────────
module sand_funnel() {
    difference() {
        union() {
            // Conical funnel body
            cylinder(d1=FUNNEL_TOP_D, d2=FUNNEL_BOT_D+4, h=FUNNEL_H, $fn=60);
            // Nozzle
            translate([0,0,-15]) cylinder(d=FUNNEL_BOT_D+4, h=16, $fn=20);
        }
        // Interior
        cylinder(d1=FUNNEL_TOP_D-6, d2=FUNNEL_BOT_D, h=FUNNEL_H, $fn=60);
        translate([0,0,-16]) cylinder(d=FUNNEL_BOT_D, h=17, $fn=16);
        // Attachment arm hole
        translate([-FUNNEL_TOP_D/2-1, 0, FUNNEL_H*0.7])
            rotate([0,90,0]) cylinder(d=THREAD_D, h=FUNNEL_TOP_D+2, $fn=10);
        // Flow control rings (decorative + functional ridges)
        for(z=[FUNNEL_H*0.3, FUNNEL_H*0.6, FUNNEL_H*0.85])
            translate([0,0,z])
                rotate_extrude($fn=60) translate([FUNNEL_TOP_D/4, 0])
                    square([3, 3]);
    }
}

// ── Sand tray (catch tray below) ──────────────────────────
module sand_tray() {
    TRAY_W = 300; TRAY_D = 300; TRAY_H = 12;
    difference() {
        cube([TRAY_W, TRAY_D, TRAY_H], center=true);
        translate([0,0,2]) cube([TRAY_W-8, TRAY_D-8, TRAY_H], center=true);
        // Reference grid (for Lissajous pattern measurement)
        for(x=[-6:1:6]) translate([x*20, 0, TRAY_H/2-0.5])
            cube([0.8, TRAY_D-10, 1], center=true);
        for(y=[-6:1:6]) translate([0, y*20, TRAY_H/2-0.5])
            cube([TRAY_W-10, 0.8, 1], center=true);
        // Label
        translate([-60, -TRAY_D/2+5, TRAY_H/2-1.5])
            linear_extrude(2) text("HARMOGRAPH SAND PENDULUM", size=6, $fn=4);
        // Freq ratio table
        translate([-60, -TRAY_D/2+15, TRAY_H/2-1.5])
            linear_extrude(2) text("1:1→circle  2:1→fig8  3:2→knot", size=5, $fn=4);
    }
}

// ── Assembly layout ───────────────────────────────────────
// Color 1 (frame/body):
// 4 corner posts
for(x=[-FRAME_W/2, FRAME_W/2]) for(y=[-FRAME_D/2, FRAME_D/2])
    translate([x, y, 0]) frame_post(FRAME_H);

// Top crossbars (supports pivot brackets)
translate([-FRAME_W/2, 0, FRAME_H-8]) rotate([90,0,90])
    frame_bar(FRAME_W);
translate([0, -FRAME_D/2, FRAME_H-8]) rotate([90,0,0])
    frame_bar(FRAME_D);
// Mid braces
for(y=[-FRAME_D/2, FRAME_D/2]) translate([-FRAME_W/2, y, FRAME_H*0.6])
    rotate([90,0,90]) frame_bar(FRAME_W);

// Sand tray (base)
translate([0, 0, BASE_T/2-4]) sand_tray();

// Color 2 (accent): pendulums + funnel
translate([FRAME_W*0.9, 0, 0]) {
    // X-axis pendulum (short — higher frequency)
    translate([0, 0, 0]) pendulum_arm(ARM_SHORT, "X");
    translate([PEND_W*2, 0, 0]) weight_disk(1);
    // Y-axis pendulum (long — lower frequency)
    translate([0, ARM_SHORT+30, 0]) pendulum_arm(ARM_LONG, "Y");
    translate([PEND_W*2, ARM_SHORT+30, 0]) weight_disk(2);
    // Sand funnel
    translate([0, ARM_LONG+60, 0]) sand_funnel();
    // Pivot brackets (2x)
    translate([0, 0, ARM_SHORT+80]) pivot_bracket();
    translate([0, ARM_SHORT+30, ARM_LONG+80]) pivot_bracket();
}
