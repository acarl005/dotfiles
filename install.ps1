$ErrorActionPreference = "Stop"

# Get the directory where this script is located
$DIR = Split-Path -Parent $MyInvocation.MyCommand.Path

# Install packages via winget
Write-Host "Installing packages via winget..." -ForegroundColor Yellow
Write-Host "This may take several minutes..." -ForegroundColor Gray

$packages = @(
    @{Id="Git.Git"; Name="Git"},
    @{Id="GitHub.cli"; Name="GitHub CLI"},
    @{Id="Neovim.Neovim"; Name="Neovim"},
    @{Id="Starship.Starship"; Name="Starship"},
    @{Id="BurntSushi.ripgrep.MSVC"; Name="ripgrep"},
    @{Id="Rustlang.Rustup"; Name="Rustup"},
    @{Id="sharkdp.fd"; Name="fd"},
    @{Id="sharkdp.bat"; Name="bat"},
    @{Id="junegunn.fzf"; Name="fzf"},
    @{Id="eza-community.eza"; Name="eza"},
    @{Id="jqlang.jq"; Name="jq"},
    @{Id="Fastfetch-cli.Fastfetch"; Name="fastfetch"},
    @{Id="dandavison.delta"; Name="git-delta"},
    @{Id="sxyazi.yazi"; Name="yazi"},
    @{Id="tldr-pages.tlrc"; Name="tldr"},
    @{Id="tree-sitter.tree-sitter"; Name="tree-sitter"},
    @{Id="Gyan.FFmpeg"; Name="ffmpeg"},
    @{Id="RazrFalcon.resvg"; Name="resvg"},
    @{Id="DEVCOM.InconsolataNerdFont"; Name="Inconsolata Nerd Font"}
)

foreach ($package in $packages) {
    Write-Host "  Installing $($package.Name)..." -ForegroundColor Gray
    try {
        winget install --id $package.Id --silent --accept-source-agreements --accept-package-agreements 2>$null | Out-Null
        Write-Host "    ✓ $($package.Name) installed" -ForegroundColor Green
    }
    catch {
        Write-Host "    ⚠ Failed to install $($package.Name)" -ForegroundColor Yellow
    }
}

New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.config" | Out-Null

$nvimConfigPath = "$env:LOCALAPPDATA\nvim"
New-Item -ItemType Directory -Force -Path "$nvimConfigPath" | Out-Null
if (Test-Path $nvimConfigPath) {
    Remove-Item -Recurse -Force $nvimConfigPath
}
New-Item -ItemType SymbolicLink -Path $nvimConfigPath -Target "$DIR\nvim" -Force | Out-Null

# $warpThemesPath = "$env:LOCALAPPDATA\Warp\themes"
# New-Item -ItemType Directory -Force -Path "$env:LOCALAPPDATA\Warp" | Out-Null
# if (Test-Path $warpThemesPath) {
#     Remove-Item -Recurse -Force $warpThemesPath
# }
# New-Item -ItemType SymbolicLink -Path $warpThemesPath -Target "$DIR\warp-themes" -Force | Out-Null

# Set up PowerShell profile
$psProfilePath = "$PROFILE"
if (Test-Path $psProfilePath) {
    Remove-Item -Force $psProfilePath
}
New-Item -ItemType SymbolicLink -Path $psProfilePath -Target "$DIR\Microsoft.PowerShell_profile.ps1" -Force | Out-Null

$gitConfigPath = "$env:USERPROFILE\.gitconfig"
if (Test-Path $gitConfigPath) {
    Remove-Item -Force $gitConfigPath
}
New-Item -ItemType SymbolicLink -Path $gitConfigPath -Target "$DIR\.gitconfig" -Force | Out-Null

$gitIgnorePath = "$env:USERPROFILE\.gitignore_global"
if (Test-Path $gitIgnorePath) {
    Remove-Item -Force $gitIgnorePath
}
New-Item -ItemType SymbolicLink -Path $gitIgnorePath -Target "$DIR\.gitignore_global" -Force | Out-Null

# Set up Starship configuration
$starshipConfigPath = "$env:USERPROFILE\.config\starship.toml"
if (Test-Path $starshipConfigPath) {
    Remove-Item -Force $starshipConfigPath
}
New-Item -ItemType SymbolicLink -Path $starshipConfigPath -Target "$DIR\starship.toml" -Force | Out-Null
