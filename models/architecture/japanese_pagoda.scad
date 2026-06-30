// 5-Story Japanese Pagoda - Desk Sculpture
// PLA — 0.15mm, 3 walls, 20% infill
// Prints in sections or as one piece with supports at eaves
// Inspired by Nikko / Kyoto temple architecture

STORIES   = 5;
BASE_W    = 90;
TAPER     = 0.78;   // Each story shrinks
STORY_H   = 32;
EAVE_OVERHANG = 14; // How far roof extends beyond walls
WALL_T    = 2.5;
ROOF_H    = 16;
FINIAL_H  = 40;

module roof_eave(w, h) {
    // Upturned corners — traditional pagoda curve
    linear_extrude(h)
        polygon([
            [-w/2 - EAVE_OVERHANG, 0],
            [ w/2 + EAVE_OVERHANG, 0],
            [ w/2 + EAVE_OVERHANG * 1.3, -4],  // upturn
            [ w/2, -h * 0.3],
            [-w/2, -h * 0.3],
            [-w/2 - EAVE_OVERHANG * 1.3, -4],
            [-w/2 - EAVE_OVERHANG, 0]
        ]);
}

module story_walls(w, h) {
    difference() {
        cube([w, w, h], center = true);
        cube([w - WALL_T*2, w - WALL_T*2, h + 1], center = true);
    }
}

module window(w, h) {
    translate([0, 0, 0])
    difference() {
        cube([w, 2, h], center = true);
        // Arched top
        translate([0, 0, h/2 - w/4])
            rotate([90, 0, 0])
                cylinder(d = w, h = 3, center = true, $fn = 20);
    }
}

module balcony_rail(w) {
    difference() {
        cube([w + 8, w + 8, 6], center = true);
        cube([w + 4, w + 4, 7], center = true);
    }
    // Rail posts
    for (x = [-w/2 - 2, w/2 + 2], y = [-w/2 - 2 : 8 : w/2 + 2])
        translate([x, y, 3]) cylinder(d = 2, h = 4, $fn = 8);
    for (y = [-w/2 - 2, w/2 + 2], x = [-w/2 - 2 : 8 : w/2 + 2])
        translate([x, y, 3]) cylinder(d = 2, h = 4, $fn = 8);
}

module pagoda() {
    for (i = [0 : STORIES - 1]) {
        w = BASE_W * pow(TAPER, i);
        z = i * (STORY_H + ROOF_H);

        translate([0, 0, z]) {
            // Walls
            story_walls(w, STORY_H);

            // Windows on each face
            for (rot = [0, 90, 180, 270])
                rotate([0, 0, rot])
                    translate([0, w/2, 0])
                        window(w * 0.3, STORY_H * 0.6);

            // Balcony
            translate([0, 0, -3]) balcony_rail(w);

            // Roof
            translate([0, 0, STORY_H]) {
                // Roof body (hip roof shape)
                hull() {
                    cube([w + EAVE_OVERHANG*2, w + EAVE_OVERHANG*2, 2], center = true);
                    translate([0, 0, ROOF_H])
                        cube([w * 0.3, w * 0.3, 2], center = true);
                }
                // Eave corners upturn detail
                for (r = [0, 90, 180, 270])
                    rotate([0, 0, r + 45])
                        translate([w/2 + 2, 0, 2])
                            rotate([0, -15, 0])
                                cube([EAVE_OVERHANG * 0.7, 3, 3]);
            }
        }
    }

    // Central finial / sorin
    top_w = BASE_W * pow(TAPER, STORIES);
    total_h = STORIES * (STORY_H + ROOF_H);
    translate([0, 0, total_h]) {
        cylinder(d1 = top_w * 0.3, d2 = 4, h = FINIAL_H, $fn = 16);
        // Rings on spire
        for (z = [8, 16, 24])
            translate([0, 0, z])
                cylinder(d1 = 10, d2 = 8, h = 3, $fn = 20);
        translate([0, 0, FINIAL_H])
            sphere(d = 8, $fn = 16);
    }
}

pagoda();
