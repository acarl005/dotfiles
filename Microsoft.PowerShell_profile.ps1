try {
  fastfetch 
} catch {
}

# Set-PSReadLineOption -EditMode Vi

function cd {
  &(Get-Command -CommandType Application cd) $args
  ll
}

if (Test-Path /opt/homebrew/bin/brew) {
  $(/opt/homebrew/bin/brew shellenv) | Invoke-Expression
}

try {
  Get-Command -ErrorAction Stop -Type Application nvim 2>&1>$null
  Set-Alias -Name vi -Value nvim
} catch {
}

try {
  Get-Command -ErrorAction Stop -Type Application ls-go 2>&1>$null
  function ll {
    ls-go -alLkn $args
  }
} catch {
  function ll {
    if ($isLinux) {
      ls -FlAhp --color=auto $args
    } else {
      ls -FGlAhp $args
    }o
  }
}

try {
  Get-Command -ErrorAction Stop -Type Application nvim 2>&1>$null
  function ya {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
      Set-Location -LiteralPath $cwd
    }
    Remove-Item -Path $tmp
  }
} catch {
}
