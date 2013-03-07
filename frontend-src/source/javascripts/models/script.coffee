Airscript.namespace "Airscript.Models", (Models) ->
  Models.Script = (scriptName='new script', scriptSource='') ->
    self =
      name: ko.observable scriptName
      source: ko.observable scriptSource
      editing: ko.observable false
