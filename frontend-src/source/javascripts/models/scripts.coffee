#= require ./script

Airscript.namespace "Airscript.Models", (Models) ->
  Models.Scripts = ->
    collection = ko.observableArray()

    index = ko.observable(-1)

    self =
      active: ko.computed ->
        collection()[index()] || Models.EMPTY_SCRIPT

      add: (name, contents) ->
        collection.push Models.Script(name, contents)
        index(collection.length - 1)

      collection: collection

      empty: ->
        collection([])
        index(-1)

      edit: (idx) ->
        for script in collection
          script.editing(false)

        self.active().editing(true)

      select: (idx) ->
        index(idx)
