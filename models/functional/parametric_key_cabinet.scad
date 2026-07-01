// Parametric Key Cabinet — Wall-Mounted with Pegboard Back & Labeled Hooks
// Holds 12 keys (3×4 grid) + 4 special hooks for large keyrings/fobs
// DUAL COLOR: cabinet body (neutral) | hooks + labels (contrast)
// PLA 0.20mm, 4 walls, 20% infill — two M4 wall screws, ~200×160×55mm
// Magnetic snap door (optional) — design can be split: box + door

$fn = 30;

// ── Dimensions ────────────────────────────────────────────
W       = 200;    // Width
H       = 165;    // Height
D       = 55;     // Depth (wall-to-front)
WALL    = 4.0;    // Wall thickness
DOOR_T  = 3.5;    // Door thickness
HINGE_R = 3.0;    // Hinge barrel radius

// ── Hook parameters ───────────────────────────────────────
HOOK_R    = 3.2;   // Hook wire radius (8mm pocket)
HOOK_W    = 22;    // Hook total width
HOOK_H    = 30;    // Hook drop
PEG_PITCH = 25.4; // Pegboard hole pitch (1 inch standard)
PEG_D     = 6.2;  // Pegboard hole diameter
ROWS      = 4;    // Hook rows
COLS      = 3;    // Hook columns per row (3 standard + 4 wide = 13 total)

// ── Wall mount plate ──────────────────────────────────────
module mount_plate() {
    difference() {
        translate([-2,-2,0]) cube([W+4, H+4, WALL-1]);
        // Keyhole slots for wall screws (6mm screw, M5 compatible)
        for(x=[W*0.2, W*0.8]) {
            translate([x, H*0.85, -1]) cylinder(d=8, h=WALL+1, $fn=20);
            translate([x, H*0.85-18, WALL*0.4]) rotate([90,0,0]) {
                cylinder(d=4.5, h=20, $fn=16);
                translate([0,0,15]) cylinder(d=8, h=6, $fn=20);
            }
        }
    }
}

// ── Cabinet body ──────────────────────────────────────────
module cabinet_body() {
    difference() {
        // Outer shell
        cube([W, H, D]);
        // Interior cavity
        translate([WALL, WALL, WALL])
            cube([W-WALL*2, H-WALL*2, D-WALL+0.1]);
        // Front opening (for door)
        translate([WALL*1.5, WALL*1.5, D-DOOR_T-1])
            cube([W-WALL*3, H-WALL*3, DOOR_T+2]);
        // Pegboard holes on back interior
        translate([WALL+PEG_PITCH, WALL+PEG_PITCH, WALL-1])
            for(row=[0:ROWS+1]) for(col=[0:COLS+2])
                translate([col*PEG_PITCH, row*PEG_PITCH, 0])
                    cylinder(d=PEG_D, h=WALL+2, $fn=16);
        // Wall mount openings
        for(x=[W*0.2, W*0.8])
            translate([x, H*0.85-9, -1]) cylinder(d=9, h=WALL+1, $fn=20);
        // Ventilation slots (back, small)
        for(i=[0:4])
            translate([W*0.3 + i*W*0.08, 10, -1])
                cube([4, H*0.15, WALL+2]);
        // Label recess (front, embossed text area)
        translate([W/2-40, H-WALL*3, D-1.5])
            linear_extrude(2)
                text("KEYS", size=10, halign="center", $fn=4);
        // Door hinge barrel socket
        for(z=[H*0.25, H*0.75])
            translate([-1, 0, z]) rotate([0,90,0])
                cylinder(r=HINGE_R+0.3, h=WALL+2, $fn=20);
    }
    // Hinge barrels (part of body)
    for(z=[H*0.25, H*0.75])
        translate([0, 0, z]) rotate([0,90,0])
            difference() {
                cylinder(r=HINGE_R, h=WALL, $fn=20);
                cylinder(d=2.2, h=WALL+1, $fn=10);
            }
    // Magnetic catch pocket (front right edge)
    translate([W-WALL-6, H/2-8, D-5])
        difference() {
            cube([6, 16, 5]);
            translate([0,3,2]) cube([4.5, 10, 4]);
        }
}

// ── Standard key hook ─────────────────────────────────────
module key_hook(label="") {
    // Peg pin (goes into pegboard hole)
    cylinder(d=PEG_D-0.6, h=12, $fn=16);
    // Backplate
    translate([-8, -8, 0]) cube([16, 16, 3]);
    // Hook body
    translate([0, -HOOK_R, 3]) {
        // Vertical drop
        cylinder(r=HOOK_R, h=HOOK_H-HOOK_R*2, $fn=16);
        // Bottom curve
        translate([HOOK_R*2, 0, HOOK_H-HOOK_R*4]) rotate([90,0,0])
            difference() {
                torus_quarter(HOOK_R*2, HOOK_R);
            }
        // Horizontal return (anti-slip)
        translate([HOOK_R*4, -HOOK_R, HOOK_H-HOOK_R*4-HOOK_R*2])
            cylinder(r=HOOK_R, h=HOOK_R*2, $fn=16);
    }
    // Label plate (horizontal, above hook)
    if (len(label) > 0)
        translate([-10, -4, 3])
            difference() {
                cube([20, 3, 8]);
                translate([10, -0.5, 2]) rotate([90,0,0])
                    linear_extrude(3.5)
                        text(label, size=4.5, halign="center", $fn=4);
            }
}

module torus_quarter(major_r, minor_r) {
    difference() {
        rotate_extrude(angle=90, $fn=24)
            translate([major_r, 0])
                circle(r=minor_r, $fn=12);
        translate([-major_r*2, -major_r*2, -minor_r*2]) cube([major_r*2, major_r*4, minor_r*4]);
    }
}

// ── Wide hook (for keyrings/fobs) ─────────────────────────
module wide_hook() {
    cylinder(d=PEG_D-0.6, h=12, $fn=16);
    translate([-14, -8, 0]) cube([28, 16, 3]);
    // Wider J-hook
    translate([0, -HOOK_R*1.5, 3]) {
        cylinder(r=HOOK_R*1.5, h=HOOK_H, $fn=16);
        translate([HOOK_R*4, 0, HOOK_H-HOOK_R*4]) rotate([90,0,0])
            rotate_extrude(angle=90, $fn=24)
                translate([HOOK_R*4, 0])
                    circle(r=HOOK_R*1.5, $fn=10);
    }
    translate([-14,-4,3]) difference() {
        cube([28,3,8]);
        translate([14,-0.5,2]) rotate([90,0,0]) linear_extrude(3.5)
            text("★", size=5.5, halign="center", $fn=4);
    }
}

// ── Snap-on door (hinged left) ────────────────────────────
module door() {
    difference() {
        cube([W-WALL*3, H-WALL*3, DOOR_T]);
        // Window cutout (decorative hex grid)
        translate([10, 30, 0])
            for(row=[0:3]) for(col=[0:3])
                translate([col*28 + (row%2)*14, row*24, -1])
                    cylinder(d=20, h=DOOR_T+2, $fn=6);
        // Hinge tabs
        for(z=[-8, H-WALL*3-12+8])
            translate([-1, z, DOOR_T*0.4])
                cube([3, 12, DOOR_T*0.3]);
        // Magnetic catch hole
        translate([W-WALL*3-10, H/2-WALL*3-8, 1.5])
            cylinder(d=7, h=3, $fn=20);
    }
    // Hinge barrels on door
    for(z=[8, H-WALL*3-8])
        translate([0, z, DOOR_T*0.35]) rotate([0,90,0])
            difference() {
                cylinder(r=HINGE_R-0.2, h=WALL*0.8, $fn=20);
                cylinder(d=2.5, h=WALL, $fn=10);
            }
    // Door handle (small knob)
    translate([W-WALL*3-5, (H-WALL*3)/2, DOOR_T])
        cylinder(d=16, h=8, $fn=20);
}

// ── KEY LABELS ────────────────────────────────────────────
KEY_LABELS = ["HOME", "CAR", "BIKE", "WORK", "GATE", "SHED",
              "MOM", "DAD", "SPARE", "SAFE", "MAIL", "EXTRA"];

// ── ASSEMBLY LAYOUT ───────────────────────────────────────
// Color 1 (neutral/white): cabinet body + mount plate + door
translate([0, 0, -WALL]) mount_plate();
cabinet_body();
translate([W+20, 0, DOOR_T]) rotate([180,0,0]) door();

// Color 2 (contrast): hooks + labels
translate([WALL*2+PEG_PITCH, WALL*2+PEG_PITCH, WALL]) {
    for(row=[0:ROWS-1]) for(col=[0:COLS-1]) {
        idx = row*COLS + col;
        lbl = (idx < len(KEY_LABELS)) ? KEY_LABELS[idx] : "";
        translate([col*PEG_PITCH, row*PEG_PITCH, 0])
            key_hook(lbl);
    }
    // Wide hooks for keyrings (separate row)
    for(i=[0:1])
        translate([i*PEG_PITCH*2.5, ROWS*PEG_PITCH+15, 0])
            wide_hook();
}
