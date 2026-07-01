// Modular Marble Run — 6 Snap-Connect Track Sections
// Marble diameter: 16mm (standard glass marble)
// Clip system: dovetail snap on each end, connects at any angle
// PLA — 0.2mm, 4 walls, 20% infill — print flat, 0 supports

MARBLE_D  = 16.5;  // Marble diameter + clearance
TRACK_W   = MARBLE_D + 8;   // Track channel width
TRACK_H   = MARBLE_D * 0.6; // Track channel depth (open top)
WALL      = 3.5;
SECTION_H = 10;    // Track piece thickness
SNAP_W    = 12;
SNAP_H    = 6;
SNAP_LOCK = 1.5;   // Snap tooth depth
SLOPE     = 5;     // Ramp slope angle (degrees)

// ── Snap connector (dovetail) ──────────────────────────
// Female socket (subtract from end)
module snap_socket() {
    hull() {
        cube([SNAP_W, SNAP_H*1.4, WALL+1], center=true);
        translate([0,0,-SNAP_H*0.3]) cube([SNAP_W+SNAP_LOCK*2, SNAP_H, WALL+1], center=true);
    }
}

// Male plug (add to start)
module snap_plug() {
    difference() {
        hull() {
            cube([SNAP_W, SNAP_H, SECTION_H], center=true);
            translate([0,0,SNAP_H*0.35]) cube([SNAP_W+SNAP_LOCK*2, SNAP_H*1.4, SECTION_H], center=true);
        }
        // Flex slot (allows snap spring action)
        cube([1.5, SNAP_H*2, SECTION_H+2], center=true);
    }
}

// ── Track channel profile ──────────────────────────────
module track_channel(len) {
    difference() {
        translate([-TRACK_W/2-WALL, 0, 0])
            cube([TRACK_W+WALL*2, len, SECTION_H]);
        // Marble channel (U-shaped groove)
        translate([-TRACK_W/2, WALL, SECTION_H-TRACK_H])
            cube([TRACK_W, len-WALL*2, TRACK_H+1]);
        // Guide lips (keep marble centered)
        for (sx=[-1,1])
            translate([sx*(TRACK_W/2+WALL*0.3), WALL, SECTION_H*0.4])
                cube([WALL*0.6, len-WALL*2, SECTION_H*0.7]);
    }
}

// ── 1. STRAIGHT ramp (150mm, 5° slope) ───────────────
module straight_ramp() {
    L = 150;
    rotate([SLOPE, 0, 0])
        track_channel(L);
    // Snap plugs on each end
    translate([0, 0, SECTION_H/2])
        rotate([SLOPE,0,0]) {
            translate([0, -3, 0]) rotate([90,0,0]) snap_plug();
            translate([0, L+3, 0]) rotate([-90,0,0]) snap_plug();
        }
}

// ── 2. CURVE section (90° arc, R=60mm) ───────────────
module curve_section() {
    R = 60;
    difference() {
        // Outer arc
        rotate_extrude(angle=90, $fn=40)
            translate([R, 0])
                square([TRACK_W+WALL*2, SECTION_H]);
        // Inner arc (channel)
        rotate_extrude(angle=91, $fn=40)
            translate([R+WALL, SECTION_H-TRACK_H])
                square([TRACK_W, TRACK_H+1]);
    }
    // Snap connectors
    translate([R+TRACK_W/2+WALL, 0, SECTION_H/2])
        rotate([90,0,90]) snap_plug();
    translate([0, R+TRACK_W/2+WALL, SECTION_H/2])
        rotate([90,0,0]) snap_plug();
}

// ── 3. LOOP-THE-LOOP (full 360° vertical loop) ────────
module loop_track() {
    R = 40;
    LOOP_W = TRACK_W + WALL*2;
    difference() {
        rotate([90,0,0]) {
            difference() {
                rotate_extrude(angle=360, $fn=48)
                    translate([R, 0])
                        square([LOOP_W, SECTION_H]);
                // Inner channel
                rotate_extrude(angle=361, $fn=48)
                    translate([R+WALL, 2])
                        square([TRACK_W, SECTION_H-2]);
            }
        }
        // Bottom cutout (entry/exit)
        translate([-LOOP_W/2-1, -5, -SECTION_H])
            cube([LOOP_W+2, 15, SECTION_H+1]);
    }
    // Entry/exit straight pieces
    for (sy=[-1,1])
        translate([0, sy*(R+LOOP_W/2+8), -SECTION_H/2])
            rotate([0,0,0]) {
                translate([-TRACK_W/2-WALL, sy*(-5), -SECTION_H/2])
                    cube([TRACK_W+WALL*2, 20, SECTION_H]);
                translate([0, sy*(12), 0]) rotate([90,0,0]) snap_plug();
            }
}

// ── 4. FUNNEL / COLLECTOR (catches missed marbles) ────
module funnel_section() {
    FW = 100;  // Funnel opening width
    FD = 60;
    difference() {
        hull() {
            cube([FW, FD, 8], center=true);
            translate([0, -FD/2+TRACK_W/2+WALL, -SECTION_H/2])
                cube([TRACK_W+WALL*2, TRACK_W+WALL*2, SECTION_H], center=true);
        }
        // Funnel bore
        hull() {
            translate([0,0,1]) cube([FW-WALL*2, FD-WALL*2, 8], center=true);
            translate([0, -FD/2+TRACK_W/2+WALL, -SECTION_H/2+WALL])
                cube([TRACK_W, TRACK_W, SECTION_H], center=true);
        }
    }
    // Snap plug at funnel exit
    translate([0, -FD/2+TRACK_W/2+WALL+2, -SECTION_H])
        rotate([0,0,0]) snap_plug();
}

// ── 5. SPLITTER (1 marble → 2 paths, random) ──────────
module splitter_section() {
    L = 60;
    // Y-junction body
    difference() {
        hull() {
            cube([TRACK_W+WALL*2, WALL*2, SECTION_H]);
            translate([-(TRACK_W+WALL*2+5), L, 0])
                cube([TRACK_W+WALL*2, WALL*2, SECTION_H]);
            translate([5, L, 0])
                cube([TRACK_W+WALL*2, WALL*2, SECTION_H]);
        }
        // Channels (3 arms)
        for (dx=[0, -(TRACK_W+WALL*2+5), 5])
            translate([dx+WALL, WALL, SECTION_H-TRACK_H])
                cube([TRACK_W, L, TRACK_H+1]);
        // Diverter pivot hole
        translate([TRACK_W/2+WALL, L/3, SECTION_H+1])
            cylinder(d=4, h=5, $fn=12);
    }
    // Random diverter fin (pivots left/right on each marble impact)
    translate([TRACK_W/2+WALL, L/3, SECTION_H])
        cylinder(d=3, h=2.5, $fn=12);
}

// ── 6. EXIT CATCHER / tray ────────────────────────────
module exit_tray() {
    TW = 80;
    TD = 60;
    difference() {
        cube([TW, TD, 20]);
        translate([WALL, WALL, WALL])
            cube([TW-WALL*2, TD-WALL, 22]);
        // Entry notch (marble rolls in)
        translate([TW/2-TRACK_W/2, -1, 20-TRACK_H-2])
            cube([TRACK_W, WALL+2, TRACK_H+3]);
    }
    // Snap socket at entry
    translate([TW/2, 0, 20-TRACK_H/2-2])
        rotate([90,0,0]) snap_plug();
}

// ── DISPLAY LAYOUT (print each as separate file in practice) ──
// All 6 pieces shown spread out for visualization
straight_ramp();
translate([0, 200, 0]) curve_section();
translate([200, 0, 0]) loop_track();
translate([200, 200, 0]) funnel_section();
translate([0, 400, 0]) splitter_section();
translate([200, 400, 0]) exit_tray();
