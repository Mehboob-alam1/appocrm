# Appomatrix CRM (`appocrm`)

Voice-first, privacy-safe, mobile CRM for solo business owners. **Beta:** `0.2.0+2` · `com.appomatrix.crm`

## Roadmap (where you are)

| Phase | Owner | Doc |
|-------|--------|-----|
| **0** Validation & waitlist | **You** (14-day sprint) | [phase-0/SPRINT.md](docs/phase-0/SPRINT.md) |
| **1** MVP | Done in `lib/` | [APPOMATRIX_CRM_PLAN.md](docs/APPOMATRIX_CRM_PLAN.md) |
| **2** Private beta (15–30 users) | **You** distribute APK | [phase-2/README.md](docs/phase-2/README.md) |
| **3** Play Store + landing | **You** | [phase-3/CHECKLIST.md](docs/phase-3/CHECKLIST.md) |
| **4–6** Growth, paid backup, scale | Playbooks ready | [phase-4](docs/phase-4/GROWTH.md) · [phase-5](docs/phase-5/MONETIZATION_AND_BACKEND.md) · [phase-6](docs/phase-6/SCALE.md) |

## Run locally

```bash
flutter pub get
flutter run   # Android device recommended
```

## Beta features (Phase 2)

- Onboarding, follow-up **notifications**, edit contact, manual notes
- CSV export & in-app [privacy policy](docs/PRIVACY_POLICY.md)
- **More** tab → enable reminders, export, beta feedback (set Google Form URL in `lib/screens/settings_screen.dart`)

## Build beta APK

See [docs/phase-2/BETA_BUILD.md](docs/phase-2/BETA_BUILD.md).

## Tests

```bash
flutter test
```
