
from flask import Flask
from flask import request
from flask import redirect
from flask import render_template

import api

app = Flask('airscript.ui')
app.config['DEBUG'] = True
api.attach(app) # see api.py

# Frontend user endpoints

@app.route('/')
def index():
    return render_template('index.html')

# OAuth dance endpoints
# TODO

