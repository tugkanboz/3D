// Schwartz-P Minimal Surface Lamp Shade
// The Schwartz Primitive (P) surface satisfies: cos(x) + cos(y) + cos(z) = 0
// It's one of the triply periodic minimal surfaces (TPMS) — zero mean curvature everywhere
// Found in nature: butterfly wing scales, sea urchin spines, block copolymers
// This lamp shade approximates the P-surface's distinctive lattice topology
// as a cylindrical shell with mathematically-placed apertures
// DUAL COLOR: main shell (body) | inner rim + socket ring (accent)
// PETG 0.15mm, 4 walls, 0% infill (shell) — E27 socket, light passes through apertures
// For best effect: warm white LED inside, cream/white PETG shell

$fn = 48;

// ── Lamp dimensions ────────────────────────────────────────
D_TOP   = 80;     // E27 socket ring diameter
D_MID   = 165;    // Lamp mid-diameter
D_BOT   = 200;    // Lamp bottom diameter (flared)
HEIGHT  = 200;    // Total lamp height
WALL    = 3.2;    // Shell wall thickness
E27_D   = 42;     // E27 socket outer diameter (standard)
E27_H   = 30;     // E27 socket grip height

// ── Schwartz-P lattice parameters ─────────────────────────
// The P-surface in cylindrical projection gives diamond-shaped openings
// arranged in a face-centered cubic pattern when unrolled
CELL_H  = 28;     // Lattice cell height
N_CELLS = 10;     // Number of cells around circumference
APERTURE_SCALE = 0.62;  // Opening fraction (0=solid, 1=open)

// ── Conical shell profile ──────────────────────────────────
// Varying radius: tapers from D_BOT at bottom to D_TOP at top
function lamp_r(z) = D_BOT/2 + (D_TOP/2 - D_BOT/2) * (z/HEIGHT);
function lamp_r_outer(z) = lamp_r(z) + WALL;

// ── Schwartz-P aperture shape (per unit cell) ─────────────
// In the P-surface, each "window" is a saddle-shaped diamond
// Approximated as a rounded diamond (rotated square) in 2D
module p_aperture(w, h, rounding=0.35) {
    RD = min(w,h) * rounding;
    hull() {
        translate([0, h/2-RD]) circle(r=RD, $fn=16);
        translate([0, -h/2+RD]) circle(r=RD, $fn=16);
        translate([w/2-RD, 0]) circle(r=RD, $fn=16);
        translate([-w/2+RD, 0]) circle(r=RD, $fn=16);
    }
}

// ── Main shell with P-surface apertures ───────────────────
module lamp_shell() {
    // Generate shell as stacked ring sections with cut apertures
    STAGGER_ROWS = floor(HEIGHT / CELL_H);

    difference() {
        // Outer shell body (conical frustum)
        union() {
            // Conical frustum (outer) minus conical frustum (inner) = shell
            for(iz=[0:40]) {
                z = iz * HEIGHT/40;
                r_out = lamp_r_outer(z);
                r_in  = lamp_r(z);
                if(iz < 40)
                    translate([0,0,z])
                        linear_extrude(HEIGHT/40+0.1)
                            difference() {
                                circle(r=r_out, $fn=80);
                                circle(r=r_in,  $fn=80);
                            }
            }
            // Top socket ring (solid band for E27 attachment)
            translate([0,0,HEIGHT-E27_H-2])
                difference() {
                    cylinder(d=D_TOP+WALL*4, h=E27_H+2, $fn=60);
                    cylinder(d=E27_D-1, h=E27_H+4, $fn=30);
                }
            // Bottom rim (reinforced ring)
            difference() {
                cylinder(d=D_BOT+WALL*3, h=8, $fn=80);
                cylinder(d=D_BOT-4, h=9, $fn=80);
            }
        }

        // ── Cut the Schwartz-P apertures ──────────────────
        CELL_W_DEG = 360 / N_CELLS;
        AW = lamp_r(HEIGHT/2) * CELL_W_DEG * PI/180 * APERTURE_SCALE;  // aperture width mm
        AH = CELL_H * APERTURE_SCALE;

        for(row=[0:STAGGER_ROWS-1]) {
            z_center = row * CELL_H + CELL_H/2;
            stagger = (row % 2) * CELL_W_DEG/2;
            r_at_z = lamp_r(z_center);

            for(col=[0:N_CELLS-1]) {
                ang = col * CELL_W_DEG + stagger;
                translate([r_at_z*cos(ang), r_at_z*sin(ang), z_center])
                    rotate([0,0, ang])
                        rotate([90, 0, 0])
                            linear_extrude(r_at_z * CELL_W_DEG * PI/180 * 0.7, center=true)
                                p_aperture(AW, AH);
            }
        }

        // Exclude top and bottom solid zones from cuts
        translate([0,0,-1]) cylinder(d=D_BOT+WALL*4+2, h=10, $fn=80);  // protect bottom rim
        translate([0,0,HEIGHT-E27_H-4]) cylinder(d=D_TOP+WALL*5+2, h=E27_H+8, $fn=60);  // protect top
    }
}

// ── E27 socket grip ring (snap-in, locks bulb in) ─────────
module socket_ring() {
    difference() {
        cylinder(d=E27_D+6, h=E27_H+4, $fn=40);
        cylinder(d=E27_D-0.5, h=E27_H+6, $fn=30);
        // Grip slots (4× for tool-free tightening)
        for(a=[0,90,180,270]) rotate([0,0,a])
            translate([E27_D/2+1, -2.5, -1]) cube([4, 5, E27_H+6]);
    }
    // Retention lip (holds shade at correct height)
    translate([0,0,E27_H]) difference() {
        cylinder(d=E27_D+8, h=3, $fn=40);
        cylinder(d=E27_D-0.4, h=4, $fn=30);
    }
}

// ── Decorative bottom rim ring (accent color) ──────────────
module bottom_ring() {
    difference() {
        cylinder(d=D_BOT+WALL*3+2, h=10, $fn=80);
        cylinder(d=D_BOT-4, h=11, $fn=80);
        // Schwartz-P pattern etched on rim (decorative)
        for(i=[0:24])
            rotate([0,0, i*15]) translate([D_BOT/2+2, -3, 1])
                cube([6, 6, 8]);
    }
    // Label
    translate([0,0,4.5]) rotate([0,0,-90])
        linear_extrude(1.5)
            rotate([0,0,90]) {
                rotate_extrude(angle=180, $fn=80)
                    translate([D_BOT/2+WALL+2, 0]) square([1, 4]);
            }
}

// ── Assembly ──────────────────────────────────────────────
// Color 1 (PETG body): main lamp shell
lamp_shell();

// Color 2 (accent): socket ring + bottom rim ring
translate([0, 0, HEIGHT-E27_H-2]) socket_ring();
translate([D_BOT+WALL*3+20, 0, 0]) {
    bottom_ring();
    translate([0, 0, 15]) socket_ring();
}
