Airscript.namespace "Airscript.Models", (Models) ->
  Models.Gist = (id=-1, desc='', files={}) ->
    id = ko.observable(id)
    description = ko.observable(desc)

    scripts = Models.Scripts()

    for fileName, fileObj of files
      scripts.add(fileName, fileObj.content)

    self =
      id: id
      description: description
      scripts: scripts

  Models.EMPTY_GIST = Models.Gist()
