// Voronoi Lamp Shade - Organic Cell Pattern
// Pair with E27 bulb socket insert (sold separately)
// Print: 0.2mm, 2 walls, 0% infill — wall IS the structure
// Best in transparent/translucent PETG for light diffusion

use <MCAD/math.scad>  // not needed — pure geometry below

D_TOP    = 120;
D_BOT    = 80;
HEIGHT   = 160;
WALL_T   = 2.2;
CELL_N   = 60;      // Number of voronoi cells
HOLE_D   = 40;      // Top opening for bulb heat
FLOOR_D  = 30;      // Bottom opening

// Seed points for cells (deterministic pseudo-random)
function cell_pts(n) = [for (i = [0:n-1])
    let(
        a = i * 137.508,          // golden angle
        r = sqrt(i / n) * 0.95
    )
    [r * cos(a), r * sin(a)]
];

// Approximate voronoi via subtraction of cylinders from shell
module voronoi_shell() {
    pts = cell_pts(CELL_N);
    difference() {
        // Outer frustum shell
        difference() {
            cylinder(d1 = D_BOT, d2 = D_TOP, h = HEIGHT, $fn = 128);
            translate([0, 0, WALL_T])
                cylinder(d1 = D_BOT - 2*WALL_T, d2 = D_TOP - 2*WALL_T,
                         h = HEIGHT, $fn = 128);
        }
        // Punch voronoi holes through shell
        for (i = [0:CELL_N-1]) {
            p = pts[i];
            // Map 2D cell point onto 3D surface at varying heights
            h_frac = (i % 7) / 7.0;
            r_at_h = (D_BOT + (D_TOP - D_BOT) * h_frac) / 2;
            ang = atan2(p[1], p[0]);
            cell_h = HEIGHT * (0.1 + h_frac * 0.8);
            cell_r = 8 + (i % 5) * 1.5;

            translate([0, 0, cell_h])
                rotate([0, 0, ang])
                    translate([r_at_h, 0, 0])
                        rotate([90, 0, 90])
                            cylinder(d = cell_r, h = WALL_T * 3,
                                     center = true, $fn = 6);
        }
        // Top opening for heat
        translate([0, 0, HEIGHT - 1])
            cylinder(d = HOLE_D, h = 10, $fn = 32);
        // Bottom opening
        cylinder(d = FLOOR_D, h = WALL_T * 2, $fn = 32);
    }
}

voronoi_shell();
