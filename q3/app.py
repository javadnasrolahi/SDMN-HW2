from urllib import response
from flask import Flask, request
import json 

app = Flask(__name__)

res = {'status': 'OK'} 
 
@app.route('/api/v1/status', methods=['GET', 'POST'])
def status():
    if request.method == 'POST':
        request_data = request.get_json()
        res['status'] = request_data['status']
        return json.dumps(res), 201
    else:        
        return json.dumps(res)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)


# curl localhost:8000/api/v1/status
# curl -X POST localhost:5000/api/v1/status -H "Content-Type: application/json" -d "{\"status\": \"not OK\"}"

# docker build --tag <image-name>:<tag> .
# docker run --name <container-name> -d -p 8000:8000 <image-name>:<tag>
