// Harmonic Drive (Strain Wave Gear) — Printable Display/Demo Model
// One of the most sophisticated gear systems: used in robotics, NASA rovers, satellite dishes
// Gear ratio = Flex_teeth / (Circ_teeth - Flex_teeth)
// With 62/64: ratio = 62/2 = 31:1 in a package 80mm across
// DUAL COLOR: circular spline housing (body dark) | flex spline + wave gen (accent)
// PLA 0.15mm, 5 walls, 30% gyroid — precise tolerances critical
// Flex spline must print at 0.15mm only; elliptical cam needs 0.35mm clearance

$fn = 80;

// ── Gear parameters ───────────────────────────────────────
CIRC_T   = 64;    // Circular spline teeth (rigid ring gear)
FLEX_T   = 62;    // Flex spline teeth (CIRC - 2, always)
MOD      = 1.6;   // Module (smaller = finer ratio possible)
PA       = 20;    // Pressure angle (degrees)
THICK    = 18;    // Axial face width
WALL     = 3.5;
AXLE_IN  = 6.2;   // Input shaft (M6) — wave generator driven
AXLE_OUT = 8.2;   // Output shaft (M8) — flex spline output
FLEX_CLR = 0.35;  // Critical: ellipse → circular flex clearance

// ── Derived geometry ──────────────────────────────────────
CIRC_PD = CIRC_T * MOD;
FLEX_PD = FLEX_T * MOD;
ECCENTRICITY = (CIRC_PD - FLEX_PD) / (2 * 3.14159);  // ellipse semi-major - semi-minor

// ── Gear profile (simplified tooth) ──────────────────────
module ext_gear_profile(n, mod, h) {
    pitch_r = n*mod/2;
    outer_r = pitch_r + mod;
    root_r  = pitch_r - mod*1.25;
    tooth_a = 360/n;
    linear_extrude(h)
        union() {
            circle(r=root_r, $fn=max(80,n*4));
            for(i=[0:n-1]) rotate([0,0,i*tooth_a])
                hull() {
                    rotate([0,0,-6]) translate([pitch_r,0]) circle(r=mod*0.42,$fn=6);
                    rotate([0,0, 6]) translate([pitch_r,0]) circle(r=mod*0.42,$fn=6);
                    translate([outer_r,0]) circle(r=mod*0.24,$fn=6);
                }
        }
}

module int_gear_profile(n, mod, od, h) {
    pitch_r = n*mod/2;
    outer_r = pitch_r + mod*1.2;
    tooth_a = 360/n;
    linear_extrude(h)
        difference() {
            circle(r=od/2, $fn=max(80,n*4));
            union() {
                circle(r=pitch_r - mod, $fn=max(80,n*4));
                for(i=[0:n-1]) rotate([0,0,i*tooth_a+180/n])
                    hull() {
                        rotate([0,0,-5]) translate([pitch_r,0]) circle(r=mod*0.4,$fn=6);
                        rotate([0,0, 5]) translate([pitch_r,0]) circle(r=mod*0.4,$fn=6);
                        translate([outer_r,0]) circle(r=mod*0.22,$fn=6);
                    }
            }
        }
}

// ── 1. CIRCULAR SPLINE (rigid housing ring gear) ──────────
module circular_spline() {
    OD = CIRC_PD + WALL*4 + MOD*2;
    difference() {
        union() {
            // Outer housing disc
            cylinder(d=OD, h=THICK+8, $fn=100);
            // Output flange (bottom)
            translate([0,0,-8])
                cylinder(d=OD*0.75, h=8, $fn=80);
        }
        // Internal ring gear bore
        translate([0,0,4])
            int_gear_profile(CIRC_T, MOD, OD, THICK+2);
        // Input bore (through-hole for shaft)
        cylinder(d=AXLE_IN+1, h=THICK+18, $fn=16);
        // Output bore (flex spline cup bottom)
        translate([0,0,-9]) cylinder(d=AXLE_OUT, h=10, $fn=16);
        // Viewing cutout (shows gear mesh inside)
        rotate([0,0,45])
            translate([0,-OD/2-1,THICK*0.2])
                rotate([90,0,0])
                    scale([0.7,0.6,1])
                        cylinder(d=OD*0.55, h=OD, $fn=40);
        // Mounting holes (M3, 4x)
        for(a=[0,90,180,270])
            rotate([0,0,a]) translate([OD/2-WALL*1.5, 0, -9])
                cylinder(d=3.2, h=THICK+18, $fn=10);
        // Label
        translate([-(CIRC_PD/2)*0.72, 0, THICK+6])
            rotate([90,0,90])
                linear_extrude(2)
                    text(str("HARMONIC ", CIRC_T, ":", FLEX_T, " = 31:1"), size=4.8, $fn=4);
    }
    // Tooth count ring (exterior)
    translate([0,0,THICK+6])
        difference() {
            cylinder(d=OD-WALL, h=3, $fn=100);
            cylinder(d=OD-WALL-3, h=4, $fn=100);
        }
}

// ── 2. FLEX SPLINE (thin cup with external teeth — the magic part) ─────
// In reality this would be thin metal — we print slightly thicker
FLEX_WALL = 1.8;  // Thin wall (critical for "flex" behavior demo)

module flex_spline() {
    // Cup body (thin-walled cylinder)
    difference() {
        union() {
            // Cylindrical cup body
            cylinder(d=FLEX_PD+MOD*2+FLEX_WALL*2, h=THICK+20, $fn=80);
            // External gear teeth (only on the top portion)
            translate([0,0,15])
                ext_gear_profile(FLEX_T, MOD, THICK+2);
        }
        // Hollow interior (thin wall)
        cylinder(d=FLEX_PD+MOD*2-FLEX_WALL, h=THICK+20, $fn=80);
        // Output shaft bore
        cylinder(d=AXLE_OUT, h=THICK+22, $fn=16);
        // Mounting cross-holes (cup bottom attachment)
        for(a=[0,120,240])
            rotate([0,0,a]) translate([FLEX_PD*0.2, 0, 2])
                cylinder(d=3.2, h=10, $fn=10);
    }
    // Cup bottom / output flange
    difference() {
        cylinder(d=FLEX_PD*0.55, h=8, $fn=40);
        cylinder(d=AXLE_OUT, h=9, $fn=16);
        for(a=[0,120,240])
            rotate([0,0,a]) translate([FLEX_PD*0.2, 0, 2])
                cylinder(d=3.2, h=8, $fn=10);
    }
}

// ── 3. WAVE GENERATOR (elliptical cam + outer race) ───────
// The ellipse deforms the flex spline, engaging teeth at 2 points 180° apart
ELLIPSE_A = FLEX_PD/2 - MOD*0.5;                    // semi-major
ELLIPSE_B = ELLIPSE_A - ECCENTRICITY * 0.8 - FLEX_CLR; // semi-minor

module wave_generator() {
    // Elliptical cam body
    difference() {
        union() {
            // Elliptical cam (the heart of harmonic drive)
            scale([1, ELLIPSE_B/ELLIPSE_A, 1])
                cylinder(d=ELLIPSE_A*2, h=THICK, $fn=80);
            // Input shaft stub
            translate([0,0,THICK])
                cylinder(d=AXLE_IN*1.8, h=14, $fn=24);
            translate([0,0,-14])
                cylinder(d=AXLE_IN*1.8, h=14, $fn=24);
        }
        // Input bore
        cylinder(d=AXLE_IN, h=THICK+30, $fn=16);
        translate([0,0,-15]) cylinder(d=AXLE_IN, h=16, $fn=16);
        // Ball bearing race groove (outer surface)
        translate([0,0,THICK*0.3])
            scale([1, ELLIPSE_B/ELLIPSE_A, 1])
                difference() {
                    cylinder(d=ELLIPSE_A*2+1, h=THICK*0.4, $fn=80);
                    cylinder(d=ELLIPSE_A*2-2, h=THICK*0.4+1, $fn=80);
                }
        // Keyway
        translate([-AXLE_IN/2, AXLE_IN*0.45, -16])
            cube([AXLE_IN, AXLE_IN*0.6, THICK+32]);
    }
    // Bearing balls (visual — 18 balls in race)
    translate([0,0,THICK*0.5]) for(i=[0:17]) {
        ang = i*20;
        bx = cos(ang)*ELLIPSE_A*0.92;
        by = sin(ang)*(ELLIPSE_B*0.92);
        translate([bx,by,0]) sphere(d=2.8, $fn=8);
    }
}

// ── 4. OUTPUT CROSS SHAFT ─────────────────────────────────
module output_shaft() {
    difference() {
        union() {
            // Flange that bolts to flex spline cup
            cylinder(d=FLEX_PD*0.52, h=6, $fn=40);
            // Shaft
            translate([0,0,6]) cylinder(d=AXLE_OUT*1.8, h=30, $fn=24);
        }
        cylinder(d=AXLE_OUT, h=38, $fn=16);
        // Mounting holes (match flex spline)
        for(a=[0,120,240])
            rotate([0,0,a]) translate([FLEX_PD*0.2, 0, 0])
                cylinder(d=3.2, h=8, $fn=10);
        // D-flat
        translate([AXLE_OUT*0.55, -AXLE_OUT, 5])
            cube([AXLE_OUT, AXLE_OUT*2, 32]);
    }
    // Output indication marks
    for(i=[0:5]) rotate([0,0,i*60]) translate([AXLE_OUT, -0.6, 32])
        cube([2, 1.2, 2]);
}

// ── ASSEMBLY LAYOUT ───────────────────────────────────────
// Color 1 (dark): circular spline housing
circular_spline();

// Color 2 (accent): flex spline + wave generator + output shaft (exploded right)
translate([CIRC_PD*1.8, 0, 0]) {
    flex_spline();
    translate([0, FLEX_PD*1.5, 0]) wave_generator();
    translate([0, -FLEX_PD*1.5, 0]) output_shaft();
}
