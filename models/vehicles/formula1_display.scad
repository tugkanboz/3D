// Formula 1 Car Display Model - Decorative / Gift
// 1:43 scale rough approximation
// Print: 0.15mm, 4 walls, 20% infill, supports for underside

LENGTH = 110;
WIDTH  = 48;
NOSE_L = 30;

module nosecone() {
    hull() {
        translate([0, WIDTH/2, 3]) sphere(d = 4, $fn = 20);
        translate([NOSE_L, WIDTH/2 - 6, 2]) cube([1, 12, 4]);
    }
}

module cockpit() {
    translate([NOSE_L + 10, WIDTH/2 - 8, 4])
        hull() {
            cube([24, 16, 2]);
            translate([4, 2, 8]) cube([16, 12, 2]);
        }
}

module sidepod() {
    hull() {
        translate([NOSE_L, 0, 1]) cube([50, 6, 8]);
        translate([NOSE_L + 10, 0, 0]) cube([30, 8, 4]);
    }
}

module rear_wing() {
    translate([LENGTH - 14, 4, 20]) {
        cube([4, WIDTH - 8, 14]);   // main plane
        translate([-2, 0, 14]) cube([8, WIDTH - 8, 3]); // upper flap
    }
}

module front_wing() {
    translate([-8, 2, 1]) {
        cube([10, WIDTH - 4, 2]);   // main plane
        translate([0, 4, 2]) cube([10, WIDTH - 12, 2]); // upper flap
    }
}

module wheel_assembly(pos) {
    translate(pos)
        rotate([0, 90, 0])
            difference() {
                cylinder(d = 18, h = 10, $fn = 36);
                cylinder(d = 8, h = 10, $fn = 20);
            }
}

union() {
    // Main body
    hull() {
        translate([NOSE_L, 6, 0]) cube([LENGTH - NOSE_L - 10, WIDTH - 12, 8]);
        translate([NOSE_L + 5, 3, 0]) cube([LENGTH - NOSE_L - 20, WIDTH - 6, 6]);
    }

    nosecone();
    cockpit();
    sidepod();
    mirror([0, 1, 0]) translate([0, -WIDTH, 0]) sidepod();
    rear_wing();
    front_wing();

    // Wheels
    wheel_assembly([-8, 8, 0]);
    wheel_assembly([-8, WIDTH - 18, 0]);
    wheel_assembly([LENGTH - 20, 2, 0]);
    wheel_assembly([LENGTH - 20, WIDTH - 12, 0]);
}
