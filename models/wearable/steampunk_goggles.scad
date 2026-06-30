// Steampunk Goggles — Wearable Prop / Costume Accessory
// Full goggle frames with lens holders, rivets, gear details
// DUAL COLOR: main frame (bronze/copper PLA) | gear details (dark PLA)
// PLA — 0.15mm, 4 walls, 20% infill
// Hardware: 2x 50mm acrylic circles (lens), 1x elastic band (30mm wide)

LENS_D    = 52;    // Lens outer diameter
LENS_T    = 3.0;   // Lens recess depth
FRAME_W   = 12;    // Frame ring width
FRAME_T   = 6.0;   // Frame ring thickness
BRIDGE_L  = 24;    // Nose bridge length
BRIDGE_W  = 10;
EYE_DIST  = LENS_D + BRIDGE_L; // Center-to-center distance
RIVET_D   = 5.0;   // Decorative rivet diameter
BAND_W    = 32;    // Head band strap width
BAND_SLOT = 3.5;   // Strap slot thickness

// ── Gear decoration ───────────────────────────────────
module small_gear(teeth, r, t) {
    tooth_h = r * 0.15;
    tooth_w = (2 * PI * r / teeth) * 0.5;
    difference() {
        union() {
            cylinder(r = r, h = t, $fn = max(teeth * 3, 32));
            for (i = [0 : teeth - 1])
                rotate([0, 0, i * 360/teeth])
                    translate([r - 0.5, -tooth_w/2, 0])
                        cube([tooth_h + 0.5, tooth_w, t]);
        }
        cylinder(d = r * 0.6, h = t + 1, $fn = 16);
        for (i = [0:2])
            rotate([0, 0, i * 120])
                translate([r * 0.35, 0, -1])
                    cylinder(d = r * 0.2, h = t + 2, $fn = 12);
    }
}

// ── Rivet (decorative) ────────────────────────────────
module rivet() {
    cylinder(d = RIVET_D, h = 2.5, $fn = 16);
    translate([0, 0, 2.5]) sphere(d = RIVET_D, $fn = 14);
}

// ── Single goggle ring ────────────────────────────────
module goggle_ring() {
    difference() {
        union() {
            // Outer ring
            cylinder(d = LENS_D + FRAME_W * 2, h = FRAME_T, $fn = 48);
            // Inner lens retainer rim
            translate([0, 0, FRAME_T])
                cylinder(d = LENS_D + 4, h = LENS_T, $fn = 40);
        }
        // Lens pocket
        translate([0, 0, FRAME_T - LENS_T + 0.5])
            cylinder(d = LENS_D + 0.5, h = LENS_T + 1, $fn = 40);
        // Inner clear opening
        translate([0, 0, -1])
            cylinder(d = LENS_D - 4, h = FRAME_T + LENS_T + 2, $fn = 40);
        // Knurled outer rim
        for (i = [0:35])
            rotate([0, 0, i * 10])
                translate([LENS_D/2 + FRAME_W + 0.5, -0.8, -1])
                    cube([2, 1.6, FRAME_T + 2]);
    }
    // Decorative rivets (6 around ring)
    for (i = [0:5])
        rotate([0, 0, i * 60 + 30])
            translate([LENS_D/2 + FRAME_W * 0.6, 0, FRAME_T])
                rivet();
    // Strap lug (side)
    translate([LENS_D/2 + FRAME_W, 0, 0]) {
        difference() {
            cube([14, BAND_W + 4, FRAME_T]);
            translate([3, 2, -1])
                cube([14, BAND_W, FRAME_T + 2]);
            translate([8, BAND_W/2 + 2, -1])
                cylinder(d = BAND_SLOT, h = FRAME_T + 2, $fn = 12);
        }
    }
}

// ── Nose bridge ───────────────────────────────────────
module nose_bridge() {
    difference() {
        hull() {
            translate([0, 0, FRAME_T/2]) rotate([90, 0, 0])
                cylinder(d = BRIDGE_W + 4, h = BRIDGE_L, center = true, $fn = 20);
        }
        // Hollow
        hull() {
            translate([0, 0, FRAME_T/2]) rotate([90, 0, 0])
                cylinder(d = BRIDGE_W, h = BRIDGE_L + 1, center = true, $fn = 16);
        }
    }
    // Bridge rivet
    translate([0, 0, FRAME_T]) rivet();
}

// ── Gear decorations (Color 2 — dark) ─────────────────
module gear_cluster() {
    // Large top gear
    translate([0, LENS_D/2 + FRAME_W * 0.7, FRAME_T])
        small_gear(12, 8, 3);
    // Medium side gear
    translate([0, LENS_D/2 + FRAME_W * 0.7 + 15, FRAME_T])
        small_gear(8, 5, 3);
    // Small accent gear
    translate([0, LENS_D/2 + FRAME_W * 0.7 + 24, FRAME_T])
        small_gear(6, 3.5, 2.5);
}

// ── Assembly ──────────────────────────────────────────
// Left ring
translate([-EYE_DIST/2, 0, 0]) {
    goggle_ring();
    gear_cluster();
}
// Right ring (mirrored gears)
translate([EYE_DIST/2, 0, 0]) {
    goggle_ring();
    mirror([0, 1, 0]) gear_cluster();
}
// Nose bridge
translate([0, -LENS_D/2 - FRAME_W - BRIDGE_L * 0.1, 0])
    rotate([0, 0, 90])
        nose_bridge();

// ── Band attachment tabs (print separately) ────────────
translate([EYE_DIST * 0.8, LENS_D/2 + FRAME_W + 10, 0]) {
    difference() {
        cube([BAND_W + 8, 20, FRAME_T]);
        translate([4, 4, -1])
            cube([BAND_W, 15, FRAME_T + 2]);
        translate([BAND_W/2 + 4, 12, -1])
            cylinder(d = BAND_SLOT, h = FRAME_T + 2, $fn = 12);
    }
}
