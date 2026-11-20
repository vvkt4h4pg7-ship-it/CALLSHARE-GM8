$ErrorActionPreference = 'Stop'
$relativePath = 'J7Bridge\WiFiVoiceEngine.swift'
if (-not (Test-Path -LiteralPath $relativePath)) {
    throw "Dosya bulunamadi: $relativePath. Scripti proje kokunde calistir."
}
$path = (Resolve-Path -LiteralPath $relativePath).Path
$original = [IO.File]::ReadAllText($path)
$oldCRLF = '            let hfpRouteActive = self.routeUsesBluetoothHFP(self.audioSession.currentRoute)' + "`r`n" + '            self.scheduleEngineRecovery(reason: "engine-configuration-change", delay: 0.45, force: hfpRouteActive)'
$oldLF = '            let hfpRouteActive = self.routeUsesBluetoothHFP(self.audioSession.currentRoute)' + "`n" + '            self.scheduleEngineRecovery(reason: "engine-configuration-change", delay: 0.45, force: hfpRouteActive)'
$newCRLF = '            // The route-change observer already handles forced HFP recovery. An engine' + "`r`n" + '            // configuration notification can be a consequence of that recovery; do not' + "`r`n" + '            // force another rebuild from it while a call is actively playing.' + "`r`n" + '            self.scheduleEngineRecovery(reason: "engine-configuration-change", delay: 0.45, force: false)'
$newLF = '            // The route-change observer already handles forced HFP recovery. An engine' + "`n" + '            // configuration notification can be a consequence of that recovery; do not' + "`n" + '            // force another rebuild from it while a call is actively playing.' + "`n" + '            self.scheduleEngineRecovery(reason: "engine-configuration-change", delay: 0.45, force: false)'
$countCRLF = ([regex]::Matches($original, [regex]::Escape($oldCRLF))).Count
$countLF = ([regex]::Matches($original, [regex]::Escape($oldLF))).Count
if (($countCRLF + $countLF) -ne 1) {
    throw "Beklenen kod blogu tam bir kez bulunmali. Bulunan eslesme: $($countCRLF + $countLF). Dosya degistirilmedi."
}
$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$backup = "$path.backup_hfp_recovery_$stamp"
[IO.File]::WriteAllText($backup, $original, [Text.UTF8Encoding]::new($false))
if ($countCRLF -eq 1) { $updated = $original.Replace($oldCRLF, $newCRLF) }
else { $updated = $original.Replace($oldLF, $newLF) }
[IO.File]::WriteAllText($path, $updated, [Text.UTF8Encoding]::new($false))
$verify = [IO.File]::ReadAllText($path)
if (-not $verify.Contains('scheduleEngineRecovery(reason: "engine-configuration-change", delay: 0.45, force: false)')) {
    [IO.File]::WriteAllText($path, $original, [Text.UTF8Encoding]::new($false))
    throw 'Dogrulama basarisiz; orijinal dosya geri yazildi.'
}
Write-Host 'OK: HFP engine-configuration bildirimindeki zorunlu tekrar recovery engellendi.' -ForegroundColor Green
Write-Host 'Gercek Bluetooth rota degisimindeki force recovery korundu.'
Write-Host "Yedek: $backup"
Write-Host 'Degisen tek kaynak: J7Bridge/WiFiVoiceEngine.swift'
Write-Host 'Android kaynaklari, Wi-Fi Core, WiFiTransport ve CallKit dosyalari degistirilmedi.'
