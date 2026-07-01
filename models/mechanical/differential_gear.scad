// Open Automotive Differential — Educational Cutaway Display
// How a car differential works: ring gear drives spider shaft; spider gears let
// side gears rotate at different speeds when cornering. Zero slip = spider gears
// don't spin. One wheel slips = spider gears rotate freely on their axis.
// Complete mechanism: ring bevel + 2 spider bevel + 2 side bevel + housing
// DUAL COLOR: housing ring + case (body) | internal gears + shaft (accent)
// PLA 0.15mm, 5 walls, 20% gyroid — M5 spider shaft, M8 axle bores
// Print all gears separately, assemble with M5/M8 rods + M3 screws

$fn = 40;

// ── Gear parameters ───────────────────────────────────────
MODULE     = 1.8;     // Tooth module (mm)
N_SIDE     = 18;      // Side bevel gear teeth
N_SPIDER   = 14;      // Spider bevel gear teeth
N_RING     = 44;      // Ring bevel gear teeth
SIDE_ANGLE = 52;      // Side gear pitch cone half-angle (°)
SPIDER_ANG = 38;      // Spider pitch cone half-angle (90 - SIDE_ANGLE)
HOUSING_D  = 110;
HOUSING_H  = 68;
AXLE_D     = 8.2;     // Drive axle clearance (M8)
SHAFT_D    = 5.2;     // Spider shaft (M5)
WALL       = 4.0;

// ── Derived ───────────────────────────────────────────────
SIDE_R  = MODULE * N_SIDE / 2;
SPIDER_R = MODULE * N_SPIDER / 2;
RING_R  = MODULE * N_RING / 2;
TOOTH_H = MODULE * 2.2;

// ── Tooth profile (involute approximation — trapezoid) ────
// Generates a 2D tooth cross-section for linear_extrude
module tooth_2d(m, clearance=0.0) {
    ha = m;         // addendum
    hd = 1.25*m;   // dedendum
    bw = m*1.0;    // tooth base width half
    tw = m*0.62;   // tooth top width half
    polygon([
        [-bw,     -hd],
        [-bw*0.9,  0],
        [-tw,      ha],
        [ tw,      ha],
        [ bw*0.9,  0],
        [ bw,     -hd]
    ]);
}

// ── Side bevel gear (left and right output gears) ─────────
// Sits in housing, rotates on drive axle, meshes with spider gears
module side_bevel_gear() {
    R = SIDE_R;
    H = R * 0.75;

    difference() {
        union() {
            // Conical gear body
            cylinder(r1=R+TOOTH_H, r2=R*0.2, h=H, $fn=80);
            // Hub (extends outward for axle)
            translate([0,0,-12]) cylinder(d=R*0.8, h=H+10, $fn=20);
        }
        // Axle bore
        translate([0,0,-13]) cylinder(d=AXLE_D, h=H+15, $fn=16);
        // Hollow core (weight reduction + visual)
        translate([0,0,2]) cylinder(r1=R-TOOTH_H*2, r2=R*0.1, h=H-4, $fn=40);
        // Keyway in hub
        translate([-1.5, AXLE_D/2, -13]) cube([3, 3, H+15]);
    }

    // Teeth on the large face (side bevel profile)
    for(i=[0:N_SIDE-1]) {
        rotate([0,0, i*360/N_SIDE])
            translate([R, 0, 0])
                rotate([0, SIDE_ANGLE*0.6, 0])
                    rotate([90, 0, 0])
                        linear_extrude(MODULE*0.9, center=true)
                            tooth_2d(MODULE);
    }
    // Flange ring
    translate([0,0,-2]) difference() {
        cylinder(d=R*1.6, h=2.5, $fn=40);
        cylinder(d=R*0.85, h=3, $fn=20);
    }
}

// ── Spider bevel gear (drives the two side gears) ─────────
module spider_bevel_gear() {
    R = SPIDER_R;
    H = R * 0.90;

    difference() {
        union() {
            cylinder(r1=R+TOOTH_H, r2=R*0.2, h=H, $fn=80);
            // Spider shaft boss
            translate([0,0,-8]) cylinder(d=R*0.7, h=H+6, $fn=16);
        }
        translate([0,0,-9]) cylinder(d=SHAFT_D, h=H+12, $fn=12);
        translate([0,0,2]) cylinder(r1=R-TOOTH_H*2, r2=R*0.1, h=H-4, $fn=40);
        // D-flat on shaft bore
        translate([SHAFT_D/2*0.7, -SHAFT_D, -9]) cube([SHAFT_D, SHAFT_D*2, H+12]);
    }

    for(i=[0:N_SPIDER-1]) {
        rotate([0,0, i*360/N_SPIDER])
            translate([R, 0, 0])
                rotate([0, SPIDER_ANG*0.6, 0])
                    rotate([90, 0, 0])
                        linear_extrude(MODULE*0.9, center=true)
                            tooth_2d(MODULE);
    }
}

// ── Ring bevel gear (driven by driveshaft, drives spider) ──
module ring_bevel_gear() {
    R = RING_R;
    H = R * 0.38;

    difference() {
        union() {
            // Outer ring body
            difference() {
                cylinder(r=R+WALL+TOOTH_H, h=H, $fn=120);
                translate([0,0,-1]) cylinder(r=R-TOOTH_H*1.5, h=H+2, $fn=100);
            }
            // Flange plate (mounts to housing)
            translate([0,0,H]) cylinder(r=R+WALL+2, h=4, $fn=120);
        }
        // Mounting holes in flange (6×)
        for(a=[0:60:300])
            rotate([0,0,a]) translate([R+WALL/2, 0, H+1])
                cylinder(d=4, h=5, $fn=10);
        // Driveshaft window (cut in housing side — visual)
        translate([R+WALL-2, -15, -1]) cube([WALL*3, 30, H+6]);
    }

    // Ring teeth (on inner conical surface, angled inward)
    for(i=[0:N_RING-1]) {
        rotate([0,0, i*360/N_RING])
            translate([R, 0, H*0.5])
                rotate([0, -(90-SIDE_ANGLE)*0.5, 0])
                    rotate([90, 0, 0])
                        linear_extrude(MODULE*0.9, center=true)
                            tooth_2d(MODULE);
    }
}

// ── Spider cross shaft ─────────────────────────────────────
module spider_shaft() {
    SPIDER_LEN = SIDE_R * 1.4;
    difference() {
        union() {
            // Cross bar (two perpendicular axes for 2 spider gears)
            cylinder(d=SHAFT_D*2.5, h=SPIDER_LEN*2, center=true, $fn=12);
            // Shaft arms
            rotate([90,0,0]) cylinder(d=SHAFT_D, h=SPIDER_LEN, center=true, $fn=12);
            // Ring mounting ears
            for(a=[0,90,180,270])
                rotate([0,0,a]) translate([SIDE_R*0.85, -3, 0])
                    cube([10, 6, 5], center=true);
        }
        // Bore for spider gears
        rotate([90,0,0]) cylinder(d=SHAFT_D+0.3, h=SPIDER_LEN+2, center=true, $fn=12);
        // Axle bores (left and right)
        cylinder(d=AXLE_D+0.3, h=SPIDER_LEN*2+2, center=true, $fn=16);
    }
}

// ── Differential housing (cutaway) ────────────────────────
module housing() {
    difference() {
        union() {
            // Main sphere housing
            sphere(d=HOUSING_D, $fn=120);
            // Axle tubes left and right
            for(s=[-1,1]) translate([0,0,s*(HOUSING_D/2-2)])
                cylinder(d=AXLE_D+WALL*2, h=20, center=true, $fn=20);
            // Mounting flange (for ring gear)
            cylinder(d=RING_R*2+WALL*4, h=4, center=true, $fn=100);
        }
        // Cutaway (front half removed for viewing interior)
        translate([-(HOUSING_D/2+1), 0, 0]) cube([HOUSING_D+2, HOUSING_D+2, HOUSING_D+2]);
        // Axle bores
        translate([0,0,-HOUSING_D]) cylinder(d=AXLE_D+1, h=HOUSING_D*2, $fn=16);
        // Ring gear window slot
        cylinder(d=RING_R*2+2, h=HOUSING_D, center=true, $fn=100);
    }
}

// ── Assembly (exploded for printing) ──────────────────────
// Color 1 (body): housing half + ring gear
housing();
translate([HOUSING_D*1.4, 0, 0]) ring_bevel_gear();

// Color 2 (accent): internals — exploded for print layout
translate([0, HOUSING_D*1.4, 0]) {
    // Left side gear
    side_bevel_gear();
    // Right side gear
    translate([SIDE_R*2.5, 0, 0]) side_bevel_gear();
    // Spider gears (2x)
    translate([SIDE_R*1.25, SPIDER_R*3.5, 0]) spider_bevel_gear();
    translate([SIDE_R*1.25, -SPIDER_R*3.5, 0]) spider_bevel_gear();
    // Spider cross shaft
    translate([SIDE_R*1.25, 0, 0]) spider_shaft();
}
