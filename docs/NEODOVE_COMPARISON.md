# NeoDove vs Appomatrix CRM (solo)

NeoDove is built for **teams of telecallers** with server-side dialer, campaigns, and WhatsApp Business API. Appomatrix is **one owner, local phone, no call center**.

## Feature map

| NeoDove | What they do | Appomatrix (this app) | Limit |
|---------|----------------|------------------------|--------|
| **Click-to-call** | Dial from CRM, log starts | **Call** on customer → phone dialer | Does not record call audio |
| **Auto call log** | Every dial tracked | **Auto-log when you tap Call** + disposition after return | Not detected if you call from Phone app |
| **Call outcome / disposition** | Connected, no answer, etc. | **After-call sheet** — pick outcome | Manual (honest tap) |
| **Follow-up reschedule** | Auto reschedule failed dials | **No answer / Busy** → tomorrow follow-up + notification | No carrier “busy” detection |
| **Auto-dialer queue** | Dials next lead in campaign | **Call queue** on Today tab | One person, no parallel agents |
| **WhatsApp one-click** | Opens WA with templates | **WhatsApp** + **message templates** | Opens WhatsApp app; no in-app chat sync |
| **Neo WhatsApp inbox** | QR link, team sees all chats | **Not available** (needs WhatsApp Business API + backend) | By design for beta |
| **Call recording** | IVR / telephony stack | **Not available** (legal + OS limits) | Use **voice note** after call |
| **Voice → CRM** | Agent types or scripts | **Voice note → text** on device | You speak summary, not call recording |
| **Campaigns / assign leads** | 10+ agents | **Pipeline tags** only | Solo user |
| **Reports & monitoring** | Manager dashboards | **Call count + notes** per contact | No team analytics |
| **Integrations** | Zoho, FB ads, sheets | **CSV export** | Phase 5 cloud optional |

## What to copy from NeoDove (workflow)

1. Call → log → outcome → follow-up → message  
2. Work a **queue** top to bottom  
3. **Templates** for WhatsApp so you don’t retype  

That flow is what we implement in the app; we skip team dialer, recording, and WhatsApp inbox.
