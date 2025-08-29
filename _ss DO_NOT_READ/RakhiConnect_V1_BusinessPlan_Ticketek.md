
# RakhiConnect – Apple Watch App (Version 1: Local Payments Only) — **Updated with Ticketek Digital Gift Option**

## 1) Executive Summary
RakhiConnect modernizes Raksha Bandhan by letting a sister send an **animated rakhi** to her brother’s Apple Watch. The brother taps it and sends a **local gift** instantly. Version 1 focuses on **domestic-only** payments to reduce compliance scope and accelerate launch. This update adds a **second gift mode**: a **Ticketek digital gift** (e.g., voucher/credit or curated event ticket), purchased locally and delivered digitally to the sister (or mutually selected recipient).

**Gift modes in V1 (local):**
- **Cash Gift (Apple Pay → domestic payout)** — baseline.
- **Ticketek Digital Gift** — Apple Pay on iPhone → backend purchases a Ticketek e‑gift (voucher/credit) or opens a secure deep link for brother to complete purchase; code/URL delivered to recipient in‑app + email/SMS.

## 2) Background & Cultural Framing
### 2.1 Raksha Bandhan: History (myth + legend)
- **Krishna–Draupadi (Mahabharata):** a protective vow born from compassion.
- **Indra–Indrani (Bhavishya Purana):** a sacred protective thread amid cosmic conflict.
- **Rani Karnavati–Humayun (medieval):** cross‑community solidarity via a rakhi appeal.
These strands converge today into a **ceremony of care, reciprocity, and remembrance**. RakhiConnect preserves this via an animated rakhi that **“lives” for 12 months** on the wrist.

### 2.2 Modern Meaning
Beyond siblings, Rakhi extends to cousins, friends, and surrogate siblings. The **gift** is a token of gratitude. Ticketek gifting aligns perfectly with modern, experience‑centric gifts.

## 3) Problem & Opportunity
- Distance and busy lives dilute the in‑person ritual.
- Digital greetings lack ceremony; e‑commerce dumps users into generic checkout flows.
- No watch‑first, culturally‑designed experience for **instant, meaningful gifting**.

**Opportunity:** A **watch‑native ritual** + **frictionless gifting**, including **experiences** (Ticketek) — a delightfully modern return‑gift.

## 4) Product Overview (V1 Local)
**Core flow:**
1) Sister sends animated rakhi to brother’s Watch (12‑month life).
2) Brother taps rakhi → chooses **Cash** or **Ticketek Digital Gift** → confirms **amount**.
3) iPhone presents **Apple Pay**.
4) Backend either (a) pays out domestically to the sister (Cash) or (b) **fulfills a Ticketek voucher** (or opens a Ticketek deep link for instant digital purchase).
5) Both see a **ceremonial receipt**; rakhi remains as a complication for 12 months.

**Why Ticketek in V1?**
- Local fulfillment; no cross‑border funds.
- Experience‑gifting is *viral* around event seasons.
- Seasonality syncs with Rakhi campaigns (pre‑Rakhi push; post‑Rakhi “experience planning”).

## 5) Architecture (V1, Local)
### 5.1 Frontend
- **watchOS app:** animated rakhi; gift kind + amount picker; WatchConnectivity to iPhone.
- **iOS companion:** presents Apple Pay; calls backend; shows gift receipt; deep link fallback for Ticketek.

### 5.2 Backend
- **Cash gift:** capture Apple Pay token via PSP (domestic) → domestic payout to recipient; ledger + receipts.
- **Ticketek gift:** two strategies supported in config:
  - **Direct fulfillment:** backend purchases a Ticketek e‑gift (voucher) through partner API; returns code/link to both parties.
  - **Deep link flow:** backend generates a signed deep link/session to Ticketek; post‑purchase webhook confirms and issues digital gift back to RakhiConnect.

### 5.3 Data
- `Rakhi` (sender/receiver, sentAt, expiresAt, design).
- `GiftIntent` (kind: cash|ticketek, amount, currency).
- `GiftReceipt` (status).
- `TicketekGift` (code, URL, expiry) when applicable.

## 6) Compliance & Risk (Local Only)
- **Domestic PSP** for Apple Pay; you’re not a remitter for cross‑border flows.
- **Ticketek gift**: treat as **merchant‑of‑record retail** of a digital voucher (or affiliate referral if deep link). Use PSP KYC/AML stack + your own fraud rules (velocity, limits, device checks).

## 7) Business Model
- **Cash:** fee per transaction.
- **Ticketek:** margin share/discount, affiliate fee, or convenience fee (where allowed). Seasonal **premium rakhi designs** as IAPs.

## 8) Go‑to‑Market
- Pre‑Rakhi campaigns with **experience‑gifting** angle (“Gift a memory, not just money”).
- Co‑marketing with Ticketek (landing pages, curated events “Rakhi Picks”).

## 9) Roadmap
- **V1 (local):** Cash + Ticketek; Watch ritual + receipts; domestic PSP only.
- **V1.x:** add in‑app voucher wallet; gifting suggestions.
- **V2 (international):** FX corridors and additional providers; broader event partners.

## 10) Financials (Illustrative, Year 1)
- Build: 100–140k; Marketing: 30–50k.
- Revenue: 200–400k (mix of cash fees, Ticketek margin/affiliate, premium designs).

## 11) Success Metrics
- Conversion from rakhi receipt → gift completed.
- % Ticketek share of gifts; average gift size.
- Repeat gifting rate over 12 months (complication lifetime).

---

# Appendix A — UX Snapshots (V1)
- **Watch:** animated rakhi → “Choose Gift Type” (Cash | Ticketek) → amount picker → “Tap to Gift”.
- **iPhone:** Apple Pay sheet; success screen → ceremonial receipt; “View Ticketek gift” if applicable.

# Appendix B — Partnering with Ticketek (Options)
1) **API/Platform partnership** for voucher purchase + issuance (ideal).
2) **Deep link / session‑hand‑off** with post‑purchase webhooks (fastest to launch).
3) **Gift card reseller** route where available (interim).
