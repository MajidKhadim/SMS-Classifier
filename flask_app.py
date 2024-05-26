from flask import Flask,request,jsonify
from flask_cors import CORS
from helper import load_model,ready_input

model = load_model('sms_classifier.pkl')

app = Flask(__name__)
CORS(app)

@app.route('/classify', methods =['POST'])
def classify_messege():
    data = request.json
    messege = data['message']
    classification = model.predict(ready_input(messege))
    return jsonify({'classification': int(classification)})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
