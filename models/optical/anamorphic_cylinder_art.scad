// Anamorphic Cylinder Art — Mathematical Optical Illusion
// A distorted radial pattern on a flat coaster that reveals a SECRET message/image
// when a mirror-finish metallic cylinder is placed at the center
// The cylinder reflection "corrects" the perspective distortion
// DUAL COLOR: coaster base (neutral) | raised distorted pattern (accent, ~0.8mm raised)
// PLA 0.20mm, 4 walls, 15% infill — print pattern in shiny/metallic filament
// After printing, place a DIY mirror cylinder (aluminum tube, diameter = CYL_D)

$fn = 120;

// ── Parameters ────────────────────────────────────────────
COASTER_D = 160;  // Outer diameter of coaster
COASTER_H = 4.0;  // Base thickness
CYL_D     = 38;   // Mirror cylinder diameter (inner circle)
CREST_H   = 0.9;  // Raised pattern height above coaster surface
WALL      = 2.5;

// ── Anamorphic math ───────────────────────────────────────
// For a cylindrical mirror of radius R_cyl, the transformation from
// image point (ix, iy) in normalized coords to coaster point (r, θ) is:
// r = R_cyl * exp(π*iy / HEIGHT_IMAGE) — radial distance from center
// θ = π * ix / WIDTH_IMAGE            — angle around center
// HEIGHT_IMAGE / WIDTH_IMAGE = aspect ratio of the hidden message

// The text "HELLO" encoded as anamorphic ellipses:
// Each letter is a series of line segments warped into the radial projection

// Helper: Draw a short arc segment (for stroke-based letter rendering)
module arc_stroke(r_inner, r_outer, a_start, a_end, h=CREST_H) {
    rotate([0,0,a_start])
        difference() {
            cylinder(r=r_outer, h=h, $fn=120);
            cylinder(r=r_inner, h=h+1, $fn=120);
            // Cut to sector
            if (a_end - a_start < 360)
                for(side=[0,1])
                    rotate([0,0,side*(a_end-a_start)])
                        translate([0,-COASTER_D/2,-1])
                            cube([COASTER_D, COASTER_D, h+2]);
        }
}

module radial_stroke(r_start, r_end, angle, width=3.5, h=CREST_H) {
    rotate([0,0,angle])
        translate([0,-width/2,0])
            difference() {
                translate([r_start,0,0]) cube([r_end-r_start, width, h]);
            }
}

// ── Anamorphic text encoding: "3D PRINT" ─────────────────
// Each letter rendered as warped strokes in polar coordinate system
// Letters appear at radii 28–72mm from center (image = 60% of coaster)

// "3": arc top half + arc bottom half + middle horizontal
module letter_3(base_angle, r_near=28, r_far=65) {
    mid_r = (r_near+r_far)/2;
    // Top arc
    arc_stroke(r_far*0.78, r_far*0.78+3, base_angle-14, base_angle+14);
    // Bottom arc
    arc_stroke(r_near*1.05, r_near*1.05+3, base_angle-14, base_angle+14);
    // Right vertical bars (two arcs connecting)
    arc_stroke(mid_r, mid_r+3, base_angle+10, base_angle+14);
    arc_stroke(mid_r*1.22, mid_r*1.22+3, base_angle+10, base_angle+14);
}

// "D": left vertical + right arc
module letter_D(base_angle, r_near=28, r_far=65) {
    mid_r = (r_near+r_far)/2;
    // Left vertical stroke (radial)
    radial_stroke(r_near, r_far, base_angle-14, width=3.5);
    // Right arc
    arc_stroke(r_far*0.82, r_far*0.82+3, base_angle-14, base_angle+14);
    // Top cap
    arc_stroke(r_far-4, r_far, base_angle-14, base_angle);
    // Bottom cap
    arc_stroke(r_near, r_near+4, base_angle-14, base_angle);
}

// " " (space — ring divider)
module divider_ring(r=22, h=CREST_H) {
    difference() {
        cylinder(r=r, h=h, $fn=80);
        cylinder(r=r-2.5, h=h+1, $fn=80);
    }
}

// Generic symbol: star at center
module center_star(n=8, r_in=CYL_D/2+4, r_out=CYL_D/2+14, h=CREST_H) {
    linear_extrude(h) {
        for(i=[0:n-1]) rotate([0,0,i*360/n]) {
            hull() {
                circle(r=1.5, $fn=6);
                translate([0,r_out]) circle(r=2, $fn=8);
            }
        }
        difference() {
            circle(r=r_in, $fn=60);
            circle(r=r_in-2.5, $fn=60);
        }
    }
}

// ── Full anamorphic pattern ───────────────────────────────
// Spiral grid (like grid paper in polar coords — helps viewer align cylinder)
module polar_grid() {
    // Concentric guide rings
    for(r=[CYL_D/2+8, CYL_D/2+20, CYL_D/2+35, CYL_D/2+52, CYL_D/2+68])
        difference() {
            cylinder(r=r, h=CREST_H*0.3, $fn=100);
            cylinder(r=r-1, h=CREST_H*0.3+1, $fn=100);
        }
    // Radial guide lines (every 22.5°)
    for(a=[0:22.5:359])
        rotate([0,0,a]) translate([CYL_D/2+2,-0.5,0])
            cube([COASTER_D/2-CYL_D/2-6, 1, CREST_H*0.3]);
}

// ── Outer decorative ring ──────────────────────────────────
module outer_ring_decoration() {
    // Alternating raised triangular wedges (like sun rays)
    N = 24;
    for(i=[0:N-1]) {
        if (i%2 == 0)
            rotate([0,0,i*360/N])
                difference() {
                    cylinder(r=COASTER_D/2-1, h=CREST_H, $fn=N*4);
                    cylinder(r=COASTER_D/2-8, h=CREST_H+1, $fn=N*4);
                    // Cut to wedge sector
                    rotate([0,0,0.5*360/N])
                        translate([0,-COASTER_D, -1]) cube([COASTER_D, COASTER_D*2, CREST_H+2]);
                    rotate([0,0,-0.5*360/N])
                        translate([-COASTER_D,-COASTER_D,-1]) cube([COASTER_D, COASTER_D*2, CREST_H+2]);
                }
    }
}

// ── Cylinder holder ring (keeps mirror cylinder in place) ──
module cylinder_holder() {
    difference() {
        cylinder(d=CYL_D+3*2, h=8, $fn=60);
        cylinder(d=CYL_D+0.3, h=9, $fn=60);
    }
}

// ── COASTER BASE (Color 1) ────────────────────────────────
difference() {
    cylinder(d=COASTER_D, h=COASTER_H, $fn=100);
    // Center recess for cylinder holder
    cylinder(d=CYL_D+7, h=4, $fn=60);
    // Bottom anti-slip texture (subtle hexagonal bumps)
    translate([0,0,-0.5])
        for(row=[-3:3]) for(col=[-3:3]) {
            x = col*18 + (row%2)*9;
            y = row*15.6;
            if(x*x+y*y < (COASTER_D/2-8)*(COASTER_D/2-8))
                translate([x,y,0]) cylinder(d=6, h=1, $fn=6);
        }
    // Label on edge
    translate([COASTER_D/2-WALL-1, -18, 1])
        rotate([90,0,90]) linear_extrude(2)
            text("▲ PLACE MIRROR CYLINDER ▲", size=4, $fn=4);
}

// ── ANAMORPHIC PATTERN ELEMENTS (Color 2 — raised) ───────
translate([0,0,COASTER_H]) {
    polar_grid();
    center_star(n=12);
    outer_ring_decoration();
    // Encoded letters at their angular positions
    letter_3(  0);   // "3" at 0°
    letter_D(  45);  // "D" at 45°
    // Repeat to fill: show "3D" × 4 around the circle
    letter_3(180);
    letter_D(225);
}

// Cylinder holder (part of base)
cylinder_holder();
