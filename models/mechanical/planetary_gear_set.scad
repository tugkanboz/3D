// Planetary Gear Set — Full 3-Planet Epicyclic Gearbox
// Printable transmission: Sun + 3 Planet + Ring gear + Carrier output
// Gear ratio = 1 + (Ring teeth / Sun teeth) = 1 + 60/20 = 4:1
// DUAL COLOR: ring gear + housing (body) | sun + planets + carrier (accent)
// PLA — 0.15mm, 4 walls, 20% gyroid — print flat, no supports
// Assemble dry or with light grease; axles = M4 bolts

M     = 2.0;   // Module (gear tooth size)
SUN   = 20;    // Sun gear teeth
PLAN  = 20;    // Planet teeth (must be integer, (Ring-Sun)/2 = Planet for mesh)
RING  = 60;    // Ring gear teeth (Ring = Sun + 2*Planet)
THICK = 12;    // Gear face width
AXLE  = 4.2;   // M4 bolt clearance
WALL  = 3.0;
PRESS = 20;    // Pressure angle (degrees) — standard 20°
N_PL  = 3;     // Number of planets

// ── Helper: involute gear ─────────────────────────────────
function involute(a) = [cos(a) + a*sin(a), sin(a) - a*cos(a)];

module gear_2d(n, mod=M, pa=PRESS, clearance=0.15) {
    pitch_r   = n * mod / 2;
    base_r    = pitch_r * cos(pa);
    addendum  = mod;
    dedendum  = mod * 1.25;
    outer_r   = pitch_r + addendum;
    root_r    = max(base_r*0.98, pitch_r - dedendum);
    tooth_ang = 360 / n;
    // Build single tooth involute flank
    inv_pts = [for (a=[0:2:30]) let(r=base_r*(1+a/30)) involute(a*PI/180) * r];
    // Mirror for both flanks
    tooth = [each inv_pts, each [for(i=[len(inv_pts)-1:-1:0]) [inv_pts[i][0]*-1, inv_pts[i][1]]]];
    // Full gear = rotated teeth
    difference() {
        union() {
            circle(r=root_r, $fn=n*4);
            for (i=[0:n-1])
                rotate([0,0, i*tooth_ang])
                    polygon(tooth);
        }
        circle(r=root_r - 0.5, $fn=n*2);
    }
    // Root fillet (approximate)
    difference() {
        circle(r=root_r, $fn=n*4);
        circle(r=root_r - 1.2, $fn=n*4);
    }
}

// Simplified gear: use polygon approximation (faster, good for printing)
module simple_gear(n, mod=M, h=THICK, pa=PRESS, clearance=0.2) {
    pitch_r  = n * mod / 2;
    outer_r  = pitch_r + mod;
    root_r   = pitch_r - mod*1.2;
    tooth_a  = 360 / n;
    linear_extrude(h) {
        difference() {
            union() {
                circle(r=pitch_r, $fn=max(60, n*4));
                for(i=[0:n-1])
                    rotate([0,0, i*tooth_a]) {
                        // Tooth profile trapezoid
                        ang = 7 + (1-pa/30)*5;
                        hull() {
                            rotate([0,0,-ang]) translate([pitch_r, 0])
                                circle(r=mod*0.5, $fn=6);
                            rotate([0,0, ang]) translate([pitch_r, 0])
                                circle(r=mod*0.5, $fn=6);
                            translate([outer_r*0.98, 0])
                                circle(r=mod*0.28, $fn=6);
                        }
                    }
            }
            circle(r=root_r, $fn=max(48, n*3));
        }
        circle(r=root_r, $fn=max(48, n*3));
    }
}

// ── Sun gear (central, driven) ────────────────────────────
module sun_gear() {
    difference() {
        simple_gear(SUN, M, THICK+2);
        // Central drive shaft
        cylinder(d=AXLE, h=THICK+4, $fn=16);
        // Keyway
        translate([-AXLE/2, AXLE/4, -1]) cube([AXLE, AXLE*0.6, THICK+4]);
    }
    // Top flange
    translate([0,0,THICK+2])
        difference() {
            cylinder(d=SUN*M*0.8, h=4, $fn=30);
            cylinder(d=AXLE, h=5, $fn=16);
        }
}

// ── Planet gear ───────────────────────────────────────────
module planet_gear() {
    difference() {
        simple_gear(PLAN, M, THICK);
        cylinder(d=AXLE, h=THICK+2, $fn=16);
    }
}

// ── Ring gear (internal, in housing) ─────────────────────
RING_PD = RING * M;
module ring_gear() {
    HOD = RING_PD + WALL*4;
    difference() {
        // Housing
        cylinder(d=HOD, h=THICK+6, $fn=100);
        // Internal ring gear teeth (subtract)
        translate([0,0,3]) {
            // First cut base bore
            cylinder(d=RING_PD - M*0.4, h=THICK+1, $fn=100);
            // Then add teeth as bumps inward
            // (Approximation: ring = outer housing minus involute pockets)
            for(i=[0:RING-1])
                rotate([0,0, i*360/RING + 90]) {
                    ang = 6;
                    translate([RING_PD/2 + M*0.5, 0, 0])
                    rotate([0,0,0])
                    hull() {
                        rotate([0,0,-ang]) translate([0,0,0]) cylinder(r=M*0.45, h=THICK+0.5, $fn=6);
                        rotate([0,0, ang]) translate([0,0,0]) cylinder(r=M*0.45, h=THICK+0.5, $fn=6);
                        translate([-M*1.1,0,0]) cylinder(r=M*0.28, h=THICK+0.5, $fn=6);
                    }
                }
        }
        // Top opening
        translate([0,0,THICK+3]) cylinder(d=HOD-WALL*2, h=5, $fn=80);
        // Carrier bearing seat
        cylinder(d=AXLE+0.5, h=3, $fn=16);
        // Mounting holes (4x)
        for(a=[0,90,180,270]) rotate([0,0,a])
            translate([HOD/2-WALL*1.5, 0, -1]) cylinder(d=3.2, h=THICK+8, $fn=10);
    }
    // Output flange on bottom
    translate([0,0,-5])
        difference() {
            cylinder(d=HOD*0.85, h=5, $fn=80);
            cylinder(d=AXLE+0.5, h=6, $fn=16);
            for(a=[0,90,180,270]) rotate([0,0,a])
                translate([HOD/2-WALL*1.5, 0, -1]) cylinder(d=3.2, h=7, $fn=10);
        }
}

// ── Planet carrier (output shaft) ─────────────────────────
PLANET_D = (SUN + PLAN) * M;  // Sun pitch r + Planet pitch r
module planet_carrier() {
    difference() {
        union() {
            // Central hub
            cylinder(d=SUN*M*1.1, h=THICK-2, $fn=36);
            // Carrier arms to planet axle positions
            for(i=[0:N_PL-1])
                rotate([0,0, i*360/N_PL])
                    translate([PLANET_D/2, 0, 0])
                        hull() {
                            cylinder(d=PLAN*M*0.55, h=THICK-2, $fn=20);
                            translate([-PLANET_D/2, 0, 0])
                                cylinder(d=SUN*M*0.9, h=THICK-2, $fn=24);
                        }
        }
        // Sun shaft clearance
        cylinder(d=AXLE+4, h=THICK, $fn=16);
        // Planet axle holes
        for(i=[0:N_PL-1])
            rotate([0,0, i*360/N_PL])
                translate([PLANET_D/2, 0, -1])
                    cylinder(d=AXLE, h=THICK+2, $fn=16);
        // Output bore pattern (D-shaft: flat on one side)
        cylinder(d=AXLE, h=THICK+2, $fn=16);
        translate([-AXLE/2, AXLE*0.35, -1]) cube([AXLE, AXLE, THICK+3]);
    }
}

// ── Assembly ──────────────────────────────────────────────
// Color 2 (accent): sun gear + planets + carrier
sun_gear();
for(i=[0:N_PL-1])
    rotate([0,0, i*360/N_PL])
        translate([PLANET_D/2, 0, 3])
            rotate([0,0, i*360/N_PL * (RING/PLAN)])
                planet_gear();
translate([0,0,THICK+8]) planet_carrier();

// Color 1 (body): ring gear + housing
ring_gear();
