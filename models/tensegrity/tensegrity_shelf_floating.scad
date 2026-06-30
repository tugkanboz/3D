// Tensegrity Floating Shelf — Wall Art + Functional Shelf
// Appears to defy gravity; holds ~500g of small items
// DUAL COLOR: shelf + wall bracket (dark) | tension nodes (bright)
// Hardware: 4x 1.5mm steel cable + ferrules (crimped)
// PETG — 0.2mm, 4 walls, 25% infill (needs strength)

SHELF_W  = 200;
SHELF_D  = 70;
SHELF_H  = 12;
BRKT_W   = 180;
BRKT_H   = 150;
BRKT_D   = 18;
CABLE_D  = 2.0;    // 1.5mm cable + tolerance
NODE_D   = 16;
WALL     = 4.0;
R        = 6;

// ── Floating shelf ───────────────────────────────────
module shelf() {
    difference() {
        hull() {
            cube([SHELF_W, SHELF_D, SHELF_H - 4]);
            translate([R, R, SHELF_H - 4])
                minkowski() {
                    cube([SHELF_W - R*2, SHELF_D - R*2, 1]);
                    cylinder(r = R, h = 1, $fn = 20);
                }
        }
        // Cable holes (4, near corners)
        for (x = [20, SHELF_W - 20], y = [15, SHELF_D - 15])
            translate([x, y, -1])
                cylinder(d = CABLE_D + 0.3, h = SHELF_H + 2, $fn = 12);
        // Lightweight rib cutouts (underside)
        for (i = [1:3])
            translate([SHELF_W * i/4 - 15, 8, -1])
                cube([30, SHELF_D - 16, SHELF_H - 4]);
    }
}

// ── Wall bracket ─────────────────────────────────────
module wall_bracket() {
    difference() {
        union() {
            // Back plate (mounts to wall)
            cube([BRKT_W, BRKT_D, BRKT_H]);
            // Cable anchor nodes (4 points)
            for (x = [20, BRKT_W - 20], z = [20, BRKT_H - 20])
                translate([x, BRKT_D, z])
                    rotate([-90, 0, 0])
                        difference() {
                            sphere(d = NODE_D, $fn = 18);
                            cylinder(d = CABLE_D + 0.3, h = NODE_D + 1,
                                     center = true, $fn = 10);
                            rotate([90, 0, 0])
                                cylinder(d = CABLE_D + 0.3, h = NODE_D + 1,
                                         center = true, $fn = 10);
                        }
        }
        // Wall screw holes
        for (x = [BRKT_W * 0.2, BRKT_W * 0.5, BRKT_W * 0.8])
            translate([x, -1, BRKT_H/2])
                rotate([-90, 0, 0])
                    cylinder(d = 5, h = BRKT_D + 2, $fn = 16);
        // Weight reduction pockets
        translate([10, 4, 10])
            cube([BRKT_W - 20, BRKT_D - 8, BRKT_H - 20]);
    }
}

shelf();
translate([0, SHELF_D + 30, 0]) wall_bracket();
