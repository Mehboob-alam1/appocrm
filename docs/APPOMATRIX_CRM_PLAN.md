# Appomatrix CRM — Full Plan

**Tagline concept:** *"NeoDove for call centers. Appomatrix for the person who IS the business."*

A voice-first, privacy-safe, mobile CRM built for solo tradespeople, tutors, freelancers, and small shop owners — the people currently using WhatsApp and a notebook instead of a CRM, because everything on the market is built for sales teams, not individuals.

---

## 1. The Problem

Small business owners in mobile-first economies (India, Southeast Asia, Africa, Latin America) run their entire client relationship over phone calls and WhatsApp. Right now that information either:

- Stays in the owner's head and gets forgotten, or
- Gets scribbled in a notebook and gets lost, or
- Sits buried in WhatsApp chat history, impossible to search later

Existing CRMs (Salesforce, HubSpot, Zoho, NeoDove, TeleCRM) are built for **teams of agents doing outbound sales**, not for **one person managing their own existing clients**. They're too complex, too expensive, and require training nobody has time for.

---

## 2. The Solution

**Appomatrix CRM**: talk into your phone after a call, the app remembers so you don't have to.

**Core mechanic:**

1. After any call, the owner records a short voice note ("Ramesh wants his AC serviced next Friday, quoted 800 rupees")
2. On-device speech-to-text turns it into a note, saved under that contact
3. One home screen shows "People to follow up with today" — no scrolling, no remembering
4. Each contact has a simple status: Lead → Follow-up → Confirmed → Paid

That's the entire product. No dashboards, no training, no complexity.

---

## 3. Market Research

### Market size

- Global CRM market: **~$101–106 billion in 2026**, growing at 12–13% CAGR toward $260B+ by early 2030s
- Global **mobile CRM** market specifically: $28.43 billion (2024) → expected $52.4 billion by 2029
- 74% of small businesses now use CRM, 50% adopted it in the last 3 years
- 43% of CRM implementations fail due to poor team adoption — **ease of use beats feature count**

### Where the growth is

- North America dominates today (44% of revenue) but is the most saturated
- **Asia-Pacific is the fastest-growing region** (8.86% CAGR to 2031), driven by India, China, Southeast Asia
- India alone: ~1 billion smartphone users by 2026, ~60+ million MSMEs, overwhelmingly mobile-only businesses
- China's data localization laws and India's SME digitization push both favor **local-first, privacy-respecting** products
- Zoho's biggest growth (45%) already comes from Asia-Pacific — proof that affordable, simple CRM wins in emerging markets

### Target user personas (ranked by opportunity)

1. **Independent tradesperson** (electrician, plumber, AC repair) — least served today, highest opportunity
2. **Solo tutor / small coaching center owner** — tracks students/payments, currently uses Excel or nothing
3. **Small shop/salon owner** — wants repeat-customer follow-ups, credit tracking
4. **Insurance/loan/real estate agent** — already well-served by NeoDove/TeleCRM, avoid this segment initially
5. **Freelancer/consultant** (global, not just emerging markets) — simple client tracking without CRM bloat

**Recommended first target:** pick ONE city + ONE profession (e.g., AC/appliance repair technicians in Bangalore, or tutors in Lagos) rather than trying to serve "small businesses" broadly.

---

## 4. Competitor Analysis

| Competitor | What they do | Weakness / gap |
|---|---|---|
| **NeoDove** | Telecalling CRM, auto-dialer, lead management, built for outbound sales teams | ₹17,000+/year minimum, built for 10+ agent teams, "overwhelming" analytics per real reviews, onboarding oversold vs. support underdelivered |
| **TeleCRM** | Similar to NeoDove, targets Indian SMBs selling via calls/WhatsApp | Same team/call-center focus, not built for a single individual |
| **CallNoty** | Direct competitor — voice-based mobile CRM, built solo from India | Validates the idea but has near-zero traction (0 upvotes on Product Hunt) — proves distribution, not tech, is the real challenge |
| **Hey DAN (Dial-A-Note)** | Voice-to-CRM notes, but feeds into an existing CRM like Salesforce | Requires you to already have a "real" CRM — not standalone |
| **Salesforce/HubSpot/Zoho** | Full-featured, enterprise-grade | Too complex, too expensive, not designed for a solo phone-first user |

**The gap:** nobody has built the *radically simple, voice-first, privacy-first, solo-user, dirt-cheap* version. NeoDove/TeleCRM serve teams; Hey DAN serves people who already have a CRM; CallNoty proves demand but hasn't cracked distribution.

---

## 5. Differentiation Table

| NeoDove | Appomatrix CRM |
|---|---|
| Built for teams of 10+ telecallers | Built for **1 person** |
| Complex dashboards, "overwhelming" analytics | One screen: "who do I follow up with today" |
| ₹17,000+/year minimum | ~$1–3/month, no annual lock-in |
| Requires onboarding/training | Zero training — open app, talk, done |
| Cloud-only, vague privacy policy | Local-first storage — genuine, verifiable privacy |
| Auto-dialer for outbound cold-calling | Voice-note capture for existing client relationships |

---

## 6. Feature Roadmap (Build Order)

1. **Contact + call log (MVP)** — add contacts manually or from phone book, log calls with one tap
2. **Voice-note capture** — record after a call, on-device speech-to-text attaches note to contact (signature feature, NeoDove doesn't have this)
3. **Follow-up home screen** — "People to follow up with today," sorted by urgency
4. **WhatsApp click-to-chat** — one-tap button to open WhatsApp with a contact
5. **Simple pipeline tags** — Lead / Follow-up / Confirmed / Paid — resist adding more
6. **Paid tier: cloud backup + multi-device sync** — the first genuinely paid feature

---

## 7. Phased Build & Launch Plan

### Phase 0 — Validate Before Building (Week 1–2)

- Pick one niche + one city
- Join 3–5 WhatsApp/Facebook groups for that profession
- Ask directly how they currently track clients/follow-ups
- Go/no-go checkpoint: need real enthusiasm before writing code

**Execution kit (worksheets, scripts, log):** [phase-0/README.md](./phase-0/README.md) — track progress in [phase-0/STATUS.md](./phase-0/STATUS.md).

### Phase 1 — MVP Build (Weeks 3–8)

- **Stack:** Kotlin + Jetpack Compose, Room (local database), Android SpeechRecognizer API (on-device, free)
- Build order: contacts → voice notes → follow-up screen → WhatsApp button → pipeline tags
- Explicitly skip: cloud sync, multi-user, auto-dialer, analytics dashboards, integrations

### Phase 2 — Private Beta (Weeks 9–10)

- 15–30 real users from the Phase 0 group, not friends/family
- Watch for: does voice-to-text work in noisy real environments? Do people actually open the app daily?

### Phase 3 — Public Launch (Weeks 11–12)

- Publish to Google Play under Appomatrix
- Simple one-page landing site with the pitch, screenshots, download link
- Launch in the same community groups from Phase 0

### Phase 4 — Early Growth (Months 3–5)

- Distribution: local WhatsApp/Facebook groups, trade associations, referral incentive ("invite another business owner, both get a free month")
- Add based on real feedback: reminders/notifications, multi-language support (Hindi, Bahasa, etc.)

### Phase 5 — Monetization (Months 4–6, once ~200–500 active users)

- Free tier stays fully local and unlimited — this is the growth engine
- Paid tier (~$2–3/month): encrypted cloud backup, multi-device sync, export contacts/notes
- Payment: local methods matter most — UPI (India), GCash (Philippines), M-Pesa (Africa)

### Phase 6 — Scale Decision (Month 6+)

- Option A: stay narrow, dominate one profession/region completely
- Option B: expand horizontally to adjacent professions
- Option C: build toward team/call-center features (NeoDove's territory) — only if users explicitly ask and will pay more

### Timeline Summary

| Phase | Duration | Effort |
|---|---|---|
| Validation | 1–2 weeks | Light |
| MVP build | 5–6 weeks | Heavy |
| Beta | 2 weeks | Medium |
| Launch | 1–2 weeks | Medium |
| Growth | Ongoing | Medium |
| Monetization | Month 4–6 | Light |

**Total to first paying users: ~3–4 months solo, working consistently.**

---

## 8. Backend & APIs — What's Actually Needed

### MVP (Phases 0–4): No backend required

The app is fully local-first. All data (contacts, voice notes, pipeline stages) lives on the user's phone via Room. No internet connection needed for core functionality.

**APIs used in MVP (all free, built into Android):**

- Android `SpeechRecognizer` API — on-device speech-to-text
- Android Contacts API — import from phone book
- WhatsApp Intent — opens WhatsApp with a given number (not a real "API," just an Android intent)

### When a backend becomes necessary (Phase 5+)

A backend is only needed once data needs to leave the phone or sync across devices:

| Feature | Why it needs a backend |
|---|---|
| Cloud backup | Restore data if the phone is lost/broken |
| Multi-device sync | Owner + assistant seeing the same client list |
| Payment processing | Verifying subscription status via a payment gateway |
| Reliable push notifications | Working even when app is closed for a long time |

**What you'll build/use at that stage:**

- **Your own custom API** (Node.js on your VPS) — the code you write to let the app talk to your database for backup/sync
- **Firebase Cloud Messaging** — free, for push notifications
- **Payment gateway API** — Razorpay (India), GCash (Philippines), or regional equivalent — the one genuinely external paid-integration service

---

## 9. Services & Costs

### Must-buy before launch

| Service | Cost | Why |
|---|---|---|
| Google Play Developer account | $25 one-time | Mandatory to publish on Android |
| Domain name | ~$10–15/year | Landing page, email, credibility |
| VPS hosting (Hetzner or InterServer) | ~$5–6/month | Landing page now, backend later |

**Total to launch: ~$40–50 one-time + ~$6/month**

### Needed once cloud backup is added (Phase 5)

| Service | Cost |
|---|---|
| SSL certificate (Let's Encrypt) | Free |
| Database (PostgreSQL/MySQL on same VPS) | Free |
| Firebase Cloud Messaging | Free |
| Payment gateway (Razorpay, etc.) | Free setup, ~2% transaction fee |

### Optional / not required yet

| Service | Cost | Verdict |
|---|---|---|
| Apple Developer account | $99/year | Skip — Android-first |
| Paid analytics (Mixpanel, Amplitude) | — | Skip — Play Console analytics is enough |
| Design/UI kit | $0–50 | Optional — Figma free tier + Material Design suffices |
| Business registration (India-specific) | Varies | Only once collecting real payments as a registered entity |
| Google Workspace email | ~$6/month | Nice-to-have, not required |

---

## 10. Recommended VPS Options (from hosting research)

For your PHP, Node.js, and ASP.NET Core sites, plus this app's future backend, all on one server:

| Provider | Best for |
|---|---|
| **Hetzner** | Best price-to-performance, newest hardware — top recommendation |
| **InterServer** | Price locked for life, good if audience is US-based, Linux + Windows options |
| **Contabo** | Cheapest raw specs, good for budget-first scaling |
| **Vultr / Linode** | Best global datacenter coverage if traffic is spread worldwide |
| **Oracle Cloud Free Tier** | Genuinely free forever (4 ARM cores, 24GB RAM) — worth testing risk-free |

---

## 11. Immediate Next Steps

1. Pick your Phase 0 niche + city
2. Join relevant community groups and validate demand
3. Set up domain + VPS (Hetzner recommended)
4. Register Google Play Developer account
5. Start MVP build: contacts → voice notes → follow-up screen
6. Recruit 15–30 beta users from your validation group
7. Launch, then layer in monetization once usage is proven

---

*Plan prepared for Appomatrix — Appomatrix CRM concept.*

---

## Repo note (this workspace)

This repository is currently a **Flutter** starter (`appocrm`). When implementing Phase 1 here, map the same MVP features to Flutter equivalents (local DB, speech-to-text, contacts, WhatsApp intents) while keeping **Android-first** launch per the plan above.
