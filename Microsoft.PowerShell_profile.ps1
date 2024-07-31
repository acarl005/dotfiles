# try {
#   fastfetch 
# } catch {
# }

# Set-PSReadLineOption -EditMode Vi

if (Test-Path -PathType Container "$($HOME)/.cargo/bin/") {
  $env:PATH += ":$($HOME)/.cargo/bin/" 
}

if (Get-Alias cd -ErrorAction SilentlyContinue) {
  Remove-Alias cd
}

function cd {
  Set-Location $args[0]
  ll
}

function mkcd {
  mkdir -p $args[0] && cd $args[0]
}

if (Test-Path /opt/homebrew/bin/brew) {
  $(/opt/homebrew/bin/brew shellenv) | Invoke-Expression
}


if (Get-Command -Name nvim -Type Application -ErrorAction SilentlyContinue) {
  Set-Alias -Name vim -Value nvim
  Set-Alias -Name vi -Value nvim
  Set-Alias -Name v -Value nvim
}

if (Get-Command -Name ls-go -Type Application -ErrorAction SilentlyContinue) {
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

if (Get-Command -Name Invoke-ZLocation -ErrorAction SilentlyContinue) {
  Set-Alias -Name j -Value Invoke-ZLocation
}
