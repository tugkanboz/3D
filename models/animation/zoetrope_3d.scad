// 3D Zoetrope — Pre-Cinema Animation Device
// Spin at ~600 RPM under strobe/phone flash → figures animate
// 12 frames of a galloping horse (Muybridge-inspired)
// DUAL COLOR: drum (dark) + animated figures (white/bright)
// PLA — 0.2mm, 4 walls, 15% infill
// Base: bearing mount for smooth spin (608 bearing)

FRAMES    = 12;
DRUM_D    = 230;   // Drum outer diameter
DRUM_H    = 80;
DRUM_T    = 3.5;   // Drum wall thickness
SLIT_W    = 3.0;   // Viewing slit width
SLIT_H    = 22;    // Slit height
FIGURE_H  = 38;    // Animation figure height
FIGURE_PAD = 5;    // Padding around figure
BASE_D    = 100;
BASE_H    = 30;
BEARING_OD = 22.2; // 608ZZ bearing OD
BEARING_ID = 8.2;  // 608ZZ bearing bore
BEARING_H  = 7.2;

// ── Drum ─────────────────────────────────────────────
module drum() {
    difference() {
        union() {
            // Outer cylinder
            cylinder(d = DRUM_D, h = DRUM_H, $fn = 100);
            // Bottom flange
            cylinder(d = DRUM_D + 16, h = 8, $fn = 80);
        }
        // Hollow interior
        translate([0, 0, 8])
            cylinder(d = DRUM_D - DRUM_T*2, h = DRUM_H, $fn = 100);
        // Viewing slits (one per frame, upper portion)
        for (i = [0 : FRAMES - 1])
            rotate([0, 0, i * 360/FRAMES])
                translate([DRUM_D/2 - DRUM_T - 0.5, -SLIT_W/2, DRUM_H - SLIT_H - 4])
                    cube([DRUM_T + 2, SLIT_W, SLIT_H]);
        // Center axle hole
        cylinder(d = BEARING_ID + 0.4, h = DRUM_H + 1, $fn = 20);
        // Bearing seat (bottom)
        translate([0, 0, -1])
            cylinder(d = BEARING_OD + 0.3, h = BEARING_H + 1, $fn = 32);
    }
}

// ── Muybridge galloping horse — 12 key frames ─────────
// Simplified silhouette, each frame slightly different pose
module horse_frame(frame) {
    phase = frame / FRAMES;
    // Body
    body_lean = sin(phase * 360) * 5;
    translate([0, 0, 0])
    rotate([0, body_lean, 0]) {
        // Torso
        hull() {
            translate([0, 0, 18]) sphere(d = 22, $fn = 16);
            translate([15, 0, 14]) sphere(d = 16, $fn = 14);
            translate([-12, 0, 12]) sphere(d = 12, $fn = 12);
        }
        // Head + neck
        hull() {
            translate([15, 0, 14]) sphere(d = 12, $fn = 12);
            translate([22, 0, 22]) sphere(d = 10, $fn = 12);
            translate([26, 0, 20]) sphere(d = 7, $fn = 10);
        }
        // Legs (4 legs, phase-shifted for gallop cycle)
        leg_angles = [
            phase * 360,
            phase * 360 + 180,
            phase * 360 + 90,
            phase * 360 + 270
        ];
        leg_xpos = [-8, -4, 6, 10];
        for (li = [0:3]) {
            la = leg_angles[li];
            lx = leg_xpos[li];
            // Upper leg
            hull() {
                translate([lx, 0, 12]) sphere(d = 5, $fn = 10);
                translate([lx + sin(la)*4, 0, 12 - cos(la)*6 - 6])
                    sphere(d = 4, $fn = 10);
            }
            // Lower leg
            hull() {
                translate([lx + sin(la)*4, 0, 12 - cos(la)*6 - 6])
                    sphere(d = 4, $fn = 10);
                translate([lx + sin(la)*6, 0, 12 - cos(la)*6 - 13])
                    sphere(d = 3, $fn = 8);
            }
        }
        // Tail
        hull() {
            translate([-12, 0, 15]) sphere(d = 6, $fn = 10);
            translate([-17, 0, 10 + sin(phase*360)*4]) sphere(d = 3, $fn = 8);
        }
    }
}

// ── Figure strip (prints inside drum bottom) ──────────
module figure_strip() {
    for (i = [0 : FRAMES - 1]) {
        angle = i * 360/FRAMES;
        r = (DRUM_D/2 - DRUM_T - FIGURE_H - FIGURE_PAD);
        rotate([0, 0, angle])
            translate([r, 0, 8])
                rotate([0, 0, -angle])
                    horse_frame(i);
    }
}

// ── Spin base (bearing housing) ───────────────────────
module spin_base() {
    difference() {
        union() {
            cylinder(d = BASE_D, h = BASE_H, $fn = 48);
            // Axle post
            translate([0, 0, BASE_H])
                cylinder(d = BEARING_OD + 6, h = 15, $fn = 32);
        }
        // Bearing socket (press fit)
        translate([0, 0, BASE_H + 15 - BEARING_H])
            cylinder(d = BEARING_OD + 0.2, h = BEARING_H + 1, $fn = 32);
        // Axle bore
        cylinder(d = BEARING_ID - 0.2, h = BASE_H + 16, $fn = 16);
        // Lightening holes
        for (i = [0:4])
            rotate([0, 0, i * 72])
                translate([BASE_D * 0.3, 0, 5])
                    cylinder(d = 18, h = BASE_H - 6, $fn = 20);
    }
}

// Color 1 (dark): drum + base
drum();
translate([0, 0, 0]) spin_base();
// Color 2 (white): figures (placed inside drum at base level)
figure_strip();
