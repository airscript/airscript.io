#= require ./script

Airscript.namespace "Airscript.Models", (Models) ->
  Models.Scripts = ->
    collection = ko.observableArray()

    index = ko.observable(-1)

    self =
      active: ->
        collection()[index()] || Models.EMPTY_SCRIPT

      add: (name, contents) ->
        collection.push Models.Script(name, contents)

      collection: collection

      delete: (script) ->
        collection.remove(script)

        if lastScript = collection()[collection().length - 1]
          lastScript.selected(true)
          index(collection.indexOf(lastScript))

      empty: ->
        collection([])
        index(-1)

      edit: (script) ->
        for s in collection()
          s.editing(false)

        script.editing(true)

      update: (files) ->
        for item in collection()
          for fileName, fileObj of files
            if item.name() is fileName
              item.source(fileObj.content)

      stopEditing: (newName) ->
        for s in collection()
          if s.editing()
            s.name(newName)

          s.editing(false)

      select: (script) ->
        for s in collection()
          s.selected(false)

        script.selected(true)
        index(collection.indexOf(script))
