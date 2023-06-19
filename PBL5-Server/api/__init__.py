from flask import Flask
from firebase_admin import credentials, initialize_app
from flask_cors import CORS
cred = credentials.Certificate("./PBL5-Server/api/key.json")
default_app = initialize_app(cred, {
    "databaseURL": "https://pbl5-bb126-default-rtdb.asia-southeast1.firebasedatabase.app",
    "storageBucket": "pbl5-bb126.appspot.com"
})

def create_app():
    app = Flask(__name__)
    CORS(app)
    app.config['SECRET_KEY'] = '1234rtfescdvf'

    from .userAPI import userAPI
    from .imageAPI import imageAPI

    app.register_blueprint(userAPI , url_prefix="/api/data")
    app.register_blueprint(imageAPI , url_prefix="/api/images")
    return app