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
      scriptsPanel = ViewModels.ScriptsPanel();
      projectName = ko.observable('http://condor.herokuapp.com/');
      Airscript.eventBus.subscribe(function(name) {
        return projectName(name);
      }, null, "editor:updateProjectName");
      return self = {
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
        }
      };
    };
  });

}).call(this);
