// LEGO Stud Keycap - MX Compatible
// Viral on social media, sells well as novelty
// Print: 0.15mm, 4 walls, 30% infill, no supports

MX_W       = 18.2;   // Cherry MX top size
MX_H       = 8.0;    // Keycap height
STEM_D_OD  = 5.5;    // MX stem outer
STEM_D_ID  = 4.0;    // MX stem inner (cross not modeled - use insert)
STEM_H     = 4.0;
WALL_T     = 1.5;
STUD_D     = 4.85;
STUD_H     = 1.8;

module mx_stem() {
    difference() {
        cylinder(d = STEM_D_OD, h = STEM_H, $fn = 24);
        cylinder(d = STEM_D_ID, h = STEM_H, $fn = 24);
    }
}

difference() {
    union() {
        // Keycap body
        hull() {
            cube([MX_W, MX_W, 2]);
            translate([1, 1, MX_H - 2])
                cube([MX_W - 2, MX_W - 2, 2]);
        }
        // LEGO stud on top
        translate([MX_W/2, MX_W/2, MX_H])
            cylinder(d = STUD_D, h = STUD_H, $fn = 24);
    }
    // MX stem socket (cylindrical — user can glue MX adapter or print cross separately)
    translate([MX_W/2, MX_W/2, -1])
        cylinder(d = STEM_D_OD + 0.3, h = STEM_H + 1, $fn = 24);
    // Hollow interior
    translate([WALL_T, WALL_T, WALL_T])
        cube([MX_W - 2*WALL_T, MX_W - 2*WALL_T, MX_H]);
}

// MX stem (print separately or together)
translate([MX_W/2, MX_W/2, WALL_T])
    mx_stem();
