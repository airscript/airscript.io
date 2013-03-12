Airscript.namespace "Airscript.Models", (Models) ->
  Models.Script = (scriptName='new script', scriptSource='') ->
    selected = ko.observable false
    editing = ko.observable false

    self =
      name: ko.observable scriptName
      source: ko.observable scriptSource
      selected: selected
      editing: editing
      activeClass: ko.computed ->
        if selected() then 'active' else ''

  Models.EMPTY_SCRIPT = Models.Script('', '')
