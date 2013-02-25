(function() {

  Airscript.namespace("Airscript.ViewModels", function(Models) {
    return Models.Scripts = function() {
      var activateScript, gists, self;
      self = this;
      self.index = -1;
      self.gists = ko.observableArray();
      self.scripts = ko.observableArray();
      self.activeGistDescription = ko.observable('');
      self.activeGist = ko.observable();
      gists = $.getJSON('/api/v1/project/target/gists', function(data) {});
      gists.success(function(data) {
        var gist, _i, _len, _results;
        _results = [];
        for (_i = 0, _len = data.length; _i < _len; _i++) {
          gist = data[_i];
          if (!gist.description.length) {
            gist.description = gist.id;
          }
          _results.push(self.gists.push(gist));
        }
        return _results;
      });
      gists.error(function() {
        var data, gist, _i, _len, _results;
        data = [
          {
            id: 'dsfasdf323r234',
            description: '',
            files: {
              'testing.rb': {
                content: 'some stuff'
              }
            }
          }, {
            id: 'lkasjdf94',
            description: 'test gist 2',
            files: {
              'testing2.rb': {
                content: 'moar stuff'
              }
            }
          }
        ];
        _results = [];
        for (_i = 0, _len = data.length; _i < _len; _i++) {
          gist = data[_i];
          if (!gist.description.length) {
            gist.description = gist.id;
          }
          _results.push(self.gists.push(gist));
        }
        return _results;
      });
      activateScript = function(index) {
        var activeScript;
        activeScript = self.scripts()[index];
        return Airscript.eventBus.notifySubscribers({
          name: activeScript.name(),
          source: activeScript.source()
        }, 'editor:updateCode');
      };
      self.activeScriptName = ko.computed(function() {
        var script;
        script = self.scripts()[self.index];
        return (script != null ? script.name() : void 0) || '';
      }, self);
      self.createNewFile = function() {
        self.scripts.push({
          name: ko.observable('new script'),
          source: ko.observable('')
        });
        self.index += 1;
        return activateScript(self.index);
      };
      self.saveGists = function() {
        var data, file, gist, _i, _len, _ref;
        gist = self.activeGist();
        data = {
          description: gist.description,
          files: {}
        };
        _ref = self.scripts();
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          file = _ref[_i];
          data.files[file.name()] = {
            content: file.source() || ""
          };
        }
        return $.ajax({
          url: '/api/v1/project',
          type: 'PUT',
          data: JSON.stringify(data),
          success: function() {
            return console.log('woo');
          }
        });
      };
      self.selectGist = function(gist, e) {
        $.ajax({
          url: "/api/v1/project/target",
          data: {
            type: 'gist',
            id: gist.id
          },
          type: 'PUT',
          success: function() {
            return $.getJSON("/api/v1/project", function(data) {
              var fileName, fileObj, _ref, _results;
              Airscript.eventBus.notifySubscribers(data.config.engine_url, 'editor:updateProjectName');
              gist.files = data.files;
              self.scripts([]);
              self.index = -1;
              self.activeGist(gist);
              self.activeGistDescription(gist.description);
              _ref = gist.files;
              _results = [];
              for (fileName in _ref) {
                fileObj = _ref[fileName];
                self.scripts.push({
                  name: ko.observable(fileName),
                  source: ko.observable(fileObj.content)
                });
                self.index += 1;
                _results.push(activateScript(self.index));
              }
              return _results;
            });
          }
        });
        return $('.modal').modal('hide');
      };
      self.selectScript = function(script, e) {
        self.index = $(e.currentTarget).parent().index();
        return activateScript(self.index);
      };
      Airscript.eventBus.subscribe(function(newValue) {
        return self.createNewScript();
      }, this, "script:new");
      Airscript.eventBus.subscribe(function(_arg) {
        var name, script, source;
        name = _arg.name, source = _arg.source;
        script = self.scripts()[self.index];
        script.source(source);
        return self.saveGists();
      }, this, "script:save");
      return self;
    };
  });

}).call(this);
