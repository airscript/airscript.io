(function() {

  Airscript.namespace("Airscript.Models", function(Models) {
    Models.Script = function(scriptName, scriptSource) {
      var editing, selected, self;
      if (scriptName == null) {
        scriptName = 'new script';
      }
      if (scriptSource == null) {
        scriptSource = '';
      }
      selected = ko.observable(false);
      editing = ko.observable(false);
      return self = {
        name: ko.observable(scriptName),
        source: ko.observable(scriptSource),
        selected: selected,
        editing: editing,
        activeClass: ko.computed(function() {
          if (selected()) {
            return 'active';
          } else {
            return '';
          }
        })
      };
    };
    return Models.EMPTY_SCRIPT = Models.Script('', '');
  });

}).call(this);
(function() {

  Airscript.namespace("Airscript.Models", function(Models) {
    return Models.Scripts = function() {
      var collection, index, self;
      collection = ko.observableArray();
      index = ko.observable(-1);
      return self = {
        active: function() {
          return collection()[index()] || Models.EMPTY_SCRIPT;
        },
        add: function(name, contents) {
          return collection.push(Models.Script(name, contents));
        },
        collection: collection,
        "delete": function(script) {
          var lastScript;
          collection.remove(script);
          if (lastScript = collection()[collection().length - 1]) {
            lastScript.selected(true);
            return index(collection.indexOf(lastScript));
          }
        },
        empty: function() {
          collection([]);
          return index(-1);
        },
        edit: function(script) {
          var s, _i, _len, _ref;
          _ref = collection();
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            s = _ref[_i];
            s.editing(false);
          }
          return script.editing(true);
        },
        update: function(files) {
          var fileName, fileObj, item, _i, _len, _ref, _results;
          _ref = collection();
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            item = _ref[_i];
            _results.push((function() {
              var _results1;
              _results1 = [];
              for (fileName in files) {
                fileObj = files[fileName];
                if (item.name() === fileName) {
                  item.source(fileObj.content);
                  _results1.push(self.select(item));
                } else {
                  _results1.push(void 0);
                }
              }
              return _results1;
            })());
          }
          return _results;
        },
        stopEditing: function(newName) {
          var s, _i, _len, _ref, _results;
          _ref = collection();
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            s = _ref[_i];
            if (s.editing()) {
              s.name(newName);
            }
            _results.push(s.editing(false));
          }
          return _results;
        },
        select: function(script) {
          var s, _i, _len, _ref;
          _ref = collection();
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            s = _ref[_i];
            s.selected(false);
          }
          script.selected(true);
          return index(collection.indexOf(script));
        }
      };
    };
  });

}).call(this);
(function() {

  Airscript.namespace("Airscript.Models", function(Models) {
    Models.Gist = function(id, desc, files) {
      var description, fileName, fileObj, scripts, self;
      if (id == null) {
        id = -1;
      }
      if (desc == null) {
        desc = '';
      }
      if (files == null) {
        files = {};
      }
      id = ko.observable(id);
      description = ko.observable(desc);
      scripts = Models.Scripts();
      for (fileName in files) {
        fileObj = files[fileName];
        scripts.add(fileName, fileObj.content);
      }
      return self = {
        id: id,
        description: description,
        scripts: scripts
      };
    };
    return Models.EMPTY_GIST = Models.Gist();
  });

}).call(this);
(function() {

  Airscript.namespace("Airscript.Models", function(Models) {
    return Models.Gists = function() {
      var collection, index, self;
      collection = ko.observableArray();
      index = ko.observable(-1);
      return self = {
        active: function() {
          return collection()[index()] || Models.EMPTY_GIST;
        },
        add: function(id, description, files) {
          collection.push(Models.Gist(id, description, files));
          return index(collection().length - 1);
        },
        collection: collection,
        fetch: function() {
          var gistsDeferred;
          gistsDeferred = $.getJSON('/api/v1/project/target/gists', function(data) {});
          gistsDeferred.success(function(data) {
            var gist, _i, _len, _results;
            _results = [];
            for (_i = 0, _len = data.length; _i < _len; _i++) {
              gist = data[_i];
              if (!gist.description.length) {
                gist.description = gist.id;
              }
              if (gist.description === 'airscript') {
                self.add(gist.id, gist.description, gist.files);
                _results.push(self.target(gist));
              } else {
                _results.push(void 0);
              }
            }
            return _results;
          });
          return gistsDeferred.error(function() {
            var data, gist, _i, _len, _results;
            data = [
              {
                id: 'dsfasdf323r234',
                description: 'All my Airscripts live in this gist.',
                files: {
                  'testing.rb': {
                    content: 'some stuff'
                  }
                }
              }, {
                id: 'lkasjdf94',
                description: 'This is a script that calls your friends up and plays Rick Astley.',
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
              _results.push(self.add(gist.id, gist.description, gist.files));
            }
            return _results;
          });
        },
        target: function(gist, e) {
          return $.ajax({
            url: "/api/v1/project/target",
            data: {
              type: 'gist',
              id: gist.id
            },
            type: 'PUT',
            success: function() {
              return $.getJSON("/api/v1/project", function(data) {
                gist.files = data.files;
                self.active().scripts.update(gist.files);
                $('.engine_deploy_spinner, .engine_deploy_curtain').removeClass('hidden');
                return $.ajax({
                  url: '/api/v1/project/engine/auth',
                  type: 'GET',
                  data: {
                    user: 'mdiebolt'
                  },
                  success: function(data) {
                    var engine_key, username;
                    engine_key = data.engine_key, username = data.username;
                    return $.ajax({
                      url: "/api/v1/project/engine?user=mdiebolt",
                      type: 'POST',
                      data: {
                        engine_key: engine_key
                      },
                      success: function(data) {
                        Airscript.eventBus.notifySubscribers(data.app_name, 'editor:updateProjectName');
                        return $('.engine_deploy_spinner, .engine_deploy_curtain').addClass('hidden');
                      }
                    });
                  }
                });
              });
            }
          });
        },
        update: function() {
          var data, file, gist, _i, _len, _ref;
          gist = self.active();
          data = {
            description: gist.description(),
            files: {}
          };
          _ref = gist.scripts.collection();
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            file = _ref[_i];
            data.files[file.name()] = {
              fileName: file.name(),
              content: file.source() || ""
            };
          }
          return $.ajax({
            url: '/api/v1/project',
            contentType: 'application/json',
            dataType: 'json',
            type: 'PUT',
            data: JSON.stringify(data)
          });
        },
        select: function(idx) {
          var active;
          index(idx);
          return active = self.active();
        },
        addScript: function(name, content) {
          return self.active().scripts.add(name, content);
        }
      };
    };
  });

}).call(this);
(function() {

  Airscript.namespace("Airscript.ViewModels", function(ViewModels) {
    return ViewModels.ScriptsPanel = function() {
      var firstScript, gists, self;
      gists = Airscript.Models.Gists();
      gists.fetch();
      firstScript = function() {
        return gists.active().scripts.collection()[0];
      };
      return self = {
        activeScript: function() {
          var _ref;
          return (_ref = gists.active()) != null ? _ref.scripts.active() : void 0;
        },
        stopEditing: function(self, e) {
          var value;
          if (e.keyCode === 13) {
            value = $(e.currentTarget).val();
            return gists.active().scripts.stopEditing(value);
          } else {
            return true;
          }
        },
        createNewFile: function() {
          return gists.active().scripts.add('new script', '');
        },
        selectScript: function(script, e) {
          return gists.active().scripts.select(script);
        },
        editScript: function(script, e) {
          $('.file .edit_script').width($('.file .name').width());
          return gists.active().scripts.edit(self.activeScript());
        },
        deleteScript: function(editor, e) {
          var data, file, gist, _i, _len, _ref;
          if (confirm("Are you sure you want to delete this script?")) {
            gist = gists.active();
            data = {
              description: gist.description(),
              files: {}
            };
            _ref = gist.scripts.collection();
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              file = _ref[_i];
              if (editor.scriptName() === file.name()) {
                data.files[file.name()] = null;
              } else {
                data.files[file.name()] = {
                  fileName: file.name(),
                  content: file.source() || ""
                };
              }
            }
            $.ajax({
              url: '/api/v1/project',
              contentType: 'application/json',
              dataType: 'json',
              type: 'PUT',
              data: JSON.stringify(data)
            });
            return gist.scripts["delete"](self.activeScript());
          }
        },
        hasScripts: function() {
          return gists.active().scripts.collection().length > 0;
        },
        files: function() {
          return gists.active().scripts.collection;
        },
        updateGist: function() {
          return gists.update();
        }
      };
    };
  });

}).call(this);
