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

      empty: ->
        collection([])
        index(-1)

      edit: (script) ->
        for s in collection()
          s.editing(false)

        script.editing(true)
        index(collection.indexOf(script))
