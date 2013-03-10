Airscript.namespace "Airscript.Models", (Models) ->
  Models.Script = (scriptName='new script', scriptSource='') ->
    editing = ko.observable false

    self =
      name: ko.observable scriptName
      source: ko.observable scriptSource
      editing: editing
      activeClass: ko.computed ->
        if editing() then 'active' else ''

  Models.EMPTY_SCRIPT = Models.Script('', '')
