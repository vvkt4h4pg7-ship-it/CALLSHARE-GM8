# CALLSHARE GM8 JITTER R1

Separate iOS test candidate for the GM8 audio-receive path. The existing J7 CALLSHARE app and Android Wi-Fi Core are preserved; this repository is intended to produce a side-by-side iPhone test build.

## Scope

The only runtime audio change in this candidate is in `J7Bridge/WiFiVoiceEngine.swift`: complete 48 kHz / stereo / S16_LE / 960-frame (20 ms) PCM blocks enter a bounded receive jitter buffer. Playback is primed with three blocks (about 60 ms), then released on a 20 ms dispatch timer. The queue holds at most eight blocks (160 ms); overflow drops the oldest block to limit latency. Underflow emits one fade-to-silence block, then waits for the three-block prebuffer and fades the next real block in.

The following remain unchanged from the uploaded project: `WiFiTransport.swift` (UDP wire format and fragment reassembly), `AppModel.swift`, `CallKitManager.swift`, `K7Protocol.swift`, BLE protocol logic, microphone capture/processing/uplink, and the rest of the call-control implementation.

## GM8-only app identity

- Display name: `CALLSHARE GM8`
- Bundle ID: `com.ugur.callshare.gm8jitterr1`
- BLE restoration ID: `com.ugur.callshare.gm8jitterr1.ble-central.r1`

The unique identifiers allow a test install alongside the existing CALLSHARE app. Do not replace or delete the known-good J7 app during testing.

## Build

Open `J7Bridge.xcodeproj` in Xcode, select the `J7Bridge` target, choose your Apple Development Team if signing locally, and verify the GM8 bundle ID above. The GitHub Actions workflow builds an **unsigned** iOS IPA and uploads it as the `CALLSHARE-GM8-JITTER-R1-unsigned` artifact. It does not sign an installable IPA or include a signing certificate/provisioning profile.

## Test status

This is an experimental test candidate, not a verified final release. It has not yet been built with Xcode or tested on a physical iPhone. The 60 ms prebuffer adds latency and may not mask larger stalls; compare it against the known-good J7 app and keep test results separate.

## Source audit

Compared with the uploaded `CALLSAHRE IOS IPA` source tree, the candidate changes exactly these existing files:

1. `J7Bridge/WiFiVoiceEngine.swift` — adds GM8 receive jitter buffering and fixed-cadence playout.
2. `J7Bridge/BLEManager.swift` — changes only the BLE restoration identifier so the test app has a unique restoration identity.
3. `J7Bridge/Info.plist` — changes the display name and local-network permission description to identify GM8.
4. `J7Bridge.xcodeproj/project.pbxproj` — changes Debug and Release bundle IDs to the unique GM8 test ID.

`README_GM8_JITTER_R1_TR.md` records the detailed candidate design. The uploaded working tree also contained a pre-existing, uncommitted `NotificationManager.swift` branding change (`J7Bridge — Missed Call` to `CALLSHARE — Missed Call`); that change was present in the supplied source and was not introduced by the GM8 jitter work.
