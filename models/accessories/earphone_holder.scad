// Earphone / AirPods Cable Holder - Desk Organizer
// Popular everyday print, good gift item
// Print: 0.2mm, 3 walls, 15% infill, no supports

BASE_D   = 60;
BASE_H   = 8;
POST_D   = 18;
POST_H   = 35;
ARM_L    = 22;
ARM_W    = 8;
ARM_H    = 5;
HOOK_D   = 12;
CABLE_D  = 6;

module base() {
    difference() {
        cylinder(d = BASE_D, h = BASE_H, $fn = 48);
        // Anti-slip grip grooves
        for (i = [0 : 11])
            rotate([0, 0, i * 30])
                translate([BASE_D/2 - 3, -1, 1])
                    cube([4, 2, BASE_H]);
    }
}

module post() {
    cylinder(d = POST_D, h = POST_H, $fn = 32);
}

module arm() {
    translate([-ARM_W/2, POST_D/2 - 2, POST_H - ARM_H])
        cube([ARM_L, ARM_W, ARM_H]);
}

module earhook() {
    translate([ARM_L - ARM_W/2, POST_D/2 + ARM_W - 2, POST_H - ARM_H])
        difference() {
            cylinder(d = HOOK_D, h = ARM_H, $fn = 24);
            cylinder(d = HOOK_D - ARM_W, h = ARM_H, $fn = 24);
            translate([-HOOK_D/2, -HOOK_D, -1])
                cube([HOOK_D, HOOK_D, ARM_H + 2]);
        }
}

module cable_slot() {
    translate([0, -POST_D/2 - 1, POST_H/2])
        rotate([-90, 0, 0])
            cylinder(d = CABLE_D, h = POST_D + 2, $fn = 20);
}

difference() {
    union() {
        base();
        post();
        arm();
        earhook();
    }
    cable_slot();
}
