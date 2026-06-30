// Halloween Skull Planter / Candle Bowl
// Iconic seasonal seller — sells Oct at 3-5x markup
// PLA/PETG — 0.2mm, 3 walls, 15% infill, no supports
// Plant succulents in top, or use as votive candle holder

SKULL_W  = 110;
SKULL_H  = 100;
SKULL_D  = 90;
WALL_T   = 3.0;   // Thick for outdoor durability in PETG
EYE_W    = 28;
EYE_H    = 22;
NOSE_W   = 16;
NOSE_H   = 14;
POT_D    = 70;    // Opening at top for planting

module cranium() {
    scale([SKULL_W/2, SKULL_D/2, SKULL_H/2])
        sphere(1, $fn = 48);
}

module jaw() {
    translate([0, 0, -SKULL_H * 0.22])
        scale([SKULL_W * 0.45, SKULL_D * 0.4, SKULL_H * 0.22])
            sphere(1, $fn = 36);
}

module eye_socket(side) {
    translate([side * SKULL_W * 0.22, SKULL_D * 0.4, SKULL_H * 0.12])
        scale([EYE_W/2, 4, EYE_H/2])
            sphere(1, $fn = 24);
}

module nose_cavity() {
    translate([0, SKULL_D * 0.45, -SKULL_H * 0.05])
        scale([NOSE_W/2, 5, NOSE_H/2])
            sphere(1, $fn = 20);
}

module teeth() {
    for (i = [-2 : 2]) {
        tw = (abs(i) == 2) ? 7 : 9;
        translate([i * 11, SKULL_D * 0.42, -SKULL_H * 0.3])
            hull() {
                cube([tw, 4, 2], center = true);
                translate([0, 0, -(8 + abs(i) * 2)])
                    cube([tw * 0.6, 3, 1], center = true);
            }
    }
}

module zygomatic_crack() {
    // Decorative crack lines on forehead
    for (side = [-1, 1])
        translate([side * SKULL_W * 0.15, SKULL_D * 0.35, SKULL_H * 0.25])
            rotate([80, 0, side * 20])
                cube([1.5, 1.5, 22], center = true);
}

difference() {
    union() {
        cranium();
        jaw();
        teeth();
    }
    // Eye sockets
    eye_socket(-1);
    eye_socket( 1);
    // Nose
    nose_cavity();
    // Top opening for planting
    translate([0, 0, SKULL_H * 0.3])
        cylinder(d = POT_D, h = SKULL_H, $fn = 48);
    // Hollow inside (preserve wall)
    scale([(SKULL_W - WALL_T*2) / SKULL_W,
           (SKULL_D - WALL_T*2) / SKULL_D,
           (SKULL_H - WALL_T*2) / SKULL_H])
        union() { cranium(); jaw(); }
    // Bottom drain hole
    translate([0, 0, -SKULL_H * 0.6])
        cylinder(d = 10, h = 20, $fn = 20);
    // Crack details
    zygomatic_crack();
}
