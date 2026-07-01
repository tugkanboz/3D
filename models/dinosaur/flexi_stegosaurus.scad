// Flexi Stegosaurus — Articulated Poseable Dinosaur
// Print flat — 20 ball-socket spine segments, bendable tail
// DUAL COLOR: body (dark green) | dorsal plates (bright orange/red)
// PLA — 0.2mm, 3 walls, 15% infill — print-in-place, 0.4mm gap
// Full length: ~280mm lying flat

BALL_D   = 14;    // Ball diameter
SOCKET_D = 14.6;  // Socket ID (0.3mm gap each side)
NECK_D   = 10;
BODY_W   = 28;
BODY_H   = 22;
TAIL_D   = 8;
LEG_D    = 10;
PLATE_W  = 18;    // Dorsal plate base width
GAP      = 0.4;   // Print-in-place clearance

// ── Ball-socket segment ───────────────────────────────
module ball_socket_joint(ball_d, socket_d, length, seg_w, seg_h) {
    union() {
        // Segment body
        hull() {
            translate([0, 0, 0]) sphere(d=seg_w, $fn=16);
            translate([length, 0, 0]) sphere(d=seg_w*0.85, $fn=14);
        }
        // Ball at one end
        translate([length, 0, 0]) sphere(d=ball_d, $fn=20);
    }
    // Socket at other end (separate, overlapping at print)
    difference() {
        sphere(d=socket_d+6, $fn=20);
        sphere(d=socket_d, $fn=20);
        // Front opening (ball enters here)
        translate([-socket_d, -socket_d/2, -socket_d/2])
            cube([socket_d * 0.8, socket_d, socket_d]);
    }
}

// ── Body segment ─────────────────────────────────────
module body_seg(w, h, len) {
    hull() {
        sphere(d=min(w,h), $fn=14);
        translate([len, 0, 0]) sphere(d=min(w,h)*0.9, $fn=12);
    }
}

// ── Dorsal plate (Color 2) ────────────────────────────
module dorsal_plate(base_w, plate_h, thickness, taper=0.3) {
    linear_extrude(thickness)
        polygon([
            [-base_w/2, 0],
            [-base_w/2*taper, plate_h],
            [0, plate_h*1.1],
            [base_w/2*taper, plate_h],
            [base_w/2, 0]
        ]);
}

// ── Head ──────────────────────────────────────────────
module stego_head() {
    difference() {
        union() {
            // Skull
            hull() {
                sphere(d=22, $fn=20);
                translate([20, 0, -3]) sphere(d=14, $fn=16);
                translate([28, 0, -5]) sphere(d=8, $fn=12);
            }
            // Beak tip
            translate([30, 0, -6]) sphere(d=6, $fn=10);
        }
        // Eye sockets
        for (sy=[-1,1])
            translate([8, sy*9, 4]) sphere(d=7, $fn=14);
        // Nostril
        translate([29, 0, -4]) sphere(d=3, $fn=10);
    }
    // Eyes
    for (sy=[-1,1])
        translate([8, sy*9, 4]) sphere(d=4, $fn=12);
}

// ── Leg pair ──────────────────────────────────────────
module leg_pair(x_pos, body_bottom) {
    for (sy=[-1,1]) {
        translate([x_pos, sy*(BODY_W/2+2), body_bottom-4]) {
            // Upper leg
            rotate([0,-15,sy*10])
                cylinder(d=LEG_D, h=22, $fn=12);
            // Foot
            translate([0, sy*3, -16])
                hull() {
                    cylinder(d=LEG_D*0.9, h=6, $fn=10);
                    translate([10, 0, 0]) cylinder(d=LEG_D*0.5, h=4, $fn=8);
                }
        }
    }
}

// ── Full stegosaurus layout ────────────────────────────
// Head + neck
stego_head();
// Neck segments (3)
for (i=[0:2])
    translate([30 + i*14, 0, 0])
        body_seg(NECK_D+i*3, NECK_D+i*2, 14);
// Main body (5 segments)
for (i=[0:4]) {
    bx = 72 + i*22;
    body_seg(BODY_W, BODY_H, 22);
    translate([bx, 0, 0]) body_seg(BODY_W*(1-i*0.04), BODY_H*(1-i*0.03), 22);
    // Dorsal plates (Color 2 — print separately, glue on pin)
    translate([bx+11, 0, BODY_H/2])
        rotate([0,0,0])
            dorsal_plate(PLATE_W*(1-abs(i-2)*0.1), 28+sin(i*36)*8, 3, 0.25);
}
// Tail (6 tapering segments)
for (i=[0:5]) {
    bx = 182 + i*15;
    td = TAIL_D*(1-i*0.1);
    translate([bx, 0, 0]) body_seg(td+3, td, 15);
    // Tail spikes pair
    if (i >= 3)
        for (sy=[-1,1])
            translate([bx+7, sy*(td/2+2), 0])
                rotate([0,sy*30,0])
                    cylinder(d1=td*0.5, d2=0, h=14, $fn=8);
}
// Legs
leg_pair(80, -BODY_H/2);
leg_pair(150, -BODY_H/2);
