// LEGO Compatible Brick - Parametric
// Print settings: 0.2mm layer, 3 walls, 20% infill, no supports
// Tested on P2S

// ─── Parameters ───────────────────────────────────────────
studs_x = 2;   // Number of studs along X
studs_y = 4;   // Number of studs along Y
plates  = 3;   // Height in plate units (1 plate = 3.2mm, 3 plates = 1 brick)

// ─── LEGO constants (mm) ──────────────────────────────────
STUD_PITCH   = 8.0;
STUD_D       = 4.85;   // Slightly undersized for fit
STUD_H       = 1.8;
PLATE_H      = 3.2;
WALL_T       = 1.4;
TUBE_OD      = 6.51;
TUBE_ID      = 4.85;
PLAY         = 0.1;    // Clearance

// ─── Derived ──────────────────────────────────────────────
W  = studs_x * STUD_PITCH;
L  = studs_y * STUD_PITCH;
H  = plates  * PLATE_H;

module stud() {
    cylinder(d = STUD_D, h = STUD_H, $fn = 24);
}

module anti_stud_tube() {
    difference() {
        cylinder(d = TUBE_OD, h = H - WALL_T, $fn = 24);
        cylinder(d = TUBE_ID, h = H - WALL_T, $fn = 24);
    }
}

module brick() {
    difference() {
        // Outer shell
        cube([W, L, H]);
        // Hollow inside
        translate([WALL_T, WALL_T, WALL_T])
            cube([W - 2*WALL_T, L - 2*WALL_T, H]);
    }

    // Studs on top
    for (x = [0 : studs_x - 1])
        for (y = [0 : studs_y - 1])
            translate([STUD_PITCH/2 + x*STUD_PITCH, STUD_PITCH/2 + y*STUD_PITCH, H])
                stud();

    // Anti-stud tubes (only when inner grid exists)
    if (studs_x > 1 && studs_y > 1)
        for (x = [0 : studs_x - 2])
            for (y = [0 : studs_y - 2])
                translate([STUD_PITCH + x*STUD_PITCH, STUD_PITCH + y*STUD_PITCH, WALL_T])
                    anti_stud_tube();
}

brick();
