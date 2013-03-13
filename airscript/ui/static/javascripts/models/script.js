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
