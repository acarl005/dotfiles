if (Test-Path /opt/homebrew/bin/brew) {
  $(/opt/homebrew/bin/brew shellenv) | Invoke-Expression
}

# try {
#   fastfetch 
# } catch {
# }

# Set-PSReadLineOption -EditMode Vi

if (Test-Path -PathType Container "$HOME/.cargo/bin/") {
  $env:PATH += ":$HOME/.cargo/bin/" 
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

function gitd {
  git d
}

function gits {
  git s
}

Set-Alias -Name gti -Value git

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

function foobar {
  sleep 10
  'foobar'
}

$someVar = 'hi, I exist'

function prompt {
  $status = if ($true -eq $?) {
    ':large_green_circle:' 
  } else {
    ':red_circle:' 
  }
  $e = "$([char]0x1b)"
  "$e[33mDAN PROMPT$e[39m $($executionContext.SessionState.Path.CurrentLocation) ($status)$('>' * ($nestedPromptLevel + 1)) "
}

# Invoke-Expression (&starship init powershell)