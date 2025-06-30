# 🛡️ Vérification droits admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Write-Host "🔐 Relance en mode administrateur..."
    Start-Process powershell "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# 👉 Config
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$outputFolder = "$PSScriptRoot\ExploitGuardReport"
$outputFile = "$outputFolder\ExploitGuard_$timestamp.txt"

# 📁 Création dossier
if (-not (Test-Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder | Out-Null
}
Write-Host "📂 Dossier de rapport : $outputFolder"

# 📝 Export de la configuration actuelle
Write-Host "`n🔎 Extraction des paramètres Exploit Protection..."
$mitigations = Get-ProcessMitigation

# 💾 Sauvegarde dans le fichier
$mitigations | Format-List * | Out-File -FilePath $outputFile -Encoding utf8
Write-Host "✅ ExploitGuard report généré : $outputFile"

# 📂 Facultatif : Export de la config en XML (excel/Scriptable)
$xmlFile = "$outputFolder\ExploitGuardConfig_$timestamp.xml"
Get-ProcessMitigation -RegistryConfigFilePath $xmlFile
Write-Host "✅ Export XML (importable) : $xmlFile"

# 🎉 Ouverture du dossier
Start-Process "explorer.exe" -ArgumentList "`"$outputFolder`""
Write-Host "`n🎉 Terminé."
