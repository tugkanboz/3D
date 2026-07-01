// Cycloidal Drive — Hypocycloid Gear Reduction
// Uses epitrochoid curve profile: N_LOBES lobes fit inside N_PINS rollers → ratio = N_LOBES:1
// With 11 pins / 10 lobes: 10:1 reduction in a single compact stage
// Compare: Planetary = 4:1, Geneva = step-function, Harmonic = 31:1 same volume
// DUAL COLOR: housing ring + backplate (body) | cycloidal disk + output shaft (accent)
// PLA 0.15mm, 5 walls, 20% gyroid — M4 roller pins (smooth), M6 output shaft

$fn = 80;

// ── Core parameters ───────────────────────────────────────
N_PINS   = 11;     // Number of ring pins (rollers)
N_LOBES  = 10;     // Disk lobes = N_PINS - 1 → ratio = N_LOBES:1
R_PIN_CIRCLE = 60; // Radius of pin circle (center of pins)
r_PIN    = 4.5;    // Pin roller radius (M4 rod fits inside with 0.5mm clearance)
ECCEN    = 3.8;    // Eccentricity (input cam offset)
DISK_T   = 14;     // Disk thickness
THICK    = 60;     // Total housing height
WALL     = 4.0;
AXLE_IN  = 5.2;   // Input shaft (M5)
AXLE_OUT = 6.2;   // Output shaft (M6)
STEPS    = 720;   // Profile resolution (must be multiple of N_LOBES)

// ── Derived dimensions ─────────────────────────────────────
HOUSING_D = (R_PIN_CIRCLE + r_PIN + WALL) * 2;

// ── Cycloidal disk profile ─────────────────────────────────
// Parametric equation for hypocycloid (inside rolling):
// x(t) = (R - r_pin) * cos(t) - e * cos(N_PINS * t / N_LOBES)
// y(t) = -(R - r_pin) * sin(t) + e * sin(N_PINS * t / N_LOBES)
// Note: sign conventions give the outward lobe form
function cx(t_deg) =
    (R_PIN_CIRCLE - r_PIN) * cos(t_deg) - ECCEN * cos(N_PINS * t_deg / N_LOBES);
function cy(t_deg) =
    -(R_PIN_CIRCLE - r_PIN) * sin(t_deg) + ECCEN * sin(N_PINS * t_deg / N_LOBES);

PROFILE = [for(i=[0:STEPS-1])
    [cx(i * N_LOBES * 360 / STEPS),
     cy(i * N_LOBES * 360 / STEPS)]];

// ── Cycloidal disk ────────────────────────────────────────
module cycloidal_disk() {
    // Eccentric cam offset (disk center not at shaft center)
    difference() {
        // Disk body extruded from cycloidal profile
        union() {
            linear_extrude(DISK_T)
                polygon(PROFILE);
            // Eccentric bore hub
            translate([-ECCEN, 0, 0])
                cylinder(d=AXLE_IN*3, h=DISK_T+4, $fn=20);
        }
        // Eccentric bore (input shaft passes through offset)
        translate([-ECCEN, 0, -1])
            cylinder(d=AXLE_IN, h=DISK_T+6, $fn=16);
        // Output pin holes (these drive the output carrier)
        // 6 holes equidistant, each will have a pin that couples to carrier
        N_OUT = 6;
        OUT_R = R_PIN_CIRCLE * 0.35;
        for(i=[0:N_OUT-1])
            rotate([0,0, i*360/N_OUT])
                translate([OUT_R, 0, -1])
                    cylinder(d=AXLE_OUT+4, h=DISK_T+6, $fn=16);
        // Lightening holes
        for(i=[0:N_LOBES-1])
            rotate([0,0, i*360/N_LOBES + 18])
                translate([(R_PIN_CIRCLE-r_PIN)*0.45, 0, -1])
                    cylinder(d=6, h=DISK_T+2, $fn=10);
    }
}

// ── Ring housing with roller pin holes ─────────────────────
module ring_housing() {
    difference() {
        union() {
            cylinder(d=HOUSING_D, h=THICK, $fn=100);
            // Mounting feet
            for(a=[0,90,180,270])
                rotate([0,0,a]) translate([HOUSING_D/2-2, -10, 0])
                    cube([18, 20, 10]);
        }
        // Interior bore (disk fits inside)
        translate([0,0,8]) cylinder(d=HOUSING_D-WALL*2, h=THICK, $fn=100);
        // Roller pin holes (N_PINS equidistant holes for pins/rollers)
        for(i=[0:N_PINS-1])
            rotate([0,0, i*360/N_PINS])
                translate([R_PIN_CIRCLE, 0, -1])
                    cylinder(d=r_PIN*2+0.3, h=THICK+2, $fn=16);
        // Input shaft bore (bottom)
        cylinder(d=AXLE_IN+1, h=THICK+2, $fn=16);
        // Output shaft bore (top)
        translate([0,0,THICK-10]) cylinder(d=AXLE_OUT+1, h=12, $fn=16);
        // Viewing windows (2 opposite)
        for(a=[0,180])
            rotate([0,0,a]) translate([0,-HOUSING_D/2-1,THICK*0.35])
                rotate([90,0,0]) scale([1,0.7,1])
                    cylinder(d=HOUSING_D*0.45, h=HOUSING_D, $fn=40);
        // Label
        translate([-35, -HOUSING_D/2+8, 6])
            rotate([90,0,0]) linear_extrude(2)
                text(str("CYCLOIDAL ", N_PINS-1, ":", N_PINS, " = ", N_LOBES, ":1"),
                     size=5.5, $fn=4);
        // Mounting holes
        for(a=[0,90,180,270])
            rotate([0,0,a]) translate([HOUSING_D/2+8, 0, 4])
                cylinder(d=4, h=10, $fn=10);
    }
}

// ── Output carrier shaft ──────────────────────────────────
// Captures the wobble of the cycloidal disk and converts to clean rotation
N_OUT_PINS = 6;
OUT_R      = R_PIN_CIRCLE * 0.35;

module output_carrier() {
    difference() {
        union() {
            cylinder(d=HOUSING_D*0.72, h=12, $fn=60);
            translate([0,0,12]) cylinder(d=AXLE_OUT*2, h=30, $fn=24);
        }
        // Center bore
        cylinder(d=AXLE_OUT, h=44, $fn=16);
        // Output coupling pins (these slide through disk holes)
        for(i=[0:N_OUT_PINS-1])
            rotate([0,0, i*360/N_OUT_PINS])
                translate([OUT_R, 0, -1])
                    cylinder(d=AXLE_OUT+0.5, h=14, $fn=16);
        // D-flat output
        translate([AXLE_OUT*0.55, -AXLE_OUT, 10])
            cube([AXLE_OUT, AXLE_OUT*2, 33]);
        // Step indicators
        for(i=[0:N_LOBES-1])
            rotate([0,0,i*36]) translate([HOUSING_D*0.34, -1, 0])
                cube([3,2,2]);
    }
    // Output pins (project downward into disk)
    for(i=[0:N_OUT_PINS-1])
        rotate([0,0, i*360/N_OUT_PINS])
            translate([OUT_R, 0, 0])
                cylinder(d=AXLE_OUT-0.6, h=16, $fn=16);
}

// ── Eccentric input cam ────────────────────────────────────
module eccentric_cam() {
    difference() {
        union() {
            // Main shaft
            cylinder(d=AXLE_IN*2, h=THICK*0.65, $fn=20);
            // Eccentric lobe (offset disc)
            translate([ECCEN, 0, THICK*0.2])
                cylinder(d=AXLE_IN*3.5, h=DISK_T+6, $fn=20);
            // Input knob (hex, bottom)
            translate([0,0,-12]) cylinder(d=AXLE_IN*3.5, h=12, $fn=6);
        }
        // Through bore
        cylinder(d=AXLE_IN, h=THICK+2, $fn=16);
        // Keyway
        translate([-AXLE_IN/2, AXLE_IN*0.45, -13])
            cube([AXLE_IN, AXLE_IN*0.6, THICK+15]);
    }
    // RPM counter marks (10 marks = 1:10 ratio visual)
    for(i=[0:9]) rotate([0,0,i*36])
        translate([AXLE_IN*1.5, -0.6, THICK*0.5])
            cube([2, 1.2, 2.5]);
}

// ── Assembly layout ───────────────────────────────────────
// Color 1 (body): ring housing
ring_housing();

// Color 2 (accent): disk + carrier + cam (exploded right)
translate([HOUSING_D*1.3, 0, 0]) {
    cycloidal_disk();
    translate([0, HOUSING_D*0.7, 0]) output_carrier();
    translate([0, -HOUSING_D*0.7, 0]) eccentric_cam();
}
