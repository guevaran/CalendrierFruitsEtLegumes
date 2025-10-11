# F-Droid packaging notes

This app is prepared for inclusion in F-Droid.

- License: MIT (see LICENSE)
- No proprietary services; fonts are bundled locally (Handlee)
- Reproducibility: ART/baseline profile tasks disabled; uses R8 shrinker and resource shrinking

## Metadata

See `fdroid/metadata/fr.guev.calendrier_fruits_legumes.yml`.

Key fields:
- package id: fr.guev.calendrier_fruits_legumes
- version: 0.2.0+2
- build: Gradle assembleRelease
- outputs: build/app/outputs/flutter-apk/app-release.apk

## Tagging and releases

Create a Git tag matching the version for easier updates:

    git tag v0.2.0
    git push origin v0.2.0

Then update the metadata `commit:` to that tag.

## Reproducible builds tips

- Keep dependency pins stable (avoid floating overrides)
- If resource shrinking causes non-determinism, you can disable it:
  - In `android/app/build.gradle` add `shrinkResources false` inside `buildTypes.release {}`
- Use `org.gradle.jvmargs=-Xmx3g -Dfile.encoding=UTF-8` in `gradle.properties` to reduce locale variance

## Local verification

    flutter clean ; flutter pub get ; flutter build apk --release

Compare APK hashes across two clean builds.
