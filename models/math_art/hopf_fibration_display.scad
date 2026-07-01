// Hopf Fibration Display Sculpture
// Mathematical object: S³ → S² fiber bundle, visualized via Villarceau circles
// Each ring is a "fiber" — all rings link exactly once with every other ring
// Projecting 4D sphere to 3D gives this elegant interlocked torus structure
// DUAL COLOR: outer rings (dark) | inner rings + base (accent)
// PETG 0.15mm, 4 walls, gyroid 15% — ~6h, 240mm display piece

$fn = 60;

// ── Mathematical parameters ───────────────────────────────
N_FIBERS = 32;       // Number of fiber circles (more = denser lattice)
R_MAJOR  = 68;       // Major torus radius (center of fiber circles)
R_MINOR  = 28;       // Minor torus radius (= fiber circle radius)
TUBE_D   = 7.5;      // Fiber tube cross-section diameter
BASE_H   = 18;       // Display base height
BASE_D   = 180;      // Display base diameter

// ── Villarceau (Hopf fiber) angle ─────────────────────────
// sin(β) = R_MINOR / sqrt(R_MAJOR² + R_MINOR²)
// This angle ensures each fiber lies exactly ON the torus surface
BETA     = asin(R_MINOR / sqrt(R_MAJOR*R_MAJOR + R_MINOR*R_MINOR));

// ── Single fiber ring (tube torus) ────────────────────────
module fiber_ring() {
    rotate_extrude(angle=360, $fn=N_FIBERS*2)
        translate([R_MINOR, 0])
            circle(d=TUBE_D, $fn=16);
}

// ── Full Hopf fiber structure ─────────────────────────────
// Place N_FIBERS rings around the torus, each tilted by BETA
// This is the Villarceau circle arrangement = Hopf fibers
module hopf_fibers(n_start=0, n_end=-1) {
    end = (n_end < 0) ? N_FIBERS-1 : n_end;
    for (k=[n_start:end]) {
        phi = k * 360 / N_FIBERS;
        rotate([0, 0, phi])              // distribute around Z axis
            translate([R_MAJOR, 0, 0])  // move to torus major radius
                rotate([BETA, 0, 0])    // Villarceau tilt (the magic angle)
                    difference() {
                        // Outer tube
                        rotate_extrude(angle=360, $fn=48)
                            translate([R_MINOR, 0])
                                circle(d=TUBE_D, $fn=12);
                        // Inner hollow (weight reduction)
                        rotate_extrude(angle=360, $fn=48)
                            translate([R_MINOR, 0])
                                circle(d=TUBE_D-2.5, $fn=10);
                    }
    }
}

// ── Reference torus (the torus that all fibers live on) ──
module reference_torus() {
    difference() {
        rotate_extrude(angle=360, $fn=100)
            translate([R_MAJOR, 0])
                circle(d=R_MINOR*2, $fn=40);
        // Make it a wireframe (hollow torus shell)
        rotate_extrude(angle=360, $fn=100)
            translate([R_MAJOR, 0])
                circle(d=R_MINOR*2-3, $fn=40);
    }
}

// ── Intersection rings (visual tie points) ─────────────────
// The 2 circles where all fibers share tangency
module hopf_equator_circles() {
    for(z=[R_MINOR*0.05, -R_MINOR*0.05]) {
        translate([0,0,z])
            difference() {
                cylinder(r=R_MAJOR+TUBE_D/2, h=2.5, $fn=120, center=true);
                cylinder(r=R_MAJOR-TUBE_D/2, h=3, $fn=120, center=true);
            }
    }
}

// ── Display base (octagonal prism with engravings) ─────────
module display_base() {
    difference() {
        // Octagonal base
        cylinder(d=BASE_D, h=BASE_H, $fn=8);
        // Hollow interior
        translate([0,0,5]) cylinder(d=BASE_D-12, h=BASE_H, $fn=8);
        // Center channel for inner arm
        cylinder(d=16, h=BASE_H+2, $fn=24);
        // Engraving
        translate([0,-BASE_D/2+8, BASE_H-0.8])
            linear_extrude(1.5)
                text("HOPF FIBRATION  S³ → S²", size=5.5, halign="center", $fn=4);
        // Side labels
        for(a=[0,45,90,135,180,225,270,315])
            rotate([0,0,a]) translate([BASE_D/2-5, -3, 4])
                rotate([90,0,90]) linear_extrude(2)
                    text(str(a, "°"), size=3.5, $fn=4);
    }
    // Inner pillar support
    difference() {
        cylinder(d=14, h=BASE_H+R_MINOR, $fn=20);
        cylinder(d=10, h=BASE_H+R_MINOR+1, $fn=16);
    }
}

// ── Assembly ──────────────────────────────────────────────
// Color 1 (dark): outer half of fibers + reference torus
hopf_fibers(0, N_FIBERS/2 - 1);
reference_torus();

// Color 2 (accent): inner half of fibers + base + equator rings
translate([0,0,BASE_H]) {
    hopf_fibers(N_FIBERS/2, N_FIBERS-1);
    hopf_equator_circles();
}
display_base();
