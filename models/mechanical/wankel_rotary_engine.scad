// Wankel Rotary Engine — Epitrochoid Housing Display
// The only piston-less internal combustion engine in mass production (Mazda RX-7/8)
// Triangular rotor spins eccentrically inside a 2-lobed epitrochoid housing
// 4 phases per rotation: intake → compression → combustion → exhaust
// Rotor rotates 1× per 3 crankshaft rotations
// DUAL COLOR: housing + end plates (body) | rotor + eccentric shaft (accent)
// PLA 0.15mm, 5 walls, 20% gyroid — cutaway shows all 4 chambers simultaneously

$fn = 80;

// ── Core parameters ───────────────────────────────────────
E      = 10;   // Eccentricity (shaft offset from rotor center)
R      = 58;   // Rotor circumradius (apex to center)
THICK  = 25;   // Housing depth
WALL   = 5;    // Housing wall thickness
PORT_D = 12;   // Intake/exhaust port diameter
PLUG_D = 8;    // Spark plug diameter
STEPS  = 360;  // Polygon resolution

// ── Wankel epitrochoid housing profile ────────────────────
// x(t) = e*cos(3t) + R*cos(t)  |  This creates the 2-lobed figure with
// y(t) = e*sin(3t) + R*sin(t)  |  3 "apex positions" for the rotor
HOUSING_PROFILE = [for(i=[0:STEPS-1])
    [E * cos(i * 3) + R * cos(i),
     E * sin(i * 3) + R * sin(i)]];

// Offset housing profile (adds WALL thickness)
HOUSING_OUTER = [for(i=[0:STEPS-1])
    let(ix = E * cos(i*3) + R * cos(i),
        iy = E * sin(i*3) + R * sin(i),
        mag = sqrt(ix*ix + iy*iy))
    [ix * (1 + WALL/mag), iy * (1 + WALL/mag)]];

// ── Housing body ──────────────────────────────────────────
module housing_body() {
    difference() {
        union() {
            // Main housing
            linear_extrude(THICK) polygon(HOUSING_OUTER);
            // Mounting ears (4 corner bolts)
            for(a=[45,135,225,315])
                rotate([0,0,a]) translate([R+WALL+8, 0, 0])
                    cylinder(d=14, h=THICK, $fn=12);
        }
        // Interior bore (rotor chamber)
        linear_extrude(THICK+2) polygon(HOUSING_PROFILE);
        // Intake port (one side)
        translate([-R-WALL*0.5, -R*0.3, THICK*0.5])
            rotate([0,90,0]) cylinder(d=PORT_D, h=WALL*2.5, $fn=20);
        // Exhaust port (opposite)
        translate([R+WALL*0.5-WALL*1.5, R*0.3, THICK*0.5])
            rotate([0,90,0]) cylinder(d=PORT_D, h=WALL*2.5, $fn=20);
        // Spark plug holes (2 per chamber in most Wankels, 1 shown)
        for(plug_y=[-R*0.15, R*0.15]) translate([R*0.55, plug_y, -1])
            cylinder(d=PLUG_D, h=WALL+2, $fn=16);
        // Mounting bolt holes
        for(a=[45,135,225,315])
            rotate([0,0,a]) translate([R+WALL+8, 0, -1])
                cylinder(d=4.5, h=THICK+2, $fn=10);
        // Phase labels (4 combustion zones)
        for(ang=[0,90,180,270]) rotate([0,0,ang])
            translate([R*0.55, 0, THICK-1.5])
                linear_extrude(2) text(["COMB","EXHS","INTK","COMP"][ang/90],
                    size=5, halign="center", $fn=4);
        // Cutaway (front half removed for viewing)
        translate([-(R+WALL+15), 0, -1]) cube([R*2+WALL*4+30, R*2+WALL*4+30, THICK+2]);
    }
}

// ── Rotor (equilateral triangle with curved sides) ────────
// Rotor apices at 120° spacing, radius R-E from eccentric center
R_APEX = R - 1.5*E;   // Rotor apex radius (rotor is slightly smaller)
R_SIDE = R_APEX * sqrt(3);  // Arc radius for curved rotor sides

module rotor_2d() {
    // Reuleaux-triangle-like shape: intersection of 3 circles at apex positions
    APICES = [for(i=[0:2]) [R_APEX * cos(i*120 + 30), R_APEX * sin(i*120 + 30)]];
    intersection() {
        for(i=[0:2]) translate(APICES[i]) circle(r=R_SIDE*0.88, $fn=120);
    }
}

module rotor() {
    difference() {
        // Main rotor body (extruded profile with apex seals)
        linear_extrude(THICK - 2) rotor_2d();
        // Center bore for eccentric shaft
        cylinder(d=E*3.5, h=THICK, $fn=20);
        // Gear teeth pocket (rotor meshes with fixed central gear)
        cylinder(d=E*2.5, h=THICK+2, $fn=24);
        // Apex seal slots (3× — critical for compression)
        for(i=[0:2]) {
            rotate([0,0, i*120+30]) translate([R_APEX-2, -0.8, -1])
                cube([6, 1.6, THICK+2]);
        }
        // Internal oil passages (decorative channels)
        for(i=[0:2]) rotate([0,0, i*120+30]) {
            rotate_extrude(angle=60, $fn=40)
                translate([R_APEX*0.55, 0]) square([R_APEX*0.06, THICK-4]);
        }
        // Weight reduction holes (triangular pattern)
        for(i=[0:2]) rotate([0,0, i*120+30+60])
            translate([R_APEX*0.38, 0, -1]) cylinder(d=R_APEX*0.35, h=THICK+2, $fn=20);
    }
    // Apex seals (thin raised strips — in the slots above)
    for(i=[0:2]) rotate([0,0, i*120+30])
        translate([R_APEX-1, -0.5, 0])
            cube([3, 1, THICK-2]);
}

// ── Eccentric shaft ───────────────────────────────────────
module eccentric_shaft() {
    SHAFT_L = THICK + 24;
    difference() {
        union() {
            // Main shaft (output)
            cylinder(d=E*2.8, h=SHAFT_L, center=true, $fn=20);
            // Eccentric journal (offset by E — this is what the rotor rides on)
            translate([E, 0, 0])
                cylinder(d=E*3.0, h=THICK-2, center=true, $fn=20);
            // Counterweights (balance the eccentricity)
            for(sign=[-1,1]) translate([sign*(E+2), 0, sign*THICK*0.3])
                cylinder(d=E*5, h=5, $fn=20);
        }
        // Key flat (for coupling)
        translate([E*1.0, -E*0.2, -SHAFT_L/2-1]) cube([E*0.3, E*0.4, SHAFT_L+2]);
    }
}

// ── End plate ─────────────────────────────────────────────
module end_plate() {
    difference() {
        linear_extrude(8) polygon(HOUSING_OUTER);
        // Shaft hole
        cylinder(d=E*3+1, h=10, $fn=20);
        // Rotor clearance
        linear_extrude(6) offset(r=1) rotor_2d();
        // Bolt holes
        for(a=[45,135,225,315])
            rotate([0,0,a]) translate([R+WALL+8, 0, -1])
                cylinder(d=4.5, h=10, $fn=10);
        // Port labels
        translate([-R*0.8, 0, 5.5]) linear_extrude(2)
            text("INTAKE", size=4, halign="center", $fn=4);
        translate([R*0.6, 0, 5.5]) linear_extrude(2)
            text("EXHAUST", size=4, halign="center", $fn=4);
        // Cutaway
        translate([-(R+WALL+15), 0, -1])
            cube([R*2+WALL*4+30, R*2+WALL*4+30, 10]);
    }
}

// ── Assembly layout ───────────────────────────────────────
// Color 1 (body): housing + end plate
housing_body();
translate([0, 0, -10]) end_plate();
translate([0, 0, THICK+2]) mirror([0,0,1]) end_plate();

// Color 2 (accent): rotor + shaft (shown in position at "combustion" phase)
translate([E*cos(15), E*sin(15), 1.5]) {
    rotate([0,0, 15]) rotor();  // rotor offset from eccentric center
}
translate([(R+WALL)*1.8, 0, THICK/2]) {
    rotate([90,0,0]) eccentric_shaft();
}
