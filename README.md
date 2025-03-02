# plantDiseaseDetection

numpy
pillow
flask
keras
tensorflow -
- If installing and running scripts is disabled, use 
```
Set-ExecutionPolicy RemoteSigned -Scope Process
```
# setup
 - make a virtual environment (version may vary)
```
py -3.12 -m venv .tensorflow_env
```
 - activate virtual environment
```
.\.tensorflow_env\Scripts\activate
pip install -r requirements.txt
```
 - to test virtual environment
```
python -c "import tensorflow as tf; print(tf.reduce_sum(tf.random.normal([1000, 1000])))"
```


