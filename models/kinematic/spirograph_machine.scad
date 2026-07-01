// Spirograph Drawing Machine — Print-in-Place Gear Plotter
// Ring gear + planet gears + pen carriage traces hypotrochoid curves
// Swap planet gears to get different Lissajous/rose patterns
// DUAL COLOR: ring frame (dark) | planet gears + carriage (accent)
// PLA — 0.15mm, 4 walls, print flat — 0.35mm gear tooth gaps

// Gear parameters
RING_R    = 95;    // Ring gear pitch radius
RING_T    = 5;     // Tooth height
TOOTH_N   = 96;    // Ring gear teeth count (must be divisible by planet teeth)
MOD       = 2.0;   // Gear module (tooth size)
RING_THK  = 8;     // Ring gear thickness
GAP       = 0.35;  // Print clearance

// Planet gear sets (different tooth counts = different patterns)
// P_TEETH: must divide evenly into TOOTH_N for clean repeat
PLANET_SETS = [[32, "rose-3"], [24, "rose-4"], [48, "ellipse"]];

WALL      = 4.0;
FRAME_D   = (RING_R + RING_T) * 2 + WALL * 2 + 10;
FRAME_H   = 16;
PEN_D     = 8.5;   // Pen barrel diameter (standard 8mm pen fits)
CARRIAGE_W = 24;

// ── Involute tooth profile (approximated with circles) ────
module tooth(m=MOD) {
    hull() {
        circle(d=m*0.8, $fn=8);
        translate([0, m*1.1]) circle(d=m*0.4, $fn=8);
    }
}

// ── Ring gear (internal teeth) ────────────────────────
module ring_gear() {
    difference() {
        // Outer ring body
        cylinder(r=RING_R+RING_T+WALL, h=RING_THK, $fn=TOOTH_N);
        // Bore with internal teeth
        difference() {
            cylinder(r=RING_R+RING_T+0.5, h=RING_THK+2, center=true, $fn=TOOTH_N);
            for (i=[0:TOOTH_N-1])
                rotate([0,0, i*360/TOOTH_N])
                    translate([RING_R+RING_T*0.3, 0, 0])
                        linear_extrude(RING_THK+2, center=true)
                            tooth();
        }
        // Center bore
        cylinder(r=RING_R-RING_T*2, h=RING_THK+2, center=true, $fn=80);
        // Alignment tick marks (every 15°)
        for (i=[0:23])
            rotate([0,0,i*15])
                translate([RING_R+RING_T+WALL*0.3, 0, RING_THK-1])
                    cylinder(d=1.5, h=2, $fn=6);
    }
}

// ── Planet gear (external teeth, rolls inside ring) ───
module planet_gear(teeth) {
    r = teeth * MOD / 2;
    difference() {
        union() {
            // Gear body
            cylinder(r=r, h=RING_THK, $fn=teeth);
            // Outer teeth
            for (i=[0:teeth-1])
                rotate([0,0, i*360/teeth])
                    translate([r-MOD*0.2, 0, 0])
                        linear_extrude(RING_THK)
                            tooth();
        }
        // Center bore (for axle pin)
        cylinder(d=5+GAP, h=RING_THK+2, center=true, $fn=16);
        // Pen carriage hole (offset for hypotrochoid trace)
        translate([r*0.5, 0, 0])
            cylinder(d=PEN_D+GAP, h=RING_THK+2, center=true, $fn=16);
        // Spoke weight relief
        for (j=[0:2])
            rotate([0,0,j*120])
                hull() {
                    cylinder(d=3, h=RING_THK+2, center=true, $fn=8);
                    translate([r*0.55, 0, 0]) cylinder(d=3, h=RING_THK+2, center=true, $fn=8);
                }
    }
}

// ── Pen carriage arm ──────────────────────────────────
module pen_carriage(teeth) {
    r = teeth * MOD / 2;
    translate([r*0.5, 0, RING_THK]) {
        difference() {
            union() {
                cylinder(d=PEN_D+WALL*2, h=22, $fn=20);
                // Top retention clip
                translate([0, 0, 22])
                    cylinder(d=PEN_D+WALL*2+4, h=3, $fn=20);
            }
            // Pen bore
            cylinder(d=PEN_D+GAP, h=28, $fn=20);
            // Access slit
            translate([-1, 0, 0])
                cube([2, PEN_D/2+WALL+2, 28]);
        }
    }
}

// ── Frame base ────────────────────────────────────────
module frame_base() {
    difference() {
        hull() {
            cylinder(d=FRAME_D, h=4, $fn=6);
            translate([0,0,4]) cylinder(d=FRAME_D-8, h=2, $fn=6);
        }
        // Center paper viewing area
        cylinder(r=RING_R+RING_T+1, h=8, $fn=80);
        // Paper clip notches
        for (i=[0:5])
            rotate([0,0,i*60+30])
                translate([FRAME_D/2-3, 0, 2])
                    cube([8, 4, 4], center=true);
    }
}

// ── Ring gear retainer clips ──────────────────────────
module retainer_clips() {
    for (i=[0:2]) {
        rotate([0,0,i*120+60])
            translate([RING_R+RING_T+WALL*0.7, 0, 0]) {
                difference() {
                    cylinder(d=8, h=FRAME_H+4, $fn=12);
                    translate([0, -5, -1]) cube([10, 10, FRAME_H+6]);
                    cylinder(d=4+GAP, h=FRAME_H+6, $fn=12);
                }
            }
    }
}

// ── Assembly label ────────────────────────────────────
module labels() {
    for (idx=[0:len(PLANET_SETS)-1]) {
        rotate([0,0,idx*120])
            translate([FRAME_D/2-12, 0, 1])
                linear_extrude(1.5)
                    text(PLANET_SETS[idx][1], size=5, halign="center", $fn=4);
    }
}

// Color 1 (dark): frame + ring gear
frame_base();
retainer_clips();
labels();
translate([0, 0, 4]) ring_gear();

// Color 2 (accent): planet gears (one of each set, spaced for display)
for (idx=[0:len(PLANET_SETS)-1]) {
    assign(t=PLANET_SETS[idx][0]) {
        rotate([0, 0, idx*120])
            translate([RING_R - t*MOD/2, 0, 4])
                planet_gear(t);
    }
}
