function gbk2jis {
  param (
    [string]$Text,
    [switch]$Reverse
  )
  if ($Reverse) {
    [System.Text.Encoding]::GetEncoding(936).GetString([System.Text.Encoding]::GetEncoding(932).GetBytes($Text))
  } else {
    [System.Text.Encoding]::GetEncoding(932).GetString([System.Text.Encoding]::GetEncoding(936).GetBytes($Text))
  }
}

function hlnjis {
  param (
    [switch]$PreservePlain
  )
  mkdir (Join-Path .. 0jis)
  Get-ChildItem -Recurse -Directory | % {
    mkdir (Join-Path .. 0jis (gbk2jis (Resolve-Path -Relative $_.FullName)))
  }
  Get-ChildItem -Recurse -File | % {
    if (!$PreservePlain -and ((gbk2jis $_.Name) -eq $_.Name)) {
      return
    }
    New-Item -ItemType HardLink -Value $_.FullName -Path (Join-Path .. 0jis (gbk2jis (((Resolve-Path -Relative $_.Directory) -eq (Join-Path .. (Split-Path -Leaf (Get-Location)))) ? "." : (Resolve-Path -Relative $_.Directory)))) -Name (gbk2jis $_.Name)}
  Move-Item (Join-Path .. 0jis) .
  while (!$PreservePlain) {
    $emptyUselessDir = Get-ChildItem -Recurse -Directory 0jis | ? {!(Test-Path (Join-Path $_ *)) -and ((gbk2jis -Reverse $_.Name) -eq $_.Name)}
    if ($emptyUselessDir) {
      $emptyUselessDir | % {
        Remove-Item $_
      }
    } else {
      if (!(Test-Path (Join-Path 0jis *))) {
        Remove-Item 0jis
      }
      break
    }
  }
}

