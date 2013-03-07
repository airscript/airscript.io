Airscript.namespace "Airscript.Models", (Models) ->
  Models.Gist = (desc='', files={}) ->
    description = ko.observable(desc)

    scripts = Models.Scripts()

    self =
      description: description
