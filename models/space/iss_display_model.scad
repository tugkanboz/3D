// International Space Station — Display Model 1:700 Scale
// Accurate solar panel array layout + truss + modules
// DUAL COLOR: modules (white) | solar panels (dark blue/black)
// PLA — 0.15mm, 4 walls, 20% infill
// ~240mm wingspan — fits P2S bed

SC = 0.142;  // 1:700 (ISS truss = 109m → 155mm)

// ISS real dimensions (mm):
TRUSS_L   = 109000;
TRUSS_D   = 1200;
PANEL_W   = 34000;   // Each solar array wing width
PANEL_H   = 12000;   // Panel height
MODULE_D  = 4200;    // Habitation module diameter
PANEL_T   = 600;     // Panel thickness (real)

// ── Main truss (S0-S6) ────────────────────────────────
module main_truss() {
    // Integrated truss structure
    cube([TRUSS_L*SC, TRUSS_D*SC, TRUSS_D*SC*0.6], center=true);
    // Truss lattice detail (simplified ribs)
    for (i=[-6:6])
        translate([i * TRUSS_L*SC/14, 0, 0])
            rotate([0,0,45])
                cube([TRUSS_D*SC*0.7, TRUSS_D*SC*0.7, TRUSS_D*SC*0.7], center=true);
}

// ── Solar array wing (4 pairs = 8 total) ─────────────
module solar_panel_wing(x, side, z_tilt=0) {
    translate([x, side*(TRUSS_D/2+PANEL_H/2)*SC, 0]) {
        rotate([z_tilt, 0, 0])
        difference() {
            cube([PANEL_W*SC, PANEL_H*SC, PANEL_T*SC*2], center=true);
            // Solar cell grid lines
            for (i=[-8:8])
                translate([i*PANEL_W*SC/16, 0, 0])
                    cube([0.4, PANEL_H*SC+1, PANEL_T*SC*3], center=true);
            for (j=[-4:4])
                translate([0, j*PANEL_H*SC/8, 0])
                    cube([PANEL_W*SC+1, 0.4, PANEL_T*SC*3], center=true);
        }
        // Mast connecting panel to truss
        translate([0, -PANEL_H/2*SC-1000*SC, 0])
            cylinder(d=400*SC, h=1000*SC, $fn=8);
    }
}

// ── Habitation modules ────────────────────────────────
module hab_module(len, d) {
    union() {
        cylinder(d=d*SC, h=len*SC, $fn=20, center=true);
        // End caps
        for (z=[-1,1]) translate([0,0,z*len*SC/2]) sphere(d=d*SC, $fn=16);
        // Module window bumps
        for (i=[-2:2])
            translate([0, d/2*SC, i*len*SC/6])
                sphere(d=d*0.3*SC, $fn=10);
    }
}

// ── ISS full assembly ─────────────────────────────────
// Color 1 (white): modules + truss
main_truss();

// Core modules (Zarya, Unity, Zvezda, etc.)
// Core cluster (center, parallel to Y axis)
rotate([90,0,0]) {
    // Zvezda / Zarya stack (Russian segment)
    translate([-8000*SC, 0, 0])
        hab_module(14000, MODULE_D);
    // Unity node
    translate([-1000*SC, 0, 0])
        hab_module(6000, MODULE_D);
    // Destiny lab + harmony
    translate([5000*SC, 0, 0])
        hab_module(12000, MODULE_D);
    // Columbus + Kibo
    translate([4000*SC, 3500*SC, 0])
        rotate([90,0,0]) hab_module(7000, MODULE_D*0.9);
    translate([5500*SC, -4000*SC, 0])
        rotate([90,0,0]) hab_module(11000, MODULE_D);
    // Cupola (observation dome)
    translate([3000*SC, 5000*SC, 0])
        sphere(d=MODULE_D*0.8*SC, $fn=20);
}

// Radiators (top of truss)
for (side=[-1,1])
    translate([side*25000*SC, 0, TRUSS_D*SC])
        cube([15000*SC, 2000*SC, 300*SC], center=true);

// Color 2 (dark blue): solar panels (8 wings)
solar_panel_wing(-45000, -1);
solar_panel_wing(-45000,  1);
solar_panel_wing(-15000, -1,  5);
solar_panel_wing(-15000,  1, -5);
solar_panel_wing( 15000, -1, -5);
solar_panel_wing( 15000,  1,  5);
solar_panel_wing( 45000, -1);
solar_panel_wing( 45000,  1);

// ── Display stand ─────────────────────────────────────
translate([0, 0, -MODULE_D*SC/2 - 15]) {
    cylinder(d=20, h=15, $fn=16);
    translate([0,0,-8]) cylinder(d=80, h=8, $fn=48);
}
