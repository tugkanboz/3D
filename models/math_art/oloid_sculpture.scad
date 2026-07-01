// Oloid Rolling Sculpture — A Unique Geometric Solid
// The oloid is the convex hull of two circles where each passes through the other's center
// Mathematical property: when rolled, the ENTIRE SURFACE contacts the flat plane
// (one of only a handful of shapes with this property — cylinders/cones don't qualify)
// It also has the unusual property that its surface area equals that of a sphere of same radius
// SINGLE COLOR: oloid body | print orientation: flat face down
// PLA 0.20mm, 4 walls, 20% gyroid — print and roll on flat surface (mesmerizing!)
// Include: oloid + display cradle + mathematical data plate

$fn = 180;

// ── Parameters ─────────────────────────────────────────────
R = 55;             // Radius of each generating circle (and the oloid)
WALL = 3.0;         // Wall thickness for hollow variant
CRADLE_H = 22;
PLATE_T = 3;

// ── Oloid ──────────────────────────────────────────────────
// Convex hull of two circles:
//   Circle A: at x=-R/2, in the XZ plane (y-normal), radius R
//   Circle B: at x=+R/2, in the XY plane (z-normal), radius R
// Each circle passes through the other's center:
//   A's rightmost point = (R/2, 0, 0) = center of B ✓
//   B's leftmost point  = (-R/2, 0, 0) = center of A ✓
module oloid_solid() {
    // Approximate each circle as a very thin cylinder (disc)
    hull() {
        // Circle A: XZ plane, centered at (-R/2, 0, 0)
        translate([-R/2, 0, 0])
            rotate([90, 0, 0])   // now in XZ plane
                cylinder(r=R, h=0.12, center=true, $fn=180);
        // Circle B: XY plane, centered at (+R/2, 0, 0)
        translate([R/2, 0, 0])
            cylinder(r=R, h=0.12, center=true, $fn=180);
    }
}

// ── Hollow oloid (for material savings) ───────────────────
module oloid_hollow() {
    difference() {
        oloid_solid();
        // Slightly smaller inner oloid (subtract)
        scale([(R-WALL)/R, (R-WALL)/R, (R-WALL)/R])
            oloid_solid();
        // Opening holes for sand/marble fill or just drainage
        cylinder(d=10, h=R*4, center=true, $fn=20);
        rotate([90,0,0]) cylinder(d=10, h=R*4, center=true, $fn=20);
    }
}

// ── Display cradle ─────────────────────────────────────────
// V-shaped cradle that holds the oloid at rest position
module cradle() {
    // The oloid rests with its circular edge down — cradle supports two tangent points
    CRADLE_W = R * 2.4;
    CRADLE_D = R * 0.8;
    SUPPORT_R = R * 0.85;

    difference() {
        union() {
            // Base platform
            hull() {
                for(x=[-CRADLE_W/2+10, CRADLE_W/2-10]) for(y=[-CRADLE_D/2+10, CRADLE_D/2-10])
                    translate([x, y, 0]) cylinder(d=20, h=CRADLE_H*0.35, $fn=16);
            }
            // Two saddle supports
            for(side=[-1,1]) translate([side*SUPPORT_R*0.45, 0, 0]) {
                difference() {
                    cylinder(d=SUPPORT_R*0.9, h=CRADLE_H, $fn=40);
                    // Saddle cutout (concave to match oloid curve)
                    translate([side*SUPPORT_R*0.35, 0, CRADLE_H-12])
                        rotate([0, side*15, 0]) cylinder(d=SUPPORT_R*0.7, h=14, $fn=40);
                }
            }
        }
        // Center relief
        translate([0,0,CRADLE_H*0.2]) cylinder(d=SUPPORT_R*0.55, h=CRADLE_H, $fn=40);
        // Mounting holes
        for(x=[-CRADLE_W/3, CRADLE_W/3]) for(y=[-CRADLE_D/3, CRADLE_D/3])
            translate([x, y, -1]) cylinder(d=4, h=6, $fn=10);
    }
}

// ── Math data plate ────────────────────────────────────────
module data_plate() {
    PW = 140; PH = 55;
    difference() {
        cube([PW, PH, PLATE_T]);
        // Title
        translate([PW/2-42, PH-12, PLATE_T-0.8])
            linear_extrude(1) text("OLOID — PAUL SCHATZ 1929", size=5.5, $fn=4);
        // Properties
        translate([4, PH-22, PLATE_T-0.8])
            linear_extrude(1) text(str("R = ", R, "mm"), size=4, $fn=4);
        translate([4, PH-30, PLATE_T-0.8])
            linear_extrude(1) text("Surface = 4πR² (= sphere of same R)", size=3.8, $fn=4);
        translate([4, PH-38, PLATE_T-0.8])
            linear_extrude(1) text("Volume = 3.0524 × R³ / 3", size=3.8, $fn=4);
        translate([4, PH-46, PLATE_T-0.8])
            linear_extrude(1) text("Full surface contact when rolling on flat plane", size=3.8, $fn=4);
        translate([4, 4, PLATE_T-0.8])
            linear_extrude(1) text("Roll on a flat surface and observe the motion", size=3.8, $fn=4);
    }
}

// ── Rolling path diagram ───────────────────────────────────
// Shows the egg-shaped rolling path the oloid traces
module rolling_path_diagram() {
    linear_extrude(2)
        difference() {
            union() {
                // Two overlapping circles (the generating geometry)
                translate([-R/2, 0]) circle(r=R, $fn=120);
                translate([R/2, 0])  circle(r=R, $fn=120);
            }
            // Inner hollow
            union() {
                translate([-R/2, 0]) circle(r=R-2, $fn=120);
                translate([R/2, 0])  circle(r=R-2, $fn=120);
            }
        }
}

// ── Layout ────────────────────────────────────────────────
// Main oloid (print solid or hollow)
oloid_solid();

// Display cradle (below and to side)
translate([R*3.5, 0, 0]) cradle();

// Data plate
translate([0, -R*2.2, 0]) data_plate();

// Rolling path diagram (on its own, printable flat)
translate([0, R*2.8, 0]) rolling_path_diagram();
