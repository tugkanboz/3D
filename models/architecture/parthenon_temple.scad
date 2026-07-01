// Parthenon — Ancient Greek Temple Display Model
// 1:200 scale approximation, accurate column ratio 8×17
// Doric order: fluted columns, entablature, triangular pediment
// DUAL COLOR: columns + steps (marble white) | frieze + pediment relief (ochre)
// PLA — 0.15mm, 4 walls, 15% infill — ~240mm long

// Scale: 1mm = 200mm real → Parthenon 69.5m → 347mm; scaled to 240mm
SCALE     = 0.65;
STEP_H    = 4.5;
N_STEPS   = 3;
STEP_IN   = 5.0;   // Each step inset
COL_D     = 8.0;   // Column base diameter
COL_H     = 68;    // Column height
COL_TAPER = 0.85;  // Column top diameter ratio (entasis taper)
FLUTES    = 20;    // Column flutes
N_FRONT   = 8;     // Front columns (Parthenon: 8)
N_SIDE    = 17;    // Side columns (Parthenon: 17)
ENTAB_H   = 14;    // Entablature height
PED_H     = 22;    // Pediment height
WALL      = 3.0;

// Template dimensions
STYLOBATE_W = N_FRONT * (COL_D * 1.6) + COL_D;
STYLOBATE_L = N_SIDE  * (COL_D * 1.6) + COL_D;
STYLOBATE_H = 5;

// ── Stepped platform (krepidoma) ──────────────────────
module steps() {
    for (i=[0:N_STEPS-1]) {
        expand = (N_STEPS-i) * STEP_IN;
        translate([-expand, -expand, i*STEP_H])
            cube([STYLOBATE_W+expand*2, STYLOBATE_L+expand*2, STEP_H]);
    }
}

// ── Doric column (with fluting) ───────────────────────
module column() {
    difference() {
        // Main shaft (tapered)
        cylinder(d1=COL_D, d2=COL_D*COL_TAPER, h=COL_H, $fn=20);
        // Flutes (vertical grooves)
        for (i=[0:FLUTES-1])
            rotate([0,0,i*360/FLUTES])
                translate([COL_D*0.42, 0, 0])
                    cylinder(d=COL_D*0.18, h=COL_H+1, $fn=8);
    }
    // Echinus (curved capital top)
    translate([0,0,COL_H])
        cylinder(d1=COL_D*COL_TAPER, d2=COL_D*1.15, h=2.5, $fn=20);
    // Abacus (flat square slab)
    translate([-COL_D*0.65, -COL_D*0.65, COL_H+2.5])
        cube([COL_D*1.3, COL_D*1.3, 2.5]);
}

// ── Column peristyle ──────────────────────────────────
COL_SPACING_W = STYLOBATE_W / (N_FRONT-1);
COL_SPACING_L = STYLOBATE_L / (N_SIDE-1);

module peristyle() {
    // Front + back rows
    for (i=[0:N_FRONT-1]) {
        translate([i*COL_SPACING_W, 0, 0]) column();
        translate([i*COL_SPACING_W, STYLOBATE_L, 0]) column();
    }
    // Side rows (excluding corners already placed)
    for (j=[1:N_SIDE-2]) {
        translate([0, j*COL_SPACING_L, 0]) column();
        translate([STYLOBATE_W, j*COL_SPACING_L, 0]) column();
    }
}

// ── Entablature (beam above columns) ─────────────────
module entablature() {
    translate([0, 0, COL_H+STYLOBATE_H]) {
        // Architrave (plain band)
        cube([STYLOBATE_W, STYLOBATE_L, ENTAB_H*0.35]);
        // Frieze (decorated band — raised triglyphs)
        translate([-2, -2, ENTAB_H*0.35])
            difference() {
                cube([STYLOBATE_W+4, STYLOBATE_L+4, ENTAB_H*0.45]);
                // Metope recesses (between triglyphs)
                for (i=[0:N_FRONT])
                    translate([i*COL_SPACING_W-COL_SPACING_W/3, -1, 1])
                        cube([COL_SPACING_W*0.55, ENTAB_H*0.5, ENTAB_H*0.5]);
            }
        // Triglyphs (raised vertical bars on frieze)
        for (i=[0:N_FRONT-1])
            for (sy=[0,1]) {
                translate([i*COL_SPACING_W+COL_SPACING_W*0.35-2, sy*(STYLOBATE_L+3)-2, ENTAB_H*0.35])
                    for (rx=[0,1,2])
                        translate([rx*2.5, 0, 0])
                            cube([1.8, 4, ENTAB_H*0.5]);
            }
        // Cornice (top ledge)
        translate([-4, -4, ENTAB_H*0.8])
            cube([STYLOBATE_W+8, STYLOBATE_L+8, ENTAB_H*0.2]);
    }
}

// ── Pediment (triangular gable ends) ─────────────────
module pediment() {
    base_z = COL_H + STYLOBATE_H + ENTAB_H;
    // Front pediment
    translate([0, 0, base_z])
        hull() {
            cube([STYLOBATE_W+8, 6, 2]);
            translate([STYLOBATE_W/2+4, 3, PED_H]) cylinder(d=4, h=2, $fn=4);
        }
    // Rear pediment
    translate([0, STYLOBATE_L-6, base_z])
        hull() {
            cube([STYLOBATE_W+8, 6, 2]);
            translate([STYLOBATE_W/2+4, 3, PED_H]) cylinder(d=4, h=2, $fn=4);
        }
    // Roof (shallow triangular slab)
    translate([0, 6, base_z+PED_H-1])
        hull() {
            cube([STYLOBATE_W+8, STYLOBATE_L-12, 2]);
            translate([4, -3, 2]) cube([STYLOBATE_W, STYLOBATE_L-6, 1]);
        }
    // Pediment relief scene (abstract wave suggests Elgin marbles)
    for (i=[0:4])
        translate([STYLOBATE_W*0.15+i*STYLOBATE_W*0.15, 1, base_z+5])
            scale([1, 0.4, 1.2])
                sphere(d=12, $fn=10);
}

// ── Display base ──────────────────────────────────────
module display_base() {
    total_w = STYLOBATE_W + N_STEPS*STEP_IN*2;
    total_l = STYLOBATE_L + N_STEPS*STEP_IN*2;
    translate([-N_STEPS*STEP_IN-5, -N_STEPS*STEP_IN-5, -10])
        difference() {
            cube([total_w+10, total_l+10, 10]);
            translate([5, 5, 3])
                cube([total_w, total_l, 10]);
            // Label
            translate([total_w/2, 10, 8])
                rotate([0,0,0])
                    linear_extrude(3)
                        text("PARTHENON  447 BCE", size=5, halign="center", $fn=4);
        }
}

// Color 1 (marble white): columns + steps + platform
display_base();
steps();
translate([0, 0, N_STEPS*STEP_H + STYLOBATE_H]) {
    peristyle();
    entablature();
}

// Color 2 (ochre/gold): pediment + frieze reliefs
translate([0, 0, N_STEPS*STEP_H + STYLOBATE_H])
    pediment();
