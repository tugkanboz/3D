// Compliant Mechanism Gripper — Single-Print Flex Actuator
// Squeeze the handle → fingers close. No assembly, no hardware.
// PETG or flexible PLA — 0.15mm, 2 walls, 10% infill
// The flexure joints are integral — monolithic part
// DUAL COLOR: rigid body (dark) | flexure zones (bright/translucent)

GRIP_W    = 30;   // Grip width
GRIP_H    = 80;   // Handle length
BODY_T    = 6.0;  // Rigid section thickness
FLEX_T    = 1.4;  // Flexure leaf thickness (key: thin = more flex)
FLEX_W    = 3.0;  // Flexure leaf width
FLEX_GAP  = 0.8;  // Gap between flexure notches
ARM_L     = 70;   // Finger arm length
ARM_W     = 10;
FINGER_T  = 5.0;
JAW_W     = 8;    // Jaw opening at rest
N_FLEX    = 3;    // Flexures per hinge joint

// ── Flexure hinge (living hinge zone) ─────────────────
module flexure_hinge(width, depth, n = N_FLEX) {
    // Series of parallel thin leaves → allow bending, resist axial load
    for (i = [0 : n - 1]) {
        translate([0, i * (FLEX_W + FLEX_GAP), 0])
            cube([FLEX_T, FLEX_W, depth]);
    }
}

// ── Rigid arm section ─────────────────────────────────
module rigid_arm(length, w, t) {
    difference() {
        cube([length, w, t]);
        // Lightening slot
        translate([5, 2, 1])
            cube([length - 10, w - 4, t - 2]);
    }
}

// ── Finger (one half) ─────────────────────────────────
module finger(side) {
    // side = 1 or -1 (left/right)
    reflect_y = (side > 0) ? 1 : -1;

    translate([0, side * (GRIP_W/2 + 2), 0]) {
        // Upper rigid section (above pivot)
        rigid_arm(ARM_L * 0.6, ARM_W, FINGER_T);

        // Flexure pivot 1 (at arm root)
        translate([ARM_L * 0.6, (ARM_W - (N_FLEX*(FLEX_W+FLEX_GAP)-FLEX_GAP))/2, 0])
            flexure_hinge(1, FINGER_T);

        // Lower rigid section
        translate([ARM_L * 0.6 + FLEX_T, 0, 0])
            rigid_arm(ARM_L * 0.4, ARM_W, FINGER_T);

        // Jaw pad (rubber-tip contact surface boss)
        translate([ARM_L, ARM_W/2, 0]) {
            difference() {
                cylinder(d = 14, h = FINGER_T, $fn = 20);
                // Grip pattern
                for (a = [0:30:150])
                    rotate([0, 0, a])
                        cube([16, 1.5, FINGER_T + 1], center = true);
            }
        }
    }
}

// ── Handle ────────────────────────────────────────────
module handle() {
    difference() {
        union() {
            // Main grip body
            hull() {
                cube([BODY_T, GRIP_W, GRIP_H]);
                translate([0, GRIP_W/2, GRIP_H])
                    cylinder(d = GRIP_W, h = 4, $fn = 24);
            }
            // Thumb rest bumps
            for (z = [GRIP_H * 0.3, GRIP_H * 0.55, GRIP_H * 0.75])
                translate([-3, GRIP_W/2, z])
                    sphere(d = 10, $fn = 16);
        }
        // Trigger slot (squeeze gap)
        translate([BODY_T/2, GRIP_W * 0.2, -1])
            cube([1.5, GRIP_W * 0.6, GRIP_H + 2]);
        // Finger hole at base
        translate([-1, GRIP_W/2, GRIP_H * 0.15])
            rotate([0, 90, 0])
                cylinder(d = 18, h = BODY_T + 2, $fn = 24);
    }
}

// ── Main flexure body (connects handle to fingers) ────
module flexure_body() {
    difference() {
        cube([ARM_L * 0.15, GRIP_W + ARM_W * 2 + 4, FINGER_T]);
        // Symmetric flexure cuts (force coupling)
        for (y = [ARM_W * 0.3, GRIP_W + ARM_W * 1.7])
            translate([-0.5, y, -1])
                cube([ARM_L * 0.15 + 1, FLEX_T, FINGER_T + 2]);
    }
}

// ── Assembly ─────────────────────────────────────────
// Color 1 (rigid PETG dark): handle + arms
handle();
translate([BODY_T + 2, 0, 0]) {
    flexure_body();
    // Fingers
    for (s = [1, -1])
        translate([ARM_L * 0.15, GRIP_W/2, 0])
            finger(s);
}
