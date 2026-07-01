// 3D Hilbert Curve Sculpture — Level 3 Space-Filling Fractal
// Based on the 3D Hilbert curve traversing all octants of a cube
// Tube follows 512 points (level 3 = 8³ subdivisions)
// SINGLE COLOR — pure mathematical form
// PLA — 0.15mm, 4 walls, 20% infill — print on support raft
// ~150mm cube — 8 hours print, stunning result

CUBE_S  = 150;   // Bounding cube side
TUBE_D  = 5.5;   // Tube diameter (tube must be printable, min ~4mm for level 3)
LEVEL   = 3;     // Recursion depth (2=fast preview, 3=final)
BASE_H  = 12;    // Display plinth height
BASE_D  = 160;

// ── 3D Hilbert curve point generation ─────────────────
// Rotate/reflect operations for 3D Hilbert traversal
function rot3(p, rx, ry, rz) = let(
    // 8 possible rotations of the unit cube octant
    // These define the Hilbert orientation per sub-cube
    x=p[0], y=p[1], z=p[2]
) rx==0 && ry==0 && rz==0 ? p :
  rx==1 ? [y, x, z] :
  ry==1 ? [x, z, y] :
  rz==1 ? [z, y, x] : p;

// Hilbert index to 3D coordinates (iterative, level n)
function h2xyz(idx, n) = let(
    pts = _hilbert3d(n),
    i = max(0, min(idx, len(pts)-1))
) pts[i];

// Generate all 3D Hilbert points at given level
// Uses the standard bit-manipulation algorithm
function _hilbert3d(n) = [
    for (i=[0:pow(8,n)-1])
        _h3_point(i, n)
];

function _h3_point(idx, n) = let(
    // Extract bit triplets and apply rotations
    result = _h3_iter(idx, n, [0,0,0])
) result;

function _h3_iter(idx, n, acc) =
    n==0 ? acc :
    let(
        oct = idx % 8,
        nx = (oct & 1) > 0 ? 1 : 0,
        ny = (oct & 2) > 0 ? 1 : 0,
        nz = (oct & 4) > 0 ? 1 : 0,
        // Simple 3D ordering (Gray code-like)
        gx = (nx ^ ny),
        gy = ny,
        gz = (nz ^ ny),
        scale = pow(2, n-1),
        base = _h3_iter(floor(idx/8), n-1, acc)
    ) [base[0]*2 + gx, base[1]*2 + gy, base[2]*2 + gz];

// ── Tube segment between two 3D points ────────────────
module tube_segment(p1, p2, d) {
    v = p2 - p1;
    len = norm(v);
    if (len > 0.01) {
        translate(p1)
            // Align cylinder from p1 toward p2
            rotate([0, acos(v[2]/len), atan2(v[1],v[0])])
                cylinder(d=d, h=len, $fn=10);
    }
}

module sphere_joint(p, d) {
    translate(p) sphere(d=d*1.1, $fn=10);
}

// ── Build the Hilbert tube ────────────────────────────
module hilbert_curve_3d(level, cube_size, tube_d) {
    n_pts = pow(8, level);
    spacing = cube_size / pow(2, level);
    offset  = spacing/2;

    for (i=[0:n_pts-2]) {
        p1 = _h3_point(i, level);
        p2 = _h3_point(i+1, level);
        // Scale from grid coords to mm
        pt1 = [p1[0]*spacing + offset, p1[1]*spacing + offset, p1[2]*spacing + offset];
        pt2 = [p2[0]*spacing + offset, p2[1]*spacing + offset, p2[2]*spacing + offset];
        tube_segment(pt1, pt2, tube_d);
        sphere_joint(pt1, tube_d);
    }
    // Final point sphere
    p_last = _h3_point(n_pts-1, level);
    sphere_joint([p_last[0]*spacing+offset, p_last[1]*spacing+offset, p_last[2]*spacing+offset], tube_d);
}

// ── Corner frame (thin wireframe cube outline) ────────
module wire_cube(s, w=2) {
    for (x=[0,s], y=[0,s])
        translate([x, y, 0]) cylinder(d=w, h=s, $fn=6);
    for (x=[0,s], z=[0,s])
        translate([x, 0, z]) rotate([-90,0,0]) cylinder(d=w, h=s, $fn=6);
    for (y=[0,s], z=[0,s])
        translate([0, y, z]) rotate([0,90,0]) cylinder(d=w, h=s, $fn=6);
}

// ── Display plinth ────────────────────────────────────
module plinth() {
    difference() {
        hull() {
            cylinder(d=BASE_D, h=BASE_H, $fn=6);
            translate([0,0,BASE_H]) cylinder(d=BASE_D-8, h=2, $fn=6);
        }
        translate([0,0,4])
            cylinder(d=BASE_D-14, h=BASE_H, $fn=6);
        // Corner shelf cutouts
        for (i=[0:2])
            rotate([0,0,i*120])
                translate([BASE_D/2-10, 0, 0])
                    cylinder(d=18, h=BASE_H+4, $fn=8);
        // Label
        translate([-40, -BASE_D/2+6, BASE_H-0.5])
            linear_extrude(1.5)
                text("HILBERT CURVE — LEVEL 3", size=5, $fn=4);
    }
}

// ── Assembly ──────────────────────────────────────────
translate([0, 0, BASE_H])
    translate([-CUBE_S/2, -CUBE_S/2, 0])
        hilbert_curve_3d(LEVEL, CUBE_S, TUBE_D);

plinth();

// Bounding cube wireframe
translate([-CUBE_S/2, -CUBE_S/2, BASE_H])
    wire_cube(CUBE_S);
