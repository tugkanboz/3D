// Advent Calendar Mini Box - Stackable, Numbered
// Print 24 copies (different number each) — sells as set
// PLA — 0.2mm, 3 walls, 15% infill
// Lid snaps on, hinged or separate

BOX_W   = 45;
BOX_D   = 45;
BOX_H   = 40;
LID_H   = 10;
WALL_T  = 2.0;
SNAP_H  = 3.0;
SNAP_D  = 3.5;
NUMBER  = 1;    // Change 1-24 for each box

module number_emboss(n) {
    // Simple raised digit — adjust translate per digit
    str_n = str(n);
    translate([BOX_W/2, BOX_D/2, BOX_H - WALL_T + 0.5])
        linear_extrude(1.5)
            text(str_n, size = 18, halign = "center", valign = "center",
                 font = "Liberation Sans:style=Bold");
}

module box_body() {
    difference() {
        cube([BOX_W, BOX_D, BOX_H]);
        translate([WALL_T, WALL_T, WALL_T])
            cube([BOX_W - WALL_T*2, BOX_D - WALL_T*2, BOX_H]);
        // Snap groove near top
        translate([-1, -1, BOX_H - LID_H - SNAP_H])
            cube([BOX_W + 2, BOX_D + 2, SNAP_H]);
    }
    // Snap bead
    translate([BOX_W/2, -1, BOX_H - LID_H - SNAP_H/2])
        rotate([-90, 0, 0])
            cylinder(d = SNAP_D, h = BOX_D + 2, $fn = 16);
}

module lid() {
    difference() {
        cube([BOX_W, BOX_D, LID_H + WALL_T]);
        // Inner socket
        translate([WALL_T - 0.3, WALL_T - 0.3, -1])
            cube([BOX_W - WALL_T*2 + 0.6, BOX_D - WALL_T*2 + 0.6, LID_H + 2]);
        // Snap groove to receive bead
        translate([-1, -1, WALL_T + 1])
            cube([BOX_W + 2, BOX_D + 2, SNAP_H + 0.3]);
    }
    // Number on lid top
    number_emboss(NUMBER);
    // Star decoration around number
    translate([BOX_W/2, BOX_D/2, LID_H + WALL_T - 0.4])
        linear_extrude(0.8)
            difference() {
                circle(r = 14, $fn = 5);
                circle(r = 10, $fn = 5);
            }
}

// Layout
box_body();
translate([BOX_W + 10, 0, 0]) lid();
