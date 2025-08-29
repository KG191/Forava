# RakhiConnect — Business Plan (V1, Local‑Only) — Cash + Digital Gift

## Executive Summary
RakhiConnect modernizes Raksha Bandhan with a watch‑first ritual: a sister sends an animated **rakhi** to her brother’s Apple Watch. He taps it to send a **local gift** instantly via Apple Pay on the iPhone. Version 1 focuses on **domestic payments** to minimize compliance scope and time‑to‑market. In addition to **Cash**, V1 supports **Digital Gift** (experience/voucher) fulfilled by our backend through local voucher providers (no brand names included in code).

## Background & Cultural Framing
**Raksha Bandhan** (“bond of protection”) is a festival where a sister ties a **rakhi**—a sacred thread—on her brother’s wrist, and the brother offers a gift with a vow of care. The practice today extends beyond siblings to cousins and close friends. RakhiConnect keeps the ceremony meaningful with:
- A persistent, animated rakhi on the Watch for **12 months**.
- A ceremonial confirmation/receipt after a gift is sent.

## Problem & Opportunity
- Physical separation reduces participation in the ritual.
- Existing e‑gift options lack cultural ceremony and are phone‑centric.
- No watch‑native flow optimized for **instant gifting** with **zero friction**.

**Opportunity:** A delightful **watch ritual** paired with **frictionless local gifting** (Cash or Digital Gift).

## Product (V1, Local Only)
**Flow:**
1. Sister sends animated rakhi to brother’s Apple Watch (valid 12 months).
2. Brother taps rakhi → chooses **Cash** or **Digital Gift** → picks an amount.
3. iPhone presents **Apple Pay** (local currency).
4. Backend:
   - **Cash**: capture payment with domestic PSP and settle locally to recipient.
   - **Digital Gift**: purchase/issue a digital voucher via integrated local voucher providers or deep‑link session; return code/URL to recipient.
5. Both see a **ceremonial receipt**; rakhi remains active on the Watch.

**Key V1 Constraints:**
- **Domestic only**: no cross‑border remittance/FX in V1.
- **No brand names** in code or files; use **Digital Gift** as a generic type.

## Architecture
**watchOS:** Animated rakhi UI, picker for gift type and amount, sends a `gift_request` via WatchConnectivity.  
**iOS:** Receives gift request, presents Apple Pay, calls backend, and returns status to the Watch.  
**Backend:** Endpoints (example):
- `POST /payments/applepay/capture` — capture Apple Pay.
- `POST /digitalgift/voucher/create` — create or fetch a Digital Gift voucher.

**Shared Models:** `Rakhi`, `GiftIntent`, `GiftReceipt`, `GiftKind (cash|digitalGift)`, `DigitalGiftVoucher`.

## Compliance & Risk (Local Only)
- Use an established domestic PSP for Apple Pay tokenization and settlement.
- Apply fraud controls (velocity limits, device checks) and robust logging.
- If using deep‑links for Digital Gift checkout, confirm post‑purchase webhooks before issuing voucher to recipient.

## Business Model
- **Cash:** transaction fee (where permitted).
- **Digital Gift:** margin share, affiliate referral, or convenience fee (as allowed).
- **Premium Designs:** optional rakhi design packs or seasonal themes (IAP).

## Go‑to‑Market
- Seasonal campaigns timed before Raksha Bandhan.
- Emphasize **experience gifting**: “Gift a memory, not just money.”
- Creator collaborations for custom rakhi designs.

## Roadmap
- **V1 (local):** Cash + Digital Gift; animated rakhi; ceremonial receipts.
- **V1.x:** in‑app voucher wallet; event recommendations.
- **V2 (international):** FX corridors, compliance extensions, and additional partners.

## KPIs
- Conversion from rakhi‑received → gift‑sent.
- Digital Gift share vs Cash; AOV by gift type.
- 90‑day repeat gifting; 12‑month engagement (complication lifetime).
