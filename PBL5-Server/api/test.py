import cv2
import os
import time
import requests

# Đặt thư mục để lưu các ảnh
folder = 'C:\API_PBL5\images'

# Khởi tạo USB webcam
cap = cv2.VideoCapture(0)

url = 'http://192.168.0.101:5000/api/images/'
filename = os.path.join(folder,"123.jpg")
files = {'image': ('123.jpg', open(filename, 'rb'), 'image/jpeg')}
response = requests.post(url, files=files)