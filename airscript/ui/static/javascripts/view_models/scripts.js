(function() {

  Airscript.namespace("Airscript.ViewModels", function(Models) {
    return Models.Scripts = function() {
      var activateScript, self;
      self = this;
      self.index = -1;
      self.gists = ko.observableArray();
      self.scripts = ko.observableArray();
      self.activeGist = ko.observable('');
      $.getJSON('/api/v1/project/target/gists', function(data) {
        var gist, _i, _len, _results;
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
      self.saveScripts = function() {
        return $.ajax('/api/v1/project/target/gists', {
          type: 'POST',
          data: {
            description: 'testing'
          },
          success: function(data) {
            return console.log(data);
          }
        });
      };
      self.selectGist = function(gist, e) {
        var fileName, fileObj, _ref;
        self.scripts([]);
        self.activeGist(gist.description);
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
      self.createNewScript = function() {
        var newScript, script, _i, _len, _ref;
        _ref = self.scripts();
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          script = _ref[_i];
          script.active(false);
        }
        newScript = {
          name: ko.observable('New Script'),
          source: ko.observable(''),
          active: ko.observable(true)
        };
        self.scripts.push(newScript);
        self.index += 1;
        return Airscript.eventBus.notifySubscribers({
          name: newScript.name(),
          source: newScript.source()
        }, 'editor:updateCode');
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
