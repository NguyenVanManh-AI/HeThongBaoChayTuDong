# from roboflow import Roboflow
from ultralytics import YOLO
import numpy as np
import time
import cv2
from pathlib import Path
import json
import torch


src = 'D:/PBL5/Datasets/Fire_Detection.v3i.yolov8/test/images/large_-1-_jpg.rf.3e3e9dd42b61504d23f82da2d8cd36b0.jpg'
#src = 'D:/PBL5/PBL5-Server/api/img_2023-05-10-145802.jpg'
# Evaluate the model on the test set and generate P-R curve data
# results = model.test(data=src, save_json=True)

# Load the P-R curve data from the JSON file
# with open(Path(results).parent / 'results.json') as f:
#     results = json.load(f)['results'][0]['metrics']['precision_recall']

model = YOLO('D:/PBL5/Model/best_10.pt')
# model = YOLO('D:/PBL5/Model/best_10.pt')
# model = YOLO('D:/PBL5/Model/yolov8n.pt')
results = model.predict(source=src)
# res_plotted = res[0].plot()
# cv2.imshow("result", res_plotted)
# if len(results[0].boxes) > 0:
#     conf_fire = 0
#     conf_smoke = 0
#     fire_count = 0
#     smoke_count = 0
#     for box in results[0].boxes:
#         if box.cls == 0:
#             conf_fire += box.conf
#             fire_count += 1
#         elif box.cls == 1:
#             conf_smoke += box.conf
#             smoke_count += 1
#     if fire_count > 0:
#         conf_fire /= fire_count
#     else:
#         conf_fire = conf_smoke
#     if smoke_count > 0:
#         conf_smoke /= smoke_count
#     else:
#         conf_smoke = conf_fire
# else:
#     print(1)
