Airscript.namespace "Airscript.Models", (Models) ->
  Models.Script = (scriptName='new script', scriptSource='') ->
    name = ko.observable scriptName
    source = ko.observable scriptSource
    editing = ko.observable false

    {
      name: name
      source: source
      editing: editing
    }
