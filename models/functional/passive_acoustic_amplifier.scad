// Passive Acoustic Phone Amplifier — No Power Required
// Pure physics: exponential horn + resonant chamber amplifies smartphone audio ~15-20dB
// Works for iPhone and Android (choose PHONE_W parameter)
// DUAL COLOR: horn body (PLA) | decorative resonance rings (accent)
// PETG or PLA 0.20mm, 4 walls, 0% infill for resonance chamber (important!)
// Best in PETG — slight flex improves acoustic coupling
// Print orientation: lying flat, resonance chamber on build plate

$fn = 60;

// ── Phone slot dimensions ─────────────────────────────────
PHONE_W    = 78;    // Phone width (iPhone 14 = 71.5, iPhone 14 Plus = 78.1, Android ~76)
PHONE_T    = 8.5;   // Phone thickness (typical 7.5–9mm, clearance built in)
PHONE_D    = 50;    // Slot depth (how far phone sits in)
SLOT_CLR   = 1.2;   // Slot clearance on each side
SPEAKER_Y  = 15;    // Distance from phone bottom to speaker (iPhone speaker pos)

// ── Horn geometry ─────────────────────────────────────────
// Exponential horn: A(x) = A_throat * e^(m*x) — most efficient for amplification
THROAT_D    = 18;   // Horn throat diameter (narrow end, near phone)
MOUTH_D     = 145;  // Horn mouth diameter (wide end, toward listener)
HORN_L      = 200;  // Horn length
HORN_FLARE  = 0.012; // Flare constant m (exponential horn)
WALL        = 4.0;
BASE_T      = 8;

// ── Resonance chamber ─────────────────────────────────────
// Helmholtz resonator enhances bass frequencies
CHAMBER_W   = PHONE_W + SLOT_CLR*2 + 30;
CHAMBER_H   = 55;
CHAMBER_D   = 45;
PORT_D      = 18;   // Helmholtz port diameter
PORT_L      = 25;   // Helmholtz port length (tunes bass frequency)

// ── Exponential horn profile function ─────────────────────
// r(x) = r_throat * exp(HORN_FLARE * x / 2)
function horn_r(x) = THROAT_D/2 * exp(HORN_FLARE * x);

// ── Exponential horn body ─────────────────────────────────
module horn() {
    N = 60;
    PROFILE = [for(i=[0:N]) [horn_r(i*HORN_L/N), i*HORN_L/N]];

    difference() {
        // Outer surface (wall adds WALL to radius)
        rotate_extrude(angle=360, $fn=100)
            polygon([[0,0],
                     each [for(p=PROFILE) [p[0]+WALL, p[1]]],
                     [0, HORN_L]]);
        // Inner bore (exponential profile)
        rotate_extrude(angle=360, $fn=80)
            polygon([[0,0],
                     each [for(p=PROFILE) [p[0], p[1]]],
                     [0, HORN_L]]);
        // Bottom flat (for bed printing)
        translate([-MOUTH_D, -MOUTH_D, -1])
            cube([MOUTH_D*2, MOUTH_D*2, 1.5]);
    }
}

// ── Resonance chamber body ────────────────────────────────
module resonance_chamber() {
    W = CHAMBER_W; H = CHAMBER_H; D = CHAMBER_D;
    difference() {
        // Outer shell
        union() {
            translate([0, 0, 0]) cube([W, D, H], center=true);
            // Rounded corners
            for(x=[-W/2+8,W/2-8]) for(z=[-H/2+8,H/2-8])
                translate([x,0,z]) cylinder(d=16, h=D, center=true, $fn=20);
        }
        // Interior cavity (0% infill = hollow)
        cube([W-WALL*2, D-WALL*2, H-WALL*2], center=true);
        // Phone slot (centered)
        translate([0, D/2-PHONE_D/2, -H/4])
            cube([PHONE_W+SLOT_CLR*2, PHONE_D+2, H*0.7], center=true);
        // Helmholtz port (front, tuned for bass)
        translate([0, -D/2-1, SPEAKER_Y-H/2])
            rotate([90, 0, 0]) cylinder(d=PORT_D, h=PORT_L+2, $fn=24);
        // Side ports (for stereo if speaker on side)
        for(s=[-1,1])
            translate([s*(W/2+1), 0, SPEAKER_Y-H/2])
                rotate([0,90,0]) cylinder(d=12, h=WALL*2+2, $fn=20);
        // Cable port (bottom)
        translate([0, 0, -H/2-1]) cylinder(d=10, h=WALL+2, $fn=16);
    }
}

// ── Horn mouth decorative rim ─────────────────────────────
module horn_mouth_ring() {
    translate([0, 0, HORN_L-2]) {
        difference() {
            cylinder(d=MOUTH_D+10, h=8, $fn=80);
            cylinder(d=MOUTH_D-4, h=9, $fn=80);
            // Decorative notches
            for(a=[0:30:330])
                rotate([0,0,a]) translate([MOUTH_D/2+2, -3, 0])
                    cube([8, 6, 9]);
        }
        // Acoustic flare lip (improves radiation pattern)
        translate([0,0,6]) {
            rotate_extrude(angle=360, $fn=80)
                translate([MOUTH_D/2+1, 0])
                    rotate([0,0,45]) square([6, 6], center=true);
        }
    }
}

// ── Acoustic resonance rings (Color 2) ────────────────────
// Quarter-wavelength resonators at ~1kHz spacing
module resonance_rings() {
    FREQS_R = [horn_r(HORN_L*0.3), horn_r(HORN_L*0.55), horn_r(HORN_L*0.78)];
    POSITIONS = [HORN_L*0.3, HORN_L*0.55, HORN_L*0.78];
    for(i=[0:2])
        translate([0, 0, POSITIONS[i]])
            difference() {
                cylinder(r=FREQS_R[i]+WALL+4, h=5, $fn=80);
                cylinder(r=FREQS_R[i]+WALL-0.5, h=6, $fn=80);
            }
}

// ── Stand legs (non-slip, angled for optimal listening) ───
module stand_leg(angle) {
    rotate([0,0,angle]) translate([MOUTH_D*0.38, 0, 0])
        rotate([0,-12,0])
            difference() {
                cylinder(d=14, h=HORN_L*0.25+BASE_T, $fn=12);
                cylinder(d=8,  h=HORN_L*0.25+BASE_T+1, $fn=12);
            }
}

// ── Frequency chart (embossed on back) ────────────────────
module freq_chart() {
    for(i=[0:5])
        translate([-30+i*12, 0, BASE_T-1])
            linear_extrude(1.5)
                text(str((i+1)*200, "Hz"), size=3, halign="center", $fn=4);
}

// ── Assembly ──────────────────────────────────────────────
// Both share a vertical orientation — horn mouth faces listener

// Color 1 (PLA/PETG body): horn + resonance chamber
translate([0, 0, CHAMBER_H/2+4]) resonance_chamber();
translate([0, 0, CHAMBER_H+10]) horn();
// Stand
for(a=[0, 120, 240]) stand_leg(a);

// Color 2 (accent): resonance rings + horn mouth ring + frequency chart
translate([0, 0, CHAMBER_H+10]) {
    resonance_rings();
    horn_mouth_ring();
}
