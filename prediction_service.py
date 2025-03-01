#prediction_service.py: Uses loaded model to make predictions

from model_loader import model
from image_preprocessor import preprocess_image

def predict_disease(image_path):
    processed_image = preprocess_image(image_path)
    prediction = model.predict(processed_image)
    return prediction

