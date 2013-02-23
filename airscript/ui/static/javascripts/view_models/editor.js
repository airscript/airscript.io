(function() {

  Airscript.namespace("Airscript.ViewModels", function(Models) {
    return Models.Editor = function() {
      this.aceEditor = ace.edit("editor");
      this.aceEditor.setShowPrintMargin(false);
      Airscript.aceEditor = this.aceEditor;
      this.scriptsView = new Models.Scripts();
      this.consoleView = new Models.Console();
      this.source = ko.observable('');
      this.scriptName = ko.observable('New Script');
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
      return this;
    };
  });

}).call(this);
