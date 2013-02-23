import os

from flask import Flask
from flask import request
from flask import redirect
from flask import render_template
from flask import make_response
import requests

app = Flask('airscript.ui', static_url_path='')
app.secret_key = os.environ.get('SECRET_KEY', 'localdev')
app.config['DEBUG'] = True

import api

# Frontend user endpoints

@app.route('/')
def index():
    return redirect('/editor.html')

# OAuth dance endpoints

client_id = '1d3b8d1b1d6613d4b4d7'
client_secret = 'f32ac091c6c203054d47536d3ce3ecf8b6d32910'

@app.route('/auth/login')
def auth_login():
    if request.cookies.get('auth'):
        return redirect('/')
    else:
        return redirect('https://github.com/login/oauth/authorize?client_id={}&scope=gist,repo'.format(client_id))

@app.route('/auth/callback')
def auth_callback():
    payload = {
        'client_id': client_id,
        'client_secret': client_secret,
        'code': request.args.get('code'),
    }
    headers = {'Accept': 'application/json'}
    url = 'https://github.com/login/oauth/access_token'
    req = requests.post(url, data=payload, headers=headers)
    if req.status_code == 200:
        resp = make_response(redirect('/'))
        resp.set_cookie('auth', req.json['access_token'])
        return resp
    else:
        return "Request for access token failed", 403

@app.route('/auth/logout')
def auth_logout():
    resp = make_response(redirect('/'))
    resp.set_cookie('auth', '')
    return resp

