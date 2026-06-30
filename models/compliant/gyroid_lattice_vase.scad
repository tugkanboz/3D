// Gyroid TPMS Lattice Vase — Triply Periodic Minimal Surface
// The gyroid is its own infill pattern — this prints as a shell of gyroid
// PETG translucent — 0.15mm, 1 wall, 0% infill (IS the surface)
// Mathematical beauty: no self-intersections, equal surface area distribution
// 150mm tall, fits P2S perfectly

HEIGHT   = 150;
BASE_D   = 80;
TOP_D    = 55;
PERIOD   = 18;    // Gyroid unit cell size (smaller = finer lattice)
ISO      = 0.0;   // Isosurface level (-1.0 to 1.0 shifts wall thickness)
WALL_T   = 2.2;   // Shell wall thickness
STEPS_X  = 20;    // Resolution (increase for smoother surface, longer render)
STEPS_Y  = 20;
STEPS_Z  = 40;

// Gyroid implicit surface: sin(x)cos(y) + sin(y)cos(z) + sin(z)cos(x) = 0
// We approximate by marching through voxels and using hull() between boundary voxels

function gyroid_val(x, y, z) =
    sin(x * 360 / PERIOD) * cos(y * 360 / PERIOD) +
    sin(y * 360 / PERIOD) * cos(z * 360 / PERIOD) +
    sin(z * 360 / PERIOD) * cos(x * 360 / PERIOD);

// Vase profile radius at height fraction t
function vase_r(t) =
    (BASE_D/2) + (TOP_D/2 - BASE_D/2) * t
    + 8 * sin(t * 180);  // Gentle bulge

module gyroid_vase() {
    // For each vertical slice, generate a ring of gyroid cells
    for (zi = [0 : STEPS_Z - 1]) {
        z0 = zi * HEIGHT / STEPS_Z;
        z1 = (zi + 1) * HEIGHT / STEPS_Z;
        t = zi / STEPS_Z;
        R = vase_r(t);

        // Sample gyroid on a cylindrical shell at this radius
        for (ai = [0 : STEPS_X - 1]) {
            for (ri_off = [-1, 0, 1]) {
                a0  = ai * 360 / STEPS_X;
                a1  = (ai + 1) * 360 / STEPS_X;
                r_s = R + ri_off * PERIOD / 4;

                x0 = r_s * cos(a0);
                y0 = r_s * sin(a0);
                x1 = r_s * cos(a1);
                y1 = r_s * sin(a1);

                // Sample gyroid at midpoint
                gv = gyroid_val((x0+x1)/2, (y0+y1)/2, (z0+z1)/2);

                // Only place material near the isosurface
                if (abs(gv - ISO) < 0.55) {
                    hull() {
                        translate([x0, y0, z0])
                            sphere(d = WALL_T, $fn = 8);
                        translate([x1, y1, z0])
                            sphere(d = WALL_T, $fn = 8);
                        translate([x0, y0, z1])
                            sphere(d = WALL_T, $fn = 8);
                        translate([x1, y1, z1])
                            sphere(d = WALL_T, $fn = 8);
                    }
                }
            }
        }
    }
}

module solid_base() {
    difference() {
        cylinder(d = BASE_D, h = 8, $fn = 60);
        translate([0, 0, 3])
            cylinder(d = BASE_D - 6, h = 6, $fn = 60);
    }
}

module top_rim() {
    translate([0, 0, HEIGHT - 4])
        difference() {
            cylinder(d = vase_r(1.0) * 2 + 6, h = 4, $fn = 48);
            cylinder(d = vase_r(1.0) * 2, h = 5, $fn = 48);
        }
}

solid_base();
gyroid_vase();
top_rim();
