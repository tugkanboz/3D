// Enchanted Forest Portal Book Nook — Fairy Tale Scene
// Glowing mushrooms, twisted trees, depth-illusion mirror back
// DUAL COLOR: tree trunks + frame (dark brown) | mushrooms + leaves (bright)
// PLA — 0.15mm, 4 walls, 15% infill
// Hardware: 5V micro-LED fairy lights (press into mushroom holes)

NOOK_W   = 72;
NOOK_D   = 110;
NOOK_H   = 195;
WALL_T   = 3.5;
ARCH_W   = 46;
ARCH_H   = 60;

// ── Frame arch (portal entrance) ──────────────────────
module portal_arch() {
    difference() {
        cube([NOOK_W, WALL_T, NOOK_H]);
        // Gothic pointed arch opening
        translate([NOOK_W/2 - ARCH_W/2, -1, 0]) {
            cube([ARCH_W, WALL_T + 2, ARCH_H * 0.7]);
            // Pointed top (lancet arch)
            translate([ARCH_W/2, 0, ARCH_H * 0.7])
                rotate([90, 0, 0])
                    cylinder(d = ARCH_W, h = WALL_T + 2, $fn = 32);
            translate([0, 0, ARCH_H * 0.7])
                rotate([90, 0, 0])
                    cylinder(d = ARCH_W * 1.2, h = WALL_T + 2, $fn = 32);
        }
    }
    // Vine + leaf border around arch
    for (side = [-1, 1])
        translate([NOOK_W/2 + side * ARCH_W/2, WALL_T, ARCH_H * 0.3])
            for (z = [0, 25, 50, 75])
                translate([0, 0, z]) {
                    sphere(d = 7 + sin(z * 5) * 2, $fn = 12);
                    rotate([0, 0, z * 15])
                        translate([4, 0, 0])
                            scale([1.5, 0.8, 0.3])
                                sphere(d = 8, $fn = 10);
                }
}

// ── Side walls ────────────────────────────────────────
module side_walls() {
    cube([WALL_T, NOOK_D, NOOK_H]);
    translate([NOOK_W - WALL_T, 0, 0])
        cube([WALL_T, NOOK_D, NOOK_H]);
    // Floor
    cube([NOOK_W, NOOK_D, WALL_T]);
    // Ceiling
    translate([0, 0, NOOK_H - WALL_T])
        cube([NOOK_W, NOOK_D, WALL_T]);
}

// ── Twisted tree trunks ───────────────────────────────
module twisted_trunk(x, d, h, twist_angle) {
    translate([x, WALL_T + 5, WALL_T])
        rotate([90, 0, 0])
            rotate([0, 0, 0])
                difference() {
                    linear_extrude(height = h, twist = twist_angle, $fn = 20)
                        polygon([for (i = [0:5])
                            let(a = i * 60, r = d/2 * (0.7 + 0.3 * sin(a * 2.5)))
                            [r * cos(a), r * sin(a)]
                        ]);
                    // Hollow core
                    cylinder(d = d * 0.4, h = h + 1, $fn = 12);
                }
}

// ── Mushrooms (Color 2 — glowing) ─────────────────────
module mushroom(x, y, stem_h, cap_d, cap_color_idx) {
    translate([x, y, WALL_T]) {
        // Stem
        cylinder(d = cap_d * 0.3, h = stem_h, $fn = 12);
        // Cap
        translate([0, 0, stem_h])
            difference() {
                scale([1, 1, 0.5])
                    sphere(d = cap_d, $fn = 20);
                translate([0, 0, -cap_d/2])
                    cube([cap_d * 2, cap_d * 2, cap_d/2], center = true);
            }
        // Spots on cap
        for (a = [0, 60, 120, 180, 240, 300], r = [cap_d * 0.2])
            translate([r * cos(a), r * sin(a), stem_h + cap_d * 0.15])
                cylinder(d = cap_d * 0.12, h = 2, $fn = 8);
        // LED socket (hollow stem)
        cylinder(d = 3.5, h = stem_h + 1, $fn = 10);
    }
}

// ── Ground cover (moss + roots) ───────────────────────
module ground_detail() {
    // Root bumps
    for (i = [0:8]) {
        x = 8 + i * 8;
        y = WALL_T + 5 + sin(i * 37) * 15;
        translate([x, y, WALL_T])
            scale([3, 1, 0.5])
                sphere(d = 5, $fn = 10);
    }
    // Moss patches
    for (i = [0:5])
        translate([10 + i * 10, NOOK_D * 0.4 + sin(i * 50) * 10, WALL_T])
            cylinder(d = 8 + sin(i * 30) * 3, h = 2, $fn = 8);
}

// ── Mirror backing frame (creates depth illusion) ──────
module mirror_frame() {
    translate([2, NOOK_D - WALL_T, 2])
        difference() {
            cube([NOOK_W - 4, WALL_T - 1, NOOK_H - 4]);
            // Mirror recess (glue 3mm mirror here)
            translate([3, -0.5, 3])
                cube([NOOK_W - 10, WALL_T, NOOK_H - 10]);
        }
}

// Color 1 (brown): frame + walls + trunks
portal_arch();
side_walls();
twisted_trunk(NOOK_W * 0.15, 14, NOOK_H * 0.85, 80);
twisted_trunk(NOOK_W * 0.75, 11, NOOK_H * 0.7, -60);
twisted_trunk(NOOK_W * 0.45, 8, NOOK_H * 0.55, 45);
ground_detail();
mirror_frame();

// Color 2 (bright): mushrooms + vine leaves
mushroom(12, 20, 18, 20, 0);
mushroom(28, 35, 12, 14, 1);
mushroom(50, 25, 22, 18, 0);
mushroom(60, 15, 10, 12, 1);
mushroom(36, 60, 28, 24, 0);
