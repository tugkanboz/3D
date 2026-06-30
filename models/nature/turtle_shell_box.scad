// Turtle Shell Trinket Box - Hinged Lid
// PLA/PETG — lid and body print separately, hinge press-fits
// 0.2mm, 4 walls, 20% infill, no supports needed
// Great gift box for rings, SD cards, etc.

SHELL_D   = 100;
SHELL_H   = 55;
WALL_T    = 2.8;   // PLA: 2.8mm = sturdy shell
HINGE_D   = 5.0;
HINGE_PLAY= 0.5;   // PLA: wider than resin
SPLIT_Z   = SHELL_H * 0.55;  // Lid split height

// Hex scute pattern
SCUTE_R   = 18;
SCUTE_ROWS= 4;

module hex_scute(r, h_raise) {
    linear_extrude(h_raise)
        polygon([for (i=[0:5]) [r*cos(i*60+30), r*sin(i*60+30)]]);
}

module shell_solid() {
    scale([1, 1, 0.65])
        sphere(d = SHELL_D, $fn = 64);
}

module shell_hollow() {
    scale([1, 1, 0.65])
        sphere(d = SHELL_D - WALL_T*2, $fn = 64);
}

module scute_pattern() {
    for (lat = [-30, 0, 25, 45])
        for (lon = [0 : 60 : 300]) {
            r_at_lat = (SHELL_D/2) * cos(lat) * 0.62;
            z_at_lat = (SHELL_D/2) * 0.65 * sin(lat);
            translate([r_at_lat * cos(lon + lat*0.5),
                       r_at_lat * sin(lon + lat*0.5),
                       z_at_lat + 1])
                hex_scute(SCUTE_R * (0.5 + cos(lat)*0.5), 1.5);
        }
}

module hinge_pin() {
    cylinder(d = HINGE_D, h = 12, center = true, $fn = 20);
}

module hinge_socket() {
    cylinder(d = HINGE_D + HINGE_PLAY, h = 14, center = true, $fn = 20);
}

// Body (bottom)
module body() {
    difference() {
        intersection() {
            shell_solid();
            translate([-SHELL_D, -SHELL_D, -SHELL_D])
                cube([SHELL_D*2, SHELL_D*2, SPLIT_Z + SHELL_D]);
        }
        shell_hollow();
        // Hinge slot
        translate([-2, SHELL_D/2 - 4, SPLIT_Z - 8])
            hinge_socket();
    }
    // Flat rim
    translate([0, 0, SPLIT_Z - 0.5])
        cylinder(d = SHELL_D * 0.85, h = 1.5, $fn = 64);
}

// Lid (top)
module lid() {
    difference() {
        union() {
            intersection() {
                difference() {
                    shell_solid();
                    shell_hollow();
                }
                translate([-SHELL_D, -SHELL_D, SPLIT_Z - SHELL_D])
                    cube([SHELL_D*2, SHELL_D*2, SHELL_D*2]);
            }
            // Scute emboss on lid exterior
            intersection() {
                scute_pattern();
                translate([-SHELL_D, -SHELL_D, SPLIT_Z - SHELL_D])
                    cube([SHELL_D*2, SHELL_D*2, SHELL_D*2]);
            }
        }
        // Hinge pin hole
        translate([-2, SHELL_D/2 - 4, SPLIT_Z + 2])
            hinge_socket();
    }
    // Hinge pin
    translate([-2, SHELL_D/2 - 4, SPLIT_Z + 2])
        hinge_pin();
}

// Print layout
body();
translate([SHELL_D + 20, 0, SHELL_H - SPLIT_Z])
    rotate([180, 0, 0])
        lid();
