// Yin-Yang Phone Stand — DUAL COLOR
// File 2/2: Yang (light) half — e.g. white PLA
// Mirror of yin half — import both in BambuStudio

D     = 110;
THICK = 12;

module yang_half() {
    // Opposite half + opposite dot inclusions
    rotate([0, 0, 180])
    union() {
        rotate_extrude(angle = 180, $fn = 80)
            translate([D/4, 0])
                circle(r = D/4, $fn = 60);
        translate([0, D/4, 0])
            cylinder(d = D/4, h = THICK, $fn = 40);
        difference() {
            translate([0, -D/4, 0])
                cylinder(d = D/4, h = THICK, $fn = 40);
            translate([0, -D/4, -1])
                cylinder(d = D/8, h = THICK + 2, $fn = 30);
        }
    }
}

linear_extrude(THICK) yang_half();
