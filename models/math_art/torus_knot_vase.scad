// Torus Knot Vase — Parametric (p,q) Knot as Functional Vase
// A tube swept along a torus knot curve — single or dual color
// Knot type: p=3, q=2 → trefoil; p=5, q=2 → cinquefoil; p=2, q=3 → different trefoil
// PETG translucent — 0.15mm, 3 walls, gyroid 15% infill — ~180mm tall
// SINGLE COLOR (the math is the art)

// Knot parameters
P = 3;        // Winding around torus tube
Q = 2;        // Winding around torus axis
R_MAJOR = 55; // Major torus radius
R_MINOR = 28; // Minor torus radius
TUBE_D  = 14; // Tube cross-section diameter
STEPS   = 180; // Curve resolution
BASE_H  = 15;
BASE_D  = 130;
WALL    = 2.8;

// Torus knot parametric equations
function tkx(t) = (R_MAJOR + R_MINOR*cos(Q*t)) * cos(P*t);
function tky(t) = (R_MAJOR + R_MINOR*cos(Q*t)) * sin(P*t);
function tkz(t) = R_MINOR * sin(Q*t);

// Build knot as chain of hull()-ed spheres
module torus_knot_tube() {
    for (i=[0:STEPS-1]) {
        t0 = i * 360 / STEPS;
        t1 = (i+1) * 360 / STEPS;
        p0 = [tkx(t0), tky(t0), tkz(t0)];
        p1 = [tkx(t1), tky(t1), tkz(t1)];
        hull() {
            translate(p0) sphere(d=TUBE_D, $fn=10);
            translate(p1) sphere(d=TUBE_D, $fn=10);
        }
    }
}

// Lift knot so it sits above base (min z → 0)
MIN_Z = R_MINOR * -1;  // approximate minimum z

// Base plinth
module base() {
    difference() {
        union() {
            cylinder(d=BASE_D, h=BASE_H, $fn=60);
            translate([0,0,BASE_H])
                cylinder(d=BASE_D*0.7, h=4, $fn=60);
        }
        // Hollow
        translate([0,0,4]) cylinder(d=BASE_D-WALL*2.5, h=BASE_H, $fn=60);
        // Label
        translate([-42, -BASE_D/2+6, BASE_H-0.8])
            linear_extrude(1.5)
                text(str("TORUS KNOT (", P, ",", Q, ")"), size=5.5, $fn=4);
    }
    // Inner water tube (functional vase insert)
    translate([0,0,BASE_H+4])
        difference() {
            cylinder(d=TUBE_D*1.5, h=R_MINOR*0.8, $fn=20);
            cylinder(d=TUBE_D, h=R_MINOR*0.8+1, $fn=20);
        }
}

// Assembled — knot lifted so bottom sits at base level
translate([0, 0, BASE_H + abs(MIN_Z) + TUBE_D/2])
    torus_knot_tube();
base();
