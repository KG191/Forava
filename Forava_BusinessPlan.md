# Forava — Business Plan (V1, Local‑Only) — Cash + Digital Gift

## Executive Summary
**Forava** modernizes cultural gifting rituals with a watch‑first experience: a loved one sends an animated token to the recipient’s Apple Watch. The recipient taps to send a **local gift** instantly via Apple Pay on the iPhone. Version 1 focuses on **domestic payments** to minimize compliance scope and time‑to‑market. Alongside **Cash**, V1 supports **Digital Gift** (experience/voucher) fulfilled via local voucher providers (no third‑party brand names in code).

## Cultural Positioning
Forava celebrates enduring human connection across cultures and traditions. Whether inspired by sacred threads, friendship bracelets, or other wrist‑based customs, Forava preserves the **symbolic promise** while embracing modern convenience:
- An animated token that remains active on the Watch for **12 months**.
- A ceremonial confirmation after a gift is sent.

## Problem & Opportunity
- Loved ones are often separated by distance; rituals lose momentum.
- E‑gift flows are phone‑centric and miss the ceremony/meaning.
- There is no watch‑native, ritual‑first gifting experience with **frictionless checkout**.

**Opportunity:** A delightful **watch ritual** paired with **local, instant gifting** (Cash or Digital Gift).

## Product (V1, Local Only)
**Flow:**
1. Sender initiates an animated token to the recipient’s Apple Watch (valid 12 months).
2. Recipient taps → chooses **Cash** or **Digital Gift** → selects amount.
3. iPhone presents **Apple Pay** (local currency).
4. Backend:
   - **Cash**: capture payment via domestic PSP and settle locally where permitted.
   - **Digital Gift**: purchase/issue a voucher (code/URL) via integrated local providers or deep‑link session.
5. Both see a **ceremonial receipt**; the watch token remains active.

**Key V1 Constraints:**
- **Domestic only**: no cross‑border remittance/FX.
- **No third‑party brand names** in code; use **Digital Gift** generically.

## Architecture
**watchOS:** Animated token UI + pickers; sends `gift_request` via WatchConnectivity.  
**iOS:** Receives request, presents Apple Pay, calls backend, returns status to Watch.  
**Backend:** Example endpoints
- `POST /payments/applepay/capture`
- `POST /digitalgift/voucher/create`

**Shared Models:** `GiftKind (cash|digitalGift)`, `RitualToken`, `GiftIntent`, `GiftReceipt`, `DigitalGiftVoucher`.

## Compliance (Local Only)
- Use a domestic PSP for Apple Pay tokenization & settlement.
- Fraud controls: velocity limits, device checks, logging.
- For Digital Gift deep‑links, require verified post‑purchase webhooks.

## Business Model
- **Cash:** transaction fee where permitted.
- **Digital Gift:** margin share, affiliate or convenience fee (as allowed).
- **Premium Designs:** optional watch token designs or seasonal themes (IAP).

## Go‑to‑Market
- Seasonal campaigns around major cultural celebrations.
- Messaging: **“A promise on your wrist, a gift in a tap.”**
- Creator collaborations for custom designs.

## Roadmap
- **V1 (local):** Cash + Digital Gift; animated token; ceremonial receipts.
- **V1.x:** voucher wallet; curated experiences.
- **V2 (international):** FX corridors and additional partners (subject to compliance).

## KPIs
- Conversion: token‑received → gift‑sent.
- Digital Gift share vs Cash; Average Order Value.
- 90‑day repeat gifting; 12‑month token engagement.
