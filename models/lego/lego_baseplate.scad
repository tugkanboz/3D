// LEGO Compatible Baseplate - 32x32
// Print settings: 0.15mm layer, 4 walls, 20% infill
// Best printed flat on bed

studs_x = 32;
studs_y = 32;

STUD_PITCH = 8.0;
STUD_D     = 4.85;
STUD_H     = 1.8;
BASE_H     = 3.2;
WALL_T     = 1.4;

W = studs_x * STUD_PITCH;
L = studs_y * STUD_PITCH;

module stud() {
    cylinder(d = STUD_D, h = STUD_H, $fn = 20);
}

union() {
    // Base slab
    cube([W, L, BASE_H]);

    // Studs
    for (x = [0 : studs_x - 1])
        for (y = [0 : studs_y - 1])
            translate([STUD_PITCH/2 + x*STUD_PITCH, STUD_PITCH/2 + y*STUD_PITCH, BASE_H])
                stud();
}
