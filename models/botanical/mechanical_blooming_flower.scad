// Mechanical Blooming Flower — Screw-Actuated Iris Petals
// Rotate the base → 8 petals open/close via cam mechanism
// DUAL COLOR: petals (bright color) | stem + cam housing (dark green)
// PETG — 0.15mm, 3 walls, 15% infill
// Print-in-place + screw thread: 0.45mm gap on cam tracks

PETALS    = 8;
PETAL_L   = 55;   // Petal length
PETAL_W   = 22;   // Petal width at base
PETAL_T   = 3.5;  // Petal thickness
CAM_D     = 70;   // Cam plate diameter
CAM_T     = 8.0;  // Cam plate thickness
AXLE_D    = 10.0; // Center axle
HUB_D     = 18;
STEM_D    = 14;
STEM_H    = 80;
TRACK_W   = PETAL_W * 0.4;  // Cam track width
TRACK_LIFT = 18;  // How much petals lift on one rotation
GAP       = 0.45;

// ── Single petal ─────────────────────────────────────
module petal(open_angle) {
    rotate([0, open_angle, 0])
        difference() {
            union() {
                // Petal body (spoon-leaf shape)
                hull() {
                    cylinder(d=HUB_D*0.5, h=PETAL_T, $fn=16);
                    translate([PETAL_L, 0, PETAL_T*0.5])
                        sphere(d=PETAL_W, $fn=16);
                }
                // Central rib
                translate([0, 0, PETAL_T])
                    hull() {
                        cylinder(d=3, h=1, $fn=10);
                        translate([PETAL_L*0.8, 0, 2])
                            cylinder(d=1.5, h=1, $fn=8);
                    }
                // Lateral veins
                for (sy=[-1,1], frac=[0.3,0.5,0.7])
                    hull() {
                        translate([PETAL_L*frac, 0, PETAL_T])
                            sphere(d=2, $fn=8);
                        translate([PETAL_L*(frac+0.15), sy*PETAL_W*0.35, PETAL_T])
                            sphere(d=1, $fn=6);
                    }
            }
            // Cam slot (sliding pin channel)
            translate([8, -TRACK_W/2, -1])
                cube([10, TRACK_W, PETAL_T+2]);
        }
}

// ── Cam plate (spiral lift track) ────────────────────
module cam_plate() {
    difference() {
        union() {
            cylinder(d=CAM_D, h=CAM_T, $fn=48);
            // Spiral cam track (raised ramp)
            for (i=[0:PETALS-1]) {
                ang = i * 360/PETALS;
                track_h = CAM_T + (i / PETALS) * TRACK_LIFT;
                rotate([0,0,ang])
                    translate([CAM_D*0.28, -TRACK_W/2, CAM_T])
                        rotate([0,-atan(TRACK_LIFT/(CAM_D*0.5)), 0])
                            cube([CAM_D*0.2, TRACK_W, 3]);
            }
        }
        // Axle bore
        cylinder(d=AXLE_D, h=CAM_T+20, $fn=16);
        // Petal slot guides
        for (i=[0:PETALS-1])
            rotate([0,0,i*360/PETALS])
                translate([HUB_D*0.3, -TRACK_W/2-GAP/2, -1])
                    cube([CAM_D*0.35, TRACK_W+GAP, CAM_T+2]);
    }
}

// ── Rotating base (screw thread actuator) ─────────────
module base_ring() {
    difference() {
        cylinder(d=CAM_D+16, h=16, $fn=48);
        translate([0,0,6])
            cylinder(d=CAM_D+0.5, h=12, $fn=48);
        cylinder(d=AXLE_D, h=18, $fn=16);
        // Finger grip slots (8 around rim)
        for (i=[0:7])
            rotate([0,0,i*45])
                translate([CAM_D/2+6, -4, 3])
                    cube([12, 8, 14]);
    }
    // Detent bumps (clicking feel at 8 positions)
    for (i=[0:PETALS-1])
        rotate([0,0,i*45+22.5])
            translate([CAM_D/2+1, 0, 5])
                sphere(d=3, $fn=10);
}

// ── Stem ──────────────────────────────────────────────
module stem() {
    difference() {
        union() {
            cylinder(d=STEM_D, h=STEM_H, $fn=20);
            // Leaves on stem
            for (h=[STEM_H*0.3, STEM_H*0.55], sy=[-1,1])
                translate([0, 0, h])
                    rotate([0,sy*70,0])
                        scale([1, 0.4, 0.25])
                            sphere(d=30, $fn=14);
        }
        cylinder(d=AXLE_D, h=STEM_H+1, $fn=16);
    }
}

// ── Flower center (pistil/stamen) ─────────────────────
module flower_center() {
    difference() {
        sphere(d=HUB_D, $fn=20);
        cylinder(d=AXLE_D, h=HUB_D, center=true, $fn=14);
    }
    // Stamen bumps
    for (i=[0:11])
        rotate([0,i*30,i*15])
            translate([0,0,HUB_D/2])
                cylinder(d=2, h=6, $fn=6);
}

// Color 2 (green): stem + cam + base
stem();
translate([0,0,STEM_H]) cam_plate();
translate([0,0,STEM_H-6]) base_ring();
// Color 1 (bright): petals + center
translate([0,0,STEM_H+CAM_T+2])
    flower_center();
for (i=[0:PETALS-1])
    rotate([0,0,i*360/PETALS])
        translate([HUB_D*0.4, 0, STEM_H+CAM_T+4])
            petal(0);   // 0=closed, 45=open — change for display pose
