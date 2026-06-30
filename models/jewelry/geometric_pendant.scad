// Sacred Geometry Pendant - Icosahedron Frame
// Minimalist wireframe jewelry
// Print: 0.1mm resin or 0.15mm FDM, 4 walls
// Add bail (loop) for chain — parametric

EDGE_L   = 22;    // Edge length of icosahedron
BAR_D    = 2.0;   // Edge bar diameter
BAIL_D   = 8.0;   // Chain loop outer diameter
BAIL_T   = 1.5;

// Icosahedron vertices (unit, scaled by EDGE_L)
PHI = (1 + sqrt(5)) / 2;
NORM = sqrt(1 + PHI*PHI);
SC = EDGE_L / (2 / NORM);  // scale so edge = EDGE_L

VERTS = [
     [0,  1,  PHI], [0, -1,  PHI], [0,  1, -PHI], [0, -1, -PHI],
     [ PHI,  0,  1], [ PHI,  0, -1], [-PHI,  0,  1], [-PHI,  0, -1],
     [1,  PHI,  0], [-1,  PHI,  0], [1, -PHI,  0], [-1, -PHI,  0]
] / NORM * EDGE_L;

EDGES = [
    [0,1],[0,4],[0,6],[0,8],[0,9],
    [1,4],[1,6],[1,10],[1,11],
    [2,3],[2,5],[2,7],[2,8],[2,9],
    [3,5],[3,7],[3,10],[3,11],
    [4,5],[4,8],[4,10],
    [5,8],[6,7],[6,9],[6,11],
    [7,9],[7,11],[8,9],[10,11]
];

module edge(a, b) {
    va = VERTS[a];
    vb = VERTS[b];
    d = vb - va;
    len = norm(d);
    mid = (va + vb) / 2;
    translate(mid)
        rotate([0, acos(d[2]/len), atan2(d[1], d[0])])
            cylinder(d = BAR_D, h = len, center = true, $fn = 10);
}

module bail() {
    translate([0, 0, max([for (v = VERTS) v[2]]) + BAIL_D/2])
    difference() {
        torus_approx(BAIL_D/2, BAIL_T);
        // Gap for chain insertion
        translate([0, BAIL_D/2 - BAIL_T, 0])
            cube([BAIL_T, BAIL_T * 2, BAIL_T * 3], center = true);
    }
}

module torus_approx(r_maj, r_min) {
    rotate_extrude($fn = 32)
        translate([r_maj, 0, 0])
            circle(r = r_min, $fn = 12);
}

union() {
    for (e = EDGES) edge(e[0], e[1]);
    bail();
}
