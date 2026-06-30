// Radiolaria Lamp Shade — Bio-Inspired Geometric Light
// Based on Ernst Haeckel's Radiolaria drawings (1862)
// PETG translucent white — light shines through the lattice
// 0.15mm, 2 walls, 0% infill — pure shell
// Fits E14 bulb socket; 180mm dia, 160mm tall

R_OUTER  = 90;
R_INNER  = 85;
HEIGHT   = 160;
STRUT_D  = 3.5;
SPINE_D  = 5.0;
SPOKES   = 12;
RINGS    = 8;
PORE_D   = 18;     // Main pore opening diameter
SOCKET_D = 40;     // E14 socket collar ID

// ── Spherical lat/lon grid (like a globe) ─────────────
module sphere_strut(lat1, lon1, lat2, lon2, r) {
    p1 = [r * cos(lat1) * cos(lon1),
           r * cos(lat1) * sin(lon1),
           r * sin(lat1)];
    p2 = [r * cos(lat2) * cos(lon2),
           r * cos(lat2) * sin(lon2),
           r * sin(lat2)];
    hull() {
        translate(p1) sphere(d = STRUT_D, $fn = 10);
        translate(p2) sphere(d = STRUT_D, $fn = 10);
    }
}

// ── Radiolaria lattice shell ──────────────────────────
module radiolaria_shell() {
    lat_step = 120 / RINGS;      // latitude: -60° to +60°
    lon_step = 360 / SPOKES;

    // Latitude rings
    for (i = [0 : RINGS - 1]) {
        lat = -60 + i * lat_step;
        for (j = [0 : SPOKES - 1]) {
            lon0 = j * lon_step;
            lon1 = (j+1) * lon_step;
            sphere_strut(lat, lon0, lat, lon1, R_OUTER);
        }
    }
    // Longitude lines
    for (j = [0 : SPOKES - 1]) {
        lon = j * lon_step;
        for (i = [0 : RINGS - 2]) {
            lat0 = -60 + i * lat_step;
            lat1 = lat0 + lat_step;
            sphere_strut(lat0, lon, lat1, lon, R_OUTER);
        }
    }
    // Diagonal bracing (for rigidity)
    for (j = [0 : SPOKES - 1]) {
        lon0 = j * lon_step;
        lon1 = (j+1) * lon_step;
        for (i = [0 : RINGS - 2]) {
            lat0 = -60 + i * lat_step;
            lat1 = lat0 + lat_step;
            sphere_strut(lat0, lon0, lat1, lon1, R_OUTER);
        }
    }
    // Radial spines (Haeckel's characteristic projections)
    for (j = [0 : SPOKES - 1]) {
        lon = j * lon_step;
        for (lat = [-50, 0, 50]) {
            p = [R_OUTER * cos(lat) * cos(lon),
                 R_OUTER * cos(lat) * sin(lon),
                 R_OUTER * sin(lat)];
            hull() {
                translate(p) sphere(d = SPINE_D, $fn = 12);
                translate(p * 1.18) sphere(d = STRUT_D * 0.6, $fn = 8);
            }
        }
    }
}

// ── Top opening (flattened) with socket collar ────────
module top_collar() {
    translate([0, 0, R_OUTER * sin(60)]) {
        difference() {
            cylinder(d = SOCKET_D + 16, h = 18, $fn = 32);
            cylinder(d = SOCKET_D, h = 20, $fn = 28);
        }
        // Triangular gussets to sphere
        for (i = [0:2])
            rotate([0, 0, i * 120])
                hull() {
                    cylinder(d = 6, h = 2, $fn = 12);
                    translate([R_OUTER * 0.4, 0, -10])
                        sphere(d = STRUT_D, $fn = 10);
                }
    }
}

// ── Bottom ring (flat base) ───────────────────────────
module bottom_ring() {
    translate([0, 0, -R_OUTER * sin(60)])
        difference() {
            cylinder(d = R_OUTER * 2 * cos(60) + 20, h = 6, $fn = 48);
            cylinder(d = R_OUTER * 2 * cos(60), h = 8, $fn = 48);
        }
}

radiolaria_shell();
top_collar();
bottom_ring();
