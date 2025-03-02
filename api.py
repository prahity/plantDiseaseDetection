#api.py: A Flask API to handle requests from the Swift interface

from flask import Flask, request, jsonify
from prediction_service import predict_disease
import requests
from CropDiseaseDetectionAttempt import uiuc_chat_call
import os
import numpy as np
from flask_cors import CORS

print("")

app = Flask(__name__)
CORS(app)
@app.route('/predict', methods=['POST'])
def predict():
    if 'image' not in request.files:
        return jsonify({'error' : 'No image provided'}), 400
    print("Before submitting")
    
    image = request.files['image']
    image_path = './temp_image.jpg'
    image.save(image_path)

    prediction = predict_disease(image_path)
    print(prediction)

    directory = '.\\dataset\\train'
    contents = os.listdir(directory)

    dictionary = []
    for i in contents:
        dictionary.append(i) 

    index = np.argmax(prediction)

    # maxProb = 0
    # index = -1
    # for i in range(len(prediction)):
    #     if (maxProb < prediction[i]):
    #         maxProb = prediction[i]
    #         index = i

    predictString = dictionary[index]

    disease = predictString.split("___")
    text = uiuc_chat_call(disease[0], disease[1])

    return jsonify({'prediction' : text})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)
