// Lissajous 3D Lamp Shade — Parametric Curve-Swept Tube
// Lissajous: x=sin(a*t+d)*Rx, y=sin(b*t)*Ry, z=cos(c*t)*Rz
// PETG translucent — light shines through gaps between curve passes
// SINGLE or DUAL color — base in contrast, curve in translucent
// 0.20mm, 3 walls, gyroid 15% infill — ~5h print, 90mm bulb recess
// Frequencies (a,b,c) and phase (d) control curve complexity

// ── Curve parameters ──────────────────────────────────────
A    = 3;      // X-axis frequency
B    = 4;      // Y-axis frequency
C    = 2;      // Z-axis frequency
D    = 45;     // X phase offset (degrees)
RX   = 52;     // X radius
RY   = 48;     // Y radius
RZ   = 55;     // Z radius (height range)
TUBE_D = 9;    // Tube cross-section diameter
STEPS  = 240;  // Curve resolution — more = smoother
BASE_H = 18;
BASE_D = 140;
WALL   = 2.5;

// ── Lissajous 3D parametric equations ─────────────────────
function lx(t) = sin(A*t + D) * RX;
function ly(t) = sin(B*t) * RY;
function lz(t) = cos(C*t) * RZ + RZ + BASE_H + TUBE_D;

// ── Tube along Lissajous curve (chain of hull spheres) ────
module lissajous_tube() {
    for (i=[0:STEPS-1]) {
        t0 = i * 360 / STEPS;
        t1 = (i+1) * 360 / STEPS;
        p0 = [lx(t0), ly(t0), lz(t0)];
        p1 = [lx(t1), ly(t1), lz(t1)];
        hull() {
            translate(p0) sphere(d=TUBE_D, $fn=8);
            translate(p1) sphere(d=TUBE_D, $fn=8);
        }
    }
}

// ── Frequency marker (visual guide to the math) ───────────
module freq_badge() {
    translate([BASE_D/2*0.52, 0, BASE_H*0.6])
        rotate([90,0,90])
            linear_extrude(2)
                text(str("Lissajous(", A, ",", B, ",", C, ")"), size=4.5, halign="center", $fn=4);
}

// ── Base plinth (hollow, E14/E27 socket recess) ───────────
module base() {
    difference() {
        union() {
            // Outer hexagonal base (6-sided for anti-roll)
            cylinder(d=BASE_D, h=BASE_H, $fn=6);
            // Inner collar rise
            translate([0,0,BASE_H]) cylinder(d=BASE_D*0.55, h=6, $fn=48);
        }
        // Hollow interior
        translate([0,0,5]) cylinder(d=BASE_D-WALL*3, h=BASE_H, $fn=6);
        // Bulb socket recess (E14 = 38mm, E27 = 48mm)
        translate([0,0,BASE_H-2]) cylinder(d=38, h=12, $fn=36);
        // Cable exit
        translate([0,0,-1]) cylinder(d=12, h=8, $fn=12);
        // Label
        freq_badge();
    }
    // Base rim detail — stepped edge
    translate([0,0,BASE_H-3])
        difference() {
            cylinder(d=BASE_D*1.02, h=3, $fn=6);
            cylinder(d=BASE_D-2, h=4, $fn=6);
        }
}

// ── Socket collar (attaches base to bulb) ─────────────────
module socket_collar() {
    translate([0,0,BASE_H+4])
        difference() {
            cylinder(d=42, h=16, $fn=36);
            cylinder(d=38, h=17, $fn=36);
            // Lock notches
            for(a=[0,120,240])
                rotate([0,0,a]) translate([20,-2,3]) cube([8,4,12]);
        }
}

// ── Assembly ──────────────────────────────────────────────
// Color 1 (opaque accent): base + socket collar
base();
socket_collar();

// Color 2 (translucent PETG): Lissajous tube structure
lissajous_tube();
