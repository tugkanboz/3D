// Geodesic Dome Terrarium Kit — 2V Icosahedron, Snap-Connect Panels
// Modular kit: 20 triangular panels snap together without tools
// DUAL COLOR: struts (dark green) | triangle infill (translucent PETG)
// PETG (moisture resistant) — 0.2mm, 3 walls, 15% infill
// Assembled dome: ~200mm diameter — perfect plant terrarium

// 2V geodesic dome has 2 panel types:
//   - 30x Type A (Class I subdivision triangles — slightly larger)
//   - 10x Type B (slightly smaller at pentagon vertices)
// + 1 base ring + snap connector nodes

PHI     = 1.6180339887;
FREQ    = 2;        // Subdivision frequency (2V)
RADIUS  = 100;      // Dome radius
EDGE_A  = 0.5465 * RADIUS;  // Type A triangle edge (2V icosahedron)
EDGE_B  = 0.5176 * RADIUS;  // Type B triangle edge

STRUT_W = 8;        // Frame strut width
STRUT_T = 4;        // Strut thickness
PANEL_T = 1.5;      // Fill panel thickness (PETG translucent)
SNAP_D  = 5.0;      // Snap peg diameter
SNAP_H  = 5.5;      // Snap peg height
SNAP_FLEX_T = 1.2;  // Snap arm flex thickness
VENT_D  = 15;       // Ventilation hole in triangles
BASE_H  = 14;

// ── Equilateral triangle panel ────────────────────────
module eq_triangle_panel(edge, with_snap = true) {
    h = edge * sqrt(3) / 2;

    difference() {
        linear_extrude(STRUT_T)
            polygon([[0, 0], [edge, 0], [edge/2, h]]);
        // Interior cutout (translucent fill inset)
        translate([STRUT_W * 0.6, STRUT_W * 0.7, -1])
            linear_extrude(STRUT_T + 2)
                offset(r = -STRUT_W)
                    polygon([[0, 0], [edge, 0], [edge/2, h]]);
        // Vent hole
        translate([edge/2, h/3, -1])
            cylinder(d = VENT_D, h = STRUT_T + 2, $fn = 20);
    }

    if (with_snap) {
        // Snap connectors at each corner
        corners = [[0, 0], [edge, 0], [edge/2, h]];
        for (c = corners)
            translate([c[0], c[1], STRUT_T])
                snap_peg();
    }

    // Fill panel (translucent inset — print separately in PETG)
    // translate([...]) fill_panel(edge);
}

// ── Snap peg ─────────────────────────────────────────
module snap_peg() {
    difference() {
        union() {
            cylinder(d = SNAP_D, h = SNAP_H, $fn = 16);
            // Snap head (mushroom)
            translate([0, 0, SNAP_H - 2])
                cylinder(d1 = SNAP_D, d2 = SNAP_D + 3, h = 2, $fn = 16);
        }
        // 4-way flex slots (makes it snappable)
        for (a = [0, 90])
            rotate([0, 0, a])
                translate([-0.6, -SNAP_D/2 - 1, SNAP_H * 0.4])
                    cube([1.2, SNAP_D + 2, SNAP_H]);
    }
}

// ── Snap socket node (6 or 5-way hub) ─────────────────
module snap_hub(n_arms) {
    ang_step = 360 / n_arms;
    HUB_D    = SNAP_D * 3.5;
    ARM_L    = 12;

    difference() {
        cylinder(d = HUB_D, h = STRUT_T + 4, $fn = max(n_arms * 4, 24));
        cylinder(d = HUB_D - 6, h = STRUT_T + 5, $fn = 24);
        for (i = [0 : n_arms - 1])
            rotate([0, 0, i * ang_step])
                translate([HUB_D/2 - ARM_L, -SNAP_D/2 - 0.25, -1])
                    cube([ARM_L + 1, SNAP_D + 0.5, STRUT_T + 6]);
    }
    // Socket receivers
    for (i = [0 : n_arms - 1])
        rotate([0, 0, i * ang_step])
            translate([HUB_D/2, 0, 0])
                difference() {
                    cylinder(d = SNAP_D + 4, h = STRUT_T + 4, $fn = 16);
                    translate([0, 0, 2])
                        cylinder(d = SNAP_D + 0.4, h = STRUT_T + 5, $fn = 14);
                    translate([0, 0, STRUT_T + 2])
                        cylinder(d1 = SNAP_D + 0.4, d2 = SNAP_D + 4, h = 3, $fn = 14);
                }
}

// ── Base ring (flat, sits on table) ───────────────────
module base_ring() {
    RING_D = RADIUS * 1.8;
    difference() {
        cylinder(d = RING_D, h = BASE_H, $fn = 60);
        translate([0, 0, 4])
            cylinder(d = RING_D - 8, h = BASE_H, $fn = 60);
        // Door opening (front access)
        translate([-25, RING_D/2 - 5, -1])
            cube([50, 10, BASE_H + 2]);
        // Drainage holes
        for (a = [30, 90, 150, 210, 270, 330])
            rotate([0, 0, a])
                translate([RING_D * 0.35, 0, -1])
                    cylinder(d = 8, h = 5, $fn = 12);
        // Panel mount sockets around top edge
        for (a = [0:30:330])
            rotate([0, 0, a])
                translate([RING_D/2 - 6, -SNAP_D/2 - 0.25, BASE_H - STRUT_T - 4])
                    cube([8, SNAP_D + 0.5, STRUT_T + 5]);
    }
}

// ── Translucent fill panel (PETG — print as Color 2) ──
module fill_panel(edge) {
    h = edge * sqrt(3) / 2;
    linear_extrude(PANEL_T)
        offset(r = -STRUT_W)
            polygon([[0, 0], [edge, 0], [edge/2, h]]);
}

// ── Print layout ──────────────────────────────────────
// Type A panels (print 30)
eq_triangle_panel(EDGE_A);
translate([EDGE_A + 5, 0, 0]) eq_triangle_panel(EDGE_A);
translate([0, EDGE_A + 5, 0]) eq_triangle_panel(EDGE_A);

// Type B panels (print 10)
translate([EDGE_B * 3, 0, 0]) eq_triangle_panel(EDGE_B);

// Hubs: 12x 5-way (pentagons) + 30x 6-way (hexagons)
translate([0, EDGE_A * 2 + 15, 0]) snap_hub(5);
translate([30, EDGE_A * 2 + 15, 0]) snap_hub(6);

// Base ring
translate([EDGE_A * 3 + 20, 0, 0]) base_ring();

// Fill panels (Color 2 — PETG translucent)
translate([0, EDGE_A * 3 + 20, 0]) fill_panel(EDGE_A);
translate([EDGE_A + 5, EDGE_A * 3 + 20, 0]) fill_panel(EDGE_B);
