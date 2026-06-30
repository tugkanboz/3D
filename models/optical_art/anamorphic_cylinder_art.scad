// Anamorphic Cylinder Art — Distorted Flat Image + Mirror Cylinder
// Place the mirror cylinder in center → reflected image corrects to a circle/face
// DUAL COLOR: base plate (dark) + raised art pixels (silver/bright)
// PLA — 0.2mm, 4 walls, 15% infill
// The cylinder is chrome/mirrored filament or polished aluminum tube

CYL_D    = 50;    // Mirror cylinder diameter
PLATE_W  = 180;   // Art plate dimensions
PLATE_D  = 180;
PLATE_T  = 4.0;
CYL_H    = 80;
CYL_WALL = 3.0;
PIX_H    = 1.8;   // Raised pixel height (visual relief)

// ── Mirror cylinder (Chrome PLA or silver) ───────────
module mirror_cylinder() {
    difference() {
        cylinder(d = CYL_D, h = CYL_H, $fn = 60);
        translate([0, 0, CYL_WALL])
            cylinder(d = CYL_D - CYL_WALL*2, h = CYL_H, $fn = 60);
    }
    // Cylinder base seat (snap into plate hole)
    cylinder(d = CYL_D + 2, h = 4, $fn = 60);
}

// ── Art plate (Color 1 — dark base) ──────────────────
module art_plate() {
    difference() {
        cube([PLATE_W, PLATE_D, PLATE_T]);
        // Cylinder seat hole
        translate([PLATE_W/2, PLATE_D/2, -1])
            cylinder(d = CYL_D + 0.4, h = 5, $fn = 60);
        // Hanging holes
        for (x = [20, PLATE_W - 20])
            translate([x, PLATE_D - 10, -1])
                cylinder(d = 5, h = PLATE_T + 2, $fn = 16);
    }
}

// ── Anamorphic star burst pattern (Color 2) ───────────
// True anamorphic distortion of a star: r_plate = sqrt(CYL_D/2 * r_image)
// This generates the radially-stretched concentric star
module anamorphic_star_pixels() {
    n_points = 8;
    rings    = 12;
    pix_size = 6;
    translate([PLATE_W/2, PLATE_D/2, PLATE_T]) {
        for (ring = [1 : rings]) {
            // Anamorphic radius: sqrt(mirror_r * image_r)
            r_image  = ring * 8;
            r_plate  = sqrt((CYL_D/2) * r_image);
            for (pt = [0 : n_points - 1]) {
                // Star shape: alternate wide/narrow points
                angle = pt * 360 / n_points;
                width_factor = (pt % 2 == 0) ? 1.0 : 0.4;
                arc_span = 360/n_points * width_factor;
                steps = max(3, floor(arc_span * r_plate / 30));
                for (s = [0 : steps - 1]) {
                    a = angle - arc_span/2 + s * arc_span/steps;
                    translate([r_plate * cos(a), r_plate * sin(a), 0])
                        cylinder(d = pix_size * (1 - ring/rings * 0.4),
                                 h = PIX_H * (1 - ring/rings * 0.3), $fn = 8);
                }
            }
        }
        // Center disc
        cylinder(d = 30, h = PIX_H * 1.5, $fn = 32);
    }
}

// Color 1: base plate
art_plate();
// Color 2: raised anamorphic pixels
anamorphic_star_pixels();
// Mirror cylinder (Chrome filament — print separately)
translate([PLATE_W + 20, PLATE_D/2, 0]) mirror_cylinder();
