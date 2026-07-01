// Tensegrity Display Structure — Floating Compression in Tension
// 3 rigid struts held together ONLY by 9 elastic/string tension members
// No rigid connections exist — the structure is in pure tensile equilibrium
// Gravity-defying: struts appear to float; perfect desk centerpiece
// DUAL COLOR: struts (body) | end nodes + jig (accent)
// PLA 0.20mm, 4 walls — print 3 struts + 1 assembly jig + base
// String: 0.8mm fishing line or 1mm elastic cord through the holes

$fn = 32;

// ── Parameters ────────────────────────────────────────────
STRUT_L   = 115;   // Strut length (compression member)
STRUT_D   = 11;    // Strut diameter
NODE_D    = 22;    // End node (cap) diameter
HOLE_D    = 2.2;   // String/elastic hole diameter
NOTCH_D   = 3;     // Identification notch (numbered 1-3 per hole)
STRING_CLR = 0.3;  // Assembly clearance on holes
TWIST_ANG  = 60;   // Strut twist angle (characteristic of 3-strut tensegrity)
BASE_D    = 100;   // Display base outer diameter
BASE_T    = 6;

// ── Single strut with indexed string holes ─────────────────
// Each end has 3 string holes at 120° — holes indexed 1-3 (notch count)
// When assembled: bottom hole 1 of strut A connects to top hole 2 of strut B, etc.
module strut_body() {
    difference() {
        union() {
            // Main shaft (hexagonal for printability flat on bed)
            cylinder(d=STRUT_D, h=STRUT_L, $fn=6);
            // Spherical end nodes (larger for string attachment)
            sphere(d=NODE_D, $fn=28);
            translate([0, 0, STRUT_L]) sphere(d=NODE_D, $fn=28);
        }
        // Bottom node: 3 string holes at 120° apart
        for(idx=[0:2]) {
            HOLE_A = idx * 120;
            // Horizontal hole through node
            rotate([0, 0, HOLE_A])
                translate([NODE_D*0.3, 0, NODE_D*0.4])
                    rotate([0, 90, 0])
                        cylinder(d=HOLE_D, h=NODE_D, center=true, $fn=10);
            // Index notches (1 notch = hole 0, 2 notches = hole 1, 3 notches = hole 2)
            for(n=[0:idx])
                rotate([0, 0, HOLE_A + 15 + n*8])
                    translate([STRUT_D/2, 0, NODE_D*0.2])
                        sphere(d=NOTCH_D, $fn=8);
        }
        // Top node: 3 string holes (rotated 60° from bottom — creates the twist)
        for(idx=[0:2]) {
            HOLE_A = idx * 120 + TWIST_ANG;
            rotate([0, 0, HOLE_A])
                translate([NODE_D*0.3, 0, STRUT_L - NODE_D*0.4])
                    rotate([0, 90, 0])
                        cylinder(d=HOLE_D, h=NODE_D, center=true, $fn=10);
            for(n=[0:idx])
                rotate([0, 0, HOLE_A + 15 + n*8])
                    translate([STRUT_D/2, 0, STRUT_L - NODE_D*0.2])
                        sphere(d=NOTCH_D, $fn=8);
        }
        // Tension markings on shaft
        for(h=[STRUT_L*0.3, STRUT_L*0.5, STRUT_L*0.7])
            translate([0, 0, h]) rotate([0, 0, 30])
                cylinder(d=STRUT_D+0.5, h=1.5, $fn=6);
    }
}

// ── Assembly jig (holds struts at correct spacing while stringing) ─
// Print in accent color; discard after assembly
module assembly_jig() {
    JIG_R = 55;    // Spacing ring radius
    JIG_T = 8;
    SLOT_W = STRUT_D + 1.5;
    difference() {
        union() {
            cylinder(d=JIG_R*2+20, h=JIG_T, $fn=60);
            // Three arms at 120°
            for(a=[0,120,240])
                rotate([0,0,a])
                    translate([JIG_R*0.3, -SLOT_W/2, 0])
                        cube([JIG_R*0.7+10, SLOT_W, JIG_T]);
        }
        // Strut slots (at 120° positions with correct twist angle)
        for(i=[0:2])
            rotate([0,0, i*120])
                translate([JIG_R, 0, -1])
                    cylinder(d=SLOT_W, h=JIG_T+2, $fn=6);
        // Center bore (optional cord pass)
        cylinder(d=20, h=JIG_T+2, $fn=20);
        // Label
        translate([-32, -1, JIG_T-1.5])
            linear_extrude(2)
                text("TENSEGRITY JIG", size=5, $fn=4);
        // Assembly guide arrows
        for(i=[0:2])
            rotate([0,0, i*120+30])
                translate([JIG_R*0.65, -2, JIG_T-1.5])
                    linear_extrude(2)
                        text("→", size=6, $fn=8);
    }
}

// ── Display base ──────────────────────────────────────────
module display_base() {
    difference() {
        union() {
            cylinder(d=BASE_D, h=BASE_T, $fn=80);
            // Three socket bumps at 120° (guide foot position)
            for(a=[0,120,240])
                rotate([0,0,a]) translate([32, 0, BASE_T-1])
                    cylinder(d=10, h=3, $fn=12);
        }
        // Center recess
        translate([0,0,BASE_T-1]) cylinder(d=BASE_D-20, h=1.5, $fn=80);
        // Tensegrity silhouette diagram
        for(i=[0:2]) rotate([0,0,i*120])
            translate([24, -1, BASE_T-1.5])
                linear_extrude(2) text("| |", size=5, $fn=4);
        // Label
        translate([-28, -3.5, BASE_T-1.5])
            linear_extrude(2)
                text("TENSEGRITY", size=6.5, $fn=4);
        translate([-38, -12, BASE_T-1.5])
            linear_extrude(2)
                text("3-STRUT FLOAT STRUCTURE", size=4, $fn=4);
        // Mounting hole
        translate([0,0,-1]) cylinder(d=5, h=BASE_T+2, $fn=12);
        // Cable channel for optional LED (ambient light)
        rotate([0,0,45]) translate([BASE_D/2-8, -2, 2])
            cube([BASE_D/2, 4, BASE_T]);
    }
}

// ── String length reference card ─────────────────────────
module string_card() {
    difference() {
        cube([80, 40, 3]);
        // Notch cut (tear-off strip marker)
        translate([65, -1, -1]) cube([2, 42, 5]);
        // String lengths
        translate([2, 28, 2]) linear_extrude(1.5)
            text("9× STRING LENGTHS:", size=4, $fn=4);
        translate([2, 20, 2]) linear_extrude(1.5)
            text("TOP ↔ BOTTOM: 75mm", size=3.5, $fn=4);
        translate([2, 12, 2]) linear_extrude(1.5)
            text("SIDE: 85mm each", size=3.5, $fn=4);
        translate([2, 4, 2]) linear_extrude(1.5)
            text("ADJUST ±5mm for tension", size=3, $fn=4);
    }
}

// ── Layout ────────────────────────────────────────────────
// Print 3 copies of strut_body + 1 jig + 1 base + 1 string_card

// Color 1 (body): 3 struts
for(i=[0:2])
    translate([i*(STRUT_D+15), 0, NODE_D/2])
        strut_body();

// Color 2 (accent): jig + base + card
translate([0, STRUT_D*3+20, 0]) {
    assembly_jig();
    translate([130, 0, 0]) display_base();
    translate([0, 115, 0]) string_card();
}
