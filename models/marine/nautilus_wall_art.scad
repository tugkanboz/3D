// Nautilus Shell Cross-Section — Mathematical Wall Art
// True logarithmic spiral: r = a*e^(b*θ)
// Chamber septa visible with golden ratio proportions
// DUAL COLOR: shell body (cream/ivory) | septa + suture lines (dark)
// PLA — 0.15mm, 4 walls, 20% infill — print flat, wall-hang ready

// Logarithmic spiral parameters
// Nautilus: growth factor b ≈ 0.1759 rad⁻¹
A_SCALE = 3.0;    // Starting radius (mm)
B_RATE  = 0.18;   // Growth rate per radian
N_TURNS = 3.5;    // Number of full turns
N_SEPT  = 30;     // Number of chamber septa

PANEL_T   = 8.0;  // Panel thickness
SHELL_T   = 4.0;  // Shell wall thickness
SEPTA_T   = 2.5;  // Septa thickness
OUTER_D   = 220;  // Panel diameter
HANG_D    = 6.0;  // Hanging hole diameter

// Spiral radius at angle θ (degrees)
function spiral_r(theta_deg) = A_SCALE * exp(B_RATE * theta_deg * PI/180);

// Point on inner spiral (shell thickness offset)
function inner_r(theta_deg) = max(2, spiral_r(theta_deg) - SHELL_T);

// Build spiral as polygon
STEPS = 200;
MAX_ANGLE = N_TURNS * 360;

function outer_pts(steps, max_a) = [
    for (i=[0:steps])
        let(a = i * max_a / steps)
            [spiral_r(a)*cos(a), spiral_r(a)*sin(a)]
];

function inner_pts_rev(steps, max_a) = [
    for (i=[steps:-1:0])
        let(a = i * max_a / steps)
            [inner_r(a)*cos(a), inner_r(a)*sin(a)]
];

// ── Shell body (Color 1) ───────────────────────────────
module shell_body() {
    outer = outer_pts(STEPS, MAX_ANGLE);
    inner = inner_pts_rev(STEPS, MAX_ANGLE);
    combined = concat(outer, inner);
    linear_extrude(PANEL_T)
        polygon(combined);
}

// ── Chamber septa (Color 2) ────────────────────────────
module septa() {
    for (i=[0:N_SEPT-1]) {
        // Septa fan from inner to outer wall along radial
        angle = i * MAX_ANGLE / N_SEPT + 15;
        r_outer = spiral_r(angle);
        r_inner = inner_r(angle);
        len = r_outer - r_inner;
        if (len > 2)
            rotate([0,0,angle])
                translate([r_inner, -SEPTA_T/2, 0])
                    // Septa: slightly curved (approximate with tapered prism)
                    hull() {
                        cube([len*0.6, SEPTA_T, PANEL_T]);
                        translate([len*0.5, SEPTA_T*0.2, 0])
                            cube([len*0.5, SEPTA_T*0.7, PANEL_T]);
                    }
    }
    // Suture lines (where septa meet outer wall — sinuous ridges)
    for (i=[0:N_SEPT-1]) {
        angle = i * MAX_ANGLE / N_SEPT + 15;
        r_outer = spiral_r(angle);
        rotate([0,0,angle])
            translate([r_outer-3, -1.5, PANEL_T-1])
                cube([4, 3, 2]);
    }
}

// ── Siphuncle tube (runs through all chambers) ────────
module siphuncle() {
    for (i=[0:N_SEPT*STEPS/N_SEPT-1]) {
        a0 = i * MAX_ANGLE / (N_SEPT*STEPS/N_SEPT);
        a1 = (i+1) * MAX_ANGLE / (N_SEPT*STEPS/N_SEPT);
        r0 = inner_r(a0) + SHELL_T*0.3;
        r1 = inner_r(a1) + SHELL_T*0.3;
        hull() {
            translate([r0*cos(a0), r0*sin(a0), PANEL_T/2])
                sphere(d=2.5, $fn=8);
            translate([r1*cos(a1), r1*sin(a1), PANEL_T/2])
                sphere(d=2.5, $fn=8);
        }
    }
}

// ── Circular panel frame ───────────────────────────────
module panel_frame() {
    difference() {
        cylinder(d=OUTER_D, h=PANEL_T*0.6, $fn=OUTER_D);
        cylinder(d=OUTER_D-14, h=PANEL_T+2, $fn=OUTER_D);
        // Hanging holes
        for (x=[-50,50])
            translate([x, OUTER_D/2-10, -1])
                cylinder(d=HANG_D, h=PANEL_T+2, $fn=12);
    }
    // Label (bottom of frame)
    translate([-45, -OUTER_D/2+5, PANEL_T*0.6-0.5])
        linear_extrude(1.5)
            text("NAUTILUS POMPILIUS — φ = 1.618", size=5.5, $fn=4);
}

// ── Assembled model ────────────────────────────────────
// Color 1 (cream): shell body + frame
shell_body();
panel_frame();
// Color 2 (dark): septa + siphuncle
septa();
siphuncle();
