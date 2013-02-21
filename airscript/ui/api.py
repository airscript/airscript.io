from flask import Flask
from flask.ext import restful

base_path = '/api/v1'

def attach(app):
    api = restful.Api(app)
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

class Target(restful.Resource):
    def get(self):
        return {"msg": "Hello world"}

    def put(self):
        pass

class TargetGists(restful.Resource):
    def get(self):
        pass

    def post(self):
        pass

class TargetRepos(restful.Resource):
    def get(self):
        pass

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
        return {"msg": "Hello world"}

    def put(self):
        pass

