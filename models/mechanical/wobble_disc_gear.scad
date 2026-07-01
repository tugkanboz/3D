// Wobble Disc Gear (Nutating Plate Drive)
// Ultra-high ratio gear mechanism: angled disc "wobbles" inside ring gear
// Gear ratio = Ring_teeth / (Ring_teeth - Disc_teeth)
// With 36/35: ratio = 36/1 = 36:1 reduction per stage
// DUAL COLOR: housing + ring (body) | wobble disc + output shaft (accent)
// PLA 0.15mm, 4 walls, 20% gyroid — no supports, flat print
// Real-world use: robotic joints, clocks, industrial indexing

RING_T   = 36;    // Ring gear teeth
DISC_T   = 35;    // Wobble disc teeth (must be Ring-1 for single stage)
MOD      = 2.2;   // Module (tooth size)
TILT_DEG = 5;     // Wobble angle (degrees) — larger = more wobble, more stress
THICK    = 14;    // Gear thickness
HOUSING_H= 60;    // Total housing height
AXLE     = 5.2;   // Input shaft bore (M5)
OUT_AXLE = 6.2;   // Output shaft bore (M6)
WALL     = 3.5;

// ── Derived dimensions ────────────────────────────────────
RING_PD  = RING_T * MOD;     // Ring pitch diameter
DISC_PD  = DISC_T * MOD;     // Disc pitch diameter
ECCENTRICITY = (RING_PD - DISC_PD) / 2;  // Offset of disc center from ring center

// ── Simple gear profile helper ────────────────────────────
module gear_2d(n, mod, pa=20, internal=false) {
    pitch_r = n * mod / 2;
    outer_r = internal ? pitch_r + mod*1.2 : pitch_r + mod;
    root_r  = internal ? pitch_r - mod*0.8 : pitch_r - mod*1.2;
    tooth_a = 360 / n;

    if (internal) {
        // Internal gear: teeth point inward
        difference() {
            circle(r=outer_r + WALL, $fn=max(80,n*3));
            union() {
                circle(r=root_r, $fn=max(80,n*3));
                for(i=[0:n-1]) rotate([0,0,i*tooth_a])
                    hull() {
                        rotate([0,0,-7]) translate([pitch_r, 0]) circle(r=mod*0.4, $fn=6);
                        rotate([0,0, 7]) translate([pitch_r, 0]) circle(r=mod*0.4, $fn=6);
                        translate([outer_r, 0]) circle(r=mod*0.22, $fn=6);
                    }
            }
        }
    } else {
        // External gear: teeth point outward
        difference() {
            union() {
                circle(r=root_r, $fn=max(60, n*3));
                for(i=[0:n-1]) rotate([0,0,i*tooth_a])
                    hull() {
                        rotate([0,0,-6]) translate([pitch_r, 0]) circle(r=mod*0.45, $fn=6);
                        rotate([0,0, 6]) translate([pitch_r, 0]) circle(r=mod*0.45, $fn=6);
                        translate([outer_r, 0]) circle(r=mod*0.25, $fn=6);
                    }
            }
            circle(r=root_r*0.8, $fn=max(48,n*2));  // not solid
        }
    }
}

// ── Housing with internal ring gear ──────────────────────
module housing() {
    OD = RING_PD + WALL*4 + MOD*2;
    difference() {
        union() {
            // Main cylindrical housing
            cylinder(d=OD, h=HOUSING_H, $fn=100);
            // Mounting feet
            for(a=[0,90,180,270])
                rotate([0,0,a]) translate([OD/2, -8, 0])
                    cube([16, 16, 8]);
        }
        // Internal ring gear bore
        translate([0,0,THICK/2+5])
            linear_extrude(THICK+2)
                gear_2d(RING_T, MOD, internal=true);
        // Top opening for output shaft
        translate([0,0,HOUSING_H-THICK-5])
            cylinder(d=DISC_PD*0.6, h=THICK+8, $fn=60);
        // Input shaft bore (bottom, angled)
        translate([0,0,-1]) cylinder(d=AXLE, h=HOUSING_H+2, $fn=16);
        // Viewing window
        translate([0,-OD/2-1, HOUSING_H*0.35])
            rotate([90,0,0]) scale([1,0.7,1])
                cylinder(d=OD*0.5, h=OD, $fn=40);
        // Mounting holes
        for(a=[0,90,180,270])
            rotate([0,0,a]) translate([OD/2+8, 0, 4])
                cylinder(d=4, h=8, $fn=10);
        // Label
        translate([-OD/2+4, 0, 6])
            rotate([90,0,90])
                linear_extrude(2)
                    text(str(RING_T, ":", RING_T-DISC_T, " WOBBLE"), size=5, $fn=4);
    }
}

// ── Wobble disc gear ──────────────────────────────────────
module wobble_disc() {
    difference() {
        union() {
            // Gear teeth
            linear_extrude(THICK)
                gear_2d(DISC_T, MOD);
            // Hub with angled bore for tilted input shaft
            translate([ECCENTRICITY, 0, THICK])
                cylinder(d=AXLE*3, h=8, $fn=24);
        }
        // Through-bore (angled, offset)
        translate([ECCENTRICITY, 0, -1])
            cylinder(d=AXLE, h=THICK+10, $fn=16);
        // Lightening pockets
        for(i=[0:DISC_T/3-1])
            rotate([0,0, i*360/(DISC_T/3)])
                translate([DISC_PD/2*0.45, 0, -1])
                    cylinder(d=DISC_PD*0.15, h=THICK+2, $fn=12);
    }
    // Anti-rotation pin (goes into output carrier slot)
    translate([0, 0, THICK])
        cylinder(d=3, h=10, $fn=10);
}

// ── Output carrier (captures wobble disc motion) ──────────
module output_carrier() {
    OD = DISC_PD * 0.55;
    difference() {
        union() {
            cylinder(d=OD, h=HOUSING_H*0.3, $fn=48);
            // Output shaft
            translate([0,0,HOUSING_H*0.3])
                cylinder(d=OUT_AXLE*1.8, h=20, $fn=24);
        }
        // Center bore
        cylinder(d=OUT_AXLE, h=HOUSING_H*0.3+22, $fn=16);
        // D-flat for output shaft
        translate([OUT_AXLE*0.5, -OUT_AXLE, -1])
            cube([OUT_AXLE, OUT_AXLE*2, HOUSING_H*0.3+24]);
        // Anti-rotation pin slot
        translate([-1.8, OD*0.3, HOUSING_H*0.1])
            cube([3.6, OD, HOUSING_H*0.2+2]);
    }
    // Step indicator (12 marks = 3:1 visible ratio stage)
    translate([0,0,0]) for(i=[0:11])
        rotate([0,0,i*30]) translate([OD/2-2, -0.5, 0])
            cube([1.5, 1, 2]);
}

// ── Eccentric input shaft ─────────────────────────────────
module eccentric_shaft() {
    difference() {
        union() {
            // Main shaft body
            cylinder(d=AXLE*1.6, h=HOUSING_H*0.55, $fn=24);
            // Eccentric cam (offset disc that drives wobble)
            translate([ECCENTRICITY, 0, HOUSING_H*0.22])
                rotate([0, TILT_DEG, 0])
                    cylinder(d=AXLE*2.5, h=THICK+4, $fn=24);
            // Input knob (top)
            translate([0,0,-12])
                difference() {
                    cylinder(d=AXLE*3.5, h=12, $fn=6);  // Hex knob
                    cylinder(d=AXLE, h=13, $fn=16);
                }
        }
        cylinder(d=AXLE, h=HOUSING_H+2, $fn=16);
    }
}

// ── Assembly (exploded view for printing separate parts) ──
// Print all separately — assembly uses M5/M6 bolts as axles

// Color 1 (dark): housing
housing();

// Color 2 (accent): wobble disc + output carrier + input shaft
translate([RING_PD*1.5, 0, 0]) {
    wobble_disc();
    translate([0, DISC_PD*1.2, 0]) output_carrier();
    translate([0, -DISC_PD*1.2, 0]) eccentric_shaft();
}
