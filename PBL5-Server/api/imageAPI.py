from flask import Blueprint, request, jsonify, send_file
from firebase_admin import storage, db
from datetime import datetime, timedelta
from flask import url_for
from ultralytics import YOLO
import cv2
import os
from werkzeug.utils import secure_filename
imageAPI = Blueprint('imageAPI', __name__)

model = YOLO('D:/PBL5/Model/best_10.pt')
# model =  YOLO('D:/PBL5/Model/yolov8n.pt')
@imageAPI.route('/', methods=['POST'])
def upload_image_and_create_item():
    # Lấy file ảnh từ form data
    image = request.files['image']
    filename = secure_filename(image.filename)
    filename = os.path.join('D:/PBL5/PBL5-Server/api', filename)
    image_data = image.read()
    image.seek(0)
    image.save(filename)
    results = model.predict(source = filename,save = True)
    if len(results[0].boxes) > 0:
        fire = results[0].boxes.conf[results[0].boxes.cls == 0]
        smoke = results[0].boxes.conf[results[0].boxes.cls == 2]
        if len(fire) > 0:
            conf_fire = fire.max().item()
        else:
            conf_fire = 0
        if len(smoke) > 0:
            conf_smoke = smoke.max().item()
        else:
            conf_smoke = 0
        if (conf_fire > 0.7) or (conf_smoke > 0.5 and conf_fire > 0.5):
            # Tải ảnh lên Firebase Storage
            image_name = "Fire_Detection/" + image.filename
            image_content_type = image.content_type
            bucket = storage.bucket()
            blob = bucket.blob(image_name)
            blob.upload_from_string(image_data, content_type=image_content_type)
            url = blob.generate_signed_url(
                version='v4',
                expiration=timedelta(minutes=15),
                method='GET'
            )

            # Lấy dữ liệu từ form data và thêm thuộc tính 'date' vào
            item = {}
            item['date'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            item['imageUrl'] = url

            # Tải dữ liệu lên Firebase Realtime Database
            ref = db.reference('user')
            new_item_ref = ref.push()
            new_item_ref.set(item)
            os.remove(filename)
            return jsonify({'message': 'Fire', 'item_id': new_item_ref.key})
    os.remove(filename)
    return jsonify({'message': 'Non Fire'})

@imageAPI.route('/<image_name>', methods=['GET'])
def get_image(image_name):
    bucket = storage.bucket()
    blob = bucket.blob('Fire_Detection/' + image_name)
    if not blob.exists():
        return jsonify({'error': 'Image does not exist'})
    url = blob.generate_signed_url(
        version='v4',
        expiration=datetime.timedelta(minutes=15),
        method='GET'
    )
    return jsonify({'url': url})