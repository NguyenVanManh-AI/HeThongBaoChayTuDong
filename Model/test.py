
import cv2
import os
import time
import requests
import RPi.GPIO as GPIO
import time
from roboflow import Roboflow

url = 'http://127.0.0.1:5000/api/images/'
GPIO.setmode(GPIO.BCM)
BUZZER_PIN = 15
GPIO.setwarnings(False)
GPIO.setup(BUZZER_PIN, GPIO.OUT)

rf = Roboflow(api_key="yKfoFEQKamu6Y3lkQ6o2")
project = rf.workspace().project("fire-detection-classification")
model = project.version(3).model

def beep(pitch):
    period = 1.0 / pitch
    delay = period / 2
    GPIO.output(BUZZER_PIN, True)
    time.sleep(delay)
    GPIO.output(BUZZER_PIN, False)
    time.sleep(delay)

def detect(filename):
    src = filename
    print(model.predict(src, confidence=40, overlap=30).json())
    return True
    

if __name__ == "__main__":
# Đặt thư mục để lưu các ảnh
    folder = '/home/pi/image'

    # Khởi tạo USB webcam
    cap = cv2.VideoCapture(0)
        
    while(True):
        # Đặt độ phân giải của USB webcam
        cap.set(cv2.CAP_PROP_FRAME_WIDTH, 1280)
        cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 720)
        # Thiết lập độ sáng
        cap.set(cv2.CAP_PROP_BRIGHTNESS, 0.5) # giá trị từ 0.0 đến 1.0
        # Thiết lập độ tương phản
        cap.set(cv2.CAP_PROP_CONTRAST, 0.5) # giá trị từ 0.0 đến 1.0
        # Đọc ảnh từ USB webcam
        ret, frame = cap.read()
        # Lưu ảnh vào thư mục đã tạo
        filename = os.path.join(folder,"img.jpg")
        cv2.imwrite(filename, frame)
        if detect(filename):
            files = {'image': open(filename, 'rb')}
            response = requests.post(url, files=files)  
        # 2 FPS
        time.sleep(2)
        os.remove(os.path.join(folder, filename))
    # Giải phóng USB webcam
    cap.release()