// Interlocking Cross Puzzle - 6 Pieces
// Classic burr puzzle — fits together in only one way
// Print 6 copies (or 2 each of 3 variants)
// Print: 0.2mm, 3 walls, 20% infill, no supports
// Tolerances tuned for PLA — reduce gap 0.05 for resin

L     = 60;   // Piece length
W     = 20;   // Cross width
NOTCH = W / 2;
GAP   = 0.25; // Assembly clearance

module base_piece() {
    // + shaped cross-section, length L
    union() {
        cube([W, W, L], center = true);
        cube([W * 0.6, W * 3, L], center = true);
    }
}

// Piece A — straight through
module piece_A() {
    base_piece();
}

// Piece B — single notch
module piece_B() {
    difference() {
        base_piece();
        translate([0, 0, L/4])
            cube([W + 1, NOTCH + GAP, W + 1], center = true);
    }
}

// Piece C — double notch (the key piece)
module piece_C() {
    difference() {
        base_piece();
        translate([0, 0,  L/4]) cube([W + 1, NOTCH + GAP, W + 1], center = true);
        translate([0, 0, -L/4]) cube([NOTCH + GAP, W + 1, W + 1], center = true);
    }
}

// Layout all 6 pieces for printing
translate([-70,  0, 0]) piece_A();
translate([-70, 30, 0]) piece_A();
translate([  0,  0, 0]) piece_B();
translate([  0, 30, 0]) piece_B();
translate([ 70,  0, 0]) piece_C();
translate([ 70, 30, 0]) piece_C();
