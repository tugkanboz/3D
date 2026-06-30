// Crank Automata — Walking Figure (Box Cam Mechanism)
// Turn the crank → figure walks via eccentric cam + connecting rods
// PLA — 0.2mm, 4 walls, 20% infill
// Hardware: 2x M4x40 bolts (axle), 2x M3x20 (leg pivots)
// DUAL COLOR: box + cam (dark PLA) + figure + rods (contrast)

BOX_W  = 90;
BOX_D  = 55;
BOX_H  = 70;
WALL   = 4.0;
AXLE_D = 4.5;    // M4 axle hole
CAM_D  = 36;
CAM_OFFSET = 10; // Eccentricity
CAM_T  = 12;
ROD_D  = 5.0;
CLEAR  = 0.45;
CRANK_L = 30;

// ── Box enclosure (Color 1) ───────────────────────────
module box() {
    difference() {
        cube([BOX_W, BOX_D, BOX_H]);
        // Hollow interior
        translate([WALL, WALL, WALL])
            cube([BOX_W - WALL*2, BOX_D - WALL*2, BOX_H]);
        // Axle holes (centered, sides)
        for (y = [-1, BOX_D + 1])
            translate([BOX_W/2, y, BOX_H * 0.45])
                rotate([90, 0, 0])
                    cylinder(d = AXLE_D, h = BOX_D + 2, $fn = 16);
        // Rod slot (top — figure exits here)
        translate([BOX_W/2 - 8, BOX_D/2 - 6, BOX_H - 0.1])
            cube([16, 12, WALL + 1]);
        // Front viewing window
        translate([WALL * 2, -0.1, WALL * 2])
            cube([BOX_W - WALL*4, WALL + 1, BOX_H - WALL*3]);
    }
}

// ── Eccentric cam (Color 2) ───────────────────────────
module cam() {
    difference() {
        union() {
            // Cam disk
            cylinder(d = CAM_D, h = CAM_T, $fn = 40);
            // Crank arm
            translate([CAM_D/2, 0, CAM_T/2])
                rotate([0, 90, 0])
                    cylinder(d = ROD_D + 2, h = CRANK_L, $fn = 16);
            // Crank handle knob
            translate([CAM_D/2 + CRANK_L, 0, CAM_T/2])
                sphere(d = ROD_D * 2.5, $fn = 16);
        }
        // Axle bore (offset = eccentricity)
        translate([CAM_OFFSET, 0, -1])
            cylinder(d = AXLE_D, h = CAM_T + 2, $fn = 16);
    }
}

// ── Connecting rod ────────────────────────────────────
module connecting_rod(length) {
    hull() {
        cylinder(d = ROD_D + 2, h = WALL - 1, $fn = 16);
        translate([length, 0, 0])
            cylinder(d = ROD_D + 2, h = WALL - 1, $fn = 16);
    }
    // Pin holes
    cylinder(d = ROD_D - CLEAR, h = WALL - 1, $fn = 16);
    translate([length, 0, 0])
        cylinder(d = ROD_D - CLEAR, h = WALL - 1, $fn = 16);
}

// ── Walking figure torso ──────────────────────────────
module figure() {
    // Head
    translate([0, 0, 50]) sphere(d = 14, $fn = 20);
    // Body
    translate([0, 0, 20]) cylinder(d1 = 16, d2 = 13, h = 28, $fn = 16);
    // Arms (spread for balance)
    for (sx = [-1, 1])
        translate([sx * 10, 0, 35]) rotate([0, 90 * sx, 20])
            cylinder(d = 5, h = 18, $fn = 10);
    // Legs (articulated via rods)
    for (sx = [-1, 1])
        translate([sx * 5, 0, 0]) {
            cylinder(d = 6, h = 20, $fn = 10);
            // Foot
            translate([0, sx * 3, 0])
                cube([8, 5, 6], center = true);
        }
    // Rod attachment boss (top of head)
    translate([0, 0, 57])
        cylinder(d = ROD_D - CLEAR, h = 10, $fn = 12);
}

// ── Print layout ─────────────────────────────────────
// Color 1
box();
// Color 2 (print separately, assembled with rods)
translate([BOX_W + 20, 0, 0]) {
    cam();
    translate([0, BOX_D + 10, 0]) connecting_rod(50);
    translate([0, BOX_D + 25, 0]) connecting_rod(40);
}
// Figure (Color 2)
translate([BOX_W + 90, 0, 60]) figure();
