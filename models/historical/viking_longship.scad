// Viking Longship — Drakkar Display Model
// Clinker-built hull, dragon prow, oar ports, striped sail
// DUAL COLOR: hull (dark oak PLA) | dragon head + shields (red/gold)
// PLA — 0.15mm, 4 walls, 20% infill
// ~280mm long, display stand included

SHIP_L  = 280;
SHIP_W  = 60;
SHIP_H  = 35;    // Hull depth
KEEL_H  = 8;
PLANK_T = 2.0;
PLANK_W = 6.0;   // Clinker plank width
N_PLANKS = 6;    // Planks each side
MAST_D  = 6.0;
MAST_H  = 120;
OAR_D   = 3.5;
OAR_L   = 55;
N_OARS  = 8;     // Per side
SHIELD_D = 14;

// ── Hull form (sweeping longship shape) ───────────────
module hull_profile() {
    // Longitudinal cross-section (side view)
    polygon([
        [0, 0],          // Stern tip
        [10, SHIP_H],    // Stern upper
        [30, SHIP_H+5],  // Stern strake rise
        [SHIP_L-30, SHIP_H+5],
        [SHIP_L-10, SHIP_H],
        [SHIP_L, 0],     // Bow tip
        [SHIP_L*0.55, -KEEL_H],  // Keel curve bottom
        [SHIP_L*0.45, -KEEL_H],
    ]);
}

module hull() {
    difference() {
        union() {
            // Solid hull shell
            translate([0, -SHIP_W/2, 0])
                rotate([90, 0, 0])
                    linear_extrude(SHIP_W, center=true)
                        hull() hull_profile();
            // Keel (bottom ridge)
            translate([10, 0, -KEEL_H])
                scale([1, 0.3, 1])
                    cylinder(d=KEEL_H*1.2, h=SHIP_L-20, center=false, $fn=8);
        }
        // Hollow interior (clinker hull — open top)
        translate([15, -SHIP_W/2+PLANK_T*2, PLANK_T])
            rotate([90, 0, 0])
                linear_extrude(SHIP_W-PLANK_T*4, center=true)
                    scale([0.92, 0.9])
                        hull() hull_profile();
        // Oar ports (8 per side)
        for (i=[0:N_OARS-1]) {
            x = 50 + i*(SHIP_L-100)/(N_OARS-1);
            for (sy=[-1,1])
                translate([x, sy*(SHIP_W/2+1), SHIP_H*0.7])
                    rotate([90,0,0])
                        cylinder(d=OAR_D+2, h=8, $fn=12);
        }
    }
    // Clinker planks (overlapping strakes)
    for (i=[0:N_PLANKS-1]) {
        h = PLANK_T + i*(SHIP_H-PLANK_T)/N_PLANKS;
        for (sy=[-1,1])
            translate([8, sy*(SHIP_W/2 - i*SHIP_W*0.06), h])
                rotate([0, 0, sy*2])
                    cube([SHIP_L-16, PLANK_T*0.6, PLANK_W]);
    }
    // Ribs (internal frames)
    for (i=[1:5]) {
        x = i*SHIP_L/6;
        translate([x-2, -SHIP_W/2+PLANK_T, -KEEL_H+2])
            cube([4, SHIP_W-PLANK_T*2, SHIP_H+5]);
    }
}

// ── Dragon prow (Color 2 — gold/red) ──────────────────
module dragon_head() {
    translate([SHIP_L, 0, SHIP_H+5]) {
        rotate([0, -15, 0]) {
            // Neck
            hull() {
                sphere(d=14, $fn=16);
                translate([-20, 0, 8]) sphere(d=18, $fn=18);
            }
            // Skull
            translate([-20, 0, 8]) {
                scale([1.3, 0.65, 0.85]) sphere(d=22, $fn=20);
                // Snout
                translate([10, 0, -5]) scale([1.2,0.55,0.6]) sphere(d=18, $fn=16);
                // Horns
                for (sy=[-1,1])
                    translate([0, sy*6, 10])
                        rotate([0,sy*20,0])
                            cylinder(d1=4, d2=0, h=18, $fn=8);
                // Teeth
                for (i=[-1,0,1])
                    translate([12+i*4, 0, -8])
                        cylinder(d1=3, d2=0, h=6, $fn=6);
                // Eyes
                for (sy=[-1,1])
                    translate([2, sy*8, 2]) sphere(d=5, $fn=12);
            }
        }
    }
}

// ── Stern dragon tail ─────────────────────────────────
module stern_decoration() {
    translate([0, 0, SHIP_H+3])
        rotate([0, 20, 0]) {
            hull() {
                sphere(d=10, $fn=12);
                translate([-10, 0, 15]) sphere(d=7, $fn=10);
                translate([-14, 0, 28]) sphere(d=4, $fn=8);
            }
        }
}

// ── Mast and sail ─────────────────────────────────────
module mast_sail() {
    translate([SHIP_L*0.4, 0, SHIP_H]) {
        // Mast
        cylinder(d=MAST_D, h=MAST_H, $fn=12);
        // Yard (horizontal boom)
        translate([0, -SHIP_W*0.8, MAST_H*0.85])
            rotate([90,0,0]) cylinder(d=MAST_D*0.7, h=SHIP_W*1.6, $fn=10);
        // Sail (striped — flat, represents furled or set)
        translate([0, -SHIP_W*0.7, MAST_H*0.2])
            for (stripe=[0:6]) {
                translate([0, stripe*SHIP_W*0.2-SHIP_W*0.7, 0])
                    cube([2, SHIP_W*0.2, MAST_H*0.6]);
            }
    }
}

// ── Oars ──────────────────────────────────────────────
module oars() {
    for (i=[0:N_OARS-1]) {
        x = 50 + i*(SHIP_L-100)/(N_OARS-1);
        for (sy=[-1,1]) {
            translate([x, sy*(SHIP_W/2+2), SHIP_H*0.7])
                rotate([0, 20*sy, 90])
                    union() {
                        cylinder(d=OAR_D, h=OAR_L, $fn=10);
                        translate([0,0,OAR_L])
                            scale([2.5,1,0.3]) sphere(d=OAR_D*2.5, $fn=10);
                    }
        }
    }
}

// ── Shields on gunwale (Color 2) ──────────────────────
module shields() {
    for (i=[0:N_OARS-1]) {
        x = 50 + i*(SHIP_L-100)/(N_OARS-1);
        for (sy=[-1,1]) {
            translate([x, sy*(SHIP_W/2+SHIELD_D*0.4), SHIP_H+3])
                rotate([90,0,0])
                    difference() {
                        cylinder(d=SHIELD_D, h=2, $fn=20);
                        cylinder(d=SHIELD_D*0.4, h=3, $fn=14);
                        // Shield pattern
                        for (a=[0,45,90,135])
                            rotate([0,0,a]) cube([SHIELD_D+1,1,3], center=true);
                    }
        }
    }
}

// ── Display stand ─────────────────────────────────────
module stand() {
    translate([0,0,-20]) {
        // Two curved cradle supports
        for (x=[SHIP_L*0.25, SHIP_L*0.75])
            translate([x, 0, 0])
                difference() {
                    scale([0.3,1,0.4]) cylinder(d=SHIP_W+20, h=20, $fn=24);
                    translate([0,0,12])
                        scale([0.35,0.85,1])
                            cylinder(d=SHIP_W+20, h=20, $fn=24);
                    translate([0,0,-1])
                        scale([0.25,0.7,0.5])
                            cylinder(d=SHIP_W+20, h=20, $fn=24);
                }
        // Base rail
        translate([10,-SHIP_W*0.6,0]) cube([SHIP_L-20, SHIP_W*1.2, 4]);
    }
}

// Color 1 (dark oak): hull + mast
hull();
mast_sail();
oars();
stand();
// Color 2 (red/gold): dragon + shields
dragon_head();
stern_decoration();
shields();
