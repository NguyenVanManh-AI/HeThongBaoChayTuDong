from flask import Blueprint, request, jsonify
import firebase_admin
from firebase_admin import db, auth
from datetime import datetime

userAPI = Blueprint('userAPI', __name__)


@userAPI.route('/', methods=['GET'])
def get_all_items():
    ref = db.reference('data')
    datas = ref.get()
    return jsonify(datas)


# API cập nhật một item dựa trên id
@userAPI.route('/<string:item_id>', methods=['PUT'])
def update_item(item_id):
    item = request.json
    ref = db.reference('data/' + item_id)
    ref.update(item)
    return jsonify({'message': 'Updated successfully'}), 200

# API xóa một item dựa trên id
@userAPI.route('/<string:item_id>', methods=['DELETE'])
def delete_item(item_id):
    ref = db.reference('data/' + item_id)
    ref.delete()
    return jsonify({'message': 'Deleted successfully'}), 200

# API thêm một item mới
@userAPI.route('/', methods=['POST'])
def create_item():
    item = request.json
    item['date'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')  # Thêm giá trị của datetime.now() vào trường 'date'
    ref = db.reference('user')
    new_item_ref = ref.push()
    new_item_ref.set(item)
    return jsonify({'message': 'Created successfully', 'item_id': new_item_ref.key}), 201

@userAPI.route('/signup', methods=['POST'])
def signup():
    email = request.json.get('email')
    password = request.json.get('password')

    try:
        # Tạo tài khoản người dùng với Firebase Authentication
        user = auth.create_user(
            email=email,
            password=password
        )
        # Trả về uid của người dùng nếu tạo thành công
        uid = user.uid
        return jsonify({'uid': uid}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Define auth API endpoint
@userAPI.route('/auth', methods=['POST'])
def authenticate():
    id_token = request.json['idToken']
    try:
        decoded_token = auth.verify_id_token(id_token)
        uid = decoded_token['uid']
        return uid
    except Exception as e:
        return str(e)