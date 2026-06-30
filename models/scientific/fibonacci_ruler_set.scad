// Fibonacci Spiral Ruler Set — Math Tool + Desk Art
// 3-piece set: Fibonacci ruler, golden ratio calipers, spiral template
// DUAL COLOR: scale marks (dark) + body (light wood PLA)
// PLA — 0.2mm, 4 walls, 20% infill

PHI = 1.6180339887;

// ── Fibonacci Ruler (measures Fibonacci numbers 1–144mm) ─
module fibonacci_ruler() {
    FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144];
    L   = 160;
    W   = 30;
    T   = 5;

    difference() {
        // Body with rounded ends
        hull() {
            cylinder(d = W, h = T, $fn = 24);
            translate([L, 0, 0]) cylinder(d = W, h = T, $fn = 24);
        }
        // Standard mm graduations
        for (i = [0 : L])
            translate([i, W/2 - (i%10==0 ? 12 : (i%5==0 ? 8 : 5)), T - 1.5])
                cube([0.8, (i%10==0 ? 12 : (i%5==0 ? 8 : 5)), 2]);
        // Fibonacci position marks (deeper, wider)
        for (fib = FIB)
            if (fib <= L)
                translate([fib, -W/2, T - 2.5])
                    cube([2, W, 3]);
        // Weight reduction
        translate([10, -W/2 + 4, -1])
            cube([L - 20, W - 8, T - 2]);
    }

    // Raised Fibonacci labels (Color 2 overlay)
    // (Position bosses for each Fibonacci mark)
    for (i = [0 : len(FIB) - 1]) {
        fib = FIB[i];
        if (fib <= L)
            translate([fib, W/2 - 16, T])
                linear_extrude(1.5)
                    text(str(fib), size = 5, halign = "center", $fn = 4);
    }
}

// ── Golden Ratio Calipers ─────────────────────────────
module golden_calipers() {
    ARM_L = 120;
    ARM_W = 10;
    ARM_T = 4;
    PIVOT_D = 6;
    PIVOT_X = ARM_L / PHI;  // Pivot at golden ratio point

    // Outer arms (2 pieces, mirrored)
    for (flip = [1, -1])
        scale([1, flip, 1])
            difference() {
                hull() {
                    cylinder(d = ARM_W, h = ARM_T, $fn = 20);
                    translate([ARM_L, 0, 0])
                        cylinder(d = ARM_W * 0.5, h = ARM_T, $fn = 16);
                }
                translate([PIVOT_X, 0, -1])
                    cylinder(d = PIVOT_D, h = ARM_T + 2, $fn = 16);
                // Slot for inner arm
                translate([PIVOT_X + 2, -ARM_W/4, -1])
                    cube([ARM_L - PIVOT_X - 2, ARM_W/2, ARM_T + 2]);
            }

    // Inner short arm (one piece, extends inward at PHI ratio)
    translate([PIVOT_X, 0, ARM_T + 0.5])
        difference() {
            hull() {
                cylinder(d = ARM_W, h = ARM_T, $fn = 20);
                translate([PIVOT_X - ARM_L/PHI, 0, 0])
                    cylinder(d = ARM_W * 0.5, h = ARM_T, $fn = 16);
            }
            cylinder(d = PIVOT_D, h = ARM_T + 1, $fn = 16);
        }

    // Pivot nut
    translate([PIVOT_X, 0, ARM_T * 2 + 1])
        cylinder(d = PIVOT_D + 4, h = 3, $fn = 6);
}

// ── Spiral template (log spiral, φ-based) ─────────────
module spiral_template() {
    T = 3.0;
    W = 5.0;
    N_TURNS = 3;
    STEPS   = 120;

    linear_extrude(T)
    for (i = [0 : STEPS - 1]) {
        t0 = i / STEPS * N_TURNS;
        t1 = (i+1) / STEPS * N_TURNS;
        r0 = 5 * pow(PHI, t0);
        r1 = 5 * pow(PHI, t1);
        a0 = t0 * 360;
        a1 = t1 * 360;
        p0 = [r0 * cos(a0), r0 * sin(a0)];
        p1 = [r1 * cos(a1), r1 * sin(a1)];
        hull() {
            translate(p0) circle(d = W, $fn = 10);
            translate(p1) circle(d = W * (r1/r0), $fn = 10);
        }
    }
}

// Layout
translate([0, 0, 0])    fibonacci_ruler();
translate([0, 50, 0])   golden_calipers();
translate([200, 0, 0])  spiral_template();
