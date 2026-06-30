// LEGO Minifigure Display Stand
// Holds 5 minifigs in a row, angled 10° back for display
// Print: 0.2mm, 3 walls, 15% infill, no supports needed

count     = 5;    // Number of minifig slots
tilt_deg  = 10;   // Backward tilt

SLOT_W  = 16.0;
SLOT_D  = 10.0;
SLOT_H  = 3.5;    // Depth minifig feet sink in
BASE_H  = 4.0;
WALL_T  = 2.0;
SPACING = 20.0;

total_W = count * SPACING + WALL_T * 2;
total_D = 60.0;
total_H = BASE_H + SLOT_H;

module slot() {
    translate([SPACING/2 - SLOT_W/2, WALL_T, BASE_H])
        cube([SLOT_W, SLOT_D, SLOT_H + 1]);
}

rotate([tilt_deg, 0, 0])
difference() {
    cube([total_W, total_D, total_H]);
    for (i = [0 : count - 1])
        translate([i * SPACING + WALL_T, 0, 0])
            slot();
}
