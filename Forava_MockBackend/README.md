# Forava Mock Backend

Lightweight Flask server to simulate the Forava endpoints during iOS/watchOS development.

## Requirements
- Python 3.10+
- `pip install -r requirements.txt`

## Run
```bash
python app.py
```
Server runs at `http://127.0.0.1:5055`

## Endpoints
- `POST /payments/applepay/capture`
  - Body: `{ "paymentToken": "<base64>", "transactionIdentifier": "...", "currencyCode": "AUD" }`
  - Response: `{ "status": "succeeded", "transactionId": "...", "capturedAt": "..." }`

- `POST /digitalgift/voucher/create`
  - Body: `{ "tokenId": "<uuid>", "amountMinor": 2500 }`
  - Response: `{ "id": "...", "voucherCode": "GFT-XXXXXX", "voucherURL": "https://...", "expiry": "..." }`
