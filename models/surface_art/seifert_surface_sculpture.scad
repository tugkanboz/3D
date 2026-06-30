// Seifert Surface Topology Sculpture — Math Art Object
// A minimal surface bounded by a trefoil knot
// PETG or silk PLA — 0.15mm, 2 walls, 0% infill
// Incredible wall art / desk sculpture — conversation starter

SCALE   = 50;   // Overall scale
THICK   = 2.8;  // Surface thickness
STEPS   = 80;   // Mesh resolution
BASE_D  = 80;
BASE_H  = 8;

// Trefoil knot parametric equations
function trefoil_x(t) = sin(t) + 2*sin(2*t);
function trefoil_y(t) = cos(t) - 2*cos(2*t);
function trefoil_z(t) = -sin(3*t);

// Seifert surface span: each point on surface = (r, t)
// where r ∈ [0,1] blends from center to knot
// Using Milnor fiber approximation
function seifert_pt(r, t) = [
    r * SCALE * (trefoil_x(t * 360) * 0.5 + (1-r) * cos(t * 360 * 1.5) * 0.3),
    r * SCALE * (trefoil_y(t * 360) * 0.5 + (1-r) * sin(t * 360 * 1.5) * 0.3),
    r * SCALE * trefoil_z(t * 360) * 0.6
];

module seifert_strip() {
    // Build surface as mesh of quads
    R_STEPS = 12;
    T_STEPS = STEPS;

    for (ti = [0 : T_STEPS - 1]) {
        for (ri = [0 : R_STEPS - 2]) {
            t0 = ti / T_STEPS;
            t1 = (ti + 1) / T_STEPS;
            r0 = ri / R_STEPS;
            r1 = (ri + 1) / R_STEPS;

            p00 = seifert_pt(r0, t0);
            p10 = seifert_pt(r1, t0);
            p01 = seifert_pt(r0, t1);
            p11 = seifert_pt(r1, t1);

            hull() {
                translate(p00) sphere(d = THICK, $fn = 8);
                translate(p10) sphere(d = THICK, $fn = 8);
                translate(p01) sphere(d = THICK, $fn = 8);
                translate(p11) sphere(d = THICK, $fn = 8);
            }
        }
    }
}

module trefoil_knot_border() {
    // Highlight the boundary knot in thicker material
    for (ti = [0 : STEPS - 1]) {
        t0 = ti / STEPS;
        t1 = (ti + 1) / STEPS;
        p0 = seifert_pt(1, t0);
        p1 = seifert_pt(1, t1);
        hull() {
            translate(p0) sphere(d = THICK * 1.8, $fn = 10);
            translate(p1) sphere(d = THICK * 1.8, $fn = 10);
        }
    }
}

module display_base() {
    difference() {
        cylinder(d = BASE_D, h = BASE_H, $fn = 48);
        translate([0, 0, 3])
            cylinder(d = BASE_D - 8, h = BASE_H, $fn = 48);
        // Label
        translate([-22, BASE_D/2 - 14, -0.5])
            linear_extrude(2)
                text("SEIFERT SURFACE", size = 4.5, $fn = 4);
    }
    // Support post
    cylinder(d = 10, h = BASE_H + SCALE * 0.3, $fn = 16);
}

translate([0, 0, BASE_H + SCALE * 0.3]) {
    seifert_strip();
    trefoil_knot_border();
}
display_base();
