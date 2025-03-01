#api.py: A Flask API to handle requests from the Swift interface

from flask import Flask, request, jsonify
#from prediction_service import predict_disease

from flask_cors import CORS

app = Flask(__name__)
CORS(app)
@app.route('/predict', methods=['POST'])
def predict():
    if 'image' not in request.files:
        return jsonify({'error' : 'No image provided'}), 400
    
    image = request.files['image']
    image_path = './temp_image.jpg'
    image.save(image_path)

    #prediction = predict_disease(image_path)

    #add label map

    return jsonify({'prediction' : "prediction.tolist()"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)
