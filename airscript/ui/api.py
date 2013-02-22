import json

from flask import request
from flask import make_response
from flask.ext import restful

from app import app

base_path = '/api/v1'

api = restful.Api(app)

@api.representation('application/json')
def output_json(data, code, headers=None):
    resp = make_response(json.dumps(data), code)
    resp.headers.extend(headers or {})
    resp.headers['Access-Control-Allow-Origin'] = '*'
    return resp

class Target(restful.Resource):
    def get(self):
        if not request.cookies.get("target"):
            return {"message": "no target"}, 404
        else:
            target = json.loads(request.cookies["target"])
            return {"target": target}

    def put(self):
        target = {
            "type": request.form.get("type", "gist"),
            "id": request.form.get("id"),
        }
        resp = api.make_response({"target": target}, 200)
        resp.set_cookie("target", json.dumps(target))
        return resp

class TargetGists(restful.Resource):
    def get(self):
        gists_mock = [
            {
                "url": "https://api.github.com/gists/0f09f5dd83141be2c96b",
                "description": "description of gist",
                "files": {
                    "script.js": {
                        "contents": "var that = this;"
                    },
                    "config": {
                        "contents": "airscript1.herokuapp.com"
                    }
                }
            },
            {
                "url": "https://api.github.com/gists/0f09f5dd837643e2c123",
                "description": "description of another gist",
                "files": {
                    "script.js": {
                        "contents": "var x = 5;"
                    }
                }
            },]
        return gists_mock


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
    def post(self):
        pass

class Engine(restful.Resource):
    def get(self):
        pass

    def post(self):
        pass

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
        project_mock = {
            "type": "gist",
            "id": "1",
            "description": "description of gist",
            "files": {
                "ring.erl": {
                    "size": 932,
                    "filename": "ring.erl",
                    "raw_url": "https://gist.github.com/raw/365370/8c4d2d43d178df44f4c03a7f2ac0ff512853564e/ring.erl"
                },
                "ring2.erl": {
                    "size": 9,
                    "filename": "ring2.erl",
                    "raw_url": "https://gist.github.com/raw/365370/8c4d2d43d178df44f4c03a7f2ac0ff512853564e/ring2.erl"
                },
            },
            "config": {
                "engine_name": "foobar",
                "engine_url": "http://foobar.herokuapps.com/"
            },
        }
        return project_mock

    def put(self):
        pass


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
