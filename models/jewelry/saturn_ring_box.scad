// Saturn Ring Box — Planet Jewelry Box
// Opens at equator to reveal velvet-lined ring storage chamber
// DUAL COLOR: planet body (sandy beige) | rings (gray metallic)
// PLA — 0.15mm, 4 walls, 20% infill — print both halves flat
// ~120mm wide (rings), ~65mm planet diameter

PLANET_D  = 65;   // Planet sphere diameter
RING_R1   = 45;   // Inner ring radius
RING_R2   = 60;   // Outer ring radius
RING_T    = 3.5;  // Ring thickness
RING_TILT = 27;   // Saturn ring tilt angle (degrees)
WALL      = 3.5;
GAP       = 0.25; // Lid gap (tight fit)
VELVET_D  = PLANET_D*0.55;  // Interior cavity diameter
CAVITY_H  = PLANET_D*0.22;  // Ring slot depth

// ── Planet hemisphere (lower body) ────────────────────
module planet_lower() {
    difference() {
        // Half sphere (bottom)
        sphere(d=PLANET_D, $fn=60);
        // Cut at equator
        translate([-PLANET_D, -PLANET_D, -0.3])
            cube([PLANET_D*2, PLANET_D*2, PLANET_D]);
        // Interior cavity (ring storage)
        sphere(d=PLANET_D-WALL*2, $fn=50);
        // Rubber feet recesses
        for (i=[0:2])
            rotate([0,0,i*120])
                translate([PLANET_D*0.3, 0, -PLANET_D/2+2])
                    cylinder(d=8, h=3, $fn=12);
    }
    // Equator alignment ring (female socket)
    translate([0,0,-0.8])
        difference() {
            cylinder(d=PLANET_D*0.98, h=2.5, $fn=60);
            cylinder(d=PLANET_D*0.94-GAP, h=3, $fn=60);
        }
    // Band detail lines (atmospheric belts — raised ridges)
    for (lat=[-20,-12,-5,5,12,20]) {
        translate([0, 0, lat*PLANET_D*0.01*(-1)]) {
            rotate_extrude($fn=60)
                translate([cos(lat)*PLANET_D/2, 0])
                    scale([sin(2)*0.5+0.3, 1])
                        circle(d=1.5, $fn=8);
        }
    }
    // Ring holder post (ring hangs on peg inside)
    difference() {
        cylinder(d=6, h=CAVITY_H+5, $fn=14);
        cylinder(d=3, h=CAVITY_H+7, $fn=10);
    }
}

// ── Planet hemisphere (upper lid) ────────────────────
module planet_upper() {
    translate([0, 0, 0.3]) {
        difference() {
            // Half sphere (top)
            sphere(d=PLANET_D, $fn=60);
            // Cut at equator + lid socket
            translate([-PLANET_D, -PLANET_D, -PLANET_D])
                cube([PLANET_D*2, PLANET_D*2, PLANET_D+1.5]);
            // Interior hollow
            translate([0,0,-PLANET_D*0.15])
                sphere(d=PLANET_D-WALL*2, $fn=50);
        }
        // Lid socket (male ring)
        translate([0,0,-2])
            difference() {
                cylinder(d=PLANET_D*0.94, h=3, $fn=60);
                cylinder(d=PLANET_D*0.88, h=4, $fn=60);
            }
        // Cloud band detail lines
        for (lat=[5,15,25])
            rotate_extrude($fn=60)
                translate([cos(lat)*PLANET_D/2, lat*0.2])
                    scale([0.4, 1])
                        circle(d=1.8, $fn=8);
        // North pole vortex (Great White Spot analog)
        translate([0, 0, PLANET_D/2-3])
            scale([1,1,0.3])
                sphere(d=14, $fn=16);
    }
}

// ── Saturn's ring system ──────────────────────────────
module ring_system() {
    // 3 concentric rings (Cassini division gap between B and A rings)
    RINGS = [
        [RING_R1,    RING_R1+8,   RING_T],     // B ring (widest)
        [RING_R1+10, RING_R1+15,  RING_T*0.7], // Cassini division → A ring
        [RING_R1+17, RING_R2,     RING_T*0.5], // A ring (outer)
    ];
    for (r=RINGS) {
        difference() {
            cylinder(r=r[1], h=r[2], center=true, $fn=80);
            cylinder(r=r[0], h=r[2]+1, center=true, $fn=80);
        }
        // Ring spoke detail (dark spoke pattern, dust lanes)
        for (i=[0:11])
            rotate([0,0,i*30])
                translate([r[0]+1, -0.5, -r[2]/2])
                    cube([r[1]-r[0]-2, 1, r[2]]);
    }
}

// ── Label plinth (optional display base) ─────────────
module display_label() {
    translate([0, 0, -PLANET_D/2-8]) {
        difference() {
            cylinder(d=70, h=8, $fn=6);
            translate([0,0,3])
                cylinder(d=62, h=6, $fn=6);
            translate([-32, -6, 7])
                linear_extrude(2)
                    text("SATURN JEWELRY BOX", size=4.5, $fn=4);
        }
    }
}

// ── Assembled ─────────────────────────────────────────
// Color 1 (sandy beige): planet body
planet_lower();
translate([0, 0, 0]) planet_upper();

// Color 2 (gray metallic): ring system
rotate([RING_TILT, 0, 0])
    ring_system();

display_label();
