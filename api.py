import logging
import os
import sys
import json
from flask import Flask, url_for, request
from postal.parser import parse_address

app = Flask(__name__)

if __name__ != '__main__':
    gunicorn_logger = logging.getLogger('gunicorn.error')
    app.logger.handlers = gunicorn_logger.handlers
    app.logger.setLevel(gunicorn_logger.level)

@app.route('/parseaddress/', methods=['POST'])
def parse():
    body = request.get_json()
    input_str = body['request']
    parsed = parse_address(input_str)
    
    result = {}
    for item in parsed:
        result[item[1]] = item[0]

    return result

if __name__ == "__main__":
    print("Main")

    app.logger.info("Loading Flask API...")
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))