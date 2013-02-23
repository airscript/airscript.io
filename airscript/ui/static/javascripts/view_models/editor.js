(function() {

  Airscript.namespace("Airscript.ViewModels", function(Models) {
    return Models.Editor = function() {
      this.aceEditor = ace.edit("editor");
      this.aceEditor.setShowPrintMargin(false);
      this.aceEditor.setTheme("ace/theme/github");
      this.aceEditor.getSession().setMode("ace/mode/lua");
      this.scriptsView = new Models.Scripts();
      this.consoleView = new Models.Console();
      this.source = ko.observable('');
      this.scriptName = ko.observable('New Script');
      this.projectName = ko.observable('New Project');
      this.saveScript = function() {
        return Airscript.eventBus.notifySubscribers({
          name: this.scriptName(),
          source: this.source()
        }, 'script:save');
      };
      Airscript.eventBus.subscribe(function(script) {
        this.source(script.source);
        return this.scriptName(script.name);
      }, this, "editor:updateCode");
      Airscript.eventBus.subscribe(function(newValue) {
        return this.projectName(newValue);
      }, this, "projectName");
      return this;
    };
  });

}).call(this);
