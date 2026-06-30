// Geometric Christmas Ornament - Icosphere Style
// PLA (silk filament = stunning) / PETG
// 0.15mm, 2 walls, 10% infill — lightweight
// Hook loop at top for hanging

STYLE   = "star";  // "sphere", "star", "snowflake"
SIZE    = 65;
WALL_T  = 1.8;     // Min 1.8mm PLA for strength
HOOK_D  = 4.0;
HOOK_H  = 12;
FACES   = 5;       // Pentagon faces for sphere

module hook_loop() {
    translate([0, 0, SIZE/2 + 2])
        difference() {
            cylinder(d = HOOK_D + 3, h = HOOK_H, $fn = 20);
            cylinder(d = HOOK_D, h = HOOK_H, $fn = 20);
            // Opening for hanging cord
            translate([-HOOK_D, 0, HOOK_H - 4])
                cube([HOOK_D * 2, HOOK_D * 2, 5]);
        }
}

module star_ornament() {
    // 6-pointed star body
    union() {
        // Central sphere
        sphere(d = SIZE * 0.5, $fn = 32);
        // Points
        for (lat = [-90, -30, 30, 90])
            for (lon = [0 : 60 : 300])
                rotate([lat, 0, lon])
                    translate([0, 0, SIZE * 0.18])
                        cylinder(d1 = SIZE * 0.12, d2 = SIZE * 0.025,
                                 h = SIZE * 0.32, $fn = 12);
        // Equatorial ring
        rotate_extrude($fn = 48)
            translate([SIZE * 0.24, 0])
                circle(r = SIZE * 0.04, $fn = 10);
    }
}

module snowflake_ornament() {
    // 2D snowflake extruded into thin disc ornament
    ARMS = 6;
    DEPTH = SIZE * 0.12;
    linear_extrude(DEPTH, center = true)
    union() {
        for (i = [0 : ARMS - 1])
            rotate([0, 0, i * 60]) {
                // Main arm
                polygon([
                    [-SIZE*0.025, 0], [SIZE*0.025, 0],
                    [SIZE*0.018, SIZE*0.45], [-SIZE*0.018, SIZE*0.45]
                ]);
                // Side branches
                for (d = [0.2, 0.35])
                    translate([0, SIZE * d, 0])
                        rotate([0, 0, 30])
                            polygon([
                                [-SIZE*0.015, 0], [SIZE*0.015, 0],
                                [SIZE*0.01, SIZE*0.12], [-SIZE*0.01, SIZE*0.12]
                            ]);
                for (d = [0.2, 0.35])
                    translate([0, SIZE * d, 0])
                        rotate([0, 0, -30])
                            polygon([
                                [-SIZE*0.015, 0], [SIZE*0.015, 0],
                                [SIZE*0.01, SIZE*0.12], [-SIZE*0.01, SIZE*0.12]
                            ]);
                // Center hex
                circle(r = SIZE * 0.06, $fn = 6);
            }
    }
}

module sphere_ornament() {
    difference() {
        sphere(d = SIZE, $fn = 48);
        sphere(d = SIZE - WALL_T*2, $fn = 48);
        // Star window pattern
        for (lat = [0, 60, -60])
            for (lon = [0 : 72 : 360])
                rotate([lat, lon, 0])
                    translate([0, 0, SIZE/2 - 2])
                        cylinder(d = SIZE * 0.15, h = SIZE, $fn = 5);
    }
}

if      (STYLE == "star")      { star_ornament();      hook_loop(); }
else if (STYLE == "snowflake") { snowflake_ornament();
    translate([0, 0, SIZE*0.06]) hook_loop(); }
else                           { sphere_ornament();    hook_loop(); }
