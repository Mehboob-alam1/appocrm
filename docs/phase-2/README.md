# Phase 2 — Private beta (you + 15–30 users)

**Prerequisite:** Phase 0 **GO** with 15+ waitlist in [beta-waitlist.csv](./beta-waitlist.csv).

## What’s in the app (beta build `0.2.0`)

- Onboarding (3 screens)
- Follow-up **local notifications** (More → enable reminders)
- Edit contact, manual text notes, CSV export
- Package ID: `com.appomatrix.crm`
- In-app privacy policy
- Beta feedback link placeholder in `lib/screens/settings_screen.dart`

## Your steps

1. **Replace feedback URL** — create a Google Form (name, phone optional, “what confused you?”, “did voice work?”) and paste URL in `settings_screen.dart`.
2. **Build APK** — follow [BETA_BUILD.md](./BETA_BUILD.md).
3. **Send to waitlist** — WhatsApp message template in [FEEDBACK.md](./FEEDBACK.md).
4. **Run 2 weeks** — watch for daily opens, voice in noise, notification delivery.
5. **Log issues** in GitHub Issues or a sheet; fix P0 before Phase 3 (you own Play launch).

## Success signals

| Signal | Good | Bad |
|--------|------|-----|
| Daily opens | ≥3 days/week for half of testers | Install once, never open |
| Voice notes | Used after real calls | Never used |
| Today tab | Matches their mental list | Ignored |
| Notifications | At least some enabled | All denied + no value seen |

## When Phase 2 is done

Hand off to **[Phase 3 checklist](../phase-3/CHECKLIST.md)** (Play Store + landing — **you**).
