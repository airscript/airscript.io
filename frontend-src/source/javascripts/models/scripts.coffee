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

      delete: (script) ->
        collection.remove(script)

      empty: ->
        collection([])
        index(-1)

      edit: (script) ->
        for s in collection()
          s.editing(false)

        script.editing(true)

        Airscript.eventBus.notifySubscribers
          src: script.source()
          name: script.name()
        , "editor:updateCode"

    Airscript.eventBus.subscribe ({name, source}) ->
      active = self.active()

      active.source(source)
    , null, "script:save"

    return self
