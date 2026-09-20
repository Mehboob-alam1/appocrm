# Appomatrix backend (Phase 5 — not implemented)

This folder is a **placeholder** for encrypted backup/sync. The current app is **100% local**; no server is required for beta or Phase 3 launch.

## Planned stack

- **API:** Node.js (Express or Fastify) on Hetzner VPS
- **DB:** PostgreSQL (contacts, notes, encrypted blobs per user)
- **Auth:** Phone OTP (MSG91 / Twilio — region-specific)
- **Payments:** Razorpay subscription webhooks
- **Push:** Firebase Cloud Messaging (optional)

## Endpoints (sketch)

| Method | Path | Purpose |
|--------|------|---------|
| POST | `/v1/auth/otp` | Request login code |
| POST | `/v1/auth/verify` | Session token |
| PUT | `/v1/backup` | Upload encrypted snapshot |
| GET | `/v1/backup` | Download latest snapshot |
| GET | `/v1/subscription` | Paid status |

## Security notes

- Client-side encryption key derived from user passphrase (server never sees plaintext contacts)
- TLS only; rate-limit OTP

Implement when Phase 5 criteria in [../docs/phase-5/MONETIZATION_AND_BACKEND.md](../docs/phase-5/MONETIZATION_AND_BACKEND.md) are met.
