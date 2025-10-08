if (Test-Path /opt/homebrew/bin/brew) {
  $(/opt/homebrew/bin/brew shellenv) | Invoke-Expression
}

try {
  fastfetch 
} catch {
}

Set-PSReadLineOption -EditMode Vi

if (Test-Path -PathType Container "$HOME/.cargo/bin/") {
  $env:PATH += ":$HOME/.cargo/bin/" 
}

if (Get-Alias cd -ErrorAction SilentlyContinue) {
  Remove-Alias cd
}

function cd {
  Set-Location "$($args[0])" -ErrorAction Stop
  ls
}

function mkcd {
  mkdir -p "$($args[0])" && cd "$($args[0])"
}

function gitd {
  git d
}

function gits {
  git s
}

function desk {
  cd ~/Desktop
}

function down {
  cd ~/Downloads
}

if (Get-Command -Name nvim -Type Application -ErrorAction SilentlyContinue) {
  Set-Alias -Name vim -Value nvim
  Set-Alias -Name vi -Value nvim
  Set-Alias -Name v -Value nvim
}

if (Get-Command -Name fastfetch -Type Application -ErrorAction SilentlyContinue) {
  Set-Alias -Name ff -Value fastfetch
}

if (Get-Command -Name eza -Type Application -ErrorAction SilentlyContinue) {
  function ll {
    eza -al --icons --group-directories-first --sort extension
  }
} else if (Get-Command -Name ls-go -Type Application -ErrorAction SilentlyContinue) {
  function ll {
    ls-go -alLkn $args
  }
} else {
  function ll {
    if ($isLinux) {
      ls -FlAhp --color=auto $args
    } else {
      ls -FGlAhp $args
    }
  }
}

Set-Alias -Name gti -Value git
Set-Alias -Name j -Value Invoke-ZLocation

if (Get-Command -Name yazi -Type Application -ErrorAction SilentlyContinue) {
  function ya {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
      Set-Location -LiteralPath $cwd
    }
    Remove-Item -Path $tmp
  }
}


Invoke-Expression (&starship init powershell)

function dev {
  Import-Module 'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\Microsoft.VisualStudio.DevShell.dll'
  Enter-VsDevShell b31daaa6 -SkipAutomaticLocation -DevCmdArguments '-arch=x64 -host_arch=x64'
}

Import-Module Terminal-Icons
Import-Module ZLocation
