from flask import Flask, request, jsonify
import base64, uuid, datetime

app = Flask(__name__)

@app.route("/payments/applepay/capture", methods=["POST"])
def capture():
    data = request.get_json(silent=True) or {}
    token = data.get("paymentToken", "")
    try:
        base64.b64decode(token)
    except Exception:
        return jsonify({"status": "error", "message": "invalid token"}), 400
    return jsonify({
        "status": "succeeded",
        "transactionId": str(uuid.uuid4()),
        "capturedAt": datetime.datetime.utcnow().isoformat() + "Z"
    })

@app.route("/digitalgift/voucher/create", methods=["POST"])
def voucher():
    data = request.get_json(silent=True) or {}
    amount = int(data.get("amountMinor", 0))
    if amount <= 0:
        return jsonify({"status": "error", "message": "invalid amount"}), 400
    return jsonify({
        "id": str(uuid.uuid4()),
        "tokenId": data.get("tokenId") or data.get("rakhiId") or str(uuid.uuid4()),
        "voucherCode": "GFT-" + str(uuid.uuid4())[:8].upper(),
        "voucherURL": "https://example.com/voucher/" + str(uuid.uuid4()),
        "expiry": (datetime.datetime.utcnow() + datetime.timedelta(days=365)).isoformat() + "Z"
    })

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5055, debug=True)
