// Voronoi Skull — Organic Lattice Art Object / Planter
// Skull silhouette with Voronoi cell structure — light passes through
// PETG translucent or silk PLA — 0.15mm, 2 walls, 0% infill
// DUAL COLOR: skull lattice (dark) | eye glow rings (bright)
// ~140mm tall, fits P2S perfectly

SKULL_SCALE = 1.3;
WALL_T  = 2.5;
EYE_D   = 30;
CELL_R  = 8;       // Voronoi cell approximate radius
SEED_N  = 80;      // Number of Voronoi seed points

// ── Skull base form (approximate anatomy) ─────────────
module skull_form() {
    scale(SKULL_SCALE) {
        union() {
            // Cranium (large upper sphere)
            translate([0, 0, 55]) scale([1, 0.82, 1]) sphere(d = 100, $fn = 48);
            // Frontal bone (forehead)
            translate([0, -12, 85]) scale([0.8, 0.6, 0.5]) sphere(d = 80, $fn = 32);
            // Zygomatic (cheek bones)
            for (sx = [-1, 1])
                translate([sx * 40, 5, 40]) scale([0.5, 0.4, 0.6]) sphere(d = 50, $fn = 24);
            // Maxilla (upper jaw)
            translate([0, 15, 20]) scale([0.75, 0.5, 0.55]) sphere(d = 65, $fn = 28);
            // Mandible (lower jaw)
            translate([0, 20, 5]) scale([0.65, 0.45, 0.45]) sphere(d = 58, $fn = 24);
            // Nasal cavity bridge
            translate([0, -20, 45]) scale([0.3, 0.5, 0.5]) sphere(d = 40, $fn = 20);
        }
    }
}

// ── Voronoi approximation via sphere subtraction ───────
// True voronoi is complex in OpenSCAD; we use random sphere
// intersections to create organic cell-like openings
module voronoi_cells(scale_f) {
    // Pseudo-random seed points distributed across skull volume
    pts = [
        [0, -10, 90], [25, -5, 88], [-25, -5, 88],
        [0, 10, 95], [20, 15, 80], [-20, 15, 80],
        [35, 0, 70], [-35, 0, 70], [0, -20, 75],
        [15, -15, 70], [-15, -15, 70], [0, 5, 65],
        [30, 10, 60], [-30, 10, 60], [0, -10, 55],
        [20, 20, 55], [-20, 20, 55], [35, -5, 50],
        [-35, -5, 50], [10, -25, 50], [-10, -25, 50],
        [0, 25, 45], [25, 5, 42], [-25, 5, 42],
        [12, -18, 40], [-12, -18, 40], [0, 15, 35],
        [22, -8, 32], [-22, -8, 32], [0, -15, 28],
        [15, 18, 25], [-15, 18, 25], [0, 5, 18],
        [18, -5, 15], [-18, -5, 15], [0, 20, 12]
    ];

    for (p = pts) {
        translate(p * scale_f)
            sphere(r = CELL_R * scale_f * (0.75 + sin(p[0] * 13 + p[2] * 7) * 0.25),
                   $fn = 12);
    }
}

// ── Eye sockets ───────────────────────────────────────
module eye_sockets() {
    for (sx = [-1, 1])
        translate([sx * 28 * SKULL_SCALE, -18 * SKULL_SCALE, 55 * SKULL_SCALE])
            scale([1.2, 0.7, 0.9])
                sphere(d = EYE_D * SKULL_SCALE, $fn = 24);
    // Nasal aperture
    translate([0, -22 * SKULL_SCALE, 42 * SKULL_SCALE])
        scale([0.7, 0.5, 1])
            sphere(d = 22 * SKULL_SCALE, $fn = 20);
}

// ── Teeth ─────────────────────────────────────────────
module teeth() {
    for (i = [-3:3])
        translate([i * 7 * SKULL_SCALE, 18 * SKULL_SCALE, 8 * SKULL_SCALE]) {
            // Upper tooth
            cylinder(d = 5 * SKULL_SCALE, h = 12 * SKULL_SCALE, $fn = 8);
            // Lower tooth
            translate([0, 0, -10 * SKULL_SCALE])
                cylinder(d = 4.5 * SKULL_SCALE, h = 10 * SKULL_SCALE, $fn = 8);
        }
}

// ── Planter opening (top of cranium) ──────────────────
module planter_opening() {
    translate([0, -5 * SKULL_SCALE, 100 * SKULL_SCALE])
        sphere(d = 55 * SKULL_SCALE, $fn = 28);
}

// ── Main skull (Color 1) ──────────────────────────────
module voronoi_skull_body() {
    difference() {
        skull_form();
        // Voronoi cell openings
        scale(SKULL_SCALE) voronoi_cells(1);
        // Eye sockets
        eye_sockets();
        // Nasal
        translate([0, -22 * SKULL_SCALE, 42 * SKULL_SCALE])
            scale([0.7, 0.5, 1]) sphere(d = 22 * SKULL_SCALE, $fn = 20);
        // Planter top
        planter_opening();
        // Foramen magnum (base hole)
        translate([0, 5 * SKULL_SCALE, -2])
            cylinder(d = 30 * SKULL_SCALE, h = 15, $fn = 20);
    }
    teeth();
}

// ── Eye glow rings (Color 2 — bright) ────────────────
module eye_rings() {
    for (sx = [-1, 1])
        translate([sx * 28 * SKULL_SCALE, -18 * SKULL_SCALE, 55 * SKULL_SCALE])
            scale([1.2, 0.7, 0.9])
                difference() {
                    sphere(d = EYE_D * SKULL_SCALE + 3, $fn = 24);
                    sphere(d = EYE_D * SKULL_SCALE, $fn = 24);
                    translate([-50, -50, -50]) cube(100);  // keep front half only
                }
}

voronoi_skull_body();
eye_rings();
