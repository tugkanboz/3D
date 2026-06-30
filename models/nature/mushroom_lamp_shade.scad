// Mushroom Lamp Shade - Fairy Tale Style
// Fits standard E14 candelabra bulb socket
// PETG (semi-translucent) or white PLA — light glows through
// 0.2mm, 2 walls, 0% infill — wall acts as diffuser
// Trending: cottagecore, fairy, nature aesthetic

CAP_D      = 140;
CAP_H      = 60;
STALK_D    = 38;
STALK_H    = 50;
WALL_T     = 2.0;   // Thin = more light through; min 1.8mm for PLA
SOCKET_D   = 32;    // E14 socket diameter + clearance
SPOT_N     = 8;     // Number of white spots on cap
SPOT_D     = 22;

module cap() {
    difference() {
        union() {
            // Cap dome — squashed sphere
            scale([1, 1, 0.55])
                sphere(d = CAP_D, $fn = 72);
            // Rolled edge (gills suggestion)
            translate([0, 0, -CAP_H * 0.28])
                rotate_extrude($fn = 72)
                    translate([CAP_D/2 - 8, 0])
                        scale([1, 1.6])
                            circle(d = 16, $fn = 20);
        }
        // Hollow inside
        scale([1, 1, 0.55])
            sphere(d = CAP_D - WALL_T*2, $fn = 72);
        // Bottom opening for light/stalk
        translate([0, 0, -CAP_D])
            cylinder(d = STALK_D + 2, h = CAP_D, $fn = 32);
        // Decorative spots (raised bumps cut from inside = thin wall = glows)
        for (i = [0 : SPOT_N - 1]) {
            angle = i * 360 / SPOT_N + 15;
            translate([
                CAP_D * 0.28 * cos(angle),
                CAP_D * 0.28 * sin(angle),
                CAP_H * 0.15
            ])
                scale([1, 1, 0.4])
                    sphere(d = SPOT_D, $fn = 20);
        }
        // Top spot
        translate([0, 0, CAP_H * 0.35])
            scale([1, 1, 0.4])
                sphere(d = SPOT_D * 0.8, $fn = 20);
    }
}

module stalk() {
    difference() {
        union() {
            cylinder(d1 = STALK_D * 1.3, d2 = STALK_D, h = STALK_H, $fn = 40);
            // Flared base skirt
            cylinder(d1 = STALK_D * 2.2, d2 = STALK_D * 1.3, h = 12, $fn = 40);
        }
        // Hollow — light passes through stalk into cap
        translate([0, 0, -1])
            cylinder(d = SOCKET_D, h = STALK_H + 2, $fn = 32);
    }
}

translate([0, 0, STALK_H]) cap();
stalk();
