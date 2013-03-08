#= require ../models/gists

Airscript.namespace "Airscript.ViewModels", (ViewModels) ->
  ViewModels.ScriptsPanel = ->
    gists = Airscript.Models.Gists()
    gists.fetch()

    Airscript.eventBus.subscribe ({name, source}) ->
      ;
    , @, "script:save"

    self =
      activeGistDescription: ->
        gists.active()?.description() || ''

      createNewFile: ->
        gists.active().scripts.add('new script', '')

      editScript: (script, e) ->
        index = $(e.currentTarget).parent().index()

        gists.active().scripts.edit(index)

      hasGists: ->
        gists.hasGists()

      activeScripts: ->
        gists.active().scripts.collection

      gistsList: ->
        gists.collection

      scriptsCount: ->
        gists.scriptsCount()

      selectScript: (script, e) ->
        index = $(e.currentTarget).parent().index()

        gists.selectScript(index)
