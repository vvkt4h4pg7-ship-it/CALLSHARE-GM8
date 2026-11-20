# GM8 JITTER R1 — Dosya bazlı değişiklik kaydı

## Bu adayda değiştirilen dosyalar

| Dosya | Değişiklik |
|---|---|
| `J7Bridge/WiFiVoiceEngine.swift` | 3 blok/60 ms prebuffer; 20 ms sabit oynatma zamanlayıcısı; 8 blok/160 ms üst sınır; taşmada en eski bloğu atma; underflow'da fade-out ve yeniden prebuffer; gerçek ses geri geldiğinde kısa fade-in. |
| `J7Bridge/BLEManager.swift` | Yalnızca CoreBluetooth restoration identifier benzersiz GM8 test kimliğine değiştirildi. BLE mesaj/protokol işlemleri değiştirilmedi. |
| `J7Bridge/Info.plist` | Home Screen görünen adı `CALLSHARE GM8`; yerel ağ izin açıklamasında GM8 adı. |
| `J7Bridge.xcodeproj/project.pbxproj` | Debug/Release `PRODUCT_BUNDLE_IDENTIFIER` benzersiz GM8 test ID'si yapıldı. |

## Değiştirilmeyen uygulama parçaları

- `WiFiTransport.swift`: UDP/J7WV protokolü ve fragment reassembly aynı.
- `AppModel.swift`, `CallKitManager.swift`, `K7Protocol.swift`: aynı.
- Mikrofon yakalama, DSP, iPhone → Android UDP uplink: aynı.
- BLE komutları, telephony kontrol akışı, SMS, contacts, notification mantığı: bu adayın parçası olarak değiştirilmedi.
- Android GM8/J7 Core ve cihazdaki çalışan süreçler: kaynak paket tarafından değiştirilmez.

## Kaynak ağacında önceden bulunan değişiklik

Kullanıcının yüklediği kaynak deposunda `J7Bridge/NotificationManager.swift` zaten çalışma ağacında değiştirilmişti: kaçırılan çağrı bildiriminin başlığı/identifier'ı `J7Bridge` yerine `CALLSHARE` olarak adlandırılmış. Bu GM8 JITTER çalışmasının yaptığı bir değişiklik değildir; sağlanan kaynak tabanıyla birlikte aynen korunmuştur.

## Derleme sınırı

Bu kaynak arşivinde Xcode ile üretilmiş `.ipa` yoktur. GitHub Actions workflow'u unsigned IPA üretir; Apple signing/provisioning işlemi ayrıca gerekir. Fiziksel iPhone üzerinde gerçek test yapılmadan bu aday kararlı/nihai sayılmamalıdır.
