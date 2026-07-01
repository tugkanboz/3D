// Sierpinski Pyramid — 4-Level Recursive Fractal Tetrahedron
// True 3D Sierpinski gasket — each iteration removes center void
// 180mm total, 4 levels deep, mathematically accurate
// DUAL COLOR: outer faces (accent) | inner hollow shadow (dark base)
// PLA — 0.15mm, 3 walls, 10% sparse infill

LEVELS = 4;       // Recursion depth (3 or 4 for print quality)
BASE_SIZE = 180;  // Outer edge length (mm)
MIN_SIZE  = BASE_SIZE / pow(2, LEVELS);
WALL_MIN  = 1.8;  // Minimum printable wall

// ── Tetrahedron vertices ───────────────────────────────
// Regular tetrahedron: edge length = s
// Vertices: 4 corners of a regular tetrahedron
function tetra_pts(s) = [
    [0,         0,           s*sqrt(2/3)],
    [s/sqrt(3), 0,           0          ],
    [-s/(2*sqrt(3)), s/2,    0          ],
    [-s/(2*sqrt(3)), -s/2,   0          ],
];

// Center of edge midpoints (for recursive subdivision)
function mid(a, b) = [(a[0]+b[0])/2, (a[1]+b[1])/2, (a[2]+b[2])/2];

// ── Single solid tetrahedron ───────────────────────────
module solid_tetra(pts) {
    polyhedron(
        points = pts,
        faces  = [[0,1,2], [0,2,3], [0,3,1], [1,3,2]],
        convexity = 1
    );
}

// ── Recursive Sierpinski ───────────────────────────────
module sierpinski(pts, level) {
    if (level == 0) {
        solid_tetra(pts);
    } else {
        // 4 sub-tetrahedra at corners (center is void)
        p0=pts[0]; p1=pts[1]; p2=pts[2]; p3=pts[3];
        m01=mid(p0,p1); m02=mid(p0,p2); m03=mid(p0,p3);
        m12=mid(p1,p2); m13=mid(p1,p3); m23=mid(p2,p3);

        sierpinski([p0,  m01, m02, m03], level-1);  // corner 0
        sierpinski([m01, p1,  m12, m13], level-1);  // corner 1
        sierpinski([m02, m12, p2,  m23], level-1);  // corner 2
        sierpinski([m03, m13, m23, p3 ], level-1);  // corner 3
    }
}

// ── Base display platform ──────────────────────────────
module display_base() {
    s = BASE_SIZE;
    // Triangular prism base matching tetra footprint
    linear_extrude(10)
        polygon([
            [s/sqrt(3)+10, 0],
            [-s/(2*sqrt(3))-8, s/2+8],
            [-s/(2*sqrt(3))-8, -s/2-8],
        ]);
    // Label
    translate([0, 0, 10])
        linear_extrude(2)
            text("SIERPINSKI", size=9, halign="center", $fn=4);
    translate([0, -12, 10])
        linear_extrude(2)
            text("LEVEL 4", size=7, halign="center", $fn=4);
    // Anti-slip rubber pad recesses
    for (c=[[-20,15],[30,0],[-20,-15]])
        translate([c[0], c[1], -1])
            cylinder(d=12, h=3, $fn=8);
}

// ── Main ──────────────────────────────────────────────
// Color 2 (accent): fractal surface
translate([0, 0, 12])
    sierpinski(tetra_pts(BASE_SIZE), LEVELS);

// Color 1 (dark): display base
display_base();
