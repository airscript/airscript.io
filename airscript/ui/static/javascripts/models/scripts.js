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
                  _results1.push(item.source(fileObj.content));
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
