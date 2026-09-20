# Beta feedback loop

## Google Form (suggested questions)

1. What work do you do? (short text)
2. Did you add at least one real customer? (Yes/No)
3. Did voice-to-text work after a call? (Yes / No / Didn’t try)
4. Was the **Today** list useful? (1–5)
5. What was confusing or broken? (long text)
6. Would you keep using this weekly? (Yes / Maybe / No)

Paste form URL into `lib/screens/settings_screen.dart` → `betaFeedbackFormUrl`.

## WhatsApp templates

**Invite to beta**

> Hi [name] — thanks for chatting last week. I have a **test Android app** (Appomatrix CRM) for follow-ups after calls. Data stays on your phone. Can I send you a small APK file here? Takes ~2 min to try.

**After install**

> Please try: add 1 customer → log a call → voice note → check **Today** tab. **More → reminders → Allow**. Feedback form: [link]

**Week 2 nudge**

> Quick check — were you able to use Appomatrix after any call this week? Even one voice note helps. Form: [link]

## Triage

| Severity | Examples | Action |
|----------|----------|--------|
| P0 | Crash on open, data loss | Fix + new APK within 48h |
| P1 | Voice never works, notifications never fire | Fix before Phase 3 |
| P2 | UI confusion | Onboarding copy / Phase 4 |
| P3 | Feature requests | Backlog; don’t build until 200+ users |
