import logging
from flask import Flask, url_for, request

app = Flask(__name__)

if __name__ != '__main__':
    gunicorn_logger = logging.getLogger('gunicorn.error')
    app.logger.handlers = gunicorn_logger.handlers
    app.logger.setLevel(gunicorn_logger.level)

@app.route('/metric/thermostat/', methods=['GET'])
def get_metric_thermostat():
    