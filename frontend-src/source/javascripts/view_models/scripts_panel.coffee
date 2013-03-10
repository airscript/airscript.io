#= require ../models/gists

Airscript.namespace "Airscript.ViewModels", (ViewModels) ->
  ViewModels.ScriptsPanel = ->
    gists = Airscript.Models.Gists()
    gists.fetch()

    self =
      activeGistDescription: ->
        gists.active()?.description() || ''

      createNewFile: ->
        gists.active().scripts.add('new script', '')

      editScript: (script, e) ->
        gists.active().scripts.edit(script)

      deleteScript: (script, e) ->
        gists.active().scripts.delete(script)

      hasGists: ->
        gists.hasGists()

      activeScripts: ->
        gists.active().scripts.collection

      gistsList: ->
        gists.collection

      scriptsCount: ->
        gists.scriptsCount()

      selectGist: (gist, e) ->
        index = $(e.currentTarget).index()

        gists.select(index)

        self.editScript(gists.active().scripts.collection()[0])

      selectScript: (script, e) ->
        index = $(e.currentTarget).parent().index()

        gists.selectScript(index)
