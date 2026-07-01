# 🖨️ 3D Print Model Library

A curated collection of **145+ parametric OpenSCAD models + Blender character/organic library** designed specifically for the **Bambu Lab P2S Combo** with **AMS HT** (4-color multi-material printing). Every model is print-ready for PLA or PETG — no resin.

---

## 🖨️ Printer & Material Specs

| Property | Value |
|---|---|
| Printer | Bambu Lab P2S Combo + AMS HT |
| Build Volume | 256 × 256 × 256 mm |
| Materials | **PLA** (all models) · **PETG** (outdoor / translucent / flexible) |
| Colors | Up to 4-color AMS — single, dual, or quad color per model |
| Layer Height | 0.15 mm fine · 0.20 mm standard |
| Wall Count | 3–4 walls minimum |
| Infill | 10–25% (gyroid or grid) |
| Supports | Designed to be support-free wherever possible |

---

## 📁 Repository Structure

```
models/
├── abstract_art/        Borromean rings, Mondrian panel
├── accessories/         Cable organizers, phone stands, hooks
├── animation/           Zoetrope, flip-book stand
├── architecture/        Parthenon, pagoda, Eiffel Tower
├── art/                 City skyline lamp, mandala, voronoi, spiral tower
├── astronomy/           Moon phase mechanical calendar
├── biology/             Anatomical heart planter
├── book_nook/           Castle gateway, forest portal
├── botanical/           Mechanical blooming flower, treehouse planter
├── celtic/              Celtic knotwork interlace panel
├── compliant/           Flexure gripper, gyroid lattice vase
├── cryptex/             5-ring password lock box
├── dinosaur/            Flexi stegosaurus
├── dome/                Geodesic dome terrarium
├── education/           DNA helix model
├── flexi/               T-Rex, dragon, octopus, mechanical hand, gyroscope
├── fractal/             Sierpinski pyramid level 4
├── functional/          Coin sorter, self-watering planter, sundial
├── games/               Marble run modular track system
├── gaming/              Controller stand, headphone hanger, wrist rest
├── gifts/               Crystal vase, premium jewelry box
├── historical/          Viking longship drakkar
├── home_decor/          Fractal candle holder, honeycomb shelf
├── islamic_art/         8-star panel, Moroccan zellige coaster
├── jewelry/             Saturn ring box, pendants, bracelets
├── kids/                Marble run (spiral + straight)
├── kinematic/           Spirograph machine, iris aperture box
├── kinetic/             Newton's wave toy, sand pendulum, Calder mobile
├── kitchen/             Herb planter, magnetic spice rack
├── lego/                Compatible bricks, baseplate, keycap, minifig stand
├── marine/              Nautilus logarithmic spiral wall art
├── math_art/            3D Hilbert curve sculpture, torus knot vase
├── maze3d/              3-level internal marble maze sphere
├── mechanical/          Gear clock, orrery solar system, automata figure, Geneva drive, planetary gearset
├── miniature/           Roman Colosseum, Japanese zen garden
├── music/               Mechanical music box, vinyl record display
├── nature/              Ammonite fossil, leaf bowl, turtle box, mushroom cluster (Blender)
├── optical/             Kaleidoscope full kit
├── optical_art/         Penrose tiling, impossible triangle lamp, anamorphic art
├── outdoor/             Solar light plant stake
├── pets/                Cat feeder puzzle
├── puzzles/             Infinity cube, interlocking cross, iris box
├── scientific/          Astrolabe, Fibonacci ruler, Radiolaria lamp
├── seasonal/            Advent calendar, Halloween skull, Christmas ornament
├── skull/               Voronoi skull planter, Sugar skull Day of Dead
├── space/               Saturn V rocket 1:200, ISS display 1:700
├── strandbeest/         Jansen linkage walker, WHEG robot leg
├── surface_art/         Escher lizard tile, hyperbolic paraboloid, Seifert surface
├── tabletop/            Hex terrain tiles, dragon dice tower
├── tech/                Watch charging dock
├── tensegrity/          Floating table, floating wall shelf
├── tools/               Cable clips, key organizer, wall mount organizer
├── topology/            Klein bottle vase
├── vehicles/            Formula 1 display, toy car
├── wearable/            Auxetic bracelet, chainmail patch, steampunk goggles
├── wind/                Kinetic outdoor wind sail sculpture
├── characters/          Chibi character figures (Pikachu, sitting cat — Blender)
└── art/                 City skyline lamp, mandala, voronoi lamp shade, spiral tower
```

---

## 🌟 Featured Models

### 🔧 Mechanical & Kinematic

| Model | File | Description | Colors |
|---|---|---|---|
| Iris Aperture Box | `kinematic/iris_aperture_box.scad` | 8-blade print-in-place camera iris lid, secret box | Dual |
| Spirograph Machine | `kinematic/spirograph_machine.scad` | Gear plotter with 3 planet sets, pen carriage | Dual |
| Gear Wall Clock | `mechanical/gear_clock_face.scad` | 280mm exposed gear clock face | Dual |
| Orrery Solar System | `mechanical/orrery_solar_system.scad` | 6-planet mechanical orrery | 4-color |
| Strandbeest Walker | `strandbeest/jansen_linkage_walker.scad` | Theo Jansen 12-bar kinematic linkage | Single |
| Cryptex Lock Box | `cryptex/cryptex_password_box.scad` | 5-ring letter combination lock | Dual |
| Mechanical Music Box | `music/mechanical_music_box.scad` | Pin cylinder, brass comb, "Happy Birthday" | Dual |
| Moon Phase Calendar | `astronomy/moon_phase_calendar.scad` | Rotating 8-phase disc + 30-day ring, wall-mount | Dual |
| Mechanical Flower | `botanical/mechanical_blooming_flower.scad` | Cam-actuated 8-petal iris, rotate base to open | Dual |
| Compliant Gripper | `compliant/compliant_gripper.scad` | Single-print flexure gripper, 1.4mm hinges | Single |
| Geneva Drive | `mechanical/geneva_drive.scad` | 4-slot intermittent motion mechanism, M5 axles | Dual |
| Planetary Gearset | `mechanical/planetary_gear_set.scad` | 3-planet epicyclic 4:1 gearbox, sun+ring+carrier | Dual |
| Torus Knot Vase | `math_art/torus_knot_vase.scad` | Trefoil (3,2) knot swept tube, functional base | Single |
| Wobble Disc Gear | `mechanical/wobble_disc_gear.scad` | Nutating plate 36:1 single-stage reduction, M5/M6 | Dual |
| Lissajous Lamp | `math_art/lissajous_lamp.scad` | 3D Lissajous curve (3,4,2) PETG lamp, E14 socket | Dual |
| Hex Wall Tiles | `functional/modular_wall_tile_system.scad` | 4 patterns: star/honeycomb/sunburst/plain, snap-fit | Dual |
| Harmonic Drive | `mechanical/harmonic_drive.scad` | Strain wave gear 31:1 (wave gen + flex spline + ring) | Dual |
| Anamorphic Coaster | `optical/anamorphic_cylinder_art.scad` | Polar-distorted art reveals image in mirror cylinder | Dual |
| Key Cabinet | `functional/parametric_key_cabinet.scad` | 12-hook wall cabinet, labeled, magnetic door, pegboard | Dual |
| Hopf Fibration | `math_art/hopf_fibration_display.scad` | 32 Villarceau circles (S³→S²), interlocked fiber rings, 240mm | Dual |
| 4-Bar Linkage | `kinematic/four_bar_linkage.scad` | Grashof crank-rocker with coupler point tracer, Grashof proven | Dual |
| Acoustic Amplifier | `functional/passive_acoustic_amplifier.scad` | Exponential horn phone stand, ~15dB passive gain, no power | Dual |
| Cycloidal Drive | `mechanical/cycloid_drive.scad` | Hypocycloid 10:1 gear reduction, 11-pin ring, eccentric disk, viewing windows | Dual |
| Tensegrity Display | `functional/tensegrity_display.scad` | 3-strut floating tensegrity with assembly jig + string card, indexed holes | Dual |
| Differential Gear | `mechanical/differential_gear.scad` | Open automotive differential: ring + 2 spider + 2 side bevel gears, cutaway housing | Dual |
| Oloid Sculpture | `math_art/oloid_sculpture.scad` | Oloid rolling toy (Paul Schatz 1929), convex hull of 2 interlocked circles, full surface contact | Single |
| Sand Harmograph | `kinetic/sand_pendulum_harmograph.scad` | Two-pendulum Lissajous curve tracer with sand funnel, length-ratio freq control | Dual |
| Wankel Rotary Engine | `mechanical/wankel_rotary_engine.scad` | Epitrochoid housing, triangular rotor, ports, spark plug holes, combustion phase labels | Dual |
| Schwartz-P Lamp | `math_art/schwartz_p_lamp.scad` | Triply periodic minimal surface lamp shade, TPMS aperture pattern, E27 socket, 200mm | Dual |
| Accordion Lantern | `functional/collapsible_accordion_lantern.scad` | Print-in-place collapsible hexagonal lantern, 5 accordion folds, 120mm→30mm collapsed | Dual |

### 🎨 Art & Display

| Model | File | Description | Colors |
|---|---|---|---|
| Borromean Rings | `abstract_art/borromean_rings_sculpture.scad` | Print-in-place topological impossibility | Dual |
| Mondrian Panel | `abstract_art/mondrian_wall_panel.scad` | Parametric De Stijl grid, 200×200mm | 4-color |
| Celtic Knotwork | `celtic/knotwork_panel.scad` | Solomon's knot over/under interlace, 3×3 | Dual |
| Hilbert Cube | `math_art/hilbert_cube_sculpture.scad` | Level-3 space-filling fractal, 150mm | Single |
| Nautilus Wall Art | `marine/nautilus_wall_art.scad` | True logarithmic spiral cross-section, φ=1.618 | Dual |
| Sierpinski Pyramid | `fractal/sierpinski_pyramid.scad` | Level-4 recursive tetrahedron, 180mm | Dual |
| Ammonite Fossil | `nature/ammonite_fossil.scad` | Ceratitic suture pattern, 200mm plaque | Dual |
| Seifert Surface | `surface_art/seifert_surface_sculpture.scad` | Trefoil knot topology | Single |
| Penrose Tiling | `optical_art/penrose_tiling_coaster.scad` | P3 kite+dart aperiodic tiling coaster | 4-color |
| Voronoi Skull | `skull/voronoi_skull.scad` | Lattice openings, eye glow, planter | Dual |
| Mandala Wall Art | `art/mandala_wall_art_base.scad` | Parametric Islamic-inspired mandala | Dual |
| Escher Lizard Tile | `surface_art/escher_lizard_tile.scad` | M.C. Escher tessellation panel | Dual |
| Voronoi Lamp Shade | `art/voronoi_lamp_shade.scad` | Organic Voronoi cells, E27 socket, 200mm | Dual |
| Chladni Wall Art | `art/chladni_wall_art.scad` | 6-panel scientific resonance patterns, gallery rail, mode (1,1) to (3,3) | Dual |

### 🏛️ Architecture & Historical

| Model | File | Description | Colors |
|---|---|---|---|
| Parthenon Temple | `architecture/parthenon_temple.scad` | 1:200 scale, 8×17 Doric columns, pediment | Dual |
| Viking Longship | `historical/viking_longship.scad` | 280mm drakkar, dragon prow, oars, 16 shields | Dual |
| Roman Colosseum | `miniature/roman_colosseum.scad` | 3-tier elliptical arcade, 180mm | Single |
| Japanese Pagoda | `architecture/japanese_pagoda.scad` | Multi-tier traditional pagoda | Dual |
| Eiffel Tower | `architecture/mini_eiffel_tower.scad` | Miniature lattice tower | Single |

### 🌿 Functional & Everyday

| Model | File | Description | Colors |
|---|---|---|---|
| Coin Sorting Bank | `functional/coin_sorting_bank.scad` | Gravity ramp cascade, 5 tubes, EUR/USD | Dual |
| Self-Watering Planter | `functional/self_watering_planter.scad` | Double-wall wicking reservoir, PETG | Single |
| Treehouse Planter | `botanical/treehouse_planter.scad` | Whimsical cabin succulent pot, ladder | Dual |
| Herb Planter | `kitchen/herb_planter_window.scad` | Window sill modular herb garden | Single |
| Magnetic Spice Rack | `kitchen/magnetic_spice_rack.scad` | Fridge-mount magnetic spice containers | Dual |
| Equatorial Sundial | `functional/equatorial_sundial.scad` | Accurate solar time, calibrated lat=41° | Dual |
| Cat Feeder Puzzle | `pets/cat_feeder_puzzle.scad` | Slow-feed enrichment puzzle | Single |

### 🚀 Science & Space

| Model | File | Description | Colors |
|---|---|---|---|
| Saturn V Rocket | `space/saturn_v_rocket.scad` | 1:200 scale, F-1 engines, accurate stages | Dual |
| ISS Display Model | `space/iss_display_model.scad` | 1:700 scale, 8 solar wings, Cupola | Single |
| Planispheric Astrolabe | `scientific/astrolabe_planispheric.scad` | Medieval instrument, latitude 41° | Dual |
| DNA Helix | `education/dna_helix_model.scad` | Double helix with base pair rungs | Dual |
| Radiolaria Lamp | `scientific/radiolaria_lamp_shade.scad` | Haeckel bio-inspired E14 shade | Single |
| Fibonacci Ruler | `scientific/fibonacci_ruler_set.scad` | Ruler + golden ratio calipers + log spiral | Dual |

### 🎮 Gaming & Tech

| Model | File | Description | Colors |
|---|---|---|---|
| Dragon Dice Tower | `tabletop/dice_tower_dragon.scad` | Dragon head, zigzag baffles, gold details | Dual |
| Hex Terrain Tiles | `tabletop/hex_terrain_tile.scad` | 4 types: plains/forest/mountain/water, 100mm | Dual |
| Geodesic Terrarium | `dome/geodesic_dome_terrarium.scad` | 2V icosahedron snap-connect panels | Dual |
| LEGO-Compatible Bricks | `lego/lego_brick.scad` | Standard-stud compatible brick + baseplate | Single |
| Marble Run Pack | `games/marble_run_pack.scad` | 6 snap-connect sections: loop, split, funnel | Single |
| Controller Stand | `gaming/controller_stand_dual.scad` | Dual controller display stand | Dual |

### 🎨 Blender Organic Models

| Model | File | Description | Colors |
|---|---|---|---|
| Sitting Cat | `characters/cat_sitting_blender.stl` | Metaball cat with collar, bell, whiskers, green eyes | Dual-print (gray+red) |
| Mushroom Cluster | `nature/mushroom_cluster_blender.stl` | 10-mushroom forest scene, Amanita style, forest floor | Multi |
| Barn Owl on Perch | `characters/barn_owl_blender.stl` | Detailed barn owl, feather strips, talons, branch perch, 150mm | Dual |
| Coral Reef Scene | `nature/coral_reef_blender.stl` | Sea anemones + staghorn coral + seaweed, 160mm | Multi |
| Fennec Fox | `characters/fennec_fox_blender.stl` | Metaball fennec with giant ears, slit eyes, belly patch, 130mm | Dual |
| Dragon Head Wall | `characters/dragon_head_wall_blender.stl` | Dragon bust with horns, ridge spikes, slit eyes, shield plaque, 180mm | Multi |
| Axolotl | `characters/axolotl_blender.stl` | Wide-headed axolotl with feathery gill branches, dorsal fin, 180mm | Dual |
| Crystal Geode | `nature/crystal_geode_blender.stl` | Geode cross-section: amethyst+quartz+citrine crystals, 155mm | Multi |
| Narwhal | `characters/narwhal_blender.stl` | Metaball narwhal with twisted spiral horn, flukes, pectoral fins, spots, 240mm | Dual |
| Steampunk Octopus | `characters/steampunk_octopus_blender.stl` | 8 gear-ringed tentacles, goggle eyes, top hat, rivet band, gear badge, 204mm | Multi |
| Kitsune Fox | `characters/kitsune_fox_blender.stl` | Nine-tailed Japanese fox spirit, 9 flowing curved tails, slit pupils, whiskers, 238mm | Dual |
| Deep Sea Anglerfish | `nature/anglerfish_blender.stl` | Anglerfish with bioluminescent esca lure, curved illicium rod, massive fangs, pale eyes, 204mm | Single |
| Phoenix | `characters/phoenix_blender.stl` | Perched phoenix with spread wings (230mm), primary/secondary feathers, crest, rock perch | Dual |
| Manta Ray | `nature/manta_ray_blender.stl` | Oceanic manta ray, 240mm wingspan, cephalic horns, gill slits, belly spots, whip tail | Dual |

### 🦕 Flexi Animals (Print-in-Place)

| Model | File | Segments | Colors |
|---|---|---|---|
| Articulated T-Rex | `flexi/articulated_trex.scad` | Ball-socket joints | Dual |
| Flexi Dragon | `flexi/flexi_dragon.scad` | 18 segments | Dual |
| Flexi Octopus | `flexi/flexi_octopus.scad` | 8 tentacles | Dual |
| Flexi Stegosaurus | `dinosaur/flexi_stegosaurus.scad` | 20 segments + plates | Dual |
| Mechanical Hand | `flexi/mechanical_hand.scad` | Tendon-actuated fingers | Single |
| Gyroscope | `flexi/print_in_place_gyroscope.scad` | 3-axis gimbals | Single |

---

## 🎨 Dual-Color Workflow (Bambu P2S + AMS HT)

Each dual-color model consists of two bodies separated in BambuStudio by filament assignment:

```
1. Open the .scad file in OpenSCAD
2. Render (F6) and export as STL (File → Export → Export as STL)
3. Import STL into BambuStudio
4. Right-click model → "Assign Filament by Color"
   OR use the color painting tool (brush icon)
5. AMS Slot 1 → Color A (body/base)
   AMS Slot 2 → Color B (detail/accent)
6. Slice and send to printer
```

> **Tip:** Models with `// Color 1` and `// Color 2` comments in the SCAD file indicate which geometry belongs to each AMS filament slot.

### 4-Color Models (Full AMS HT Spectrum)

Models tagged `4-color` use all 4 AMS slots. Example — Mondrian panel:
- Slot 1 → White (background)
- Slot 2 → Red (rectangles)
- Slot 3 → Blue (rectangles)
- Slot 4 → Black (grid lines)

---

## ⚙️ Print Settings Reference

### PLA (default for most models)

```
Nozzle:         0.4mm
Layer height:   0.15mm (fine detail) or 0.20mm (standard)
Walls:          4 perimeters
Top/Bottom:     5 layers
Infill:         20% gyroid
Speed:          200mm/s (Bambu preset)
Nozzle temp:    220°C
Bed temp:       55°C
Cooling:        Part fan 100%
```

### PETG (outdoor, vases, flexible parts)

```
Nozzle:         0.4mm
Layer height:   0.20mm
Walls:          4 perimeters
Infill:         15–20% gyroid
Speed:          150mm/s
Nozzle temp:    240°C
Bed temp:       70°C
Cooling:        Part fan 50–70%
Supports:       Avoid if possible (stringing risk)
```

### Print-in-Place Critical Settings

```
Layer height:   0.15mm (mandatory — coarser layers fuse joints)
Joint gap:      0.35–0.45mm clearance built into design
First layer:    0.20mm for better bed adhesion
Tip:            Flex/shake model immediately after removal while still warm
Test first:     Print a single joint before full model
```

---

## 🔧 OpenSCAD Usage

### Install OpenSCAD

Download from [openscad.org](https://openscad.org/downloads.html) — free and open source.

### Open and render a model

```bash
openscad models/kinematic/iris_aperture_box.scad
# Press F5 for preview, F6 for full render, then File → Export → STL
```

### Batch export all models to STL

```powershell
# Windows — exports every .scad to matching .stl in /stl folder
.\export_all.ps1
```

### CLI export (single file)

```bash
openscad -o output.stl models/fractal/sierpinski_pyramid.scad
```

### Customize parameters

Every model has parameters at the top:

```openscad
// iris_aperture_box.scad
N_BLADES  = 8;     // Number of iris blades
IRIS_D    = 140;   // Outer diameter (mm)
GAP       = 0.38;  // Print-in-place clearance
BOX_H     = 40;    // Box body height
```

Change values → press `F6` to re-render → export updated STL.

---

## 📐 Design Constraints

All models follow these rules for reliable P2S printing:

| Constraint | Value | Reason |
|---|---|---|
| Minimum wall thickness | ≥ 2.5mm (typically 3.5mm+) | Structural integrity |
| Print-in-place joint gap | 0.35–0.45mm | Prevents fusion between moving parts |
| Max overhang angle | ≤ 45° where possible | Support-free printing |
| Maximum single dimension | ≤ 250mm | P2S build volume |
| Thread clearance | 0.3mm | Self-tapping M3/M4 screws fit |
| Bearing press-fit | −0.1 to −0.2mm | 608 / 624 bearings snap in |
| Magnet pocket | +0.1mm diameter | 6mm N52 magnets |

---

## 🌐 Where to Publish

These models are suitable for:

| Platform | Link | Notes |
|---|---|---|
| **MakerWorld** | makerworld.com | Bambu Lab native, best for P2S profiles |
| **Printables** | printables.com | Prusa community, strong engagement |
| **Thingiverse** | thingiverse.com | Largest general audience |
| **Cults3D** | cults3d.com | Paid model sales |
| **Etsy** | etsy.com | Sell physical prints or digital STL files |

---

## 🛠️ Tools & Pipeline

| Tool | Version | Purpose |
|---|---|---|
| **OpenSCAD** | 2021.01+ | Parametric model creation (all .scad files) |
| **BambuStudio** | Latest | Slicing, color assignment, AMS management |
| **export_all.ps1** | — | Batch STL export script |
| **Blender 5.1 + bpy** | 5.1 | Organic/character model generation (metaballs, subdivision surface) |
| **blender-mcp** | v1.6.4 | MCP server for AI-driven Blender scripting |

---

## 📊 Collection Stats

| Metric | Value |
|---|---|
| Total .scad files | 154+ |
| Blender STL models | 15 (cat, mushroom, pikachu, owl, coral, fennec, dragon, axolotl, geode, narwhal, steampunk octopus, kitsune, anglerfish, phoenix, manta ray) |
| Categories | 65+ |
| Dual-color models | ~60% |
| 4-color AMS models | ~10% |
| Print-in-place mechanisms | 20+ models |
| Functional everyday objects | ~44 models |
| Art & display pieces | ~56 models |
| Mechanical / kinematic | ~22 models |

---

## 🗂️ Tags Index

**#print-in-place** — iris_aperture_box · flexi_dragon · articulated_trex · flexi_octopus · mechanical_hand · gyroscope · chainmail_glove_patch · jansen_linkage_walker · borromean_rings_sculpture · marble_maze_sphere · compliant_gripper · auxetic_cuff_bracelet · mechanical_blooming_flower · spirograph_machine

**#outdoor-petg** — kinetic_wind_sail · self_watering_planter · herb_planter_window · plant_stake_solar_light · crystal_vase_parametric · gyroid_lattice_vase · treehouse_planter

**#wall-art** — nautilus_wall_art · mondrian_wall_panel · knotwork_panel · 8star_geometric_panel · moroccan_zellige_coaster · mandala_wall_art · penrose_tiling_coaster · ammonite_fossil · city_skyline_panel · topographic_coaster

**#math-art** — hilbert_cube_sculpture · sierpinski_pyramid · seifert_surface_sculpture · klein_bottle_vase · borromean_rings_sculpture · hyperbolic_paraboloid_vase · fibonacci_ruler_set · astrolabe_planispheric · nautilus_wall_art · hopf_fibration_display · chladni_wall_art

**#mechanical** — iris_aperture_box · spirograph_machine · gear_clock_face · orrery_solar_system · mechanical_music_box · cryptex_password_box · moon_phase_calendar · automata_walking_figure · jansen_linkage_walker · mechanical_blooming_flower · coin_sorting_bank · cycloid_drive · harmonic_drive · wobble_disc_gear · planetary_gear_set · geneva_drive

**#gifts** — saturn_ring_box · premium_jewelry_box · crystal_vase_parametric · cryptex_password_box · mechanical_music_box · vinyl_record_display · advent_calendar_box · zoetrope_3d · ammonite_fossil

**#kids** — marble_run_pack · marble_run_spiral · marble_maze_sphere · flexi_dragon · flexi_octopus · articulated_trex · lego_brick · dice_tower_dragon · cat_feeder_puzzle

**#characters** — pikachu_chibi · cat_sitting_blender · mushroom_cluster_blender

**#blender-organic** — cat_sitting_blender · mushroom_cluster_blender · pikachu_blender · barn_owl_blender · coral_reef_blender · fennec_fox_blender · dragon_head_wall_blender · axolotl_blender · crystal_geode_blender · narwhal_blender · steampunk_octopus_blender · kitsune_fox_blender · anglerfish_blender · phoenix_blender · manta_ray_blender

**#flexi-animals** — flexi_dragon · articulated_trex · flexi_octopus · flexi_stegosaurus · mechanical_hand

**#space** — saturn_v_rocket · iss_display_model · orrery_solar_system · moon_phase_calendar · astrolabe_planispheric

---

## 📜 License

Models released for personal use and making. Attribution appreciated for remixes.

---

*Designed for Bambu Lab P2S Combo · PLA/PETG only · No resin*
