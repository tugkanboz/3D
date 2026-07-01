// Ammonite Fossil Replica — Ceratitic Suture Pattern
// Mathematically accurate logarithmic spiral with realistic suture lines
// Suitable as wall art, paperweight, or display piece
// DUAL COLOR: shell body (stone/cream) | suture pattern + keel (dark)
// PLA — 0.15mm, 4 walls, print flat — ~200mm diameter

// Ammonite parameters
A       = 4.5;     // Starting radius
B       = 0.145;   // Growth rate (ceratitic ~0.145)
N_TURNS = 2.8;     // Full turns visible
WHORL_T = 0.45;    // Whorl cross-section ratio (height/width)
BODY_T  = 14;      // Model thickness (print flat)
OUTER_D = 200;     // Outer diameter
KEEL_H  = 2.5;     // Ventral keel height
WALL_T  = 2.8;     // Shell wall thickness

// ── Whorl cross-section profile (sub-oval) ────────────
module whorl_profile(w) {
    // Ceratitic cross-section: sub-rounded to sub-angular
    scale([1, WHORL_T])
        hull() {
            circle(d=w*0.85, $fn=20);
            translate([w*0.06, -w*0.1]) circle(d=w*0.3, $fn=12);
        }
}

// ── Spiral shell body ─────────────────────────────────
// Built as a chain of lofted cross-sections along the spiral
STEPS   = 180;
MAX_ANG = N_TURNS * 360;

module shell_whorl() {
    // Solid lofted spiral using hull of adjacent cross-sections
    for (i=[0:STEPS-2]) {
        a0 = i * MAX_ANG / STEPS;
        a1 = (i+1) * MAX_ANG / STEPS;
        r0 = A * exp(B * a0 * PI/180);
        r1 = A * exp(B * a1 * PI/180);
        // Whorl width grows with radius
        w0 = r0 * 0.82;
        w1 = r1 * 0.82;
        hull() {
            translate([r0*cos(a0), r0*sin(a0), 0])
                rotate([0,0,a0])
                    linear_extrude(BODY_T)
                        whorl_profile(w0);
            translate([r1*cos(a1), r1*sin(a1), 0])
                rotate([0,0,a1])
                    linear_extrude(BODY_T)
                        whorl_profile(w1);
        }
    }
}

// ── Suture lines (ceratitic = lobed, not ammonitic) ───
// Ceratitic sutures: sinusoidal with 3-4 saddles per lobe
module suture_line(angle, r, whorl_w) {
    translate([r*cos(angle), r*sin(angle), BODY_T-0.8])
        rotate([0,0,angle+90]) {
            // Main lobe (saddle at center, lobes on sides)
            for (y=[-whorl_w*0.2, 0, whorl_w*0.2])
                translate([0, y, 0])
                    scale([1, 0.4, 1])
                        cylinder(d=2, h=1.2, $fn=8);
            // Secondary crenulations
            for (y=[-whorl_w*0.35, whorl_w*0.35])
                translate([0, y, 0])
                    sphere(d=2.5, $fn=8);
        }
}

module all_sutures() {
    N_SUTURES = 28;
    for (i=[0:N_SUTURES-1]) {
        ang = 15 + i * (MAX_ANG-30) / N_SUTURES;
        r = A * exp(B * ang * PI/180);
        w = r * 0.82;
        if (r < OUTER_D*0.48)
            suture_line(ang, r, w);
    }
}

// ── Ventral keel (runs along outer edge of spiral) ────
module keel() {
    for (i=[0:STEPS-2]) {
        a0 = i * MAX_ANG / STEPS;
        a1 = (i+1) * MAX_ANG / STEPS;
        r0 = A * exp(B * a0 * PI/180) + A * exp(B * a0 * PI/180) * 0.41;
        r1 = A * exp(B * a1 * PI/180) + A * exp(B * a1 * PI/180) * 0.41;
        hull() {
            translate([r0*cos(a0), r0*sin(a0), BODY_T*0.3])
                sphere(d=KEEL_H, $fn=8);
            translate([r1*cos(a1), r1*sin(a1), BODY_T*0.3])
                sphere(d=KEEL_H, $fn=8);
        }
    }
}

// ── Umbilicus (central navel depression) ──────────────
module umbilicus() {
    // Raised spiral ridge visible in center
    for (i=[0:20]) {
        a0 = i * 180 / 20;
        a1 = (i+1) * 180 / 20;
        r0 = A * exp(B * a0 * PI/180) * 0.15;
        r1 = A * exp(B * a1 * PI/180) * 0.15;
        hull() {
            translate([r0*cos(a0), r0*sin(a0), BODY_T-0.5])
                sphere(d=2, $fn=8);
            translate([r1*cos(a1), r1*sin(a1), BODY_T-0.5])
                sphere(d=2, $fn=8);
        }
    }
}

// ── Back plaque ───────────────────────────────────────
module back_plaque() {
    difference() {
        cylinder(d=OUTER_D+15, h=4, $fn=80);
        // Scalloped edge
        for (i=[0:23])
            rotate([0,0,i*15])
                translate([OUTER_D/2+8, 0, -1])
                    cylinder(d=10, h=6, $fn=16);
        // Hanging holes
        for (p=[[0, OUTER_D/2+2], [-35, -OUTER_D/2-4], [35, -OUTER_D/2-4]])
            translate([p[0], p[1], -1])
                cylinder(d=5, h=6, $fn=12);
        // Label
        translate([-45, -OUTER_D/2-10, 2])
            linear_extrude(3)
                text("CERATITES  TRIASSIC  220 MYA", size=5, $fn=4);
    }
}

// Color 1 (stone/cream): shell body + plaque
back_plaque();
translate([0, 0, 4]) shell_whorl();

// Color 2 (dark amber): sutures + keel + umbilicus
translate([0, 0, 4]) {
    all_sutures();
    keel();
    umbilicus();
}
