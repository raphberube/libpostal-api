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

@app.route('/parse/', methods=['POST'])
def parse():
    return json.dumps(parse_address('The Book Club 100-106 Leonard St Shoreditch London EC2A 4RH, United Kingdom'))

if __name__ == "__main__":
    print("Main")

    app.logger.info("Loading Flask API...")
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))