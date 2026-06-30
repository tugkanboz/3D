// Magnetic Spice Jar Lid — Fridge-Mount
// Jar lid snaps onto standard spice jar, magnet holds to fridge
// PETG — 0.2mm, 4 walls, 25% infill
// Hardware: 1x N52 neodymium magnet 20x3mm per lid

JAR_D      = 52;    // Standard spice jar neck OD — adjust!
JAR_PLAY   = 0.8;   // Fit tolerance — increase if too tight
LID_H      = 22;
WALL_T     = 2.8;
MAGNET_D   = 20.5;  // 20mm + 0.5 clearance
MAGNET_H   = 3.2;   // 3mm + 0.2
THREAD_PITCH = 3.0; // Approximate thread pitch (no real threading — friction fit)

module jar_lid() {
    difference() {
        union() {
            // Outer body — slightly domed top
            hull() {
                cylinder(d = JAR_D + WALL_T*2, h = LID_H - 4, $fn = 48);
                translate([0, 0, LID_H - 4])
                    cylinder(d = JAR_D + WALL_T*2 - 4, h = 4, $fn = 48);
            }
        }
        // Inner socket for jar neck
        translate([0, 0, -1])
            cylinder(d = JAR_D + JAR_PLAY, h = LID_H - 6, $fn = 48);
        // Magnet pocket in top (press-fit, add drop of CA glue)
        translate([0, 0, LID_H - MAGNET_H - 0.5])
            cylinder(d = MAGNET_D, h = MAGNET_H + 1, $fn = 32);
        // Grip ridges (subtract)
        for (i = [0:11])
            rotate([0, 0, i*30])
                translate([JAR_D/2 + WALL_T - 1, -1, 4])
                    cube([2, 2, LID_H - 8]);
    }
    // Inner friction ring (holds jar)
    translate([0, 0, LID_H - 8])
        difference() {
            cylinder(d = JAR_D + JAR_PLAY - 1, h = 4, $fn = 48);
            cylinder(d = JAR_D + JAR_PLAY - 3, h = 5, $fn = 48);
        }
}

jar_lid();
