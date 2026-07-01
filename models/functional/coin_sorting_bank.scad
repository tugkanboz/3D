// Mechanical Coin Sorting Bank — Gravity Ramp Sorter
// Coins roll down angled ramps, sorted by diameter into 5 tubes
// Works with EUR/USD coins — fully parametric diameters
// PLA/PETG — 0.2mm, 4 walls, 20% infill — no supports needed
// DUAL COLOR: body/ramps (dark) | coin tubes + labels (accent)

// Coin diameters (EUR standard, change for USD/GBP)
// EUR:  1c=16.25  2c=18.75  5c=21.25  10c=19.75  20c=22.25  50c=24.25  1€=23.25  2€=25.75
// USD:  penny=19  nickel=21.2  dime=17.9  quarter=24.26

COINS = [
    [16.5,  "1c",  "#C0392B"],  // 1 cent (smallest)
    [19.0,  "5c",  "#E67E22"],
    [21.5,  "10c", "#F1C40F"],
    [23.5,  "50c", "#27AE60"],
    [26.0,  "2€",  "#2980B9"],  // 2 euro (largest)
];

COIN_T    = 3.0;    // Coin thickness (sorter gap)
WALL      = 3.5;
RAMP_ANGLE = 12;    // Ramp incline degrees
TUBE_H    = 90;     // Collection tube height
TUBE_GAP  = 4;      // Gap between tubes
BODY_H    = 140;    // Total sorter body height
BODY_D    = 30;     // Sorter body depth (front-back)

N_COINS   = len(COINS);
// Total width of sorter
TOTAL_W   = sum([for (i=[0:N_COINS-1]) COINS[i][0] + COIN_T*2 + TUBE_GAP]) + WALL*2;

function sum(v, i=0, r=0) = i >= len(v) ? r : sum(v, i+1, r+v[i]);

// X position of each coin slot center
function slot_x(n) = WALL + sum([for (i=[0:n-1]) COINS[i][0] + COIN_T*2 + TUBE_GAP]) + COINS[n][0]/2 + COIN_T;

// ── Sorting ramp cascade ──────────────────────────────
module sorter_body() {
    difference() {
        cube([TOTAL_W, BODY_D, BODY_H]);
        // Main coin entry channel (wide slot at top)
        translate([WALL, -1, BODY_H-25])
            cube([TOTAL_W-WALL*2, BODY_D+2, 28]);
        // Cascading ramp pockets (one per coin size)
        for (i=[0:N_COINS-1]) {
            slot_w = COINS[i][0] + COIN_T*2;
            cx = slot_x(i);
            ramp_y = BODY_H - 30 - i*22;
            // Coin slot (only coins ≤ this size pass through)
            translate([cx - COINS[i][0]/2 - 0.25, -1, ramp_y])
                cube([COINS[i][0] + 0.5, BODY_D*0.6, COIN_T+0.5]);
            // Ramp deflector pocket
            translate([WALL, BODY_D*0.4, ramp_y - 18])
                rotate([RAMP_ANGLE, 0, 0])
                    cube([TOTAL_W-WALL*2, 2, 35]);
        }
        // Collection tube bores
        for (i=[0:N_COINS-1]) {
            cx = slot_x(i);
            translate([cx, BODY_D/2, -1])
                cylinder(d=COINS[i][0]+1, h=TUBE_H+2, $fn=32);
        }
        // Front access door cutout (to retrieve coins)
        translate([WALL*2, -1, 5])
            cube([TOTAL_W-WALL*4, WALL+2, TUBE_H-10]);
    }

    // Ramp deflectors (angled guides between each slot)
    for (i=[0:N_COINS-2]) {
        ramp_y = BODY_H - 30 - i*22;
        cx_right = slot_x(i+1);
        translate([slot_x(i)+COINS[i][0]/2+1, BODY_D*0.15, ramp_y-15])
            rotate([0, 0, 0])
                hull() {
                    cube([cx_right-slot_x(i)-COINS[i][0]/2-2, BODY_D*0.7, 2]);
                    translate([0, BODY_D*0.1, -12])
                        cube([cx_right-slot_x(i)-COINS[i][0]/2-2, BODY_D*0.5, 2]);
                }
    }
}

// ── Collection tubes (Color 2 — accent) ──────────────
module collection_tubes() {
    for (i=[0:N_COINS-1]) {
        cx = slot_x(i);
        translate([cx, BODY_D/2, 0]) {
            // Tube wall
            difference() {
                cylinder(d=COINS[i][0]+WALL*2+1, h=TUBE_H, $fn=32);
                cylinder(d=COINS[i][0]+1, h=TUBE_H+1, $fn=32);
            }
            // Label platform (raised top ring)
            translate([0, 0, TUBE_H-5])
                difference() {
                    cylinder(d=COINS[i][0]+WALL*2+3, h=5, $fn=32);
                    cylinder(d=COINS[i][0]+1, h=6, $fn=32);
                }
            // Denomination label
            translate([0, 0, TUBE_H+1])
                linear_extrude(2)
                    text(COINS[i][1], size=min(6, COINS[i][0]*0.35),
                         halign="center", valign="center", $fn=4);
        }
    }
}

// ── Base platform ─────────────────────────────────────
module base_platform() {
    difference() {
        hull() {
            cube([TOTAL_W, BODY_D, 6]);
            translate([3, 3, 6]) cube([TOTAL_W-6, BODY_D-6, 2]);
        }
        // Coin exit windows (front face slot per tube)
        for (i=[0:N_COINS-1]) {
            cx = slot_x(i);
            translate([cx-COINS[i][0]/2-1, -1, 1])
                cube([COINS[i][0]+2, WALL+2, 5]);
        }
    }
}

// ── Top funnel (guides coins to ramp) ────────────────
module top_funnel() {
    translate([0, 0, BODY_H]) {
        difference() {
            hull() {
                translate([-5, -5, 0]) cube([TOTAL_W+10, BODY_D+10, 2]);
                translate([WALL, WALL*0.5, 20]) cube([TOTAL_W-WALL*2, BODY_D-WALL, 2]);
            }
            // Funnel opening
            translate([WALL, WALL*0.5, -1])
                cube([TOTAL_W-WALL*2, BODY_D-WALL, 24]);
        }
    }
}

// Color 1 (dark body): sorter + base + funnel
base_platform();
translate([0, 0, 6]) sorter_body();
top_funnel();
// Color 2 (accent tubes): collection tubes
translate([0, 0, 6]) collection_tubes();
