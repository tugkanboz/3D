// Voronoi Lamp Shade — Parametric Organic Cell Pattern
// Fits standard E27 socket; print in PETG for heat + light diffusion
// DUAL COLOR: outer shell (white PETG) | inner ring + cap (dark accent)
// 0.2mm, 4 walls, gyroid 8% infill — ~4h print, 145g PETG
// Pattern method: pseudo-Voronoi via stacked sine displacement

$fn = 80;

// ── Dimensions ──────────────────────────────────────────
TOP_D    = 48;   // Top opening (E27 bulb thread clears ~40mm)
MID_D    = 155;  // Widest point
BOT_D    = 130;  // Bottom opening (light direction)
HEIGHT   = 200;
WALL     = 2.2;

// ── Voronoi cell parameters ──────────────────────────────
CELL_COUNT  = 28;  // Higher = smaller cells
CELL_DEPTH  = 4.5; // Depth of pattern ribs
VEIN_W      = 1.2; // Vein wall thickness
ROWS        = 12;  // Rows of cells vertically

// ── E27 socket ring ──────────────────────────────────────
SOCKET_OD   = 42;
SOCKET_ID   = 38;  // E27 thread minor diameter
SOCKET_H    = 22;

// ── Lamp profile (exponential flare) ─────────────────────
function profile_r(z) =
    let(t = z / HEIGHT,
        r_top = TOP_D/2,
        r_mid = MID_D/2,
        r_bot = BOT_D/2)
    // Bezier-like blend: tight at top, flares at 60%, tapers at bottom
    (t < 0.6)
    ? r_top + (r_mid - r_top) * pow(t/0.6, 0.65)
    : r_mid + (r_bot - r_mid) * pow((t-0.6)/0.4, 1.5);

// ── Generate profile points ───────────────────────────────
N_SLICES = 60;
PROFILE = [for (i=[0:N_SLICES]) [profile_r(i*HEIGHT/N_SLICES), i*HEIGHT/N_SLICES]];

// ── Main shell (rotate_extrude) ───────────────────────────
module shade_shell() {
    difference() {
        rotate_extrude(angle=360, $fn=120)
            polygon([[0,0],
                     each [for (p=PROFILE) [p[0], p[1]]],
                     [0, HEIGHT]]);
        // Inner hollow
        rotate_extrude(angle=360, $fn=120)
            polygon([[0,0],
                     each [for (p=PROFILE) [max(0.1, p[0]-WALL), p[1]]],
                     [0, HEIGHT]]);
        // Bottom open
        translate([0,0,-1]) cylinder(d=BOT_D+1, h=8, $fn=80);
    }
}

// ── Pseudo-Voronoi cutout cells ───────────────────────────
// Each cell is an ellipsoid-shaped hole in the shell wall
module voronoi_cells() {
    seed = 42;
    for (row=[0:ROWS-1]) {
        for (col=[0:CELL_COUNT-1]) {
            // Jitter position
            jx = sin(row * 73.1 + col * 37.7 + seed) * 0.4;
            jy = cos(row * 51.3 + col * 89.1 + seed) * 0.3;
            z_frac = (row + 0.5 + jy) / ROWS;
            z     = 15 + z_frac * (HEIGHT - 30);
            angle = (col + (row%2)*0.5 + jx) * 360 / CELL_COUNT;
            r     = profile_r(z);

            // Cell size varies with height (larger in middle)
            cell_w = (3 + 2.5 * sin(z_frac * 180)) * (1 + 0.4 * jx);
            cell_h = cell_w * (0.7 + 0.3 * cos(row * 29.7 + col * 17.3));

            rotate([0, 0, angle])
                translate([r - CELL_DEPTH/2, 0, z])
                    rotate([0, 90, 0])
                        scale([1, cell_h/cell_w, 1])
                            cylinder(d=cell_w, h=CELL_DEPTH + 2, $fn=12);
        }
    }
}

// ── E27 socket collar (Color 2) ───────────────────────────
module socket_collar() {
    translate([0, 0, HEIGHT - SOCKET_H])
        difference() {
            cylinder(d=SOCKET_OD, h=SOCKET_H+2, $fn=48);
            // Socket bore
            cylinder(d=SOCKET_ID, h=SOCKET_H+3, $fn=48);
            // Strain relief slots
            for (a=[0,90,180,270])
                rotate([0,0,a]) translate([SOCKET_ID/2-2, -2, 5])
                    cube([8, 4, SOCKET_H]);
        }
    // Thread grip ribs (4 ribs, printed as internal castellations)
    translate([0,0,HEIGHT-SOCKET_H+3])
        difference() {
            cylinder(d=SOCKET_ID-0.5, h=SOCKET_H-6, $fn=48);
            cylinder(d=SOCKET_ID-3.5, h=SOCKET_H-5, $fn=48);
            for (a=[0:45:315])
                rotate([0,0,a]) translate([-12,-1,0]) cube([12,2,SOCKET_H]);
        }
}

// ── Bottom rim ring (Color 2) ─────────────────────────────
module bottom_rim() {
    difference() {
        cylinder(d=BOT_D+6, h=7, $fn=80);
        cylinder(d=BOT_D-4, h=8, $fn=80);
    }
    // Decorative ribbing on rim
    for (a=[0:30:330])
        rotate([0,0,a])
            translate([BOT_D/2, 0, 7])
                sphere(d=4, $fn=8);
}

// ── Assembly ──────────────────────────────────────────────
// Color 1 (white PETG): main shade with voronoi cells
difference() {
    shade_shell();
    voronoi_cells();
}

// Color 2 (dark accent): socket collar + bottom rim
socket_collar();
bottom_rim();
