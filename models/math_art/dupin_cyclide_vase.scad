// Dupin Cyclide Vase — Fourth-Degree Algebraic Surface
// A Dupin cyclide is the unique surface where BOTH families of curvature lines are circles
// It is the conformal inversion of a torus — discovered by Charles Dupin in 1822
// The surface satisfies: (x²+y²+z²−μ²+b²)² = 4(ax−cμ)² + 4b²y²
// This vase uses the ring cyclide's distinctive asymmetric "inflated torus" silhouette
// DUAL COLOR: vase body (body) | base ring + lip ring (accent)
// PLA/PETG 0.15mm, 4 walls, 15% gyroid
// The cyclide's non-uniform curvature creates an organic vase unlike any standard lathe profile

$fn = 180;
PI = 3.14159265358979;

// ── Cyclide parameters (a²=b²+c²) ────────────────────────
// a: focal distance (controls overall size)
// b: equatorial radius minor axis
// c: eccentricity (controls asymmetry — 0=horn torus, a=spindle cyclide)
// μ: inversion sphere parameter (controls inner/outer radius ratio)
A  = 60;   // a
B  = 42;   // b  (must satisfy b² < a², i.e. b < a)
C  = sqrt(A*A - B*B);  // c = sqrt(a²-b²) ≈ 42.4
MU = 80;   // μ (>a for ring cyclide, which is a "fat" torus variant)

// ── Dupin cyclide parametric equations ───────────────────
// u,v ∈ [0, 2π)
// x(u,v) = (d(c − a·cos u·cos v) + b²·cos u) / (a − c·cos u·cos v)
// y(u,v) = (b·sin u·(a − d·cos v))           / (a − c·cos u·cos v)
// z(u,v) = (b·sin v·(c·cos u − d))           / (a − c·cos u·cos v)
// where d = μ (for ring cyclide: d > a)
D = MU;

function denom(u,v) = A - C*cos(u)*cos(v);
function cx(u,v)   = (D*(C - A*cos(u)*cos(v)) + B*B*cos(u)) / denom(u,v);
function cy(u,v)   = (B*sin(u)*(A - D*cos(v))) / denom(u,v);
function cz(u,v)   = (B*sin(v)*(C*cos(u) - D)) / denom(u,v);

// ── Profile extraction for rotate_extrude ────────────────
// The cyclide has circular symmetry around one axis only when c=0 (torus).
// For c>0, we take a longitudinal cross-section (y=0 slice) and use it as
// the lathe profile — this captures the cyclide's asymmetric side silhouette
// v ∈ [0°,180°] traces the cross-section in the x-z plane (y→0)

// At y=0: sin(u)=0, so u=0 or 180.
// u=0: traces the "outer" generatrix circle
// u=180: traces the "inner" (inverted) generatrix
// Together they form the full cross-section contour

STEPS_V = 120;
STEPS_U = 60;

// Build profile points for the outer and inner arcs
// Outer arc (u=0): x goes from (D*(C-A)+B²)/(A-C) to (D*(C+A)-B²)/(A+C)
// at v=0 and v=180 respectively
// We sample v from 0→360 at u=0 and u=180 to get the closed profile

// Profile for rotate_extrude: [r, z] pairs where r = sqrt(x²+y²) at given point
// We fix y=0 (take v∈[0,180], u=0 for outer wall; u=180 for inner wall)

// Vase height: the z-extent of the cyclide at these parameters
// Z_MIN ≈ B*(C-D)/A (when cos u = C/A, sin v = -1)
// Z_MAX ≈ B*(D-C)/A

// ── Profile generation (outer silhouette only) ────────────
// For a vase we take the outer silhouette of the cyclide
// Sample points along the outer surface profile

// We'll use the v-parameter contour at u=0 (outer arc)
PROFILE_OUTER = [for(i=[0:STEPS_V-1])
    let(v_deg = i * 360/STEPS_V,
        u_deg = 0,
        px = cx(u_deg, v_deg),
        pz = cz(u_deg, v_deg))
    [max(px, 1), pz]  // r must be positive for rotate_extrude
];

// ── Vase body via rotate_extrude of cyclide profile ──────
// The profile is pre-scaled to fit within print volume
SCALE = 1.0;
WALL_T = 3.0;    // vase wall thickness
NECK_D = 44;     // neck opening diameter

module cyclide_profile_solid() {
    rotate_extrude(angle=360, $fn=180)
        polygon(PROFILE_OUTER);
}

// ── Actual parametric vase body ───────────────────────────
// Full 3D cyclide mesh via polyhedron approximation
// We generate the mesh from the full parametric surface
NU = 60; NV = 60;

// Pre-compute mesh vertices
function v_idx(iu,iv) = iu * NV + iv;

VERTS = [for(iu=[0:NU-1]) for(iv=[0:NV-1])
    let(u_deg = iu * 360/NU, v_deg = iv * 360/NV)
    [cx(u_deg,v_deg), cy(u_deg,v_deg), cz(u_deg,v_deg)]
];

FACES = [for(iu=[0:NU-1]) for(iv=[0:NV-1])
    let(iu2=(iu+1)%NU, iv2=(iv+1)%NV,
        a=v_idx(iu,iv), b=v_idx(iu2,iv),
        c=v_idx(iu2,iv2), d=v_idx(iu,iv2))
    [a,b,c,d]
];

module cyclide_mesh() {
    polyhedron(points=VERTS, faces=FACES, convexity=6);
}

// ── Vase shell (hollowed cyclide) ─────────────────────────
// Build as scaled nested difference — outer full, inner slightly smaller
module vase_body() {
    // Compute bounding z range
    Z_VALS = [for(v=[0:STEPS_V-1]) let(v_deg=v*360/STEPS_V)
        (B*(C*cos(0)-D)/denom(0,v_deg))];  // z at u=0

    // Scale factor: target 190mm height (z extent)
    Z_MIN_EST = -B*(D-C)/A;
    Z_MAX_EST =  B*(D-C)/A;
    Z_SPAN = Z_MAX_EST - Z_MIN_EST;
    // Approximate z span and scale to 185mm
    SF = 185 / max(Z_SPAN * 2.5, 100);  // rough estimate

    difference() {
        // Outer cyclide body
        scale([SF, SF, SF*1.2])
            cyclide_mesh();

        // Hollow interior (scaled down slightly)
        scale([SF*0.92, SF*0.92, SF*1.2+1])
            translate([0, 0, 0.5/SF])
                cyclide_mesh();

        // Cut the bottom flat (vase stands on a plane)
        translate([0, 0, -200]) cube([400, 400, 400], center=true);

        // Cut the top open (neck opening for flowers)
        translate([0, 0, 200 - 15]) cylinder(d=500, h=20, $fn=80);
    }
}

// ── Base ring (stabilizing flat base, accent color) ───────
module base_ring() {
    difference() {
        cylinder(d=82, h=6, $fn=80);
        cylinder(d=60, h=7, $fn=80);
        // Inscription
        for(i=[0:5]) rotate([0,0,i*60])
            translate([28, -1.5, 4.8]) linear_extrude(1.5)
                text("◆", size=4, $fn=6);
    }
    // Toe-in chamfer on bottom
    translate([0,0,0]) difference() {
        cylinder(d1=86, d2=82, h=3, $fn=80);
        cylinder(d=60, h=4, $fn=80);
    }
}

// ── Lip ring (top edge, accent color) ─────────────────────
module lip_ring() {
    NECK_R = NECK_D/2;
    difference() {
        cylinder(d=NECK_D+8, h=5, $fn=60);
        cylinder(d=NECK_D-2, h=6, $fn=60);
        // Decorative groove
        translate([0,0,2]) difference() {
            cylinder(d=NECK_D+9, h=2, $fn=60);
            cylinder(d=NECK_D+5, h=3, $fn=60);
        }
        // Label
        translate([-22, -2, 4]) linear_extrude(1.5)
            text("CYCLIDE", size=4, $fn=4);
        translate([-16, -7, 4]) linear_extrude(1.5)
            text("1822", size=4, $fn=4);
    }
}

// ── Reference card ────────────────────────────────────────
module reference_plate() {
    difference() {
        cube([130, 70, 3]);
        translate([4,57,1.5]) linear_extrude(1.5) text("DUPIN CYCLIDE", size=8, $fn=4);
        translate([4,47,1.5]) linear_extrude(1.5) text("(x²+y²+z²−μ²+b²)²=", size=4.5, $fn=4);
        translate([4,38,1.5]) linear_extrude(1.5) text("4(ax−cμ)² + 4b²y²", size=4.5, $fn=4);
        translate([4,27,1.5]) linear_extrude(1.5) text(str("a=",A,"  b=",B,"  c=",round(C*10)/10), size=4.5, $fn=4);
        translate([4,17,1.5]) linear_extrude(1.5) text(str("μ=",MU,"  d=",D), size=4.5, $fn=4);
        translate([4,7,1.5]) linear_extrude(1.5) text("Charles Dupin, 1822", size=4.5, $fn=4);
    }
}

// ── Assembly ──────────────────────────────────────────────
// Color 1 (body): vase body
vase_body();

// Color 2 (accent): base ring + lip ring
base_ring();

// Lip ring position: approximate top of cyclide
translate([0, 0, 168]) lip_ring();

// Reference card (flat print alongside)
translate([110, -35, 0]) reference_plate();
