# CALLSHARE GM8 JITTER R1 — AYRI TEST ADAYI

## Amaç
Bu aday, J7'de sorunsuz çalışan mevcut CALLSHARE uygulamasını değiştirmeden yalnızca GM8 testinde iPhone oynatma tarafına sınırlı bir jitter buffer ekler.

## Korunan parçalar
- `WiFiTransport.swift` değiştirilmedi: J7WV başlığı, 3 x 1.280 bayt uygulama-parçası, yeniden birleştirme, sıra kontrolü ve kayıp ses yumuşatma davranışı aynen korunur.
- GSM çağrı kontrolü, BLE protokolü, CallKit yaşam döngüsü, iPhone mikrofonu ve UDP uplink biçimi değiştirilmedi.
- Ağ biçimi hâlâ 48 kHz / stereo / S16_LE / 960 kare / 20 ms / 3.840 bayt PCM'dir.
- Android GM8 Core, J7 Core ve çalışan cihazdaki PID'ler bu kaynak değişikliğiyle etkilenmez.

## GM8'e özel değişiklik
`WiFiVoiceEngine.swift` içinde alınan tam PCM kareleri doğrudan AVAudioPlayerNode'a vermek yerine:
- 3 karelik başlangıç tamponunda bekletir (yaklaşık 60 ms).
- Sonra her 20 ms'de bir tam PCM kareyi oynatıcıya verir.
- Kuyruk en fazla 8 kare (160 ms) tutar. Taşarsa gecikmeyi sınırlamak için en eski kareyi atar.
- Tampon boşalırsa son örneği sessizliğe yumuşatır, yeniden 3 kare biriktirir ve yeni sesi kısa fade-in ile başlatır.

Bu, paket geliş zamanındaki küçük dalgalanmaları maskelemek için hazırlanmış deneysel bir GM8 profildir. 344 ms'lik tekil bir ağ gecikmesini tamamen gizleyeceği garanti edilmez; ping ölçümü tek başına UDP ses jitter'ını kanıtlamaz.

## Uygulama kimliği / güvenli test
- Bundle ID: `com.ugur.callshare.gm8jitterr1`
- Home Screen adı: `CALLSHARE GM8`
- BLE restoration ID de ayrı adlandırılmıştır.
- Mevcut CALLSHARE uygulamasının üzerine kurulmak için tasarlanmamıştır; yan yana kurulabilir.
- Eski J7 uygulamasını silmeyin veya üzerine yazmayın.

## Derleme ve test
1. `J7Bridge.xcodeproj` dosyasını Xcode'da açın.
2. Signing & Capabilities bölümünde kendi Development Team'inizi seçin.
3. Bundle ID'nin `com.ugur.callshare.gm8jitterr1` olduğunu doğrulayın.
4. Ayrı GM8 test IPA'sını derleyip iPhone'a yükleyin.
5. İlk denemeyi GM8 hotspot + GSM çağrısı ile yapın; J7'deki mevcut son çalışan uygulamayı değiştirmeyin.
6. Aynı görüşmede 2-3 dakika konuşma testi yapın. Ses daha düzenli ama gecikme kabul edilebilir mi diye kontrol edin.

## Önemli sınır
Bu ortamda Xcode/iOS SDK bulunmadığından IPA derlenmedi ve gerçek iPhone testi yapılmadı. Swift sözdizimi ve proje/plist yapı kontrolleri ayrıca raporlanacaktır. Bu dosya **test adayıdır**, doğrulanmış nihai IPA değildir.

## Kaynak dosya notu
Yüklenen `CALLSAHRE IOS IPA.zip` arşivinde Xcode kaynak projesi bulunuyor; arşiv içinde derlenmiş `.ipa` veya `.app` yok. Bu nedenle telefondaki kurulu IPA'nın bu kaynak ağacıyla birebir aynı olduğunu binary üzerinden doğrulayamadım. Kaynak ağacındaki `README.md` de bu ağacı ayrı bir test adayı olarak tanımlıyor.
