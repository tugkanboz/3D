// Cryptex Password Lock Cylinder — Da Vinci-Style Secret Box
// 5 rotating letter rings, correct combo releases inner tube
// DUAL COLOR: outer cylinder + rings (dark) | inner tube + letters (brass/gold PLA)
// PLA — 0.2mm, 4 walls, 20% infill
// Hardware: 1x M4x60 center rod (optional — friction fit works too)

RINGS       = 5;
LETTERS     = 26;     // Positions per ring
RING_OD     = 55;
RING_ID     = 46;
RING_H      = 14;
RING_GAP    = 0.6;    // Between rings
INNER_OD    = 44;
INNER_ID    = 36;
INNER_H     = RINGS * (RING_H + RING_GAP) + 20;
CAP_H       = 22;
PIN_D       = 3.0;    // Locking pin diameter
PIN_SLOT_W  = 3.2;    // Slot in ring for pin to pass when aligned
LETTER_H    = 1.5;    // Embossed letter height
LETTER_SIZE = 6.0;

// ── Inner tube (Color 2 — brass) ──────────────────────
module inner_tube() {
    difference() {
        cylinder(d = INNER_OD, h = INNER_H, $fn = 48);
        // Hollow core (storage space)
        translate([0, 0, CAP_H])
            cylinder(d = INNER_ID, h = INNER_H, $fn = 40);
        // Locking pin slots (5 pins, one per ring position)
        for (i = [0 : RINGS - 1]) {
            z = CAP_H + 5 + i * (RING_H + RING_GAP) + RING_H/2;
            // Pin slot: only opens at combo position (angle 0)
            translate([INNER_OD/2 - 2, -PIN_SLOT_W/2, z - PIN_D/2])
                cube([4, PIN_SLOT_W, PIN_D]);
        }
    }
    // Bottom cap (sealed)
    cylinder(d = INNER_OD + 2, h = CAP_H * 0.4, $fn = 48);
    // Top cap shoulder
    translate([0, 0, INNER_H - 8])
        cylinder(d = INNER_OD + 2, h = 8, $fn = 48);
}

// ── Letter ring ──────────────────────────────────────
module letter_ring(ring_idx) {
    alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    ang_step = 360 / LETTERS;

    difference() {
        union() {
            // Ring body
            cylinder(d = RING_OD, h = RING_H, $fn = 60);
            // Raised letter band
            for (i = [0 : LETTERS - 1])
                rotate([0, 0, i * ang_step])
                    translate([RING_OD/2 - 0.5, 0, RING_H/2])
                        rotate([90, 0, 90])
                            linear_extrude(LETTER_H + 0.5)
                                text(str(alphabet[i]), size = LETTER_SIZE,
                                     halign = "center", valign = "center", $fn = 4);
        }
        // Inner bore (fits over inner tube with clearance)
        cylinder(d = INNER_OD + 0.5, h = RING_H + 1, $fn = 48);
        // Locking pin hole in ring wall (at 0° = unlocked position)
        translate([INNER_OD/2 + 0.2, 0, RING_H/2])
            rotate([0, 90, 0])
                cylinder(d = PIN_D + 0.1, h = (RING_OD - INNER_OD)/2 + 1, $fn = 14);
        // Grip knurling (outer surface)
        for (i = [0 : 23])
            rotate([0, 0, i * 15])
                translate([RING_OD/2 - 1, -0.8, -1])
                    cube([2, 1.6, RING_H + 2]);
    }
    // Locking pin (press-fit into ring wall, protrudes inward)
    translate([INNER_OD/2 + 1, 0, RING_H/2])
        rotate([0, 90, 0])
            cylinder(d = PIN_D - 0.1, h = 6, $fn = 14);
}

// ── Outer guard cylinder (prevents seeing alignment) ──
module outer_guard() {
    difference() {
        cylinder(d = RING_OD + 8, h = RINGS * (RING_H + RING_GAP) + 16, $fn = 60);
        // Window to see letters (narrow slit)
        translate([RING_OD/2 + 1, -3, 5])
            cube([10, 6, RINGS * (RING_H + RING_GAP) + 6]);
        // Inner clearance for rings
        translate([0, 0, 8])
            cylinder(d = RING_OD + 0.5, h = RINGS * (RING_H + RING_GAP) + 1, $fn = 60);
        // Top/bottom openings
        cylinder(d = INNER_OD + 1, h = 20, $fn = 40);
        translate([0, 0, RINGS * (RING_H + RING_GAP) + 8])
            cylinder(d = INNER_OD + 1, h = 20, $fn = 40);
    }
}

// ── Print layout ──────────────────────────────────────
// Color 2 (brass): inner tube
inner_tube();
// Color 1 (dark): outer guard
translate([RING_OD + 20, 0, 0]) outer_guard();
// Rings (Color 1, print each flat)
for (i = [0 : RINGS - 1])
    translate([i * (RING_OD + 5), RING_OD + 20, 0])
        letter_ring(i);
