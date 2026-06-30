// Honeycomb Wall Shelf - Modular, Stackable
// Each cell is a standalone shelf — mount as many as you want
// Print: 0.2mm, 4 walls, 20% infill, no supports (print hex face-down)
// Mounting: 2x M4 screws through back wall

CELL_R   = 70;    // Hex cell radius (center to vertex)
DEPTH    = 80;    // Shelf depth
WALL_T   = 3.5;
BACK_T   = 4.0;
SCREW_D  = 4.5;
SCREW_OFFSET = 20;

// Regular hexagon
module hex_prism(r, h) {
    linear_extrude(h)
        polygon([for (i=[0:5]) [r * cos(i*60), r * sin(i*60)]]);
}

module honeycomb_cell() {
    difference() {
        // Outer hex
        rotate([90, 0, 0])
            hex_prism(CELL_R, DEPTH + BACK_T);

        // Inner cavity (the shelf space)
        rotate([90, 0, 0])
            translate([0, 0, BACK_T])
                hex_prism(CELL_R - WALL_T, DEPTH + 1);

        // Open front face
        translate([-(CELL_R + 1), -(CELL_R + 1), -1])
            cube([CELL_R * 2 + 2, CELL_R * 2 + 2, WALL_T]);

        // Screw holes through back wall
        for (s = [-1, 1])
            translate([s * SCREW_OFFSET, 0, -(BACK_T + 1)])
                cylinder(d = SCREW_D, h = BACK_T + 2, $fn = 20);
    }
}

honeycomb_cell();
