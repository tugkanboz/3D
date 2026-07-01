// Double Pendulum Chaos Demonstration Stand
// The double pendulum is the SIMPLEST physical system that exhibits chaos theory
// Two pendulum arms connected in series: arm1's tip is arm2's pivot
// Even tiny changes in initial conditions → wildly different trajectories
// Used to visualize: sensitive dependence on initial conditions (butterfly effect)
// DUAL COLOR: base + mounting pillars (body) | arm1 + arm2 + bob weights (accent)
// PLA 0.2mm, 4 walls, 20% infill — M5 bolts as pivot shafts, 605 bearings (16mm OD)
// Print each part separately; assemble with M5×30 bolts (pivots) + M4 nuts (weights)

$fn = 48;

// ── Parameters ────────────────────────────────────────────
// Arm dimensions
ARM1_L   = 130;   // Length of arm1 (pivot to pivot)
ARM2_L   = 100;   // Length of arm2 (pivot to bob)
ARM_W    = 16;    // Arm width
ARM_T    = 8;     // Arm thickness

// Pivot hardware
PIVOT_D  = 5.2;   // M5 bolt clearance
BEARING_OD = 16;  // 605 bearing outer diameter (OD=16, ID=5, W=5)
BEARING_W  = 5;   // Bearing width

// Weight bobs
BOB1_D   = 36;    // Arm1 bob diameter (at arm2 pivot end — no bob on arm1)
BOB2_D   = 44;    // Arm2 bob diameter (end of arm2)
BOB_H    = 18;    // Bob height

// Base dimensions
BASE_W   = 200;   // Base width
BASE_D   = 120;   // Base depth
BASE_H   = 10;    // Base plate thickness
PILLAR_H = 220;   // Pillar height
PILLAR_D = 22;    // Pillar diameter

// ── Arm 1 (upper pendulum arm) ────────────────────────────
// Connects: top pivot (in pillar) → arm2 pivot (at bottom of arm1)
module arm1() {
    TOTAL_L = ARM1_L + BEARING_OD;
    difference() {
        union() {
            // Main arm body
            hull() {
                cylinder(d=BEARING_OD+ARM_W*0.4, h=ARM_T, $fn=30);
                translate([ARM1_L, 0, 0]) cylinder(d=BEARING_OD+ARM_W*0.4, h=ARM_T, $fn=30);
            }
            // Top pivot boss (wider to house bearing)
            cylinder(d=BEARING_OD+ARM_W, h=ARM_T+4, $fn=30);
            // Bottom pivot boss
            translate([ARM1_L, 0, 0])
                cylinder(d=BEARING_OD+ARM_W, h=ARM_T+4, $fn=30);
        }
        // Top bearing pocket (press-fit 605 bearing)
        cylinder(d=BEARING_OD+0.15, h=BEARING_W+0.5, $fn=30);
        // Top bolt through-hole
        cylinder(d=PIVOT_D, h=ARM_T+6, $fn=12);
        // Bottom bearing pocket
        translate([ARM1_L, 0, 0]) {
            cylinder(d=BEARING_OD+0.15, h=BEARING_W+0.5, $fn=30);
            cylinder(d=PIVOT_D, h=ARM_T+6, $fn=12);
        }
        // Lightening cutouts (reduces rotational inertia)
        for(i=[1,2]) translate([ARM1_L*i/3, 0, -1])
            cylinder(d=ARM_W*0.7, h=ARM_T+2, $fn=16);
        // Label
        translate([ARM1_L/2-15, -5, ARM_T-1.2]) linear_extrude(1.5)
            text(str("ARM1 ",ARM1_L,"mm"), size=5, $fn=4);
    }
}

// ── Arm 2 (lower pendulum arm) ────────────────────────────
// Connects: arm1-tip pivot → bob weight at bottom
module arm2() {
    difference() {
        union() {
            // Main arm body
            hull() {
                cylinder(d=BEARING_OD+ARM_W*0.4, h=ARM_T, $fn=30);
                translate([ARM2_L, 0, 0]) cylinder(d=BOB2_D*0.65, h=ARM_T, $fn=30);
            }
            // Top pivot boss
            cylinder(d=BEARING_OD+ARM_W, h=ARM_T+4, $fn=30);
            // Bob boss (wider)
            translate([ARM2_L, 0, 0])
                cylinder(d=BOB2_D*0.65, h=ARM_T+3, $fn=30);
        }
        // Top bearing pocket
        cylinder(d=BEARING_OD+0.15, h=BEARING_W+0.5, $fn=30);
        cylinder(d=PIVOT_D, h=ARM_T+6, $fn=12);
        // Bob attachment (M5 thread for bob weight)
        translate([ARM2_L, 0, 0]) {
            cylinder(d=PIVOT_D+0.2, h=ARM_T+5, $fn=12);
            // Weight pocket
            translate([0,0,ARM_T-4]) cylinder(d=12, h=6, $fn=20);
        }
        // Lightening hole
        translate([ARM2_L*0.5, 0, -1]) cylinder(d=ARM_W*0.6, h=ARM_T+2, $fn=16);
        // Label
        translate([ARM2_L/2-14, -5, ARM_T-1.2]) linear_extrude(1.5)
            text(str("ARM2 ",ARM2_L,"mm"), size=5, $fn=4);
        // Chaos equation
        translate([ARM2_L/2-22, 4, ARM_T-1.2]) linear_extrude(1.5)
            text("θ''= f(θ₁,θ₂,ω₁,ω₂)", size=3.5, $fn=4);
    }
}

// ── Bob weight (for arm2 tip) ─────────────────────────────
module bob_weight(d, h, label) {
    difference() {
        union() {
            // Main weight body
            cylinder(d=d, h=h, $fn=40);
            // Top collar (sits against arm)
            cylinder(d=d*0.5, h=h+5, $fn=30);
        }
        // Center M5 bolt hole (all the way through)
        cylinder(d=PIVOT_D, h=h+8, $fn=12);
        // Hex nut pocket (M5: 8mm across flats, 4mm deep)
        translate([0,0,h-4]) cylinder(d=8.7, h=5, $fn=6);
        // Mass balance groove (8× for look)
        for(i=[0:7]) rotate([0,0,i*45])
            translate([d*0.3, -1.5, -1]) cube([d*0.2, 3, h+2]);
        // Label engrave
        translate([-d/3, -3, h-1.5]) linear_extrude(1.8)
            text(label, size=5, $fn=4);
    }
    // Bottom flat for stability
    difference() {
        translate([0,0,-3]) cylinder(d=d+2, h=3, $fn=40);
        cylinder(d=d-4, h=4, $fn=40);
        translate([0,0,-4]) cylinder(d=PIVOT_D, h=8, $fn=12);
    }
}

// ── Base plate ────────────────────────────────────────────
module base_plate() {
    difference() {
        union() {
            // Main plate
            cube([BASE_W, BASE_D, BASE_H]);
            // Non-slip rim chamfer
            translate([0,0,0]) difference() {
                cube([BASE_W, BASE_D, 3]);
                translate([4,4,-1]) cube([BASE_W-8, BASE_D-8, BASE_H+2]);
            }
        }
        // Corner mounting holes (4mm countersink)
        for(x=[12,BASE_W-12]) for(y=[12,BASE_D-12])
            translate([x,y,-1]) {
                cylinder(d=4.5, h=BASE_H+2, $fn=10);
                translate([0,0,BASE_H-3]) cylinder(d1=4.5, d2=9, h=3.5, $fn=10);
            }
        // Grid weight-relief cutouts
        for(x=[30,BASE_W/2,BASE_W-30]) for(y=[30,BASE_D-30])
            translate([x,y,-1]) cylinder(d=20, h=BASE_H+2, $fn=20);
        // Phase space trajectory engraving (Lissajous-like attractor visualization)
        // Simplified butterfly attractor outline
        translate([BASE_W/2, BASE_D/2, BASE_H-1.5]) linear_extrude(2) {
            difference() {
                union() {
                    // Left lobe
                    rotate([0,0,45]) scale([20,12]) circle(r=1, $fn=30);
                    // Right lobe
                    rotate([0,0,-45]) translate([14,-14]) scale([20,12]) circle(r=1, $fn=30);
                }
                // Hollow
                rotate([0,0,45]) scale([16,9]) circle(r=1, $fn=30);
                rotate([0,0,-45]) translate([14,-14]) scale([16,9]) circle(r=1, $fn=30);
            }
        }
        // Labels
        translate([10, BASE_D/2-4, BASE_H-1.5]) linear_extrude(1.8)
            text("DOUBLE PENDULUM", size=7, $fn=4);
        translate([10, BASE_D/2-12, BASE_H-1.5]) linear_extrude(1.8)
            text("CHAOS DEMONSTRATION", size=5.5, $fn=4);
    }
}

// ── Pillar (vertical support with top pivot housing) ──────
module pillar() {
    difference() {
        union() {
            // Column shaft
            cylinder(d=PILLAR_D, h=PILLAR_H, $fn=20);
            // Pivot head (top)
            translate([0,0,PILLAR_H-BEARING_W-3])
                cylinder(d=PILLAR_D+12, h=BEARING_W+3+8, $fn=24);
            // Base flange
            cylinder(d=PILLAR_D+20, h=18, $fn=30);
        }
        // Top bearing pocket (605 bearing, centered on axis)
        translate([0,0,PILLAR_H])
            mirror([0,0,1]) cylinder(d=BEARING_OD+0.15, h=BEARING_W+1, $fn=30);
        // Through bolt
        cylinder(d=PIVOT_D, h=PILLAR_H+10, $fn=12);
        // Base mounting bolts (3×)
        for(a=[0,120,240]) rotate([0,0,a]) translate([PILLAR_D/2+5, 0, -1])
            cylinder(d=4.5, h=20, $fn=10);
        // Decorative fluting (6 channels on column)
        for(i=[0:5]) rotate([0,0,i*60])
            translate([PILLAR_D/2, -1.5, 15]) cube([2.5, 3, PILLAR_H-30]);
    }
}

// ── Pillar cap (top of pillar, locks bearing) ─────────────
module pillar_cap() {
    difference() {
        cylinder(d=PILLAR_D+12, h=6, $fn=24);
        // Center hole
        cylinder(d=PIVOT_D+1, h=8, $fn=12);
        // Bolt holes (match pillar base)
        for(a=[0,120,240]) rotate([0,0,a]) translate([PILLAR_D/2+5, 0, -1])
            cylinder(d=4.5, h=8, $fn=10);
    }
}

// ── Phase space trajectory plate ──────────────────────────
// Shows a typical chaotic trajectory of the double pendulum's θ₁ vs θ₂ phase space
// This is the "Poincaré section" — a hallmark of chaotic systems
module phase_space_plate() {
    PLATE_W = 150; PLATE_H = 150;
    difference() {
        cube([PLATE_W, PLATE_H, 3]);
        // Title
        translate([5, PLATE_H-12, 1.5]) linear_extrude(2)
            text("PHASE SPACE θ₁ vs θ₂", size=7, $fn=4);
        // Axes
        translate([PLATE_W/2, 5, 1.5]) linear_extrude(2) text("θ₁", size=5, $fn=4);
        translate([5, PLATE_H/2, 1.5]) linear_extrude(2) text("θ₂", size=5, $fn=4);
        // Simulated chaotic trajectory (parametric path approximation)
        // The chaotic attractor of a double pendulum traces a space-filling region
        for(t=[0:5:355]) {
            // Runge-Kutta-inspired trajectory approximation
            x = PLATE_W/2 + 45*sin(t*3.7)*cos(t*1.3) + 20*sin(t*7.1+30);
            y = PLATE_H/2 + 45*cos(t*2.9)*sin(t*1.8) + 18*cos(t*5.3+15);
            translate([x, y, 1.5]) cylinder(d=1.8, h=2, $fn=6);
        }
        // Axis lines
        translate([PLATE_W/2-0.5, 8, 1.5]) cube([1, PLATE_H-16, 2]);
        translate([8, PLATE_H/2-0.5, 1.5]) cube([PLATE_W-16, 1, 2]);
        // Border
        translate([2,2,1.5]) difference() {
            square([PLATE_W-4, PLATE_H-4]);
            translate([1.5,1.5]) square([PLATE_W-7, PLATE_H-7]);
        }
    }
}

// ── Assembly layout ────────────────────────────────────────
// Color 1 (body): base + pillars
translate([0, 0, 0]) base_plate();
// Single pillar at center-back of base
translate([BASE_W/2, BASE_D*0.8, BASE_H]) pillar();
translate([BASE_W/2, BASE_D*0.8, BASE_H+PILLAR_H+8]) pillar_cap();

// Color 2 (accent): arms + bobs
// Arms shown extended at starting angle (demonstrating before chaos)
translate([BASE_W/2, BASE_D*0.8, BASE_H+PILLAR_H]) {
    rotate([0, 0, -70]) {  // arm1 starting angle
        translate([BEARING_OD/2, 0, -ARM_T-2]) arm1();
        translate([BEARING_OD/2 + ARM1_L, 0, -ARM_T-6]) rotate([0,0,-45])  // arm2 starting angle
            translate([BEARING_OD/2, 0, 0]) arm2();
    }
}

// Bob weights (shown below arms, for separate printing)
translate([BASE_W+20, 0, 0]) {
    bob_weight(BOB2_D, BOB_H, "BOB2");
    translate([BOB2_D+15, 0, 0]) bob_weight(BOB2_D*0.7, BOB_H*0.8, "BOB1");
}

// Phase space plate (educational context)
translate([0, BASE_D+15, 0]) phase_space_plate();

// Axis notation plate
translate([BASE_W+20, 80, 0]) {
    difference() {
        cube([130, 70, 3]);
        translate([4,59,1.5]) linear_extrude(1.8) text("DOUBLE PENDULUM", size=7, $fn=4);
        translate([4,49,1.5]) linear_extrude(1.5) text(str("Arm 1: L=",ARM1_L,"mm"), size=5, $fn=4);
        translate([4,40,1.5]) linear_extrude(1.5) text(str("Arm 2: L=",ARM2_L,"mm"), size=5, $fn=4);
        translate([4,31,1.5]) linear_extrude(1.5) text("Pivots: M5 + 605 bearing", size=4.5, $fn=4);
        translate([4,22,1.5]) linear_extrude(1.5) text("\"Sensitive dependence", size=4.5, $fn=4);
        translate([4,13,1.5]) linear_extrude(1.5) text("on initial conditions\"", size=4.5, $fn=4);
        translate([4,4,1.5]) linear_extrude(1.5) text("— E. Lorenz, 1963", size=4.5, $fn=4);
    }
}
