// Dragon Dice Tower — Tabletop RPG Accessory
// Roll dice through the dragon's body; exit through the mouth
// DUAL COLOR: body (dark grey/black) | spines + flame (gold/orange)
// PLA — 0.2mm, 4 walls, 15% infill
// Dice: fits standard 16mm d6 through internals

TOWER_W   = 80;
TOWER_D   = 65;
TOWER_H   = 200;
WALL_T    = 4.5;
DICE_PASS = 22;    // Dice passage clearance (16mm d6 diag = ~22mm)
TRAY_W    = 100;
TRAY_D    = 80;
TRAY_H    = 18;

// ── Dice tray (catches dice) ──────────────────────────
module dice_tray() {
    difference() {
        cube([TRAY_W, TRAY_D, TRAY_H]);
        translate([WALL_T, WALL_T, WALL_T])
            cube([TRAY_W - WALL_T*2, TRAY_D - WALL_T*2, TRAY_H]);
        // Front opening (see dice roll)
        translate([-1, TRAY_D * 0.3, WALL_T])
            cube([WALL_T + 2, TRAY_D * 0.5, TRAY_H]);
    }
    // Non-slip bumps on tray floor
    for (x = [15:20:TRAY_W - 15], y = [15:20:TRAY_D - 15])
        translate([x, y, WALL_T])
            cylinder(d = 6, h = 1.5, $fn = 8);
}

// ── Tower body ────────────────────────────────────────
module tower_body() {
    difference() {
        union() {
            // Main rectangular shaft
            cube([TOWER_W, TOWER_D, TOWER_H]);
            // Head (top — dragon head shape)
            translate([TOWER_W/2, TOWER_D/2, TOWER_H])
                scale([1.2, 0.9, 0.7])
                    sphere(d = TOWER_W * 0.9, $fn = 32);
            // Neck taper
            translate([0, 0, TOWER_H - 30])
                cylinder(d1 = TOWER_W * 1.2, d2 = TOWER_W * 0.95, h = 30, $fn = 4);
        }
        // Dice channel (internal zigzag baffles)
        translate([TOWER_W/2 - DICE_PASS/2, TOWER_D/2 - DICE_PASS/2, -1])
            cube([DICE_PASS, DICE_PASS, TOWER_H + 5]);
        // Top input hole
        translate([TOWER_W/2, TOWER_D/2, TOWER_H + 5])
            cylinder(d = DICE_PASS + 6, h = 20, $fn = 20);
        // Hollow body (weight reduction)
        translate([WALL_T, WALL_T, WALL_T])
            cube([TOWER_W - WALL_T*2, TOWER_D - WALL_T*2, TOWER_H - 40]);
        // Mouth exit (front, at base)
        translate([-1, TOWER_D * 0.25, 15])
            cube([WALL_T + 2, TOWER_D * 0.5, DICE_PASS + 4]);
    }
}

// ── Zigzag baffles (inside tower — randomize dice) ────
module baffles() {
    N = 5;
    for (i = [0 : N - 1]) {
        z = 30 + i * (TOWER_H - 80) / N;
        side = (i % 2 == 0) ? 0 : 1;
        translate([side == 0 ? WALL_T : TOWER_W/2 + WALL_T,
                   WALL_T, z])
            cube([TOWER_W/2 - WALL_T, TOWER_D - WALL_T*2, 3.5]);
    }
}

// ── Dragon details (Color 2 — gold/orange) ────────────
module dragon_spines() {
    // Dorsal spines along top
    for (i = [0:6]) {
        z = TOWER_H * 0.3 + i * (TOWER_H * 0.5) / 6;
        h = 20 + sin(i * 40) * 10;
        translate([TOWER_W * 0.5, TOWER_D - 3, z])
            rotate([10, 0, 0])
                cylinder(d1 = 6, d2 = 0, h = h, $fn = 5);
    }
    // Horn pair on head
    for (sx = [-1, 1])
        translate([TOWER_W/2 + sx * 15, TOWER_D * 0.3, TOWER_H + 15])
            rotate([0, sx * 20, 0])
                cylinder(d1 = 8, d2 = 0, h = 35, $fn = 4);
    // Eyes
    for (sx = [-1, 1])
        translate([TOWER_W/2 + sx * 12, TOWER_D * 0.15, TOWER_H + 8])
            sphere(d = 10, $fn = 14);
    // Flame licks at exit
    for (i = [0:4]) {
        translate([-8 - i * 6, TOWER_D * 0.25 + i * 8, 15 + i * 4])
            rotate([0, 30 - i * 10, 0])
                cylinder(d1 = 8 - i, d2 = 0, h = 20 + i * 5, $fn = 6);
    }
    // Wing nubs (decorative)
    for (sx = [-1, 1])
        translate([TOWER_W/2 + sx * TOWER_W * 0.42, TOWER_D/2, TOWER_H * 0.65])
            rotate([0, sx * 70, 0])
                scale([1, 0.4, 1])
                    cylinder(d1 = 30, d2 = 0, h = 45, $fn = 5);
}

// Color 1 (dark): body + tray
translate([0, TOWER_D + 10, 0]) dice_tray();
tower_body();
baffles();
// Color 2 (gold): spines + flame + eyes
dragon_spines();
