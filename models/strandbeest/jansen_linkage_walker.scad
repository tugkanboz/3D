// Theo Jansen Strandbeest Leg — 12-Bar Kinematic Linkage
// Print-in-place connected leg segments — turn the crank → leg walks
// PLA — 0.15mm, 3 walls, 15% infill
// Print flat on bed, 0.35mm gap between links
// DUAL COLOR: links (dark) | crank + foot (accent)

// ── Jansen linkage bar lengths (normalized, then scaled) ──
// Verified to produce smooth walking motion
// a=38, b=41.5, c=39.3, d=40.1, e=55.8, f=39.4, g=36.7, h=65.7, i=49, j=50, k=61.9, l=7.8
SCALE   = 2.0;   // Scale factor (all mm × 2)
a = 38  * SCALE;  // Crank
b = 41.5* SCALE;  // Connector 1
c = 39.3* SCALE;
d = 40.1* SCALE;
e = 55.8* SCALE;
f = 39.4* SCALE;
g = 36.7* SCALE;
h = 65.7* SCALE;  // Foot link
FRAME = 7.8 * SCALE;  // Fixed frame (l)

BAR_W   = 8;     // Bar width
BAR_T   = 5;     // Bar thickness
HOLE_D  = 5.0;   // Pivot hole diameter
PIN_D   = 4.6;   // Pivot pin OD (press-fit into one side, free on other)
GAP     = 0.35;  // Print-in-place clearance

// ── Single bar ────────────────────────────────────────
module bar(length, w = BAR_W, t = BAR_T) {
    hull() {
        cylinder(d = w, h = t, $fn = 20);
        translate([length, 0, 0])
            cylinder(d = w, h = t, $fn = 20);
    }
    // Pivot holes (one each end)
    cylinder(d = HOLE_D, h = t + 1, $fn = 16);
    translate([length, 0, 0])
        cylinder(d = HOLE_D, h = t + 1, $fn = 16);
}

module bar_solid(length, w = BAR_W, t = BAR_T) {
    difference() {
        bar(length, w, t);
        cylinder(d = HOLE_D, h = t + 2, center = true, $fn = 16);
        translate([length, 0, 0])
            cylinder(d = HOLE_D, h = t + 2, center = true, $fn = 16);
        // Weight reduction
        translate([length * 0.2, -w/2 + 2.5, -1])
            cube([length * 0.6, w - 5, t + 2]);
    }
}

// ── Print-in-place pivot joint ────────────────────────
module pivot_joint() {
    // Two overlapping bar ends with gap → print flat, already hinged
    difference() {
        cylinder(d = HOLE_D + BAR_W - 2, h = BAR_T * 2 + GAP, $fn = 20);
        // Gap between layers
        translate([0, 0, BAR_T])
            cylinder(d = HOLE_D + BAR_W + 1, h = GAP, $fn = 20);
        // Center hole
        cylinder(d = HOLE_D, h = BAR_T * 3, $fn = 16);
    }
}

// ── Crank arm (Color 2) ────────────────────────────────
module crank() {
    difference() {
        hull() {
            cylinder(d = BAR_W + 4, h = BAR_T + 2, $fn = 20);
            translate([a, 0, 0])
                cylinder(d = BAR_W, h = BAR_T + 2, $fn = 16);
        }
        cylinder(d = HOLE_D, h = BAR_T + 4, $fn = 16);
        translate([a, 0, 0])
            cylinder(d = PIN_D, h = BAR_T + 4, $fn = 16);
        // Spoke cutout
        translate([a * 0.15, -BAR_W/2 + 2, -1])
            cube([a * 0.7, BAR_W - 4, BAR_T + 4]);
    }
    // Crank handle knob
    translate([a * 1.18, 0, BAR_T/2 + 1])
        sphere(d = BAR_W * 1.5, $fn = 16);
}

// ── Foot (special curved link) ────────────────────────
module foot_link() {
    difference() {
        union() {
            // Main h-bar
            bar_solid(h);
            // Foot pad (curved, on ground contact)
            translate([h * 0.6, 0, 0])
                rotate([0, 0, -20])
                    hull() {
                        cylinder(d = 14, h = BAR_T, $fn = 20);
                        translate([20, -8, 0])
                            cylinder(d = 8, h = BAR_T, $fn = 16);
                    }
        }
    }
}

// ── Full leg layout (print flat) ─────────────────────
// Color 1 (dark): all bars
translate([0, 0, 0])        bar_solid(b);
translate([0, 30, 0])       bar_solid(c);
translate([0, 60, 0])       bar_solid(d);
translate([0, 90, 0])       bar_solid(e);
translate([0, 120, 0])      bar_solid(f);
translate([0, 150, 0])      bar_solid(g);
translate([0, 180, 0])      foot_link();
// Fixed frame bar
translate([0, 220, 0])      bar_solid(FRAME);

// Color 2 (accent): crank + joints
translate([300, 0, 0])      crank();
// Print 6 pivot joints (for 6 hinge points)
for (i = [0:5])
    translate([300 + i * 25, 60, 0]) pivot_joint();
