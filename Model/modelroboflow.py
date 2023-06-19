from roboflow import Roboflow
import os
import glob

rf = Roboflow(api_key="yKfoFEQKamu6Y3lkQ6o2")
project = rf.workspace().project("fire_detection-d5jqa")
model = project.version(3).model
    
model.predict("D:/PBL5/Datasets/Fire_Detection.v3i.yolov8/test/images/large_-1-_jpg.rf.3e3e9dd42b61504d23f82da2d8cd36b0.jpg", confidence=40, overlap=30).save("prediction.jpg")
# for i in range(len(detection)):
#     confidence = detection[0]['confidence']
#     print(detection[0])
    # cls = detection[0]['class']
    # if cls == "fire":
    #     print(confidence)