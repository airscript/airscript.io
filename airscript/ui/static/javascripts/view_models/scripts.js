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
          _results.push(self.gists.push(gist));
        }
        return _results;
      });
      gists.error(function() {
        var data, gist, _i, _len, _results;
        data = [
          {
            id: 'dsfasdf323r234',
            description: 'test gist',
            files: {
              'testing.rb': {
                raw_url: 'https://gist.github.com/testing.rb'
              }
            }
          }, {
            id: 'lkasjdf94',
            description: 'test gist 2',
            files: {
              'testing2.rb': {
                raw_url: 'https://gist.github.com/testing2.rb'
              }
            }
          }
        ];
        _results = [];
        for (_i = 0, _len = data.length; _i < _len; _i++) {
          gist = data[_i];
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
      self.createNewFile = function() {
        return self.scripts.push({
          name: ko.observable('new script'),
          source: ko.observable(''),
          active: ko.observable(false)
        });
      };
      self.selectGist = function(gist, e) {
        var fileName, fileObj, _ref;
        self.scripts([]);
        self.activeGist(gist);
        self.activeGistDescription(gist.description || gist.id);
        _ref = gist.files;
        for (fileName in _ref) {
          fileObj = _ref[fileName];
          self.scripts.push({
            name: ko.observable(fileName),
            source: ko.observable(fileObj.contents),
            active: ko.observable(false)
          });
          self.index += 1;
        }
        activateScript(self.index);
        return $('.modal').modal('hide');
      };
      self.selectScript = function(script, e) {
        var _i, _len, _ref;
        self.index = $(e.currentTarget).parent().index();
        _ref = self.scripts();
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          script = _ref[_i];
          script.active(false);
        }
        return activateScript(self.index);
      };
      Airscript.eventBus.subscribe(function(newValue) {
        return self.createNewScript();
      }, this, "script:new");
      Airscript.eventBus.subscribe(function(_arg) {
        var name, script, source;
        name = _arg.name, source = _arg.source;
        script = self.scripts()[self.index];
        script.name(name);
        return script.source(source);
      }, this, "script:save");
      return self;
    };
  });

}).call(this);
