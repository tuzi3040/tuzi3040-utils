function Check-Time {

  param (
    [ValidateNotNullOrEmpty()]
    [String]$Path = ".",
    [ValidateNotNullOrEmpty()]
    [Int32]$Depth = 0,
    [ValidateNotNullOrEmpty()]
    [Int32]$Tolerance = 1,
    [ValidateNotNullOrEmpty()]
    [Switch]$FullPath
  )

  function _Check-Time {

    param (
      [Parameter(Mandatory)]
      [String]$PathPrefix
    )

    $ls = Get-ChildItem -Attributes d
    if (-not $ls) {return}
    $ls | ForEach-Object {
      Set-Location ("$_" -replace (']','`]') -replace ('\[','`['))
      $s = $?
      if ($s) {$currentDepth += 1}
      if ($currentDepth -le $Depth) {if ($s) {_Check-Time -PathPrefix $PathPrefix}}
      if ($s) {
        Set-Location ..
        $currentDepth -= 1
      }
      $c = $_.CreationTime
      $w = $_.LastWriteTime
      $icList = (Get-ChildItem ($_ -replace (']','`]') -replace ('\[','`[')) | ForEach-Object {Write-Output $_.CreationTime} | Sort-Object)
      if (-not $icList) {return}
      $icFirst = ($icList | Select-Object -First 1)
      $icLast = ($icList | Select-Object -Last 1)
      $cDelta = $c - $icFirst
      $wDelta = $w - $icLast
      $pTolerance = New-TimeSpan -Seconds $Tolerance
      $nTolerance = New-TimeSpan -Seconds -$Tolerance
      $PathSplit = ($_.PSPath -replace "^Microsoft.PowerShell.Core\\FileSystem::")
      $DirectoryPath = ($FullPath) ? $PathSplit : ($PathSplit -replace ($PathPrefix,'.'))
      if (($cDelta -lt $nTolerance) -or ($cDelta -gt $pTolerance)){
        Write-Output $DirectoryPath
        Write-Output "CreationTime      = $c"
        Write-Output "FirstCreationTime = $icFirst`n"
      }
      if (($wDelta -lt $nTolerance) -or ($wDelta -gt $pTolerance)){
        Write-Output $DirectoryPath
        Write-Output "LastWriteTime    = $w"
        Write-Output "LastCreationTime = $icLast`n"
      }
    }
  }

  $pwd = (Get-Location) -replace (']','`]') -replace ('\[','`[')
  Set-Location ("$Path" -replace (']','`]') -replace ('\[','`['))
  $prefix = (Get-Location) -replace (']','`]') -replace ('\[','`[') -replace ('\\','\\')
  $prefix = ($prefix[-1] -eq '\') ? ($prefix -replace '\\') : $prefix
  $currentDepth = 0
  _Check-Time -PathPrefix $prefix
  Set-Location "$pwd"
}
