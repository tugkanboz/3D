// Flexi Snake — DUAL COLOR
// File 2/2: Belly plates (Color 2 — cream/yellow PLA)
// Snaps into belly slots of snake_dual_color_body.scad
// P2S AMS: slot 2 = cream/light filament

SEGMENTS = 22;
GAP      = 0.45;
SEG_L    = 18;
SEG_W    = 12;   // Belly width (narrower than body)
SEG_H    = 3.5;  // Belly plate height
TAPER    = 0.96;

module belly_plate(i) {
    sf = pow(TAPER, i);
    w  = (SEG_W - 2) * sf;
    l  = SEG_L * sf * 0.85;

    // Flat belly plate with segmentation lines
    difference() {
        cube([l, w, SEG_H], center = true);
        // Transverse groove lines (segmented belly look)
        for (x = [-l/2 + 3 : 4 : l/2 - 3])
            translate([x, 0, SEG_H/2 - 0.6])
                cube([0.8, w + 1, 1], center = true);
    }
}

for (i = [0 : SEGMENTS-1])
    translate([i * (SEG_L + GAP*2), 0, 0])
        belly_plate(i);
