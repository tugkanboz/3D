// Magnetic Modular Hexagonal Desk Organizer
// Snap-together hexagonal modules with embedded neodymium magnets
// Each module attaches magnetically to its neighbors on any of 6 faces
// Mix heights for pens (tall), scissors (medium), cards/sticky notes (short)
// Magnet spec: 8mm × 3mm neodymium disc (very common, Amazon/AliExpress)
// DUAL COLOR: hex body + rim (body) | base plate + magnet caps (accent)
// PLA 0.15mm, 4 walls, 20% gyroid — very useful everyday desk object
// Build: print as many modules as needed, stick together magnetically

$fn = 6;   // Hexagonal cross-sections

// ── Parameters ────────────────────────────────────────────
HEX_SIZE   = 42;    // Hex outer diameter (vertex to vertex)
WALL_T     = 3.0;   // Wall thickness
FLOOR_T    = 2.5;   // Bottom floor thickness
MAG_D      = 8.2;   // Magnet hole diameter (8mm + 0.2 clearance)
MAG_H      = 3.2;   // Magnet hole depth (3mm + 0.2)
MAG_CAP_T  = 0.8;   // Thin lid over magnet (printed in second color)
RIM_H      = 4;     // Top rim height (reinforces the opening)
RIM_CHAMF  = 2.5;   // Inner chamfer on rim (easy insertion)
ALIGN_D    = 6;     // Alignment pin diameter
ALIGN_H    = 3;     // Alignment pin height
ALIGN_HOLE_EXTRA = 0.3;  // Clearance for alignment pins

// ── Module heights ─────────────────────────────────────────
H_TALL   = 130;   // Pens, pencils, rulers
H_MED    = 90;    // Scissors, markers, highlighters
H_SHORT  = 55;    // Sticky notes, cards, stapler
H_TRAY   = 20;    // Flat tray (coins, clips, rubber bands)

// ── Hex flat-to-flat radius ────────────────────────────────
HEX_FTF = HEX_SIZE * cos(30);  // flat-to-flat = size × cos(30°)
HEX_R   = HEX_SIZE / 2;        // vertex radius = size/2

// ── Single module ─────────────────────────────────────────
module hex_module(height) {
    difference() {
        union() {
            // Main hex body
            cylinder(d=HEX_SIZE, h=height, $fn=6);
            // Rim (slightly larger + chamfered for easy module stacking)
            translate([0, 0, height-RIM_H])
                cylinder(d1=HEX_SIZE, d2=HEX_SIZE+WALL_T*0.5, h=RIM_H, $fn=6);
        }

        // ── Interior hollow ──────────────────────────────
        translate([0, 0, FLOOR_T])
            cylinder(d=HEX_SIZE-WALL_T*2, h=height, $fn=6);

        // ── Rim chamfer (easy insertion of items) ────────
        translate([0, 0, height-RIM_CHAMF])
            cylinder(d1=HEX_SIZE-WALL_T*2, d2=HEX_SIZE-WALL_T*2+RIM_CHAMF*1.8,
                     h=RIM_CHAMF+1, $fn=6);

        // ── Magnet pockets in floor (bottom face) ────────
        // 3 magnets triangularly arranged for best flux linkage
        for(a=[0,120,240]) rotate([0,0,a]) translate([HEX_R*0.48, 0, 0])
            cylinder(d=MAG_D, h=MAG_H, $fn=24);
        // Center magnet
        cylinder(d=MAG_D, h=MAG_H, $fn=24);

        // ── Alignment pin holes (on floor, mate with pins below) ─
        for(a=[60,180,300]) rotate([0,0,a]) translate([HEX_R*0.38, 0, 0])
            cylinder(d=ALIGN_D+ALIGN_HOLE_EXTRA, h=ALIGN_H+0.5, $fn=20);

        // ── Cable routing notch (one face, bottom) ───────
        // Single notch in one face for USB/charging cables to pass through
        translate([HEX_FTF/2-2.5, -6, FLOOR_T])
            cube([WALL_T+3, 12, 18]);

        // ── Height label ─────────────────────────────────
        translate([-10, HEX_FTF/2-WALL_T*0.5-1.5, height*0.5])
            rotate([90,0,0]) linear_extrude(1.5)
                text(str(height,"mm"), size=5.5, $fn=4);
    }

    // ── Alignment pins (on top face, mate with holes below) ─
    translate([0, 0, height])
        for(a=[60,180,300]) rotate([0,0,a]) translate([HEX_R*0.38, 0, 0])
            cylinder(d=ALIGN_D, h=ALIGN_H, $fn=20);

    // ── Top rim outer detail ring ─────────────────────────
    translate([0, 0, height+ALIGN_H])
        difference() {
            cylinder(d=HEX_SIZE+WALL_T, h=2, $fn=6);
            cylinder(d=HEX_SIZE-1, h=3, $fn=6);
        }
}

// ── Magnet caps (accent color, pressed in after magnets) ──
module magnet_cap() {
    // Thin disc to retain magnet in pocket
    difference() {
        cylinder(d=MAG_D-0.1, h=MAG_CAP_T+0.8, $fn=20);
        // Grip pattern
        for(i=[0:5]) rotate([0,0,i*60])
            translate([MAG_D*0.3, -0.4, 0]) cube([MAG_D*0.2, 0.8, MAG_CAP_T+1]);
    }
}

// ── Magnetic base plate ────────────────────────────────────
// 2×3 hexagonal array base plate for organizing multiple modules
// Modules stick to this base plate and to each other
BASE_COLS = 3;
BASE_ROWS = 2;
BASE_T    = 8;

module hex_base_plate() {
    // Hex spacing: flat-to-flat = HEX_SIZE*cos(30°)
    DX = HEX_FTF;          // horizontal spacing (x)
    DY = HEX_SIZE * 1.5;   // vertical spacing (y, for hex grid)

    difference() {
        union() {
            // Base slab
            hull() {
                for(row=[0:BASE_ROWS-1]) for(col=[0:BASE_COLS-1]) {
                    x_offset = col * DX + (row%2 == 1 ? DX/2 : 0);
                    y_offset = row * DY;
                    translate([x_offset, y_offset, 0])
                        cylinder(d=HEX_SIZE-2, h=BASE_T, $fn=6);
                }
            }
            // Edge reinforcement
            translate([-(DX/2), -(HEX_SIZE/2), 0])
                cube([(BASE_COLS+0.5)*DX, BASE_ROWS*DY+HEX_SIZE, 3]);
        }

        // ── Magnet pockets on top surface ─────────────────
        for(row=[0:BASE_ROWS-1]) for(col=[0:BASE_COLS-1]) {
            x_off = col * DX + (row%2 == 1 ? DX/2 : 0);
            y_off = row * DY;
            translate([x_off, y_off, BASE_T-MAG_H]) {
                for(a=[0,120,240]) rotate([0,0,a]) translate([HEX_R*0.48, 0, 0])
                    cylinder(d=MAG_D, h=MAG_H+1, $fn=24);
                cylinder(d=MAG_D, h=MAG_H+1, $fn=24);
            }
            // Alignment pin holes on top
            translate([x_off, y_off, BASE_T-ALIGN_H])
                for(a=[60,180,300]) rotate([0,0,a]) translate([HEX_R*0.38, 0, 0])
                    cylinder(d=ALIGN_D+ALIGN_HOLE_EXTRA, h=ALIGN_H+1, $fn=20);
        }

        // Anti-slip cavity on bottom (for rubber pad sticker)
        translate([DX/2, DY*0.35, -1])
            cylinder(d=45, h=1.5, $fn=30);

        // Label on base
        translate([8, -HEX_SIZE*0.3, BASE_T-1.5]) linear_extrude(2)
            text("MAGNETIC HEX", size=6, $fn=4);
        translate([8, -HEX_SIZE*0.55, BASE_T-1.5]) linear_extrude(2)
            text("ORGANIZER", size=6, $fn=4);
    }

    // Rubber feet pockets (4 corners)
    for(x=[-DX*0.3, (BASE_COLS-0.7)*DX]) for(y=[-8, BASE_ROWS*DY-8])
        translate([x, y, -3]) difference() {
            cylinder(d=14, h=4, $fn=16);
            cylinder(d=10, h=5, $fn=16);
        }
}

// ── Assembly layout ────────────────────────────────────────
// Color 1 (body): hex module bodies
hex_module(H_TALL);
translate([HEX_FTF+2, 0, 0]) hex_module(H_MED);
translate([(HEX_FTF+2)*2, 0, 0]) hex_module(H_SHORT);
translate([(HEX_FTF+2)*3, 0, 0]) hex_module(H_TRAY);

// Color 2 (accent): base plate + magnet caps
translate([0, HEX_SIZE+25, 0]) hex_base_plate();

// Magnet cap batch (one cap per magnet position — print many)
for(i=[0:3]) translate([i*(MAG_D+3), HEX_SIZE+25+BASE_ROWS*HEX_SIZE*1.5+40, 0])
    magnet_cap();

// ── Assembly instructions card ─────────────────────────────
CARD_X = (HEX_FTF+2)*4+10;
difference() {
    cube([140, 120, 3]);
    translate([4,109,1.5]) linear_extrude(1.8) text("HEX ORGANIZER", size=8, $fn=4);
    translate([4,99,1.5]) linear_extrude(1.5) text("Magnets: 8×3mm neodymium", size=4.8, $fn=4);
    translate([4,90,1.5]) linear_extrude(1.5) text("4 magnets per module floor", size=4.8, $fn=4);
    translate([4,81,1.5]) linear_extrude(1.5) text("Press magnets in pockets", size=4.8, $fn=4);
    translate([4,72,1.5]) linear_extrude(1.5) text("Cap with printed disc", size=4.8, $fn=4);
    translate([4,62,1.5]) linear_extrude(1.5) text("Align pins auto-orient", size=4.8, $fn=4);
    translate([4,52,1.5]) linear_extrude(1.5) text("modules on base plate", size=4.8, $fn=4);
    translate([4,42,1.5]) linear_extrude(1.5) text("Heights:", size=4.8, $fn=4);
    translate([4,33,1.5]) linear_extrude(1.5) text(str("Tall: ",H_TALL,"mm  Med: ",H_MED,"mm"), size=4.5, $fn=4);
    translate([4,24,1.5]) linear_extrude(1.5) text(str("Short: ",H_SHORT,"mm  Tray: ",H_TRAY,"mm"), size=4.5, $fn=4);
    translate([4,14,1.5]) linear_extrude(1.5) text("Cable slot in one face", size=4.8, $fn=4);
    translate([4,5,1.5]) linear_extrude(1.5) text("for USB/power cables", size=4.8, $fn=4);
}
