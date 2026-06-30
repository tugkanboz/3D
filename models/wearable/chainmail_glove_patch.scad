// Print-in-Place Chainmail Patch — Flexible Wearable
// 4-in-2 European chainmail weave — each ring linked to 4 others
// PLA or PETG — 0.15mm, 2 walls, 0% infill
// Print flat on bed — peels off already linked and flexible
// Size: 80x80mm patch (can tile for larger pieces)

RING_OD  = 8.0;   // Outer diameter of ring
RING_ID  = 5.0;   // Inner diameter (determines link gap)
RING_T   = 1.4;   // Ring wire thickness
CLEAR    = 0.3;   // Print-in-place clearance between rings
ROWS     = 8;
COLS     = 10;
FLAT_H   = RING_T + CLEAR;  // Print height of lying ring

// Ring offsets for 4-in-2 pattern
DX = RING_OD * 0.9;   // Horizontal pitch
DY = RING_OD * 0.5;   // Vertical pitch (interlocking offset)

// ── Single torus ring (lying flat) ────────────────────
module ring() {
    linear_extrude(FLAT_H)
        difference() {
            circle(d = RING_OD, $fn = 32);
            circle(d = RING_ID, $fn = 32);
        }
}

// ── Horizontal ring (lies rotated 90° — links vertical) ─
module ring_h() {
    rotate([90, 0, 0])
        rotate([0, 0, 90])
            ring();
}

// ── 4-in-2 European chainmail grid ───────────────────
module chainmail(rows, cols) {
    for (row = [0 : rows - 1]) {
        for (col = [0 : cols - 1]) {
            // Flat (horizontal) rings
            translate([col * DX, row * DY * 2, 0])
                ring();
            // Vertical connector rings (between flat rings)
            translate([col * DX + DX/2,
                       row * DY * 2 + DY,
                       RING_T/2 + CLEAR])
                ring_h();
        }
        // Offset second row
        for (col = [0 : cols - 2])
            translate([col * DX + DX/2, row * DY * 2 + DY*2, 0])
                ring();
    }
}

chainmail(ROWS, COLS);
