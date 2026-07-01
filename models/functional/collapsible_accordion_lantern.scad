// Collapsible Accordion Lantern — Print-in-Place Folding Light
// Prints as one piece: when folded flat = 30mm tall, extended = 120mm tall
// Bellows accordion walls with living hinge flex (PLA 0.15mm, 2 walls for flex)
// Top and bottom rings rigid; side walls flex like a paper accordion
// Use with LED tea light or battery candle (no open flame — PETG version safer)
// DUAL COLOR: top/bottom plates + handle ring (body) | bellows walls (accent PETG)
// Accordion design: 5 folds of 24mm each = 120mm extended, ~30mm collapsed
// The hexagonal geometry gives elegant look + structural stability when extended

$fn = 6;   // Hexagonal for aesthetics (change to $fn=60 for round version)

// ── Lantern dimensions ─────────────────────────────────────
D_OUTER  = 100;    // Lantern outer diameter (hex flat-to-flat)
D_INNER  = 90;     // Inner diameter (light passes through)
FOLD_H   = 22;     // Height of each accordion fold section
N_FOLDS  = 5;      // Number of accordion folds
FOLD_T   = 1.2;    // Bellows wall thickness (thin = more flexible in PETG)
GAP      = 0.5;    // Print-in-place clearance at fold joints
PLATE_T  = 6;      // Top/bottom plate thickness
PLATE_D  = D_OUTER + 12;  // Plate diameter (slightly larger)
HANDLE_D = 28;     // Candle/LED insert diameter
TOTAL_H  = N_FOLDS * FOLD_H + PLATE_T * 2;  // Extended height

// ── Helper: hexagonal ring at given height range ──────────
module hex_ring(d, h, t) {
    difference() {
        cylinder(d=d, h=h, $fn=6);
        cylinder(d=d-t*2, h=h+1, $fn=6);
    }
}

// ── Accordion fold section (one V-fold) ───────────────────
// Each fold = outer ring → angled wall → inner ridge → angled wall → outer ring
// The fold "breathes" by angling the walls — like a bellows or accordion
module accordion_fold(z, invert=false) {
    H = FOLD_H;
    R_OUT = D_OUTER/2;
    R_IN  = D_INNER/2;
    FOLD_GAP = GAP;

    // Outer ring at bottom of fold
    translate([0,0,z])
        hex_ring(D_OUTER, FOLD_T, FOLD_T);

    // Tapered wall: outer → inward ridge (first half-fold)
    translate([0,0,z+FOLD_T])
        difference() {
            cylinder(d1=D_OUTER, d2=D_INNER, h=H/2, $fn=6);
            cylinder(d1=D_OUTER-FOLD_T*2, d2=D_INNER-FOLD_T*2, h=H/2+1, $fn=6);
        }

    // Inner ridge (the fold apex)
    translate([0,0,z+H/2])
        hex_ring(D_INNER, FOLD_T, FOLD_T);

    // Tapered wall: inward → outer (second half-fold)
    translate([0,0,z+H/2+FOLD_T])
        difference() {
            cylinder(d1=D_INNER, d2=D_OUTER, h=H/2-FOLD_T, $fn=6);
            cylinder(d1=D_INNER-FOLD_T*2, d2=D_OUTER-FOLD_T*2, h=H/2-FOLD_T+1, $fn=6);
        }
}

// ── Top plate (rigid, holds lantern handle + hook) ────────
module top_plate() {
    difference() {
        union() {
            // Main plate
            cylinder(d=PLATE_D, h=PLATE_T, $fn=6);
            // Hook arm
            translate([0, PLATE_D/2-4, PLATE_T])
                cylinder(d=10, h=20, $fn=16);
            // Hook (J-shape)
            translate([0, PLATE_D/2-4, PLATE_T+20])
                rotate([0, 90, 0]) cylinder(d=10, h=16, $fn=12);
            translate([8, PLATE_D/2-4, PLATE_T+20])
                cylinder(d=10, h=8, $fn=12);
        }
        // Candle insert hole
        cylinder(d=HANDLE_D, h=PLATE_T+2, $fn=20);
        // Weight relief holes
        for(i=[0:5]) rotate([0,0,i*60+30]) translate([D_OUTER/3, 0, -1])
            cylinder(d=14, h=PLATE_T+2, $fn=12);
        // Vent holes (heat safety)
        for(i=[0:11]) rotate([0,0,i*30]) translate([PLATE_D/3.5, 0, -1])
            cylinder(d=5, h=PLATE_T+2, $fn=10);
        // Label
        translate([-22, -4, PLATE_T-1.2])
            linear_extrude(1.5) text("LANTERN", size=7, $fn=4);
        // Collapsed height reference
        translate([-18, -12, PLATE_T-1.2])
            linear_extrude(1.5) text(str(N_FOLDS,"× FOLD"), size=5, $fn=4);
    }
}

// ── Bottom plate (base, candle sits on this) ───────────────
module bottom_plate() {
    difference() {
        union() {
            cylinder(d=PLATE_D, h=PLATE_T, $fn=6);
            // Non-slip pad ring
            difference() {
                cylinder(d=PLATE_D+2, h=2, $fn=6);
                cylinder(d=PLATE_D-4, h=3, $fn=6);
            }
        }
        // Candle well (tea light sits here)
        cylinder(d=HANDLE_D+0.5, h=PLATE_T-1.5, $fn=20);
        // Ventilation holes (ring)
        for(i=[0:11]) rotate([0,0,i*30]) translate([PLATE_D/3.5, 0, -1])
            cylinder(d=5, h=PLATE_T+2, $fn=10);
        // Center vent
        cylinder(d=10, h=PLATE_T+2, $fn=16);
        // Dimension label
        translate([-28, -4, 1.2]) linear_extrude(1.5)
            text(str("Ø", D_OUTER, "mm COLLAPSED:", N_FOLDS*4+PLATE_T*2, "mm"), size=4, $fn=4);
    }
    // Grip feet (3× rubber pad pockets)
    for(i=[0:2]) rotate([0,0,i*120]) translate([PLATE_D*0.34, 0, -1])
        cylinder(d=12, h=2.5, $fn=12);
}

// ── Connecting ring (joins plates to bellows) ──────────────
module connector_ring(d_outer, d_inner, h) {
    difference() {
        cylinder(d=d_outer, h=h, $fn=6);
        cylinder(d=d_inner, h=h+1, $fn=6);
        // Vent slots
        for(i=[0:5]) rotate([0,0,i*60+30]) translate([d_outer/3, -3, -1])
            cube([6, 6, h+2]);
    }
}

// ── Full lantern assembly ──────────────────────────────────
// Color 1 (body): top plate + bottom plate + connector rings
top_plate();  // top
translate([0,0,-PLATE_T]) bottom_plate();  // bottom (mirror → attach at z=0)

// Connector rings (bond accordion to plates)
translate([0,0,0])
    connector_ring(D_OUTER+0.5, D_OUTER-6, FOLD_T*2);
translate([0,0,TOTAL_H-PLATE_T-FOLD_T*2])
    connector_ring(D_OUTER+0.5, D_OUTER-6, FOLD_T*2);

// Color 2 (accent PETG): accordion bellows
for(i=[0:N_FOLDS-1]) accordion_fold(i*FOLD_H);

// ── Separate print layout ──────────────────────────────────
// Print lantern vertically — the natural print direction
// The accordion walls print thin for flexibility
// Assembly: none needed — springs from bed as one piece!
// Test collapse: gently push top down toward bottom after printing

// Print instructions plate
translate([PLATE_D+20, 0, 0]) {
    difference() {
        cube([120, 70, 3]);
        translate([4,56,2]) linear_extrude(1.5) text("ACCORDION LANTERN", size=7, $fn=4);
        translate([4,46,2]) linear_extrude(1.5) text(str("Extended: ",TOTAL_H,"mm"), size=5, $fn=4);
        translate([4,36,2]) linear_extrude(1.5) text(str("Collapsed: ~",N_FOLDS*4+16,"mm"), size=5, $fn=4);
        translate([4,26,2]) linear_extrude(1.5) text("PETG walls = flex", size=5, $fn=4);
        translate([4,16,2]) linear_extrude(1.5) text("2 walls, 0% infill", size=5, $fn=4);
        translate([4,6,2]) linear_extrude(1.5) text("LED candle only, no flame", size=4.5, $fn=4);
    }
}
