# Export all .scad files to STL
# Usage: .\export_all.ps1

$openscad = "C:\Program Files\OpenSCAD\openscad.exe"
$models   = Get-ChildItem -Recurse -Filter "*.scad" -Path "$PSScriptRoot\models"
$out_dir  = "$PSScriptRoot\stl"

if (-not (Test-Path $out_dir)) { New-Item -ItemType Directory $out_dir | Out-Null }

foreach ($f in $models) {
    $stl = Join-Path $out_dir ($f.BaseName + ".stl")
    Write-Host "Exporting: $($f.Name) ..."
    & $openscad -o $stl $f.FullName
}

Write-Host "`nDone. STL files saved to: $out_dir"
