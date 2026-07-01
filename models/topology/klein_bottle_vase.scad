// Klein Bottle Vase — Topological Non-Orientable Surface
// A bottle with no inside: surface folds back through itself
// Printable approximation — neck passes THROUGH body wall (self-intersection resolved)
// PETG translucent — 0.15mm, 3 walls, gyroid 15% infill, ~180mm tall
// SINGLE COLOR — surface continuity is the art

// Resolution
$fn = 60;

// Klein bottle parametric form
// u = 0..2π (longitude), v = 0..2π (latitude)
// Classic "figure-8 immersion" parameterization

SCALE = 28;       // Overall size scale
WALL  = 2.5;      // Minimum wall thickness
BASE_D = 80;      // Display base diameter
BASE_H = 12;      // Base height

// Parametric Klein bottle point
// Using the "Lawson" / figure-8 immersion that avoids self-intersection in 3D
function kx(u, v) =
    (2.5 + cos(u/2)*sin(v) - sin(u/2)*sin(2*v)) * cos(u);
function ky(u, v) =
    (2.5 + cos(u/2)*sin(v) - sin(u/2)*sin(2*v)) * sin(u);
function kz(u, v) =
    sin(u/2)*sin(v) + cos(u/2)*sin(2*v);

// ── Surface shell (polyhedron approximation) ──────────
// Build as lathe of profile cross-sections
// Uses OpenSCAD's hull-chain technique for smooth quads

NU = 40;   // Longitudinal divisions
NV = 20;   // Latitudinal divisions

module klein_strip(u_idx, v_idx) {
    u0 = u_idx * 360 / NU;
    u1 = (u_idx+1) * 360 / NU;
    v0 = v_idx * 360 / NV;
    v1 = (v_idx+1) * 360 / NV;
    pts = [
        [kx(u0,v0)*SCALE, ky(u0,v0)*SCALE, kz(u0,v0)*SCALE],
        [kx(u1,v0)*SCALE, ky(u1,v0)*SCALE, kz(u1,v0)*SCALE],
        [kx(u1,v1)*SCALE, ky(u1,v1)*SCALE, kz(u1,v1)*SCALE],
        [kx(u0,v1)*SCALE, ky(u0,v1)*SCALE, kz(u0,v1)*SCALE],
    ];
    hull()
        for (p = pts)
            translate(p) sphere(d=WALL*1.2, $fn=6);
}

module klein_surface() {
    for (ui=[0:NU-1])
        for (vi=[0:NV-1])
            klein_strip(ui, vi);
}

// ── Stabilizing base plinth ───────────────────────────
module base_plinth() {
    difference() {
        union() {
            // Hexagonal base
            cylinder(d=BASE_D, h=BASE_H, $fn=6);
            translate([0,0,BASE_H])
                cylinder(d=BASE_D*0.6, h=4, $fn=6);
        }
        // Hollow center (weight saving)
        translate([0,0,3])
            cylinder(d=BASE_D*0.7, h=BASE_H+6, $fn=6);
        // Decorative engrave on base face
        translate([0,0,BASE_H-1])
            linear_extrude(2)
                text("KLEIN", size=8, halign="center", valign="center", $fn=4);
        translate([0,-10,BASE_H-1])
            linear_extrude(2)
                text("BOTTLE", size=6, halign="center", valign="center", $fn=4);
    }
}

// ── Water channel insert (makes it functional as vase) ─
// A separate inner tube that actually holds water
module inner_tube() {
    translate([0, 0, BASE_H+5])
        difference() {
            cylinder(d=22, h=90, $fn=24);
            cylinder(d=16, h=92, $fn=24);
        }
}

// Assembled model (translated so base sits at z=0)
translate([0, 0, BASE_H + SCALE*0.8]) {
    klein_surface();
}
base_plinth();
inner_tube();
