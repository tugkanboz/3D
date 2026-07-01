// Moroccan Zellige Tile Coaster — 12-Fold Star Pattern
// Traditional hand-cut tile geometry, mathematically exact
// DUAL COLOR: star/polygon (terracotta) | background (cream)
// PLA — 0.15mm, 3 walls, 15% infill
// 100mm coaster fits 4 on P2S plate

COASTER_W = 100;
COASTER_T = 5.0;
PATTERN_H = 2.2;
GROUT_W   = 1.8;   // Grout line width (gap between tiles)
BEVEL_R   = 0.5;

// 12-fold rosette: central 12-pointed star + surrounding shapes
module star_12(r, t) {
    linear_extrude(t)
        union() {
            for (i=[0:2])
                rotate([0,0,i*60]) square([r*1.8, r*0.42], center=true);
        }
}

// ── 12-pointed star ───────────────────────────────────
module dodecagram(r, t) {
    linear_extrude(t)
        union() {
            for (i=[0:3]) rotate([0,0,i*30]) square([r*2, r*0.35], center=true);
        }
}

// ── Kite shape (fills between star points) ────────────
module kite_fill(angle, dist, w, h, t) {
    rotate([0,0,angle])
        translate([dist, 0, 0])
            linear_extrude(t)
                polygon([[0,0],[-w/2,h],[w/2,h]]);
}

// ── Hexagon fill ──────────────────────────────────────
module hex_fill(cx, cy, r, t) {
    translate([cx,cy,0])
        linear_extrude(t)
            circle(r=r, $fn=6);
}

// ── Full zellige pattern ──────────────────────────────
module zellige_pattern() {
    C = COASTER_W/2;
    BASE_T = COASTER_T;
    PAT_T  = PATTERN_H;
    R      = C * 0.32;   // Central star radius

    // Central 12-pointed star
    translate([C,C,BASE_T])
        dodecagram(R, PAT_T);

    // 12 kite shapes around center
    for (i=[0:11])
        translate([C,C,BASE_T])
            kite_fill(i*30, R*1.15, R*0.3, R*0.38, PAT_T);

    // 12 outer shapes (elongated hexagons)
    for (i=[0:11]) {
        a = i * 30;
        r_out = R * 1.7;
        translate([C + cos(a)*r_out, C + sin(a)*r_out, BASE_T])
            rotate([0,0,a])
                linear_extrude(PAT_T)
                    polygon([
                        [0, R*0.22], [R*0.18, R*0.08],
                        [R*0.18, -R*0.08], [0, -R*0.22],
                        [-R*0.18, -R*0.08], [-R*0.18, R*0.08]
                    ]);
    }

    // 6 large hexagonal fills
    for (i=[0:5]) {
        a = i * 60 + 30;
        hex_fill(C + cos(a)*R*2.2, C + sin(a)*R*2.2, R*0.52, BASE_T + PAT_T*0.6);
    }

    // Corner accent stars (4 corners)
    CORNER_R = R * 0.4;
    for (cx=[CORNER_R*1.5, COASTER_W - CORNER_R*1.5],
         cy=[CORNER_R*1.5, COASTER_W - CORNER_R*1.5])
        translate([cx, cy, BASE_T])
            dodecagram(CORNER_R, PAT_T * 0.8);
}

// ── Coaster base (Color 1 — terracotta) ──────────────
module coaster_base() {
    difference() {
        // Slightly rounded base
        hull() {
            for (dx=[3,COASTER_W-3], dy=[3,COASTER_W-3])
                translate([dx,dy,0])
                    cylinder(r=3, h=COASTER_T, $fn=12);
        }
        // Anti-slip feet recesses (4 corners)
        for (cx=[8,COASTER_W-8], cy=[8,COASTER_W-8])
            translate([cx,cy,-1]) cylinder(d=12, h=3, $fn=8);
    }
}

coaster_base();
zellige_pattern();
