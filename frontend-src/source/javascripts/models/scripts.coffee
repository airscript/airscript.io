#= require ./script

Airscript.namespace "Airscript.Models", (Models) ->
  Models.Scripts = ->
    collection = ko.observableArray()

    index = ko.observable(-1)

    {
      active: ko.computed ->
        collection()[index]

      add: (name, contents) ->
        collection.push Models.Script(name, contents)
        index(collection.length - 1)

      collection: collection

      empty: ->
        collection([])
        index(-1)

      edit: (index) ->
        for script in collection
          script.editing(false)

        collection()[index].editing(true)

      select: (index) ->
        index(index)
    }
