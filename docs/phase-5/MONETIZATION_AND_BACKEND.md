# Phase 5 — Monetization & backend

Start when you have **~200–500 active users** in one niche and repeated “backup if phone lost” requests.

## Free tier (keep forever)

- Unlimited local contacts, voice notes, follow-ups
- CSV export (already in app)

## Paid tier (~$2–3 / month)

- Encrypted cloud backup
- Multi-device sync
- Priority restore support

## Backend architecture (when you build)

```
Android app  →  HTTPS API (Node.js on VPS)  →  PostgreSQL
             →  Razorpay / UPI webhook for subscription status
             →  FCM for optional server-triggered reminders
```

See stub folder: [../../backend/README.md](../../backend/README.md)

## Payments (India-first)

- Razorpay subscriptions or UPI autopay when available
- Play Billing alternative if you prefer single channel

## Legal

- Registered business entity before collecting money (jurisdiction-specific)
- Updated privacy policy covering cloud storage & encryption

## App changes (future PRs)

- Account sign-in (phone OTP)
- Background sync worker
- “Restore from backup” on fresh install
