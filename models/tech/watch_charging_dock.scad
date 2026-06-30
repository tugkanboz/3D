// Apple Watch + AirPods Charging Dock — DUAL COLOR
// File: single color version (dual-color: dock_base + dock_accent)
// PETG — 0.2mm, 4 walls, 20% infill
// Channels for Apple Watch magnetic puck + AirPods flat charging
// Apple Watch band passes through slot below puck

WALL_T       = 3.0;
BASE_W       = 120;
BASE_D       = 80;
BASE_H       = 12;
WATCH_ANGLE  = 45;    // Watch face angle
POST_H       = 55;
PUCK_D       = 35.5;  // Apple Watch charger puck OD + play
PUCK_DEPTH   = 3.5;   // Puck sits this deep
CORD_D       = 4.5;   // Lightning / USB-C cord channel
BAND_SLOT_W  = 50;    // Band passes through here
BAND_SLOT_H  = 12;
PODS_W       = 62;    // AirPods case footprint
PODS_D       = 46;
PODS_H       = 3.5;   // Recessed pocket depth
CORNER_R     = 8;

module rounded_base(w, d, h, r) {
    minkowski() {
        cube([w - r*2, d - r*2, h - 1]);
        cylinder(r = r, h = 1, $fn = 24);
    }
}

module watch_post() {
    difference() {
        union() {
            // Angled post body
            rotate([-WATCH_ANGLE, 0, 0])
                cylinder(d = PUCK_D + WALL_T*2, h = POST_H, $fn = 32);
            // Fillet to base
            rotate([-WATCH_ANGLE * 0.5, 0, 0])
                cylinder(d = PUCK_D + WALL_T*3, h = 10, $fn = 32);
        }
        // Puck pocket at top of post
        rotate([-WATCH_ANGLE, 0, 0])
            translate([0, 0, POST_H - PUCK_DEPTH])
                cylinder(d = PUCK_D, h = PUCK_DEPTH + 1, $fn = 32);
        // Cord channel through post
        rotate([-WATCH_ANGLE, 0, 0])
            cylinder(d = CORD_D, h = POST_H + 2, $fn = 16);
        // Band slot
        translate([-BAND_SLOT_W/2, -1, -1])
            cube([BAND_SLOT_W, BASE_D, BAND_SLOT_H]);
    }
}

module airpods_pocket() {
    translate([BASE_W - PODS_W - WALL_T, (BASE_D - PODS_D)/2, BASE_H - PODS_H])
        difference() {
            cube([PODS_W, PODS_D, PODS_H + 1]);
            // Rounded corners
            for (x = [4, PODS_W - 4], y = [4, PODS_D - 4])
                translate([x, y, -1]) cylinder(r = 4, h = PODS_H + 3, $fn = 16);
        }
    // Cord exit hole
    translate([BASE_W - PODS_W/2 - WALL_T, BASE_D/2, -1])
        cylinder(d = CORD_D, h = BASE_H + 2, $fn = 16);
}

difference() {
    union() {
        translate([CORNER_R, CORNER_R, 0]) rounded_base(BASE_W, BASE_D, BASE_H, CORNER_R);
        translate([PUCK_D/2 + WALL_T * 2, BASE_D/2, BASE_H])
            watch_post();
    }
    // AirPods recess
    airpods_pocket();
    // Weight relief
    translate([CORNER_R + 4, CORNER_R + 4, 4])
        rounded_base(BASE_W - 8, BASE_D - 8, BASE_H, CORNER_R - 2);
    // Cable management slot on back
    translate([BASE_W/2 - 8, -1, 2])
        cube([16, WALL_T + 2, BASE_H]);
}
