import json
import hashlib

from flask import request
from flask import session
from flask import make_response
from flask.ext import restful
import requests

from app import app

base_path = '/api/v1'

api = restful.Api(app)

@api.representation('application/json')
def output_json(data, code, headers=None):
    resp = make_response(json.dumps(data), code)
    resp.headers.extend(headers or {})
    resp.headers['Access-Control-Allow-Origin'] = '*'
    return resp

def heroku_account(full_username=True):
    login = session['user']
    username = "{}@airscript-users.appspotmail.com".format(login)
    password = hashlib.sha1(
                "{}--{}".format(login, app.secret_key)).hexdigest()
    if full_username:
        return {'username': username, 'password': password}
    else:
        return {'username': login, 'password': password}

def heroku_appname():
    return "{}-airscript-engine".format(session['user'])

class Target(restful.Resource):
    def get(self):
        if "target" not in session:
            return {"message": "no target"}, 404
        else:
            return {"target": session['target']}

    def put(self):
        session['target'] = {
            "type": request.form.get("type", "gist"),
            "id": request.form.get("id"),
        }
        resp = api.make_response({"target": session['target']}, 200)
        return resp

class TargetGists(restful.Resource):
    def get(self):
        user = request.cookies['user']
        auth = request.cookies['auth']

        url = 'https://api.github.com/users/{}/gists'.format(user)

        create_default = True

        req = requests.get(url, params={'access_token': auth})

        for gist in req.json():
            if gist.get('description') == 'airscript':
                create_default = False

        if create_default:
            create_url = 'https://api.github.com/gists?access_token={}'.format(auth)

            placeholder_content = """-- make an HTTP request with query parameters
local response = http.request {
  url = 'http://www.random.org/integers/',
  params = {
      num=1, min=0, max=1, format='plain',
      rnd='new', col=1, base=10
  }
}
if tonumber(response.content) == 0 then
  return 'heads'
else
  return 'tails'
end"""

            default_gist_params = {
                'description': 'airscript',
                'public': True,
                'files': {
                    'coin_flip.lua': {
                        'content': placeholder_content
                    }
                }
            }

            requests.post(create_url, json.dumps(default_gist_params))

            updated_req = requests.get(url, params={'access_token': auth})

            return updated_req.json()
        else:
            return req.json()

    def post(self):
        created_gist_mock = {
                "description": request.form['description'],
                "id": "3",
                "url": "https://api.github.com/gists/fakenewgist",
        }
        return created_gist_mock

class TargetRepos(restful.Resource):
    def get(self):
        repos_mock = [
            {
                "id": 1296269,
                "name": "Hello-World",
                "full_name": "octocat/Hello-World",
                "description": "This your first repo!",
            },
            {
                "id": 1296361,
                "name": "Hello-World2",
                "full_name": "octocat/Hello-World2",
                "description": "This your second repo!",
            },]
        return repos_mock

class EngineAuth(restful.Resource):
    def get(self):
        user = request.args.get('user')
        if user:
            session['user'] = user

        def _login():
            url = 'https://api.heroku.com/login'
            resp = requests.post(url, data=heroku_account())
            if resp.status_code == 200:
                return resp.json['api_key']
        def _register():
            url = 'https://airscript-users.appspot.com/new'
            resp = requests.post(url, data=heroku_account(False))
            if resp.status_code == 201:
                url = resp.headers['location']
                resp = requests.get(url)
                if resp.status_code == 200:
                    return True, resp
                else:
                    return False, resp
            else:
                return False, resp

        api_key = _login()
        if api_key:
            response = heroku_account()
            response["engine_key"] = api_key 
            return response
        else:
            success, resp = _register()
            if not success:
                return {"error": resp.text}, resp.status_code
            api_key = _login()
            if api_key:
                response = heroku_account()
                response["engine_key"] = api_key
                return response
            else:
                return {"error": "try again"}, 400

class Engine(restful.Resource):
    def get(self):
        user = request.args.get('user')
        if user:
            session['user'] = user

        api_key = request.args.get("engine_key")
        if not api_key:
            return {"error": "engine_key parameter required"}, 400

        url = 'https://api.heroku.com/apps/{}'.format(heroku_appname())
        resp = requests.get(url, auth=('', api_key))
        return resp.json, resp.status_code


    def post(self):
        user = request.args.get('user')
        if user:
            session['user'] = user

        api_key = request.form.get("engine_key")
        if not api_key:
            return {"error": "engine_key parameter required"}, 400

        url = 'https://api.heroku.com/apps/{}'.format(heroku_appname())
        resp = requests.get(url, auth=('', api_key))
        if resp.status_code == 404:
            url = 'https://api.heroku.com/apps'
            resp = requests.post(url, auth=('', api_key), data={
                'app[name]': heroku_appname()})
            if resp.status_code != 202:
                return resp.json, resp.status_code

        url = 'https://api.heroku.com/apps/{}/config_vars'.format(heroku_appname())
        requests.put(url, auth=('', api_key), data=json.dumps({'BUILDPACK_URL': 'https://github.com/airscript/heroku-buildpack-airscript'}))

        url = 'https://api.heroku.com/apps/{}/domains'.format(heroku_appname())
        requests.post(url, auth=('', api_key), data={'domain_name[domain]': '{}.airscript.io'.format(session['user'])})

        engine_repo = 'git://github.com/airscript/airscript-engine.git'
        deployer = """
  mkdir -p ~/.ssh
  cat <<EOF > ~/.ssh/config
Host heroku.com
    UserKnownHostsFile=/dev/null
    StrictHostKeyChecking=no
EOF
  ssh-keygen -t dsa -N "" -f /app/.ssh/id_dsa -C "robot@airscript.io"
  curl -u ":{key}" -d @/app/.ssh/id_dsa.pub -X POST https://api.heroku.com/user/keys
  git clone {repo} repo
  cd repo
  git remote add heroku "git@heroku.com:{app}.git"
  git push heroku master
  curl -u ":{key}" -X DELETE "https://api.heroku.com/user/keys/robot@airscript.io"
""".format(key=api_key, app=heroku_appname(), repo=engine_repo)
        url = 'https://api.heroku.com/apps/{}/ps'.format(heroku_appname())
        resp = requests.post(url, auth=('', api_key), data={
            'command': deployer})
        return resp.json, resp.status_code

class EngineLogs(restful.Resource):
    def get(self):
        pass

class EngineConfig(restful.Resource):
    def get(self):
        pass

    def put(self):
        pass

class Project(restful.Resource):
    def get(self):
        if "target" not in session:
            return {"message": "no target"}, 404
        url = 'https://api.github.com/gists/{}'.format(
                session['target']['id'])
        req = requests.get(url, params={
            'access_token': request.cookies['auth']})
        files = req.json['files']
        for filename in files:
            url = files[filename]['raw_url']
            files[filename]['content'] = requests.get(url).text
        session['project'] = {
            "files": files,
            "config": {
                "engine_name": "pure-reaches-3506",
                "engine_url": "http://pure-reaches-3506.herokuapp.com/"
            },
        }
        return session['project']

    def put(self):
        # see http://developer.github.com/v3/gists/#edit-a-gist
        # for arguments and semantics
        url = 'https://api.github.com/gists/{}'.format(
                session['target']['id'])
        req = requests.patch(url,
            params={'access_token': request.cookies['auth']},
            data=request.data)
        return req.json, req.status_code

routes = {
    '/project/target': Target,
    '/project/target/gists': TargetGists,
    '/project/target/repos': TargetRepos,
    '/project/engine/auth': EngineAuth,
    '/project/engine': Engine,
    '/project/engine/logs': EngineLogs,
    '/project/engine/config': EngineConfig,
    '/project': Project,
}
for path in routes:
    api.add_resource(routes[path], '{}{}'.format(base_path, path))
