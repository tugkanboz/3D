// Treehouse Planter — Whimsical Birdhouse-Style Succulent Pot
// Tree trunk base with hollow planting cavity, rope bridge, ladder
// DUAL COLOR: trunk (bark brown) | roof + windows + door (bright color)
// PLA — 0.15mm, 4 walls, 20% infill
// PETG for outdoor use; ~200mm tall

TRUNK_D   = 70;
TRUNK_H   = 100;
CABIN_W   = 80;
CABIN_D   = 65;
CABIN_H   = 60;
ROOF_OVER = 15;   // Roof overhang
WALL_T    = 4.0;
WIN_W     = 14;
WIN_H     = 16;
DOOR_W    = 18;
DOOR_H    = 26;
PLANTER_D = 55;   // Inner planting cavity diameter
DRAIN_D   = 5.0;
LADDER_W  = 12;
RUNG_N    = 7;

// ── Tree trunk base ───────────────────────────────────
module trunk() {
    difference() {
        union() {
            // Main trunk (organic tapered cylinder)
            cylinder(d1=TRUNK_D+12, d2=TRUNK_D, h=TRUNK_H, $fn=10);
            // Root buttresses (3 flared roots)
            for (i=[0:2])
                rotate([0,0,i*120+20])
                    hull() {
                        translate([TRUNK_D*0.4, 0, 0])
                            cylinder(d=16, h=8, $fn=8);
                        translate([TRUNK_D*0.55, 0, 0])
                            cylinder(d=8, h=1, $fn=8);
                        translate([0, 0, 25])
                            cylinder(d=6, h=4, $fn=6);
                    }
            // Bark texture (horizontal ridges)
            for (z=[10:8:TRUNK_H-10])
                translate([0, 0, z])
                    rotate_extrude($fn=10)
                        translate([TRUNK_D/2, 0, 0])
                            scale([0.4, 1])
                                circle(d=3, $fn=8);
        }
        // Hollow (for drainage + weight reduction)
        translate([0, 0, 5])
            cylinder(d=TRUNK_D-WALL_T*2.5, h=TRUNK_H, $fn=10);
    }
}

// ── Cabin body ────────────────────────────────────────
module cabin() {
    translate([-CABIN_W/2, -CABIN_D/2, TRUNK_H]) {
        difference() {
            cube([CABIN_W, CABIN_D, CABIN_H]);
            // Hollow interior (planting cavity)
            translate([WALL_T, WALL_T, -1])
                cylinder(d=PLANTER_D, h=CABIN_H+2, $fn=32);
            // Front windows (2)
            for (x=[8, CABIN_W-WIN_W-8])
                translate([x, -1, CABIN_H*0.45])
                    cube([WIN_W, WALL_T+2, WIN_H]);
            // Side window
            translate([-1, CABIN_D*0.35, CABIN_H*0.5])
                cube([WALL_T+2, WIN_W, WIN_H*0.85]);
            // Door (front)
            translate([CABIN_W/2-DOOR_W/2, -1, 0])
                cube([DOOR_W, WALL_T+2, DOOR_H]);
            // Drainage hole (bottom)
            cylinder(d=DRAIN_D, h=5, $fn=12);
        }
        // Window frames (raised, Color 2)
        for (x=[8, CABIN_W-WIN_W-8])
            translate([x-1.5, -0.5, CABIN_H*0.45-1.5])
                difference() {
                    cube([WIN_W+3, 2, WIN_H+3]);
                    translate([2, -1, 2]) cube([WIN_W-1, 4, WIN_H-1]);
                }
        // Flower boxes under windows
        for (x=[6, CABIN_W-WIN_W-10])
            translate([x, -3, CABIN_H*0.44-5])
                difference() {
                    cube([WIN_W+6, 5, 5]);
                    translate([1, 1, 1]) cube([WIN_W+4, 4, 5]);
                }
    }
}

// ── Roof (Color 2) ────────────────────────────────────
module roof() {
    translate([0, 0, TRUNK_H+CABIN_H]) {
        // Gabled roof
        hull() {
            translate([-CABIN_W/2-ROOF_OVER, -CABIN_D/2-ROOF_OVER, 0])
                cube([CABIN_W+ROOF_OVER*2, CABIN_D+ROOF_OVER*2, 2]);
            translate([0, 0, 35]) cylinder(d=6, h=2, $fn=4);
        }
        // Roof ridgeline
        cylinder(d=5, h=40, $fn=4);
        // Chimney
        translate([CABIN_W*0.2, -CABIN_D*0.1, 20])
            difference() {
                cube([10, 10, 25]);
                translate([2,2,-1]) cube([6,6,26]);
            }
        // Shingle detail lines
        for (z=[5:5:32])
            translate([-CABIN_W/2-ROOF_OVER+2, -CABIN_D/2, z])
                cube([CABIN_W+ROOF_OVER*2-4, 1.5, 2]);
    }
}

// ── Ladder (side — Color 1 wood) ──────────────────────
module ladder() {
    translate([TRUNK_D/2+2, 0, 5]) {
        // Side rails
        for (sy=[-1,1])
            translate([0, sy*LADDER_W/2, 0])
                cylinder(d=3, h=TRUNK_H-10, $fn=8);
        // Rungs
        for (i=[0:RUNG_N-1])
            translate([0, -LADDER_W/2, 8+i*(TRUNK_H-16)/RUNG_N])
                rotate([-90,0,0])
                    cylinder(d=2.5, h=LADDER_W, $fn=8);
    }
}

// ── Rope bridge connector (decorative) ────────────────
module rope_bridge() {
    translate([0, TRUNK_D/2, TRUNK_H*0.7]) {
        for (rope=[0:3])
            translate([0, rope*8, 0])
                rotate([90,0,0])
                    cylinder(d=2, h=40, $fn=8);
        // Bridge planks
        for (z=[-5:5:TRUNK_H*0.3-5])
            translate([-8, 0, z])
                cube([16, 40, 2.5]);
    }
}

// Color 1 (bark brown): trunk + ladder + bridge
trunk();
cabin();
ladder();
rope_bridge();
// Color 2 (bright): roof + window frames
roof();
