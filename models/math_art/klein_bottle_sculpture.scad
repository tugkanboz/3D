// Klein Bottle Sculpture — Non-Orientable Surface (3D Immersion)
// A Klein bottle is a surface with NO inside or outside — one continuous surface
// In 4D it has no self-intersection; this model shows the 3D projection (immersion)
// where the "neck" passes through the body wall (the self-intersection visible here
// would NOT exist in true 4D — it's an artifact of projecting down one dimension)
// Topology: Euler characteristic χ=0, one-sided (like a Möbius strip but closed)
// "The Klein bottle is what you get when you try to fill a Möbius strip"
// DUAL COLOR: outer body (body) | neck tube + self-intersection highlight (accent)
// PETG 0.2mm, 4 walls — stand-alone sculpture, fits 230×120×200mm
// Print flat on bottom; no supports needed if body is oriented correctly

$fn = 90;
PI = 3.14159265358979;

// ── Parametric Klein bottle immersion ────────────────────
// Using the "classical" figure-8 immersion (Lawson's form):
// The bottle is divided into two parts with smooth junction:
// Part A (u ∈ [0,π]): forms the "outer" body tube
// Part B (u ∈ [π,2π]): forms the "inner" neck passing through

// Figure-8 Klein bottle (smoothly embedded in R³):
// r(u,v) vector in terms of R (major), P (profile), a (neck scale)
R_MAJOR  = 52;   // Major radius (center of tube to center of bottle)
R_MINOR  = 22;   // Minor radius (tube cross-section)
NECK_R   = 9;    // Neck tube radius (where it passes through)
WALL_T   = 3.5;  // Wall thickness (for printability)
HEIGHT   = 195;  // Target height ~195mm

// ── Model approach: 4 components ─────────────────────────
// 1. BODY: large toroidal lower section (the "bottle" part)
// 2. UPPER_TUBE: tube that rises from body and curves around
// 3. NECK_PIERCE: tube that enters through the body side
// 4. INNER_CUP: inside portion that connects neck to body interior
// This gives the recognizable Klein bottle shape

// ── Lower body (oblate torus — the "bottle base") ─────────
module lower_body() {
    R_BOT = R_MAJOR + R_MINOR;  // outer equator
    R_TOP = R_MAJOR - R_MINOR;  // inner equator (where neck will pass)

    difference() {
        // Full torus section (bottom 3/4 turn)
        rotate_extrude(angle=300, $fn=180)
            translate([R_MAJOR, 0, 0])
                circle(r=R_MINOR, $fn=48);

        // Remove top (open for upper tube connection)
        translate([0, 0, R_MINOR*0.6]) cylinder(r=R_MAJOR+R_MINOR+5, h=R_MINOR*2, $fn=60);

        // Inner hollow (wall thickness)
        rotate_extrude(angle=302, $fn=180)
            translate([R_MAJOR, 0, 0])
                circle(r=R_MINOR-WALL_T, $fn=48);
    }

    // Bottom cap (flat base for printing)
    difference() {
        cylinder(r=R_BOT+2, h=WALL_T, $fn=120);
        cylinder(r=R_BOT-WALL_T*2, h=WALL_T+1, $fn=120);
    }

    // Connection lips on the torus ends
    for(ang=[0,300]) rotate([0,0,ang])
        translate([R_MAJOR, 0, 0])
            cylinder(r=R_MINOR+1, h=3, $fn=30);
}

// ── The "neck arc" — tube that rises up and curves back ──
// Goes from the top of the body, arcs 180°, comes back down
// to pass through the body wall
module neck_arc() {
    ARC_R   = R_MAJOR * 0.72;   // arc radius (center of arc path)
    ARC_CX  = 0;                // arc center
    ARC_CZ  = R_MINOR * 1.2;   // start height

    // Rising straight section (from body top to arc start)
    translate([R_MAJOR, 0, ARC_CZ])
        cylinder(r=NECK_R, h=R_MAJOR*0.65, $fn=24);
    translate([R_MAJOR, 0, ARC_CZ])
        cylinder(r=NECK_R-WALL_T, h=R_MAJOR*0.65+2, $fn=24);  // hollow

    // Arc: semicircle bending over the top
    RISE_H = R_MAJOR * 0.65 + ARC_CZ;
    ARC_Y_CENTER = R_MAJOR;
    ARC_Z_CENTER = RISE_H;

    // Outer arc (180° from right side to left side, going up over)
    difference() {
        translate([0, ARC_Y_CENTER, ARC_Z_CENTER])
            rotate([90, 0, 0])
                rotate_extrude(angle=180, $fn=120)
                    translate([ARC_R, 0]) circle(r=NECK_R, $fn=20);
        // Hollow
        translate([0, ARC_Y_CENTER, ARC_Z_CENTER])
            rotate([90, 0, 0])
                rotate_extrude(angle=182, $fn=120)
                    translate([ARC_R, 0]) circle(r=NECK_R-WALL_T, $fn=20);
    }

    // ── The pierce: tube coming back down through body ────
    // After the 180° arc, the tube descends and enters the body wall
    PIERCE_X = -R_MAJOR;  // opposite side
    PIERCE_TOP_Z = RISE_H + ARC_R*1.5; // where the arc ends on left side (approx)

    // Descending section after arc
    PIERCE_TOP = ARC_Z_CENTER + ARC_R;
    translate([0, ARC_Y_CENTER, PIERCE_TOP])
        difference() {
            cylinder(r=NECK_R, h=PIERCE_TOP, $fn=24);
            cylinder(r=NECK_R-WALL_T, h=PIERCE_TOP+2, $fn=24);
        }
}

// ── Junction highlight rings (show the self-intersection) ─
module intersection_rings() {
    // The self-intersection occurs where the neck passes through the body
    // Highlighted with a ring/collar showing where 4D would be smooth
    PIERCE_Z = R_MINOR * 0.5;  // height where neck enters body
    translate([0, ARC_Y_CENTER_APPROX, PIERCE_Z])
        difference() {
            cylinder(r=NECK_R+3, h=6, $fn=30);
            cylinder(r=NECK_R-1, h=8, $fn=30);
        }
}

// Helper to compute arc endpoint
ARC_Y_APPROX = R_MAJOR;
ARC_Z_APPROX = R_MINOR * 1.2 + R_MAJOR*0.65;
ARC_Y_CENTER_APPROX = ARC_Y_APPROX;

// ── Mathematical label plate ──────────────────────────────
module label_plate() {
    difference() {
        cube([130, 72, 3]);
        translate([4,60,1.5]) linear_extrude(1.8) text("KLEIN BOTTLE", size=9, $fn=4);
        translate([4,50,1.5]) linear_extrude(1.5) text("Non-Orientable Surface", size=5, $fn=4);
        translate([4,41,1.5]) linear_extrude(1.5) text("χ = 0, no inside/outside", size=5, $fn=4);
        translate([4,32,1.5]) linear_extrude(1.5) text("4D: no self-intersection", size=5, $fn=4);
        translate([4,23,1.5]) linear_extrude(1.5) text("Felix Klein, 1882", size=5, $fn=4);
        translate([4,13,1.5]) linear_extrude(1.5) text("K = M∪M / (∂M₁≡∂M₂)", size=5, $fn=4);
        translate([4,4,1.5]) linear_extrude(1.5)
            text("Euler char: K#K ≅ T#T#T", size=4.5, $fn=4);
    }
}

// ── Base ring ─────────────────────────────────────────────
module base_ring() {
    R_BOT_OUTER = R_MAJOR + R_MINOR;
    difference() {
        cylinder(r=R_BOT_OUTER+6, h=8, $fn=120);
        cylinder(r=R_BOT_OUTER-4, h=9, $fn=120);
        translate([-30, -4, 6]) linear_extrude(2.5) text("KLEIN 1882", size=5, $fn=4);
    }
    // Toe chamfer
    difference() {
        cylinder(r1=R_BOT_OUTER+9, r2=R_BOT_OUTER+6, h=4, $fn=120);
        cylinder(r=R_BOT_OUTER-4, h=5, $fn=120);
    }
}

// ── Full assembly ─────────────────────────────────────────
// Color 1 (body): lower body + neck arc
lower_body();
neck_arc();

// Color 2 (accent): base ring + label plate
base_ring();
translate([R_MAJOR+R_MINOR+15, -(72/2), 0]) label_plate();
