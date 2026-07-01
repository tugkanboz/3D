// Pikachu Chibi — OpenSCAD Stylized Figure
// Chunky cute style, print-ready for P2S Combo AMS
// 3-COLOR AMS:
//   Color 1 (yellow PLA)  : body, head, arms, legs, tail base
//   Color 2 (brown/black) : ear tips, back stripes, eyes, nose
//   Color 3 (red PLA)     : cheek circles
// ~100mm tall, flat base, no supports needed

$fn = 48;

// ── Main body ─────────────────────────────────────────
module body() {
    // Torso (fat rounded ellipsoid)
    scale([1, 0.85, 1.1])
        sphere(d=58);
}

// ── Head ──────────────────────────────────────────────
module head() {
    translate([0, 0, 42])
        scale([1, 0.92, 0.95])
            sphere(d=52);
}

// ── Ears (pointed, chibi style) ───────────────────────
module ear(side) {
    translate([side * 14, -5, 68]) {
        rotate([0, side * -8, side * 12]) {
            // Ear base (yellow — Color 1)
            hull() {
                sphere(d=10);
                translate([side * 4, 0, 28])
                    sphere(d=5);
            }
        }
    }
}

// Ear tips (dark — Color 2)
module ear_tip(side) {
    translate([side * 14, -5, 68]) {
        rotate([0, side * -8, side * 12]) {
            translate([side * 4.5, 0, 20])
                scale([0.7, 0.7, 1])
                    hull() {
                        sphere(d=7);
                        translate([side * 1.5, 0, 10])
                            sphere(d=3);
                    }
        }
    }
}

// ── Eyes (Color 2 — dark) ─────────────────────────────
module eyes() {
    for (side=[-1, 1]) {
        translate([side * 10, -24, 46]) {
            // Eye white base
            scale([1, 0.5, 1.1])
                sphere(d=9);
            // Pupil (dark, slightly forward)
            translate([0, -1, -1])
                scale([0.6, 0.4, 0.7])
                    sphere(d=9);
            // Eye shine (tiny white dot)
            translate([side * -1.5, -3.5, 2])
                sphere(d=2);
        }
    }
}

// ── Cheeks (Color 3 — red) ────────────────────────────
module cheeks() {
    for (side=[-1, 1]) {
        translate([side * 18, -18, 37]) {
            scale([1, 0.35, 0.85])
                sphere(d=14);
        }
    }
}

// ── Nose ──────────────────────────────────────────────
module nose() {
    translate([0, -27, 42])
        scale([1.2, 0.5, 0.7])
            sphere(d=5);
}

// ── Mouth (small smile) ───────────────────────────────
module mouth() {
    translate([0, -26, 37]) {
        // Left smile arc
        rotate([90, 0, -20])
            difference() {
                torus_arc(8, 1.5, 40);
            }
    }
}

// Tiny arc helper
module torus_arc(r, t, ang) {
    rotate_extrude(angle=ang, $fn=24)
        translate([r, 0])
            circle(r=t, $fn=8);
}

// ── Arms ──────────────────────────────────────────────
module arm(side) {
    translate([side * 28, -2, 14]) {
        rotate([0, side * -20, side * 30]) {
            // Upper arm
            hull() {
                sphere(d=12);
                translate([side * 8, 0, -14])
                    sphere(d=10);
            }
            // Hand (rounded mitten)
            translate([side * 10, 0, -18])
                scale([1, 0.8, 0.7])
                    sphere(d=12);
            // Fingers (3 small bumps)
            for (i=[-1,0,1])
                translate([side * (13 + i*1.5), i*3, -20])
                    sphere(d=5);
        }
    }
}

// ── Legs / Feet ───────────────────────────────────────
module leg(side) {
    translate([side * 14, 0, -26]) {
        // Thigh
        hull() {
            sphere(d=18);
            translate([0, 0, -14]) sphere(d=15);
        }
        // Foot (wide, flat bottom)
        translate([side * 2, 3, -22]) {
            scale([1.4, 1.8, 0.7])
                sphere(d=16);
            // Toes (3 bumps)
            for (i=[-1,0,1])
                translate([i*5, 10, -3])
                    sphere(d=5);
        }
    }
}

// ── Back stripes (Color 2 — dark brown) ──────────────
module back_stripes() {
    for (z=[5, 16]) {
        translate([0, 20, z])
            rotate([80, 0, 0])
                scale([1.1, 0.25, 1])
                    sphere(d=40);
    }
}

// ── Lightning bolt tail ───────────────────────────────
module tail() {
    translate([0, 20, 0]) {
        rotate([10, 0, 0]) {
            // Tail base (yellow)
            hull() {
                translate([0, 0, 0]) sphere(d=8);
                translate([8, 0, 12]) sphere(d=7);
            }
            hull() {
                translate([8, 0, 12]) sphere(d=7);
                translate([-2, 0, 22]) sphere(d=7);
            }
            hull() {
                translate([-2, 0, 22]) sphere(d=7);
                translate([10, 0, 34]) sphere(d=9);
            }
            hull() {
                translate([10, 0, 34]) sphere(d=9);
                translate([0, 0, 46]) sphere(d=7);
            }
        }
    }
}

// ── Flat display base ─────────────────────────────────
module base() {
    translate([0, 0, -48]) {
        difference() {
            cylinder(d=70, h=6, $fn=6);
            translate([-20, -30, 4])
                linear_extrude(3)
                    text("PIKACHU", size=7, halign="center", $fn=4);
        }
    }
}

// ══════════════════════════════════════════════════════
// COLOR 1 (YELLOW): body, head, ears base, arms, legs, tail
// ══════════════════════════════════════════════════════
body();
head();
ear(-1);
ear(1);
arm(-1);
arm(1);
leg(-1);
leg(1);
tail();
base();

// ══════════════════════════════════════════════════════
// COLOR 2 (DARK BROWN / BLACK): ear tips, back stripes, eyes, nose
// ══════════════════════════════════════════════════════
ear_tip(-1);
ear_tip(1);
back_stripes();
eyes();
nose();

// ══════════════════════════════════════════════════════
// COLOR 3 (RED): cheeks
// ══════════════════════════════════════════════════════
cheeks();
