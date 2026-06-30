// Flip Book Stand + Page Turner Mechanism
// Spring-loaded thumb lever flips pages at consistent speed
// DUAL COLOR: frame (dark wood PLA) + lever + spring seat (accent)
// PLA — 0.2mm, 4 walls, 20% infill
// Hardware: 1x M3x20 bolt pivot, 1x guitar string spring

BOOK_W   = 105;  // Standard flip book width
BOOK_H   = 148;  // A6 / standard flip book height
BOOK_T   = 20;   // Book thickness (stack of pages)
FRAME_T  = 5.0;  // Frame wall thickness
BASE_H   = 12;
TILT     = 20;   // Book tilt angle (degrees)
LEVER_L  = 55;   // Thumb lever length
LEVER_W  = 18;
LEVER_T  = 6.0;
PIVOT_D  = 3.5;  // M3 pivot
SPRING_D = 8;    // Spring seat diameter
PAGE_SEP = 1.0;  // Page separator rib gap

module frame_back() {
    // Back plate that holds the book
    difference() {
        cube([BOOK_W + FRAME_T*2, BOOK_H + FRAME_T*2, FRAME_T]);
        // Book window (recessed)
        translate([FRAME_T, FRAME_T, 1])
            cube([BOOK_W, BOOK_H, FRAME_T]);
        // Corner screw holes
        for (x = [5, BOOK_W + FRAME_T*2 - 5],
             y = [5, BOOK_H + FRAME_T*2 - 5])
            translate([x, y, -1])
                cylinder(d = 3.5, h = FRAME_T + 2, $fn = 12);
    }
    // Spine clamp (holds left edge of book)
    translate([0, FRAME_T, FRAME_T])
        cube([FRAME_T * 1.5, BOOK_H, 8]);
}

module base_stand() {
    // Tilted wedge base
    difference() {
        hull() {
            cube([BOOK_W + FRAME_T*2, BASE_H, BASE_H]);
            translate([0, BASE_H + (BOOK_H + FRAME_T*2) * sin(TILT),
                       (BOOK_H + FRAME_T*2) * cos(TILT)])
                cube([BOOK_W + FRAME_T*2, 2, 2]);
        }
        // Weight reduction
        translate([FRAME_T + 4, 4, 4])
            cube([BOOK_W - 8, BASE_H + 20, BASE_H + 5]);
        // Anti-slip pad recesses (feet)
        for (x = [8, BOOK_W + FRAME_T*2 - 18])
            translate([x, 2, -0.5])
                cube([10, 8, 3]);
    }
}

module thumb_lever() {
    // Spring-loaded page flipper
    difference() {
        union() {
            // Lever arm
            hull() {
                cylinder(d = LEVER_W, h = LEVER_T, $fn = 20);
                translate([LEVER_L, 0, 0])
                    cylinder(d = LEVER_W * 0.5, h = LEVER_T, $fn = 16);
            }
            // Thumb groove pad
            translate([LEVER_L * 0.65, 0, LEVER_T])
                cylinder(d = LEVER_W * 0.8, h = 3, $fn = 20);
        }
        // Pivot hole
        cylinder(d = PIVOT_D, h = LEVER_T + 1, $fn = 14);
        // Spring tension slot
        translate([0, 0, LEVER_T/2])
            rotate([90, 0, 0])
                cylinder(d = SPRING_D, h = LEVER_W + 1, center = true, $fn = 16);
        // Thumb grip knurling
        for (i = [0:5])
            translate([LEVER_L * 0.6 + i * 4 - 8, -LEVER_W/2, LEVER_T - 0.5])
                cube([2, LEVER_W, 4]);
    }
    // Page separator fins (peels one page at a time)
    translate([LEVER_L - 12, -LEVER_W/4, 0])
        for (i = [0:2])
            translate([0, 0, -i * PAGE_SEP - 2])
                hull() {
                    cube([12, LEVER_W/2, 1]);
                    translate([14, LEVER_W/4, -1])
                        cylinder(d = 2, h = 1, $fn = 8);
                }
}

module pivot_bracket() {
    // Mounts lever to frame side
    difference() {
        cube([12, LEVER_W + 8, 20]);
        translate([3, 4, 10])
            rotate([0, 90, 0])
                cylinder(d = PIVOT_D, h = 10, $fn = 14);
        // Lever slot
        translate([3, 4, -1])
            cube([8, LEVER_W, 12]);
    }
}

// Color 1 (wood PLA): frame + base
frame_back();
base_stand();
// Color 2 (accent): lever + bracket
translate([BOOK_W + FRAME_T*2 + 15, 0, 0]) {
    thumb_lever();
    translate([0, LEVER_W + 10, 0]) pivot_bracket();
}
