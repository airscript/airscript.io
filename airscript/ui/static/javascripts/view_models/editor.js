(function() {

  Airscript.namespace("Airscript.ViewModels", function(ViewModels) {
    return ViewModels.Editor = function() {
      var aceEditor, projectName, scriptsPanel, self;
      aceEditor = ace.edit("editor");
      aceEditor.setShowPrintMargin(false);
      aceEditor.on('change', function(e) {
        var value;
        value = aceEditor.getSession().getValue();
        return scriptsPanel.activeScript().source(value);
      });
      aceEditor.commands.addCommand({
        name: 'newScript',
        bindKey: {
          win: 'Ctrl-n',
          mac: 'Ctrl-n'
        },
        exec: function(editor) {
          return scriptsPanel.createNewFile();
        },
        readOnly: false
      });
      aceEditor.commands.addCommand({
        name: 'saveScript',
        bindKey: {
          win: 'Ctrl-s',
          mac: 'Ctrl-s'
        },
        exec: function(editor) {
          return scriptsPanel.updateGist();
        },
        readOnly: false
      });
      aceEditor.commands.addCommand({
        name: 'linkToScript',
        bindKey: {
          win: 'Ctrl-l',
          mac: 'Ctrl-l'
        },
        exec: function(editor, b, c) {
          debugger;          return $('.link').click();
        },
        readOnly: false
      });
      aceEditor.commands.addCommand({
        name: 'editScript',
        bindKey: {
          win: 'Ctrl-e',
          mac: 'Ctrl-e'
        },
        exec: function(editor) {
          return scriptsPanel.editScript();
        },
        readOnly: false
      });
      scriptsPanel = ViewModels.ScriptsPanel();
      projectName = ko.observable('');
      Airscript.eventBus.subscribe(function(name) {
        return projectName(name);
      }, null, "editor:updateProjectName");
      self = {
        fullScriptPath: ko.computed(function() {
          return "" + (projectName()) + (escape(scriptsPanel.activeScript().name()));
        }),
        scriptsPanel: scriptsPanel,
        scriptName: function() {
          return scriptsPanel.activeScript().name();
        },
        scriptSource: function() {
          return scriptsPanel.activeScript().source();
        },
        scriptEditing: function() {
          return scriptsPanel.activeScript().editing();
        },
        avatarSrc: function() {
          var cookies, key, str, value, _i, _len, _ref;
          cookies = {};
          if (!(cookies = document.cookie.split(';')).length) {
            return;
          }
          for (_i = 0, _len = cookies.length; _i < _len; _i++) {
            str = cookies[_i];
            _ref = str.split('='), key = _ref[0], value = _ref[1];
            if (key && value) {
              cookies[key.trim()] = value.trim();
            }
          }
          return cookies.avatar || "";
        },
        userName: function() {
          var cookies, key, str, value, _i, _len, _ref;
          cookies = {};
          if (!(cookies = document.cookie.split(';')).length) {
            return;
          }
          for (_i = 0, _len = cookies.length; _i < _len; _i++) {
            str = cookies[_i];
            _ref = str.split('='), key = _ref[0], value = _ref[1];
            if (key && value) {
              cookies[key.trim()] = value.trim();
            }
          }
          return cookies.user || "";
        },
        toggleFullscreen: function() {
          $('.edit, .scripts').toggleClass('fullscreen');
          $('.btn.fullscreen').toggleClass('active');
          return aceEditor.resize();
        },
        selectFullPath: function() {
          return setTimeout(function() {
            return $('input.full_script_path').select();
          }, 1);
        }
      };
      aceEditor.commands.addCommand({
        name: 'toggleFullscreen',
        bindKey: {
          win: 'Ctrl-f',
          mac: 'Ctrl-f'
        },
        exec: function(editor) {
          return self.toggleFullscreen();
        },
        readOnly: false
      });
      return self;
    };
  });

}).call(this);
