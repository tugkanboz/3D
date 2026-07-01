// Saturn V Rocket — Detailed 1:200 Scale Display Model
// NASA Apollo mission rocket, accurate stage proportions
// DUAL COLOR: main body (white) | black/gold detail bands (accent)
// PLA — 0.15mm, 4 walls, 20% infill
// Height: ~230mm — fits P2S

SCALE    = 0.185;  // 1:200 scale (Saturn V = 111m → 205mm)

// Saturn V real dimensions (mm at 1:1):
S1_D = 10058;   // S-IC first stage diameter
S1_H = 42000;   // S-IC height (excl. engines)

S2_D = 10058;   // S-II diameter
S2_H = 24700;

S3_D = 6604;    // S-IVB third stage diameter
S3_H = 17820;

CM_D = 3900;    // Command module
SM_D = 3900;
LEM_D = 4300;   // Lunar module adapter

// ── Cylinder stage with detail ────────────────────────
module stage(d, h, taper_top=0) {
    d_top = (taper_top > 0) ? taper_top : d;
    cylinder(d1=d*SCALE, d2=d_top*SCALE, h=h*SCALE, $fn=32);
}

// ── Interstage skirt ──────────────────────────────────
module interstage(d1, d2, h) {
    cylinder(d1=d1*SCALE, d2=d2*SCALE, h=h*SCALE, $fn=32);
}

// ── F-1 Engine (5 per S-IC) ──────────────────────────
module f1_engine() {
    union() {
        // Thrust chamber
        cylinder(d1=1500*SCALE, d2=900*SCALE, h=2800*SCALE, $fn=16);
        // Nozzle extension
        translate([0,0,-1200*SCALE])
            cylinder(d1=1800*SCALE, d2=1500*SCALE, h=1200*SCALE, $fn=16);
        // Turbopump housing
        translate([0, 500*SCALE, 2000*SCALE]) sphere(d=600*SCALE, $fn=14);
    }
}

// ── J-2 Engine (5 per S-II, 1 per S-IVB) ─────────────
module j2_engine() {
    cylinder(d1=800*SCALE, d2=500*SCALE, h=2000*SCALE, $fn=14);
    translate([0,0,-600*SCALE])
        cylinder(d1=1000*SCALE, d2=800*SCALE, h=600*SCALE, $fn=14);
}

// ── Fins (S-IC grid fins / stabilizers) ───────────────
module fin() {
    linear_extrude(300*SCALE)
        polygon([[0,0],[0,3000*SCALE],[800*SCALE,1500*SCALE],[800*SCALE,0]]);
}

// ── Color accent bands (Color 2) ─────────────────────
module detail_bands() {
    // S-IC black roll pattern / USA text band
    translate([0,0,8000*SCALE])
        difference() {
            cylinder(d=S1_D*SCALE+0.5, h=1500*SCALE, $fn=32);
            cylinder(d=S1_D*SCALE-1, h=1600*SCALE, $fn=32);
        }
    // S-II gold insulation band
    translate([0,0,(S1_H+2000)*SCALE])
        difference() {
            cylinder(d=S2_D*SCALE+0.5, h=800*SCALE, $fn=32);
            cylinder(d=S2_D*SCALE-1, h=900*SCALE, $fn=32);
        }
    // S-IVB black band
    translate([0,0,(S1_H+S2_H+2000)*SCALE])
        difference() {
            cylinder(d=S3_D*SCALE+0.5, h=600*SCALE, $fn=28);
            cylinder(d=S3_D*SCALE-1, h=700*SCALE, $fn=28);
        }
    // Escape tower (LES) spike
    translate([0, 0, (S1_H+S2_H+S3_H+CM_D+SM_D+LEM_D+2000)*SCALE])
        cylinder(d1=200*SCALE, d2=0, h=4000*SCALE, $fn=8);
    // Escape tower cross arms
    translate([0, 0, (S1_H+S2_H+S3_H+CM_D+SM_D+LEM_D+4000)*SCALE])
        for (i=[0:2])
            rotate([0,0,i*120])
                translate([-150*SCALE, -150*SCALE, 0])
                    cube([300*SCALE, 1500*SCALE, 150*SCALE]);
}

// ── Launch stand / display base ────────────────────────
module display_base() {
    translate([0,0,-15]) {
        difference() {
            cylinder(d=S1_D*SCALE+20, h=15, $fn=32);
            translate([0,0,3]) cylinder(d=S1_D*SCALE+14, h=14, $fn=32);
        }
        // Nameplate
        translate([-22,-S1_D*SCALE/2-6,-12])
            cube([44, 4, 12]);
    }
}

// ── Full rocket assembly (Color 1 — white) ────────────
z0 = 0;
// S-IC (first stage)
translate([0,0,z0]) stage(S1_D, S1_H);
// S-IC engines (5x F-1)
for (i=[0:4]) {
    a = i * 72;
    r = (i==0) ? 0 : S1_D*0.32;
    translate([r*cos(a)*SCALE, r*sin(a)*SCALE, -1800*SCALE])
        f1_engine();
}
// Stabilizer fins (4x)
for (i=[0:3]) rotate([0,0,i*90])
    translate([S1_D/2*SCALE-100*SCALE, 0, 0])
        fin();

// Interstage S-IC to S-II
z1 = S1_H*SCALE;
translate([0,0,z1]) interstage(S1_D, S2_D, 1500);

// S-II (second stage)
z2 = z1 + 1500*SCALE;
translate([0,0,z2]) stage(S2_D, S2_H);

// Interstage S-II to S-IVB
z3 = z2 + S2_H*SCALE;
translate([0,0,z3]) interstage(S2_D, S3_D, 1500);

// S-IVB (third stage)
z4 = z3 + 1500*SCALE;
translate([0,0,z4]) stage(S3_D, S3_H);

// Instrument unit (ring)
z5 = z4 + S3_H*SCALE;
translate([0,0,z5]) cylinder(d=S3_D*SCALE, h=900*SCALE, $fn=28);

// Lunar module adapter (LMA) — tapers
z6 = z5 + 900*SCALE;
translate([0,0,z6]) interstage(S3_D, CM_D, LEM_D);

// Service module
z7 = z6 + LEM_D*SCALE;
translate([0,0,z7]) stage(SM_D, 6800);

// Command module (cone)
z8 = z7 + 6800*SCALE;
translate([0,0,z8]) cylinder(d1=CM_D*SCALE, d2=0, h=3500*SCALE, $fn=20);

// Color 2: detail bands + escape tower
detail_bands();
// Display base
display_base();
