// Sugar Skull — Día de los Muertos Art Object / Planter
// Richly decorated with flowers, geometric patterns, scrollwork
// DUAL COLOR: skull base (white/cream) | decorations (vibrant color)
// PLA — 0.15mm, 4 walls, 20% infill
// ~120mm tall — striking centerpiece or succulent planter

SC = 1.2;   // Scale factor

// ── Base skull form ───────────────────────────────────
module skull_base() {
    union() {
        // Cranium
        translate([0, 0, 55*SC]) scale([1, 0.85, 1]) sphere(d = 95*SC, $fn = 48);
        // Cheeks (rounded)
        for (sx=[-1,1]) translate([sx*38*SC, 8*SC, 38*SC])
            scale([0.55,0.45,0.65]) sphere(d=55*SC, $fn=20);
        // Jaw
        translate([0, 12*SC, 18*SC]) scale([0.78, 0.5, 0.58]) sphere(d=65*SC, $fn=28);
        // Chin
        translate([0, 15*SC, 5*SC]) scale([0.55,0.42,0.4]) sphere(d=48*SC, $fn=20);
    }
}

// ── Hollow skull (planter) ────────────────────────────
module hollow_skull() {
    difference() {
        skull_base();
        scale(0.86) skull_base();
        // Planter opening (top)
        translate([0, -5*SC, 90*SC]) sphere(d=50*SC, $fn=24);
        // Eye sockets
        for (sx=[-1,1]) translate([sx*27*SC, -15*SC, 52*SC])
            scale([1.15,0.75,0.9]) sphere(d=28*SC, $fn=22);
        // Nasal hole
        translate([0,-20*SC, 42*SC]) scale([0.6,0.5,0.8]) sphere(d=18*SC, $fn=16);
        // Drainage (base)
        translate([0, 8*SC, -1]) cylinder(d=8*SC, h=6, $fn=14);
    }
}

// ── Decorative elements (Color 2 — vibrant) ──────────
module flower(cx, cy, cz, r) {
    translate([cx, cy, cz]) {
        // Petals
        for (i=[0:7]) rotate([0,0,i*45])
            translate([r*0.6,0,0]) scale([1,0.7,0.4]) sphere(d=r, $fn=12);
        // Center
        sphere(d=r*0.6, $fn=14);
    }
}

module scroll_band(r, z, w, n_repeats) {
    for (i=[0:n_repeats-1]) {
        a = i * 360/n_repeats;
        translate([r*cos(a)*SC, r*sin(a)*SC, z*SC])
            rotate([0,0,a]) {
                // S-curve scroll (simplified)
                for (ta=[0:15:90])
                    translate([0, ta*0.08*SC, 0])
                        rotate([0,0,ta])
                            cube([w*SC, w*0.4*SC, 2*SC], center=true);
            }
    }
}

module eye_decorations() {
    for (sx=[-1,1]) {
        // Rose around each eye socket
        for (petal=[0:7])
            rotate([0,0,petal*45])
                translate([sx*27*SC + cos(petal*45)*18*SC, -15*SC + sin(petal*45)*14*SC, 52*SC])
                    scale([1,0.7,0.3]) sphere(d=10*SC, $fn=10);
        // Eyelash bars
        for (i=[-2:2])
            translate([sx*27*SC + i*5*SC, -27*SC, 52*SC])
                cube([2*SC, 12*SC, 1.5*SC], center=true);
    }
}

module forehead_diamond() {
    translate([0,-18*SC, 82*SC])
        rotate([90,0,0]) {
            // Central diamond
            cylinder(d=18*SC, h=2*SC, $fn=4);
            // Surrounding dots
            for (i=[0:7]) rotate([0,0,i*45])
                translate([12*SC,0,0]) sphere(d=4*SC, $fn=10);
        }
}

module teeth_row() {
    for (i=[-3:3])
        translate([i*7*SC, 20*SC, 10*SC]) {
            cylinder(d1=6*SC, d2=5*SC, h=10*SC, $fn=6);
            translate([0,0,-8*SC]) cylinder(d1=5*SC, d2=5.5*SC, h=8*SC, $fn=6);
        }
}

module nose_heart() {
    translate([0,-20*SC,42*SC]) rotate([90,0,0]) scale([0.5,0.5,0.2]) {
        translate([-5,3,0]) sphere(d=10*SC,$fn=12);
        translate([5,3,0]) sphere(d=10*SC,$fn=12);
        cylinder(d1=10*SC, d2=0, h=8*SC, $fn=3);
    }
}

// Color 1 (cream white): skull
hollow_skull();
// Color 2 (vibrant): decorations
// Flowers on cheeks and top
flower(-38*SC,  5*SC, 45*SC, 14*SC);
flower( 38*SC,  5*SC, 45*SC, 14*SC);
flower(0, -10*SC, 95*SC, 18*SC);   // Top center
flower(-20*SC, -8*SC, 92*SC, 10*SC);
flower( 20*SC, -8*SC, 92*SC, 10*SC);
// Eye decorations
eye_decorations();
// Forehead diamond
forehead_diamond();
// Scroll bands
scroll_band(40, 30, 3, 12);
scroll_band(38, 55, 2.5, 14);
// Teeth
teeth_row();
// Nose heart
nose_heart();
