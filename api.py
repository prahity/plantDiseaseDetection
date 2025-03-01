#api.py: A Flask API to handle requests from the Swift interface

from flask import Flask, request, jsonify
from prediction_service import predict_disease

app = Flask(__name__)

@app.route('/predict', methods=['POST'])
def predict():
    if 'image' not in request.files:
        return jsonify({'error' : 'No image provided'}), 400
    
    image = request.files['image']
    image_path = 'temp_image.jpg'
    image.save(image_path)

    prediction = predict_disease(image_path)

    #add label map

    return jsonify({'prediction' : prediction.tolist()})

if __name__ == '__main__':
    app.run(debug=True)