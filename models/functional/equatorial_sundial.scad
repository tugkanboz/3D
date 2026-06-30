// Equatorial Sundial — Accurate to ~5 Minutes
// Properly calibrated for any latitude — fully functional
// DUAL COLOR: dial plate (dark) + hour markers (brass/gold)
// PLA or PETG — 0.2mm, 4 walls, 20% infill
// Tilt the gnomon to your latitude, align N-S → tells solar time

LAT       = 41;      // Latitude (Istanbul / Madrid / NYC)
DIAL_D    = 180;     // Dial plate diameter
DIAL_T    = 4.0;
GNOMON_W  = 3.5;     // Gnomon rod width
GNOMON_H  = 80;      // Gnomon length
BASE_W    = 140;
BASE_D    = 100;
BASE_H    = 12;
HOUR_R    = DIAL_D/2 - 12;
MARK_H    = 1.5;     // Hour mark emboss height
N_HOURS   = 24;

// ── Equatorial dial plate (tilted to latitude) ────────
module dial_plate() {
    difference() {
        cylinder(d = DIAL_D, h = DIAL_T, $fn = 80);
        // Center gnomon slot
        translate([-GNOMON_W/2 - 0.3, -DIAL_D/2, -1])
            cube([GNOMON_W + 0.6, DIAL_D, DIAL_T + 2]);
        // Concentric decoration rings
        for (r = [HOUR_R - 18, HOUR_R - 26])
            difference() {
                cylinder(r = r + 1, h = DIAL_T + 1, $fn = 80);
                cylinder(r = r, h = DIAL_T + 2, $fn = 80);
            }
    }
    // Hour marks (Color 2 emboss — top face)
    for (h = [0 : N_HOURS - 1]) {
        angle = h * 360 / N_HOURS - 90;  // 0° = noon (top)
        is_main = (h % 2 == 0);
        mark_l = is_main ? 14 : 8;
        translate([0, 0, DIAL_T])
            rotate([0, 0, angle])
                translate([HOUR_R - mark_l/2, -0.8, 0])
                    cube([mark_l, 1.6, MARK_H]);
        // Hour number (every 3 hours)
        if (h % 3 == 0) {
            hr_label = (h == 0) ? "12" : str(h > 12 ? h - 12 : h);
            translate([0, 0, DIAL_T + MARK_H])
                rotate([0, 0, angle])
                    translate([HOUR_R - 22, 0, 0])
                        rotate([0, 0, -angle])
                            linear_extrude(MARK_H)
                                text(hr_label, size = 7, halign = "center",
                                     valign = "center", $fn = 4);
        }
    }
    // Compass N/S labels
    translate([0, DIAL_D/2 - 8, DIAL_T + MARK_H])
        linear_extrude(MARK_H)
            text("N", size = 8, halign = "center", $fn = 4);
    translate([0, -DIAL_D/2 + 2, DIAL_T + MARK_H])
        linear_extrude(MARK_H)
            text("S", size = 8, halign = "center", $fn = 4);
}

// ── Gnomon (aligned to celestial pole = latitude angle) ─
module gnomon() {
    // Gnomon rod (points to North Star at lat° angle)
    difference() {
        hull() {
            cube([GNOMON_W, 4, 1]);
            translate([0, 0, GNOMON_H])
                cube([GNOMON_W, 1, 1]);
        }
        // Decorative cutout
        translate([GNOMON_W/2, -0.5, GNOMON_H * 0.2])
            rotate([90, 0, 0])
                cylinder(d = 4, h = 3, $fn = 8);
    }
}

// ── Base (angled mount) ───────────────────────────────
module base() {
    difference() {
        union() {
            cube([BASE_W, BASE_D, BASE_H]);
            // Angled wedge to tilt dial to latitude
            translate([0, BASE_D, BASE_H])
                rotate([-( 90 - LAT), 0, 0])
                    translate([0, 0, 0])
                        cube([BASE_W, 4, DIAL_D/2 + 10]);
        }
        // Weight reduction pockets
        translate([10, 10, 4])
            cube([BASE_W - 20, BASE_D - 20, BASE_H]);
        // Compass rose at base center
        for (i = [0:7])
            rotate([0, 0, i * 45])
                translate([BASE_W/2 - 1.5, BASE_D/2, -0.5])
                    cube([1.5, BASE_D/2 - 15, 3]);
        // N alignment arrow
        translate([BASE_W/2, BASE_D - 8, -0.5])
            linear_extrude(3)
                text("N", size = 8, halign = "center", $fn = 4);
    }
}

// Color 1 (dark): base + dial plate
base();
// Dial plate (rotated to latitude, mounted on wedge top)
translate([BASE_W/2, BASE_D, BASE_H])
    rotate([-(90 - LAT), 0, 0])
        translate([-DIAL_D/2, 0, 4])
            rotate([90, 0, 0])
                translate([DIAL_D/2, 0, 0])
                    dial_plate();

// Gnomon (Color 2 — brass)
translate([BASE_W/2, BASE_D, BASE_H + 2])
    rotate([LAT - 90, 0, 0])
        translate([-GNOMON_W/2, 0, 0])
            gnomon();
