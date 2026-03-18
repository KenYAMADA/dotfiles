$homeBin = Join-Path $HOME ".bin"

if (Test-Path $homeBin) {
    $pathEntries = $env:PATH -split ";"
    if ($pathEntries -notcontains $homeBin) {
        $env:PATH = "$homeBin;$env:PATH"
    }
}

$starshipConfig = Join-Path $HOME ".config\starship.toml"

if (Get-Command starship -ErrorAction SilentlyContinue) {
    $env:STARSHIP_CONFIG = $starshipConfig
    Invoke-Expression (& starship init powershell)
}
