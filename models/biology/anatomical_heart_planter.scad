// Anatomical Heart Planter — Succulent Pot / Vase
// Accurate cardiac anatomy: ventricles, aorta, pulmonary arteries
// DUAL COLOR: heart muscle (red PLA) | vessels (cream/white PLA)
// PLA — 0.2mm, 4 walls, 20% infill
// Plant small succulents in the open top (left ventricle)

SCALE    = 1.4;   // Scale factor (heart ≈ 100mm tall at 1.0)
WALL     = 3.5;
DRAIN_D  = 5.0;
// Base dimensions
H_W      = 75 * SCALE;   // Width
H_D      = 55 * SCALE;   // Depth (front-back)
H_H      = 80 * SCALE;   // Height

// ── Left ventricle body (dominant, larger cone) ────────
module left_ventricle() {
    hull() {
        // Apex (bottom point)
        translate([5 * SCALE, 0, 0])
            sphere(d = 12 * SCALE, $fn = 16);
        // Upper left (broad)
        translate([-15 * SCALE, 5 * SCALE, 55 * SCALE])
            sphere(d = 45 * SCALE, $fn = 24);
        translate([10 * SCALE, -5 * SCALE, 60 * SCALE])
            sphere(d = 38 * SCALE, $fn = 20);
    }
}

// ── Right ventricle (wraps around left, smaller) ───────
module right_ventricle() {
    hull() {
        translate([5 * SCALE, 0, 0])
            sphere(d = 10 * SCALE, $fn = 14);
        translate([20 * SCALE, 8 * SCALE, 45 * SCALE])
            sphere(d = 30 * SCALE, $fn = 18);
        translate([28 * SCALE, 2 * SCALE, 55 * SCALE])
            sphere(d = 22 * SCALE, $fn = 16);
    }
}

// ── Aortic arch (Color 2 — white/cream) ───────────────
module aorta() {
    // Ascending aorta
    translate([-8 * SCALE, 0, 62 * SCALE])
        rotate([5, 0, 0])
            cylinder(d = 14 * SCALE, h = 28 * SCALE, $fn = 16);
    // Aortic arch (curves over)
    rotate_extrude(angle = 180, $fn = 32)
        translate([12 * SCALE, 80 * SCALE, 0])
            circle(d = 12 * SCALE, $fn = 12);
    // Descending aorta stub
    translate([-8 * SCALE, 0, 90 * SCALE])
        rotate([10, 0, 0])
            cylinder(d = 12 * SCALE, h = 14 * SCALE, $fn = 14);
}

// ── Pulmonary artery ──────────────────────────────────
module pulmonary_artery() {
    // Main trunk
    translate([18 * SCALE, 0, 60 * SCALE])
        rotate([0, -15, 0])
            cylinder(d = 10 * SCALE, h = 20 * SCALE, $fn = 14);
    // Left branch
    translate([15 * SCALE, 0, 75 * SCALE])
        rotate([0, 40, 0])
            cylinder(d = 7 * SCALE, h = 15 * SCALE, $fn = 12);
    // Right branch
    translate([20 * SCALE, 0, 75 * SCALE])
        rotate([0, -20, 30])
            cylinder(d = 7 * SCALE, h = 12 * SCALE, $fn = 12);
}

// ── Superior vena cava ────────────────────────────────
module vena_cava() {
    translate([-20 * SCALE, 0, 65 * SCALE])
        rotate([5, 0, 0])
            cylinder(d = 9 * SCALE, h = 22 * SCALE, $fn = 12);
}

// ── Coronary arteries (surface detail) ────────────────
module coronary_arteries() {
    // Anterior interventricular artery (LAD)
    for (i = [0:8])
        translate([5 * SCALE + sin(i * 10) * 3,
                   0,
                   5 * SCALE + i * 7 * SCALE])
            sphere(d = 4 * SCALE * (1 - i * 0.06), $fn = 10);
    // Right coronary
    for (i = [0:6])
        translate([10 * SCALE + cos(i * 20) * 20 * SCALE,
                   sin(i * 20) * 8 * SCALE,
                   15 * SCALE + i * 6 * SCALE])
            sphere(d = 3.5 * SCALE, $fn = 10);
}

// ── Hollow planter body ───────────────────────────────
module heart_planter() {
    difference() {
        union() {
            left_ventricle();
            right_ventricle();
        }
        // Hollow interior (for soil)
        translate([0, 0, WALL * 1.5])
            scale([0.88, 0.88, 0.88]) {
                left_ventricle();
                right_ventricle();
            }
        // Drainage holes at apex
        translate([5 * SCALE, 0, -1])
            cylinder(d = DRAIN_D, h = 6, $fn = 12);
        for (a = [0, 120, 240])
            rotate([0, 0, a])
                translate([8 * SCALE, 0, -1])
                    cylinder(d = 3, h = 5, $fn = 10);
    }
    // Coronary arteries (surface detail)
    coronary_arteries();
}

// ── Flat base (stability) ─────────────────────────────
module heart_base() {
    intersection() {
        hull() {
            translate([-H_W/2, -H_D/2, 0]) cylinder(r = 5, h = 8, $fn = 8);
            translate([H_W/2, -H_D/2, 0]) cylinder(r = 5, h = 8, $fn = 8);
            translate([-H_W/2, H_D/2, 0]) cylinder(r = 5, h = 8, $fn = 8);
            translate([H_W/2, H_D/2, 0]) cylinder(r = 5, h = 8, $fn = 8);
        }
        translate([0, 0, -1]) heart_planter();
    }
}

// Color 1 (red PLA): heart body
heart_planter();
// Color 2 (white PLA): vessels
aorta();
pulmonary_artery();
vena_cava();
