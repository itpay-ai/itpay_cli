$ErrorActionPreference = "Stop"

$SourceDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ItpBin = Join-Path $SourceDir "bin\itp"
$SkillFile = Join-Path $SourceDir "skills\voltagent\SKILL.md"
$NodeModules = Join-Path $SourceDir "node_modules"
$Prefix = if ($env:ITP_PREFIX) { $env:ITP_PREFIX } else { Join-Path $HOME ".local" }
$TargetDir = Join-Path $Prefix "bin"
$TargetScript = Join-Path $TargetDir "itp.js"
$TargetCmd = Join-Path $TargetDir "itp.cmd"
$ModuleTarget = Join-Path $TargetDir "node_modules"
$SkillTargetDir = Join-Path $Prefix "share\itpay_cli\skills\voltagent"
$SkillTarget = Join-Path $SkillTargetDir "SKILL.md"

if (!(Test-Path $ItpBin)) {
  throw "itp binary not found at $ItpBin"
}

New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
Copy-Item -Force $ItpBin $TargetScript
if (Test-Path $NodeModules) {
  if (Test-Path $ModuleTarget) {
    Remove-Item -Recurse -Force $ModuleTarget
  }
  Copy-Item -Recurse -Force $NodeModules $ModuleTarget
}
if (Test-Path $SkillFile) {
  New-Item -ItemType Directory -Force -Path $SkillTargetDir | Out-Null
  Copy-Item -Force $SkillFile $SkillTarget
}
Set-Content -Path $TargetCmd -Encoding ASCII -Value @"
@echo off
node "%~dp0itp.js" %*
"@

Write-Output "Installed itp to $TargetCmd"
if (($env:Path -split ';') -notcontains $TargetDir) {
  Write-Output "Add $TargetDir to PATH before running itp."
} else {
  & $TargetCmd --version
}
