// 3D Marble Maze Ball — Tilt to Navigate Inside a Sphere
// Marble rolls through internal 3D channels — multiple layers
// Split in half for printing; snap-fit assembly
// PLA — 0.2mm, 4 walls, 15% infill
// DUAL COLOR: outer shell (dark) | maze walls + start/finish (accent)
// Marble size: 16mm standard marble

SPHERE_R  = 65;    // Outer sphere radius
SHELL_T   = 4.0;   // Outer shell thickness
MARBLE_D  = 16.5;  // Marble OD + clearance
CHANNEL_D = 18.0;  // Channel inner diameter
WALL_T    = 3.5;   // Maze wall thickness
FLOORS    = 3;     // Number of maze levels
SNAP_D    = 4.0;   // Snap-fit peg diameter
N_SNAPS   = 6;     // Number of snap pegs at equator

// ── Outer shell (top half) ────────────────────────────
module shell_top() {
    difference() {
        sphere(r = SPHERE_R, $fn = 80);
        // Hollow interior
        sphere(r = SPHERE_R - SHELL_T, $fn = 80);
        // Cut at equator (bottom half removed)
        translate([-SPHERE_R - 1, -SPHERE_R - 1, -SPHERE_R - 1])
            cube([(SPHERE_R + 1) * 2, (SPHERE_R + 1) * 2, SPHERE_R + 1]);
        // Viewing windows (small, to see marble progress)
        for (a = [0, 90, 180, 270])
            rotate([0, 0, a]) rotate([45, 0, 0])
                cylinder(d = 15, h = SPHERE_R * 2, center = true, $fn = 16);
        // Top start hole
        translate([0, 0, SPHERE_R - SHELL_T - 0.5])
            cylinder(d = MARBLE_D + 2, h = SHELL_T + 1, $fn = 24);
    }
    // Snap-fit female slots (equator)
    for (i = [0 : N_SNAPS - 1])
        rotate([0, 0, i * 360/N_SNAPS])
            translate([SPHERE_R - SHELL_T, 0, 0])
                difference() {
                    cylinder(d = SNAP_D + 4, h = 6, $fn = 16);
                    cylinder(d = SNAP_D + 0.3, h = 7, $fn = 14);
                }
}

// ── Outer shell (bottom half) ─────────────────────────
module shell_bottom() {
    difference() {
        sphere(r = SPHERE_R, $fn = 80);
        sphere(r = SPHERE_R - SHELL_T, $fn = 80);
        // Keep only bottom half
        translate([-SPHERE_R - 1, -SPHERE_R - 1, 0])
            cube([(SPHERE_R + 1) * 2, (SPHERE_R + 1) * 2, SPHERE_R + 1]);
        // Bottom exit hole
        translate([0, 0, -SPHERE_R - 0.5])
            cylinder(d = MARBLE_D + 2, h = SHELL_T + 1, $fn = 24);
    }
    // Snap-fit male pegs
    for (i = [0 : N_SNAPS - 1])
        rotate([0, 0, i * 360/N_SNAPS + 360/N_SNAPS/2])
            translate([SPHERE_R - SHELL_T - 2, 0, 0])
                cylinder(d = SNAP_D, h = 8, $fn = 14);
}

// ── Internal maze levels ──────────────────────────────
module maze_level(level) {
    r = (SPHERE_R - SHELL_T - WALL_T) * (1 - level * 0.22);
    z = (level - 1) * (SPHERE_R * 0.3) - SPHERE_R * 0.15;
    ch_r = CHANNEL_D / 2;

    translate([0, 0, z]) {
        // Disk platform at this level
        difference() {
            intersection() {
                cylinder(r = r, h = WALL_T, $fn = 48);
                sphere(r = SPHERE_R - SHELL_T - 1, $fn = 48);
            }
            // Maze channels cut through disk
            // Straight channels
            for (a = [0, 60, 120, 180, 240, 300]) {
                rotate([0, 0, a + level * 30])
                    translate([-r, -ch_r, -1])
                        cube([r * (0.4 + 0.2 * (level % 2)), ch_r * 2, WALL_T + 2]);
            }
            // Curved channel (spiral)
            rotate_extrude(angle = 200 + level * 40, $fn = 60)
                translate([r * 0.55, 0, 0])
                    square([ch_r * 2, WALL_T + 2], center = true);
            // Drop hole (to next level)
            translate([r * 0.7 * cos(level * 137.5),
                       r * 0.7 * sin(level * 137.5), -1])
                cylinder(d = CHANNEL_D, h = WALL_T + 2, $fn = 20);
        }
        // Funnel at drop hole
        translate([r * 0.7 * cos(level * 137.5),
                   r * 0.7 * sin(level * 137.5), -8])
            cylinder(d1 = CHANNEL_D * 2, d2 = CHANNEL_D, h = 8, $fn = 20);
    }
}

// ── Start funnel (at top) ────────────────────────────
module start_funnel() {
    translate([0, 0, SPHERE_R - SHELL_T - 25])
        cylinder(d1 = MARBLE_D + 2, d2 = CHANNEL_D * 2, h = 20, $fn = 24);
}

// ── Finish detector bump ──────────────────────────────
module finish_cup() {
    translate([0, 0, -SPHERE_R + SHELL_T + 2])
        difference() {
            cylinder(d = 30, h = 10, $fn = 24);
            cylinder(d = MARBLE_D + 0.5, h = 11, $fn = 20);
        }
}

// Layout: top and bottom halves side-by-side for printing
shell_top();
translate([SPHERE_R * 2 + 20, 0, 0])
    rotate([180, 0, 0])
        shell_bottom();
// Maze internals (Color 2 — print as second filament pause)
for (lv = [1 : FLOORS])
    maze_level(lv);
start_funnel();
finish_cup();
