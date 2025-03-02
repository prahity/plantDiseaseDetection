#model_loader.py: Load the trained model to make predictions without retraining data

from tensorflow.keras.models import load_model

def load_trained_model(model_path):
    return load_model(model_path)

model = load_trained_model('./plant_disease_model_inception_first.keras')