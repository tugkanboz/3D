// Cable Clip Set - Desk / Monitor Edge Mount
// PETG — flexible enough to snap on, strong enough to hold
// 0.2mm, 4 walls, 25% infill
// Prints 6 clips per plate — sell as sets

CLIP_TYPE  = "edge";  // "edge" = monitor/desk rim, "flat" = adhesive base

// Cable specs
CABLE_D    = 6;    // Cable diameter (USB-C ≈ 4mm, HDMI ≈ 10mm)
CLIP_PLAY  = 0.6;  // Snap-fit opening extra — PLA needs 0.8, PETG 0.5

// Edge-mount specs
EDGE_T     = 22;   // Desk/monitor edge thickness
EDGE_DEPTH = 18;
WALL_T     = 2.5;

module cable_channel() {
    cylinder(d = CABLE_D + CLIP_PLAY, h = 100, center = true, $fn = 20);
}

module snap_clip_body() {
    union() {
        // Cable cradle
        difference() {
            cylinder(d = CABLE_D + WALL_T*2 + CLIP_PLAY, h = 14, $fn = 32);
            cable_channel();
            // Snap opening (top 120°)
            translate([0, 0, 7])
                rotate([0, 0, -60])
                    linear_extrude(14)
                        polygon([[0,0],
                                 [(CABLE_D+WALL_T*3)*cos(-60), (CABLE_D+WALL_T*3)*sin(-60)],
                                 [(CABLE_D+WALL_T*3)*cos(60),  (CABLE_D+WALL_T*3)*sin(60)]]);
        }
        // Snap fingers
        for (s = [-1, 1])
            rotate([0, 0, s * 30])
                translate([CABLE_D/2 + CLIP_PLAY/2, 0, 7])
                    rotate([0, -15*s, 0])
                        cube([WALL_T * 0.8, 4, 8], center = true);
    }
}

module edge_mount_arm() {
    // Wraps over desk/monitor edge
    difference() {
        union() {
            // Front arm
            cube([CABLE_D + WALL_T*2 + CLIP_PLAY, WALL_T*2, EDGE_DEPTH + 14]);
            // Top bridge
            translate([0, 0, EDGE_DEPTH + 14 - WALL_T])
                cube([CABLE_D + WALL_T*2 + CLIP_PLAY, EDGE_T + WALL_T*4, WALL_T]);
            // Back arm
            translate([0, EDGE_T + WALL_T*2, 0])
                cube([CABLE_D + WALL_T*2 + CLIP_PLAY, WALL_T*2, EDGE_DEPTH * 0.6]);
        }
        // Grip pad slots (for foam tape)
        translate([2, EDGE_T + WALL_T*2 + 0.5, 4])
            cube([CABLE_D + WALL_T*2 + CLIP_PLAY - 4, 2, EDGE_DEPTH * 0.5]);
    }
}

module flat_adhesive_base() {
    cube([CABLE_D + WALL_T*2 + CLIP_PLAY, 28, WALL_T * 1.5]);
}

// Build plate — 6 clips in a row
for (i = [0 : 5]) {
    translate([i * (CABLE_D + WALL_T*2 + CLIP_PLAY + 8), 0, 0]) {
        if (CLIP_TYPE == "edge") {
            edge_mount_arm();
            translate([0, 0, 14]) snap_clip_body();
        } else {
            flat_adhesive_base();
            translate([0, 14, WALL_T * 1.5]) snap_clip_body();
        }
    }
}
