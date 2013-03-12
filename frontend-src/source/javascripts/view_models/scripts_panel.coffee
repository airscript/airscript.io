#= require ../models/gists

Airscript.namespace "Airscript.ViewModels", (ViewModels) ->
  ViewModels.ScriptsPanel = ->
    gists = Airscript.Models.Gists()
    gists.fetch()

    firstScript = ->
      gists.active().scripts.collection()[0]

    self =
      activeGistDescription: ->
        gists.active()?.description() || ''

      activeScript: ->
        gists.active()?.scripts.active()

      createNewFile: ->
        gists.active().scripts.add('new script', '')

      editScript: (script, e) ->
        gists.active().scripts.edit(script)

      deleteScript: (script, e) ->
        gists.active().scripts.delete(self.activeScript())

      hasGists: ->
        gists.hasGists()

      files: ->
        gists.active().scripts.collection

      gistsList: ->
        gists.collection

      selectGist: (gist, e) ->
        index = $(e.currentTarget).index()

        gists.select(index)

        self.editScript(firstScript())
