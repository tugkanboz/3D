// Gear-Driven Wall Clock — Decorative Exposed Mechanism
// DUAL COLOR: frame (dark wood PLA) + gears (brass/gold PLA)
// P2S: 0.2mm, 4 walls, 20% infill
// Hardware: 1x AA clock movement module (~$3), 2x M3 standoffs

// ── Involute gear parameters ──────────────────────────
function involute(r, a) = [
    r * (cos(a) + a * sin(a)),
    r * (sin(a) - a * cos(a))
];

module involute_gear(teeth, mod, thickness, pressure_angle = 20) {
    r_pitch  = teeth * mod / 2;
    r_base   = r_pitch * cos(pressure_angle);
    r_addend = r_pitch + mod;
    r_dedend = r_pitch - 1.25 * mod;
    tooth_a  = 360 / teeth;

    linear_extrude(thickness)
    union() {
        circle(r = r_dedend, $fn = max(teeth * 3, 48));
        for (i = [0 : teeth - 1])
            rotate([0, 0, i * tooth_a])
            polygon([for (a = [0 : 2 : 30])
                let(aa = a * PI / 180)
                involute(r_base, aa)
            ]);
    }
}

// ── Simplified printable gear (not true involute but looks great) ──
module display_gear(teeth, r, thickness, hub_d) {
    tooth_h = r * 0.12;
    tooth_w = (2 * PI * r / teeth) * 0.55;

    difference() {
        union() {
            cylinder(r = r, h = thickness, $fn = max(teeth*2, 48));
            // Teeth
            for (i = [0 : teeth - 1])
                rotate([0, 0, i * 360/teeth])
                    translate([r - 1, -tooth_w/2, 0])
                        hull() {
                            cube([1, tooth_w, thickness]);
                            translate([tooth_h, tooth_w*0.15, 0])
                                cube([0.5, tooth_w*0.7, thickness]);
                        }
        }
        // Center hub
        cylinder(d = hub_d, h = thickness + 1, $fn = 24);
        // Spoke holes (decorative)
        for (i = [0 : 5])
            rotate([0, 0, i * 60])
                translate([r * 0.55, 0, -1])
                    cylinder(d = r * 0.22, h = thickness + 2, $fn = 20);
    }
}

// ── Clock face ────────────────────────────────────────
FACE_D    = 280;
FACE_T    = 5;
GEAR_T    = 8;
MOV_D     = 58;    // Clock movement cutout

module clock_face() {
    difference() {
        cylinder(d = FACE_D, h = FACE_T, $fn = 80);
        // Movement cutout center
        cylinder(d = MOV_D, h = FACE_T + 1, $fn = 32);
        // Hanging hole
        translate([0, FACE_D/2 - 14, -1])
            cylinder(d = 6, h = FACE_T + 2, $fn = 20);
        // Hour markers (12 shallow holes)
        for (i = [0:11])
            rotate([0, 0, i * 30])
                translate([FACE_D/2 - 18, 0, FACE_T - 2])
                    cylinder(d = (i % 3 == 0) ? 8 : 5, h = 3, $fn = 16);
    }
    // Roman numeral bosses (raised)
    for (i = [1:12]) {
        angle = i * 30 - 90;
        translate([cos(angle)*(FACE_D/2-22), sin(angle)*(FACE_D/2-22), FACE_T])
            cylinder(d = 6, h = 1.5, $fn = 6);
    }
}

// ── Gear train (Color 2 — gold/brass PLA) ──────────────
LARGE_R  = 55;
MED_R    = 32;
SMALL_R  = 18;
TINY_R   = 10;

module gear_display() {
    // Large center gear (minute hand)
    translate([0, 0, FACE_T])
        display_gear(42, LARGE_R, GEAR_T, MOV_D + 2);
    // Medium upper-left
    translate([-(LARGE_R + MED_R + 2), 20, FACE_T])
        display_gear(24, MED_R, GEAR_T, 6);
    // Small lower-right
    translate([LARGE_R + SMALL_R + 2, -30, FACE_T])
        display_gear(14, SMALL_R, GEAR_T, 5);
    // Tiny accent
    translate([LARGE_R + SMALL_R*2 + TINY_R + 4, -30 + SMALL_R + TINY_R + 2, FACE_T])
        display_gear(8, TINY_R, GEAR_T, 4);
    // Hour hand gear (smaller, behind)
    translate([0, 0, FACE_T + GEAR_T + 1])
        display_gear(22, LARGE_R * 0.5, GEAR_T * 0.6, 5);
}

// Color 1: face
clock_face();
// Color 2: gears
gear_display();
