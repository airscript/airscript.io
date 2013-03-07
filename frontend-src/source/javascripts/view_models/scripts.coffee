#= require ../models/gists

Airscript.namespace "Airscript.ViewModels", (ViewModels) ->
  ViewModels.ScriptsPanel = ->
    gists = Airscript.Models.Gists()
    gists.fetch()

    Airscript.eventBus.subscribe ({name, source}) ->
      ;
    , @, "script:save"

    {
      createNewFile: ->
        gists.active().addScript('new script', '')

      editScript: (script, e) ->
        index = $(e.currentTarget).parent().index()

        gists.active().editScript(index)

      selectScript: (script, e) ->
        index = $(e.currentTarget).parent().index()

        gists.active().selectScript(index)
    }
