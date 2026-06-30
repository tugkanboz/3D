// Cat Puzzle Feeder — Slow-Feed, Anti-Boredom
// Labyrinth cats must paw kibble through — slows eating
// PETG (food-safe-ish, easy to clean) — 0.2mm, 4 walls, 20% infill
// No supports needed — all walls < 45°

D        = 220;   // Bowl diameter
H        = 35;    // Bowl height
WALL_T   = 3.5;
MAZE_H   = 28;    // Maze wall height
MAZE_T   = 4.0;   // Maze wall thickness
PORE_D   = 28;    // Kibble hole diameter (size M kibble ≈ 8mm)

module outer_bowl() {
    difference() {
        cylinder(d = D, h = H, $fn = 64);
        translate([0, 0, WALL_T])
            cylinder(d = D - WALL_T*2, h = H, $fn = 64);
        // Anti-tip feet cutout
        translate([0, 0, -1])
            cylinder(d = D - 30, h = WALL_T + 2, $fn = 64);
    }
    // Anti-tip rubber-grip feet ring
    translate([0, 0, 0])
        difference() {
            cylinder(d = D - 10, h = 3, $fn = 64);
            cylinder(d = D - 30, h = 4, $fn = 64);
        }
}

module maze_wall(r, arc_start, arc_end, h) {
    rotate([0, 0, arc_start])
        rotate_extrude(angle = arc_end - arc_start, $fn = 64)
            translate([r, 0])
                square([MAZE_T, h]);
}

module paw_holes(r) {
    for (a = [0 : 60 : 300])
        rotate([0, 0, a]) translate([r, 0, -1])
            cylinder(d = PORE_D, h = H + 2, $fn = 24);
}

difference() {
    union() {
        outer_bowl();
        // Concentric maze rings
        translate([0, 0, WALL_T]) {
            maze_wall(75,   0,   250, MAZE_H);
            maze_wall(55, 110,   360, MAZE_H);
            maze_wall(38,   0,   200, MAZE_H * 0.7);
            maze_wall(22, 160,   350, MAZE_H * 0.5);
            // Center post
            cylinder(d = 16, h = MAZE_H, $fn = 20);
        }
    }
    // Kibble entry holes at each ring gap
    paw_holes(65);
    paw_holes(46);
    paw_holes(30);
    // Logo / brand area on rim (flat)
    translate([0, D/2 - 18, H - 3])
        linear_extrude(4)
            text("CAT", size = 10, halign = "center", font = "Liberation Sans:style=Bold");
}
