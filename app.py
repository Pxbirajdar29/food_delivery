from flask import Flask, jsonify, request
from flask_cors import CORS
import os
import logging
from datetime import datetime

app = Flask(__name__)
CORS(app)

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

MENU = [
    {"id": 1, "name": "Cheese Burger", "price": 299, "category": "burger"},
    {"id": 2, "name": "Margherita Pizza", "price": 449, "category": "pizza"},
    {"id": 3, "name": "Pasta Alfredo", "price": 349, "category": "pasta"},
    {"id": 4, "name": "Caesar Salad", "price": 249, "category": "salad"}
]

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "healthy", "timestamp": datetime.now().isoformat()}), 200

@app.route('/api/menu', methods=['GET'])
def get_menu():
    logger.info(f"Menu requested at {datetime.now()}")
    return jsonify(MENU), 200

@app.route('/api/menu/<int:item_id>', methods=['GET'])
def get_item(item_id):
    item = next((i for i in MENU if i["id"] == item_id), None)
    if item:
        return jsonify(item), 200
    return jsonify({"error": "Item not found"}), 404

@app.route('/api/orders', methods=['POST'])
def create_order():
    data = request.json
    
    if not data or 'items' not in data:
        return jsonify({"error": "Invalid order data"}), 400
    
    total = 0
    for item in data['items']:
        menu_item = next((m for m in MENU if m["id"] == item["id"]), None)
        if menu_item:
            total += menu_item["price"] * item.get("quantity", 1)
    
    order = {
        "order_id": hash(datetime.now()),
        "status": "confirmed",
        "total": total,
        "timestamp": datetime.now().isoformat()
    }
    
    logger.info(f"Order created: {order}")
    return jsonify(order), 201

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    # Using Flask's built-in server (no gunicorn)
    app.run(host='0.0.0.0', port=port, debug=False, threaded=True)